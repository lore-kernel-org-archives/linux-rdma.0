Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0549939A4D8;
	Fri, 28 Aug 2026 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787956764; cv=none; b=fR5aNCynLLMf/Ej1vhLxZUcMyu5PeReUbNcIqsrgVPcgTv6hzVEFJ/wM9I3NZS8M4LP6i/s1jEZY5MpQMKRh/7sd1fwnxS2Pf0GtduG90kptu/ZHH/FriqujQj45gmhb1VHJj46UCTS1eQZ1sIs1ToGUoU9IGU+9cZgaK7Heryw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787956764; c=relaxed/simple;
	bh=b23OrmMZXnM1Ts3oD3e5ypjM2Z3yJKCmZ4IHTZWVn2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=g9x1PP0EBQcRt6p7T1Y6wRwKU0pIqPsW2Uc1Cp4gv1xe5kdNeUCDtTX7WBG32zx74vnhK4D9kZdATgvwJ7STEi8OEYIVCMKNYAjTB45P4XxsbyHCW4oYrsLS3YCktDHm8V9t9bRagWBYBYiCtgxzUl+BxrRXxwVyOPuI6FaIe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJcrTjOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJcrTjOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5051F00A3D;
	Fri, 28 Aug 2026 22:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787956762;
	bh=F9caGn1m/7VyO3OqoDPiMejNjiBNNFH3Fbm6Qr48Fv4=;
	h=From:To:Cc:Subject:Date;
	b=dJcrTjOLFEhuxgjVVLL2Miab5A4/3JrA9oqvmlTvlIFjlqBvPgvYTnyakh0AqK1IW
	 Wf52O1h61dnFNWISUFYjH1Ak6gEeoEbwf3AQV8JMrB4QOuUMPoSbrXKbdueY01Lmwb
	 n+2c/3bF1fv4q8tPgAXEAHOzN0S7gKfpLVz2yY9pUUlQLwA7ad31GRQtCXRNpqLjMa
	 CYApBzlkHbxOLzMW8q6/y8BUZBAPJ25wHMnhHisy3JELidG52t8XcRYPttPaCrbPyg
	 9Z+psVHT8oF4NzadqjCtthF5jBohiMNo7pbeS4Bg9tRrokXVFeIWbg6j8Xum3iTlWE
	 q55km/G76iffw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: [PATCH net v5 0/7] net/rds: own the fastpath locks across connection teardown
Date: Fri, 28 Aug 2026 15:39:14 -0700
Message-Id: <20260828223921.202913-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This is v5 of the follow-up set to "net/rds: Bug fix ports, part 2"
[1] (v1 at [2], v2 at [3], v3 at [4], v4 at [5]).  During review of part 2, the
later half of that series needed more work than a respin, so it was
split off into this set together with the companion fixes identified
along the way.  As discussed on the v2 thread, it is targeted at net.

RDS connection teardown quiesces the transmit and receive-refill fast
paths by waiting for the RDS_IN_XMIT/RDS_RECV_REFILL bits to be
sampled clear.  Sampling a bit clear is not owning it: the fast path
can re-take its bit right after the wait returns and then run
concurrently with the transport shutdown and the send-state reset.
Oracle UEK closed this by making teardown acquire the bits as locks
("rds: Make sure transmit path and connection tear-down does not run
concurrently"); patches 5 and 6 do the same for the two
rds_send_path_reset() call sites upstream.

Making teardown block on the bits as locks promotes several latent
ordering bugs from rare to load-bearing, so they are fixed first:

  Patches 1 and 2 fix the release side of the two bit locks.
  release_in_xmit() and release_refill() both clear their bit and then
  test for waiters, but the barrier is on the wrong side of the clear
  to order the critical section's stores before the release, and the
  waiter check does not order against the clear.  Once teardown blocks
  on these bits as locks (uninterruptible and untimed), a lost wake-up
  or a store observed out of order stops mattering only in theory.
  Use clear_bit_unlock() and wq_has_sleeper(), the pattern already
  half-present in release_in_xmit().

  Patch 3: rds_conn_path_reset() wipes the whole cp_flags word with a
  plain store.  Once teardown owns bits in that word across the reset,
  a blanket store would end lock ownership early - and it already
  races atomic RMWs on the same word today.  Clear the bits the reset
  is responsible for individually, as Oracle UEK also does.

  Patch 4: rds_tcp_reset_callbacks() stores RDS_CONN_RESETTING
  unconditionally, which can overwrite the RDS_CONN_ERROR or
  RDS_CONN_DISCONNECTING of a shutdown already in progress on the same
  path and send that shutdown through an extra drop cycle.  Once the
  accept path can park for the duration of a teardown (patch 6) that
  window widens, so make the transition conditional first, as Oracle
  UEK does.

With those in place, patch 5 converts rds_tcp_reset_callbacks() from
waiting on RDS_IN_XMIT to acquiring it, holding it across the socket
swap and rds_send_path_reset(), and patch 6 has rds_conn_shutdown()
hold both bit locks across the transport shutdown and path reset.

Patch 7 fixes a pre-existing teardown-state hole that this series
makes easier to hit but did not introduce.  Since commit
e97656d03ca0 the final transition in rds_conn_shutdown() accepts
RDS_CONN_ERROR as well as RDS_CONN_DISCONNECTING, so that a FIN
processed during the teardown does not derail the shutdown.  But
consuming that RDS_CONN_ERROR also consumes the shutdown pass that a
concurrent rds_conn_path_drop() queued along with it.  For a FIN that
is harmless; for rds_tcp_accept_one() it is not.  A drop can race the
accept's DOWN -> CONNECTING path claim, the accept then installs the
freshly accepted socket while the drop's teardown - which sampled
tc->t_sock before that socket existed - is still running,
rds_connect_path_complete() fails and drops the path again, and if the
in-flight shutdown's final transition then swallows that
RDS_CONN_ERROR, the pass that should reap the just-installed socket
finds the path already RDS_CONN_DOWN and does nothing.  The socket is
leaked with its callbacks armed and its rds_tcp_connection still on
rds_tcp_tc_list, the peer sees an established connection that nothing
reads, and the path wedges in RDS_CONN_DOWN.  Make the final
transition DISCONNECTING -> DOWN only and leave a racing drop's
RDS_CONN_ERROR alone, so the pass it queued runs and tears down
whatever attached to the path; the branch quiesces the reconnect
timer itself, since a pending destroy can suppress that pass (see the
changes below).

This surfaced while re-reviewing v3: whether the
release-then-transition ordering in patch 6 could let a woken waiter
install a socket that the teardown then strands.  Chasing that down,
the reachable form of the leak turned out to be the accept-vs-drop
race above rather than the parked-waiter path (a path mid-teardown is
never handed to rds_tcp_reset_callbacks(): rds_tcp_accept_one_path()
only claims a path it can move DOWN -> CONNECTING), and it predates
this series.  It reproduces on an instrumented kernel - a test-only
drop injected into the accept window plus a widened teardown-to-tail
window - as an ESTABLISHED socket with an ever-growing receive queue
on a path stuck down; the same kernel runs clean with patch 7.

The set was built per-commit, run through the rds selftests (tcp and
rdma/rxe), and exercised with a connection/netns churn load and
module load/unload cycles; the patch 7 destroy-window fix was
additionally verified against an instrumented kernel that reproduces
the timer-left-armed WARN deterministically (fires on every destroyed
path unfixed, silent with the fix).

[PATCH net 1/7] net/rds: use wq_has_sleeper() in release_in_xmit()
  Restore the full barrier before the wake-up check in
  release_in_xmit()

[PATCH net 2/7] net/rds: use clear_bit_unlock() in release_refill()
  The matching release-side fix for RDS_RECV_REFILL

[PATCH net 3/7] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  Partial port of commit d04896037223 ("net/rds: Preserve essential connection state flags")
  https://github.com/oracle/linux-uek/commit/d04896037223

[PATCH net 4/7] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
  Port of commit 72c176a1d9ac ("net/rds: Don't force state RDS_CONN_RESETTING")
  https://github.com/oracle/linux-uek/commit/72c176a1d9ac

[PATCH net 5/7] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
  Extend the port in patch 6 to the second rds_send_path_reset() call site

[PATCH net 6/7] net/rds: acquire the fastpath locks in rds_conn_shutdown()
  Port of commit 2b8aaa4f163b ("rds: Make sure transmit path and connection tear-down does not run concurrently")
  https://github.com/oracle/linux-uek/commit/2b8aaa4f163b

[PATCH net 7/7] net/rds: don't let rds_conn_shutdown() consume a concurrent drop
  Fix the accept-vs-drop socket leak found while reviewing patch 6

Changes since v4 [5]:
  - Patch 7: fixed a hole the v4 review found in the new quiet return:
    it left rds_conn_shutdown() before the tail that cancels
    cp_conn_w, and when a pending destroy had kept the racing drop
    from queueing a successor pass, nothing ever cancelled it -
    rds_conn_path_destroy() would then trip its
    WARN_ON(delayed_work_pending(&cp->cp_conn_w)) and free the path
    with the reconnect timer still armed.  The failure branch now
    quiesces cp_conn_w and clears RDS_RECONNECT_PENDING itself before
    returning, so every exit of a shutdown pass leaves the timer
    idle no matter which pass completes the transition.  Reproduced
    on an instrumented kernel (deterministic destroy-window drop) as
    the destroy-time WARN_ON firing with the timer armed; the same
    kernel runs clean with the fix.  The comment in the branch also
    no longer claims a module unload takes the noisy path (an
    unload's drop stores RDS_CONN_ERROR and takes the quiet return
    like everything else), and notes the remaining noisy branch is
    defensive.
  - Patch 6: changelog corrections from the review - the backport
    paragraph now names all four prerequisites (patches 2, 3, 5 and
    the follow-up patch 7); the krdsd paragraph no longer claims the
    teardown "never waits on krdsd" and instead explains why the
    mutual waits cannot cycle (the holder's sync cancels target
    pending-at-most items on the ordered cp_wq); the "up to 5 s"
    bound is scoped to TCP, with a note that IB's uncapped drain has
    no blocking waiter to park.  Two comments updated to match: the
    send.c ordering comment now attributes the guarantee to the
    atomic RMW on the cp_flags word rather than cross-variable
    ordering, and the sync cancels in rds_tcp_reset_callbacks() now
    document the ordered-cp_wq reliance.
  - Patch 4: the call-site comment in rds_tcp_accept_one() no longer
    promises rds_connect_path_complete() will mark the path
    RDS_CONN_UP; it names the drop-and-reap outcome too.
    Investigated possible patch re-ordering with patches 5/6, but
    retaining this ordering to avoid widening the pre-existing race
    window betwen accept and shutdown before the conditional transition
    is in place.
  - Patch 2: changelog now names the companion and dependent patches
    by subject instead of series position, and describes the
    teardown's acquire side as of the end of the series.
  - Patches 1, 3 and 5 are unchanged; patches 1-6 are code-identical
    to v4 apart from the two comments noted above.

The cong.c wq_has_sleeper() conversion mentioned on the v2 thread was
sent separately and has already been reviewed.

Questions and comments appreciated!

Thanks,
Allison

[1] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260814013501.43760-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20260816001510.73645-1-achender@kernel.org/
[4] https://lore.kernel.org/netdev/20260822052459.88017-1-achender@kernel.org/
[5] https://lore.kernel.org/netdev/20260824003759.127353-1-achender@kernel.org/

Allison Henderson (5):
  net/rds: use wq_has_sleeper() in release_in_xmit()
  net/rds: use clear_bit_unlock() in release_refill()
  net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
  net/rds: don't let rds_conn_shutdown() consume a concurrent drop

Gerd Rausch (1):
  net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent
    shutdown

Håkon Bugge (1):
  net/rds: acquire the fastpath locks in rds_conn_shutdown()

 net/rds/connection.c |  89 ++++++++++++++++++++++++++++++--------
 net/rds/ib_recv.c    |   9 ++--
 net/rds/send.c       |  14 ++++--
 net/rds/tcp.c        | 101 +++++++++++++++++++++++++++++++------------
 net/rds/tcp_listen.c |   6 ++-
 5 files changed, 166 insertions(+), 53 deletions(-)


base-commit: 4e15e89faac9f308baeb01f46c13a051814d2449
-- 
2.25.1

