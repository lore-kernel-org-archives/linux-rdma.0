Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE51FFC48;
	Mon, 24 Aug 2026 00:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787531882; cv=none; b=ZmGIFD6nHSxNgeoWdWd5KO/2RRWRLGQ1LQ+8kmJvBXG3LiC7GtagrOXe9xnyH6XOobAuLqQ+r2Ru/9CeghZaDZWC3h3mfe+H77zZHsGRy8d7EdQr6Reqd/SOZFOwtJ+ucSJB6ex6UX2jLHK8I1e8z9usRN/17kuTPmk4qbQLDPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787531882; c=relaxed/simple;
	bh=cKdZSxbBOapYM1VprahmYRcrZ0k2ck1qofuq6+iVmZE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=d/eEj0SkXPG65TkZTs2Oh3ytLbyNEwt+WyeCthX+gxYKnAbJpTs5H3rdPvNZOHXU6JIBLsyo/0AhyE02u84HYB4mFiGGwx5wsehCdcuRibsJH0PdcMrauYLWZeGUL14+VdfCtiIyolB3rm0vA1th5L4z+UUOkSO1YoK+4tFPrQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rdlc+e27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rdlc+e27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115941F000E9;
	Mon, 24 Aug 2026 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787531880;
	bh=Ggwu3KZDsppZ4tTYuARs4HRZYK18mlQjF5kY17B5tZI=;
	h=From:To:Cc:Subject:Date;
	b=Rdlc+e27oawjPjdfE4wSTgHogJgFP3O8pMCA7U7cVKuO63jyOSe95vfgSN58/qwqi
	 ZqSgxFfsb3DnGab/9M7sVDEKZfnDYFkmpR/cCRbut31z8twXC0nW9CFeQTfOxyyrCp
	 sjGg7mTsVsxE3ASafOJfyPihM4m7tXagQQ1W2Ktzq4+KOP75yAGKlTHoQXyajW+0hP
	 uvQF1HP5+YJ5uouyCGInJiZRuUBAIoj0TVthvOvRjiT8/evdKcCsmY5Nf9MPUgeocj
	 2jyTZDTNTxSy0PlBQp7uE1uWyw6nN40okwFh13CrY3CdaFsf8MeJBYoJpVRoe8xpVs
	 cc34u+dVj8OsA==
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
Subject: [PATCH net v4 0/7] net/rds: own the fastpath locks across connection teardown
Date: Sun, 23 Aug 2026 17:37:52 -0700
Message-Id: <20260824003759.127353-1-achender@kernel.org>
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

This is v4 of the follow-up set to "net/rds: Bug fix ports, part 2"
[1] (v1 at [2], v2 at [3], v3 at [4]).  During review of part 2, the
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

Patch 7 is new in v4 and fixes a pre-existing teardown-state hole that
this series makes easier to hit but did not introduce.  Since commit
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
whatever attached to the path.

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
rdma/rxe) with a clean dmesg, and exercised with a connection/netns
churn load and module load/unload cycles.

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

Changes since v3 [4]:
  - New patch 2 (release_refill clear_bit_unlock/wq_has_sleeper),
    completing the release-side pairing for the second bit lock that
    patch 6 now takes; noticed while re-reviewing patch 6.
  - New patch 7 (don't consume a concurrent drop), fixing the
    accept-vs-drop socket leak described above; found while
    re-reviewing patch 6.
  - Patch 5's block comment now names all four t_sock writers,
    including the accept-path setter.
  - Patch 6's changelog gains a note for stable backporters about its
    dependency on patches 3 and 5.
  - Patches 1, 3, 4, 5 and 6 are otherwise code-identical to v3.

The cong.c wq_has_sleeper() conversion mentioned on the v2 thread was
sent separately and has already been reviewed.

Questions and comments appreciated!

Thanks,
Allison

[1] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260814013501.43760-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20260816001510.73645-1-achender@kernel.org/
[4] https://lore.kernel.org/netdev/20260822052459.88017-1-achender@kernel.org/

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

 net/rds/connection.c | 75 +++++++++++++++++++++++++++---------
 net/rds/ib_recv.c    |  9 +++--
 net/rds/send.c       | 12 ++++--
 net/rds/tcp.c        | 92 +++++++++++++++++++++++++++++++-------------
 4 files changed, 137 insertions(+), 51 deletions(-)


base-commit: 4e15e89faac9f308baeb01f46c13a051814d2449
-- 
2.25.1

