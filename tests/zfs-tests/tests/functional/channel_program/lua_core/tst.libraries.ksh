#!/bin/ksh -p
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright (c) 2017 by Delphix. All rights reserved.
#

. $STF_SUITE/tests/functional/channel_program/channel_common.kshlib

verify_runnable "global"

log_must_program $TESTPOOL $ZCP_ROOT/lua_core/tst.lib_base.lua
log_must_program $TESTPOOL $ZCP_ROOT/lua_core/tst.lib_coroutine.lua
log_must_program $TESTPOOL $ZCP_ROOT/lua_core/tst.lib_strings.lua
log_must_program $TESTPOOL $ZCP_ROOT/lua_core/tst.lib_table.lua

log_pass "lua libraries work correctly."
