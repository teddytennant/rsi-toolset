#!/usr/bin/env bash
set -euo pipefail

# Basic integration test for rsi-toolset
# Requires: sudo access, NixOS with nixos-container support
#
# Usage: sudo bash tests/test-basic.sh

RSI_BIN="$(cd "$(dirname "$0")/../bin" && pwd)"
RSI="$RSI_BIN/rsi"
TEST_NAME="t$(date +%s | tail -c 4)"  # short unique name within 7 chars
PASSED=0
FAILED=0

log() {
    echo "=== $1 ==="
}

pass() {
    echo "  PASS: $1"
    (( PASSED++ ))
}

fail() {
    echo "  FAIL: $1" >&2
    (( FAILED++ ))
}

cleanup() {
    log "Cleanup"
    # Best-effort destroy regardless of test outcome
    "$RSI" destroy "$TEST_NAME" 2>/dev/null || true
}
trap cleanup EXIT

# -------------------------------------------------------------------
# Test 1: Create a container
# -------------------------------------------------------------------
log "Test 1: Create container '${TEST_NAME}'"
if "$RSI" create "$TEST_NAME"; then
    pass "Container created"
else
    fail "Container creation failed"
    exit 1  # can't continue without a container
fi

# -------------------------------------------------------------------
# Test 2: Verify it appears in the list
# -------------------------------------------------------------------
log "Test 2: Verify container appears in list"
if "$RSI" list | grep -q "$TEST_NAME"; then
    pass "Container listed"
else
    fail "Container not found in list"
fi

# -------------------------------------------------------------------
# Test 3: Verify it is running
# -------------------------------------------------------------------
log "Test 3: Verify container is running"
if "$RSI" run "$TEST_NAME" echo "hello from container" | grep -q "hello from container"; then
    pass "Command executed inside container"
else
    fail "Could not run command inside container"
fi

# -------------------------------------------------------------------
# Test 4: Run a command that exercises the agent user environment
# -------------------------------------------------------------------
log "Test 4: Verify agent user environment"
agent_home="$("$RSI" run "$TEST_NAME" pwd)"
if [[ "$agent_home" == "/home/agent" ]]; then
    pass "Agent home directory is /home/agent"
else
    fail "Unexpected home directory: ${agent_home}"
fi

# -------------------------------------------------------------------
# Test 5: Stop the container
# -------------------------------------------------------------------
log "Test 5: Stop container"
if "$RSI" stop "$TEST_NAME"; then
    pass "Container stopped"
else
    fail "Failed to stop container"
fi

# -------------------------------------------------------------------
# Test 6: Start the container again
# -------------------------------------------------------------------
log "Test 6: Re-start container"
if "$RSI" start "$TEST_NAME"; then
    pass "Container restarted"
else
    fail "Failed to restart container"
fi

# -------------------------------------------------------------------
# Test 7: Destroy the container
# -------------------------------------------------------------------
log "Test 7: Destroy container"
# Disable the EXIT trap since we are explicitly destroying here
trap - EXIT
if "$RSI" destroy "$TEST_NAME"; then
    pass "Container destroyed"
else
    fail "Failed to destroy container"
fi

# -------------------------------------------------------------------
# Test 8: Verify cleanup is complete
# -------------------------------------------------------------------
log "Test 8: Verify container no longer exists"
if "$RSI" list | grep -q "$TEST_NAME"; then
    fail "Container still appears in list after destroy"
else
    pass "Container fully cleaned up"
fi

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo ""
echo "=============================="
echo "  Results: ${PASSED} passed, ${FAILED} failed"
echo "=============================="

if [[ $FAILED -gt 0 ]]; then
    exit 1
fi
