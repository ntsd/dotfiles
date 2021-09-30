#!/usr/bin/env bats

load "../system/.function"
load "../system/.function_text"

FIXTURE=$'foo\nbar\nbaz\nfoo'
FIXTURE_TEXT="foo"

@test "get" {
	ACTUAL=$(get "FIXTURE_TEXT")
	EXPECTED="foo"
	[ "$ACTUAL" = "$EXPECTED" ]
}

@test "line" {
	ACTUAL=$(get "FIXTURE" | line 2)
	EXPECTED="bar"
	[ "$ACTUAL" = "$EXPECTED" ]
}

@test "line + surrounding lines" {
	ACTUAL=$(get "FIXTURE" | line 3 1)
	EXPECTED=$(echo -e "bar\nbaz\nfoo")
	[ "$ACTUAL" = "$EXPECTED" ]
}
