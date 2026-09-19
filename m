Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9054B321420;
	Sat, 19 Sep 2026 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798312; cv=none; b=iDd43cxtvf5xU9BtqvzbP6ClUr4gO1dhlA+Pc/m9IpgILfd+j3tVX8eOXWcjh7vTXHxsViimNYlLP4LyZhKhZRPao5gNk9AInXFjBM/6laJFyZefi27iNZA2O49p10nnQvA/hyTGEUT3ueMXV20ok16DKRfJajovDdvTl2N/PXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798312; c=relaxed/simple;
	bh=NVq6Vmze3Kmb/6YlkorQEQlaSdfitf9SjUncS0bxVcM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P6n2q/lTVecU1cSbAqzJj45C80iDDCPU0wdZKi/Geu7/n/BWRD/mbs5xIG6xN38aEvqUlIh4K8JKkHWpbQ18jSBAb1/lprdzm22MhIdaI0bA9hyPPzVam0iMKvZGTelsDZ5wavq96JEjgvprji3AZoVOmLzLZb+lqNky6enogP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DK+bc9Vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DK+bc9Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EF61F000FF;
	Sat, 19 Sep 2026 06:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798310;
	bh=YRs+j8BvYqKBuWd8Vdknw4F1hGEcV0jpVBQYcbFSHzQ=;
	h=From:To:Cc:Subject:Date;
	b=DK+bc9VucJ/6u3nStB0tGiMmD8w3rgdzu46e4p1YxMsJLVBNIjtBWUZCfZ70frBvZ
	 N265oVhZD1EEnZ24fbxpDUV2XgshkV4eWTLLJcg0R+WnOi/GDNvvV3M0C66igpK9hd
	 2tvPNhqKmBO/gy2Rj7YSQXt0AcUSw8wHc4GA1avGxL4kV3mdhli+biH7xh89kdhWub
	 CyrbfcPji79vSknkCxai/8pOlltriDc5kywUmIDlsggPO+uEvYc7ERTa6j8tIFN3mA
	 /zT0BbucEoTAiqKhYxh9WILavdP1QLl8K+t1VmNF8gE/3H8Ro5OvuQ8lBnDwJ6WB/G
	 DH4ZAjB/lBL1A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v5 00/12] net/rds: make connection lifetime reference-counted
Date: Fri, 18 Sep 2026 23:11:37 -0700
Message-Id: <20260919061149.250658-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v5 of the connection-lifetime set (v1 at [1], v2 at [2],
v3 at [3], v4 at [6]), following
"net/rds: own the fastpath locks across connection teardown", which is
in net-next.  It is targeted at net-next: although the series fixes
real use-after-frees (one syzbot report and one report from Chengfeng
Ye below), it does so by reworking connection lifetime rather than
patching the individual crash sites, and that rework is too invasive
for net.

rds_conn_destroy() frees the connection, its paths and its workqueues
on the spot, relying on the documented assumption that "no one else is
referencing the connection".  That assumption stopped being true a
long time ago: connections are destroyed on netns teardown and on a
protocol-version mismatch as well as on rmmod, while pointers to them
still live in socket rs_conn caches, congestion-map conn lists, CM
callbacks and workers, and - for as long as an application leaves data
unread - in every rds_incoming sitting on a receive queue.  No single
Fixes: commit covers the rot, so the series carries Reported-by tags
where there are concrete reports instead.

  Patch 1 fixes rds_ib_conn_free() re-enabling interrupts under
  a caller's irqsave lock.

  Patch 2 frees every path's transport data on the
  passive-connection exits of __rds_conn_create(), where only path 0 was
  freed.  Both are pre-existing and stand on their own; they are first
  in the series because the reference-counted teardown calls conn_free()
  from more places.

  Patch 3 guards the five work-arming sites that never tested
  rds_destroy_pending(): two IB completion paths, the IB recv refill,
  the TCP accept kick and the multipath reconnect in sendmsg.

  Patch 4 gives the connection its own destroy-in-progress marker so
  that the predicate also covers the one single-connection destroy.
  Based on UEK commits:
     e2f5005adf63 net/rds: Add krefs to struct rds_connection
     https://github.com/oracle/linux-uek/commit/e2f5005adf63

     6c53ef92f46e net/rds: Merge uses of conn->c_destroy_in_prog & RDS_DESTROY_PENDING
     https://github.com/oracle/linux-uek/commit/6c53ef92f46e

  Patch 5 splits rds_conn_destroy() into a synchronous quiesce and a
  kref-governed free.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection").
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

  Patch 6 makes each transport's exit path wait for its connections to
  actually be freed before the module goes away.  The wait is
  unbounded and warns every ten seconds: a connection reference can be
  held for an application-controlled time (unread data), so a timeout
  would only move the use-after-free from freed memory to unloaded
  module text.  rmmod blocking while data is queued and unread is the
  historical RDS contract.  For IB the wait re-sweeps the nodev list,
  since device connections migrate to it asynchronously.
  Based on UEK commits:
     ece4b4e39afa ("net/rds: wait_event_timeout until zero connections during rmmod")
     https://github.com/oracle/linux-uek/commit/ece4b4e39afa

     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count")
     https://github.com/oracle/linux-uek/commit/905ec90e6166

  Patch 7 unlinks each transport node before its destroy, so a
  free deferred past the teardown loop cannot write into the loop's
  stack-local list head.  IB marks a gathered node as claimed by the
  sweep, since its connect and shutdown paths move the node too.

  Patch 8 hands out real references everywhere a connection pointer
  previously escaped bare, RCU-annotates parent->c_passive, refuses to
  revive a passive connection whose destroy has begun, and serializes
  the SIOCRDSSETTOS check with the rs_conn cache.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

     0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
     https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7

  Patch 9 has rds_send_queue_rm() and rds_send_probe() refuse, under
  cp_lock, to queue on a connection whose destroy has begun, and has
  the quiesce splice cp_send_queue away under the same lock: a message
  queued after the purge would hold a connection reference nothing
  ever drops.

  Patch 10 pins the connection across the RDMA-CM event handler
  and rejects a connect request for a connection whose destroy has
  already quiesced it.

  Patch 11 drops the now-unused global rds_conn_count.
  Based on UEK commits:
     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
     https://github.com/oracle/linux-uek/commit/905ec90e6166

  Patch 12 makes struct rds_incoming hold a reference on i_conn, the
  fix for the KASAN use-after-free Chengfeng Ye reported [4].
  Based on UEK commits:
      99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
      https://github.com/oracle/linux-uek/commit/99b9a3715419

Patches 5, 8, 6 and 12 are ports of the connection kref work Sharath
Srinivasan did for Oracle UEK, adapted to the upstream code.

The series has been validated with the RDS selftests over loopback-TCP
and RXE-RDMA, plus churn tests that delete network namespaces and
unload the modules under live rds-stress traffic.

Changes since v4 [6]:
 - Patch 7: the IB sweep marks each gathered node with a new
   i_ib_node_detached flag instead of relying on list emptiness.  A
   node parked on the sweep's stack list is not empty, so a concurrent
   rds_ib_add_conn() would have unlinked it from under the sweep's
   lockless walk; rds_ib_add_conn(), rds_ib_remove_conn() and
   rds_ib_conn_free() now leave a claimed node alone.

Changes since v3 [3]:
 - Rebased; the version-mismatch destroy that patch 10 also had to
   cope with is now an rds_conn_drop() in net (f97d8c7bab78), and
   patch 10's changelog says what remains for it to cover.
 - The uninitialised transport pointer in the CM event handler that
   the second v2 review pass raised turned out to be the bug Aohan
   Mei already posted a fix for (v2 at [5], stalled after review); it
   is carried forward separately for net rather than added here.
 - Patch 7: the teardown walks take a reference on each gathered
   connection, so a connection destroyed earlier and freed by a
   pending holder cannot vanish under the iterator, and the two IB
   list movers tolerate a node the sweep already unlinked instead of
   BUG_ON()ing; the nodev sweep gathers entry by entry, so the
   resweep from the unload wait no longer relies on list_splice_init().
 - Patch 8: SIOCRDSSETTOS check-then-act closed - the install in
   rds_sendmsg() re-checks the socket's ToS under rs_lock; rs_conn
   documented as a referenced, rs_lock-serialised cache; contract
   comment restored to rds_conn_lookup().
 - Patch 9: rds_send_probe() gets the same rds_destroy_pending()
   test under cp_lock as rds_send_queue_rm() (a probe queued after the
   purge pinned the connection for good).
 - v3 patch 10 (rds_tcp_accept_one() destroy check) dropped: the check
   was not serialised against the destroy, and the race it aimed at is
   not reachable - every TCP destroy path stops the listener, flushing
   the accept work, first.  A comment now records that ordering.
 - Changelog and comment corrections from the second v2 review pass
   (self-requeue exemption in patch 3, c_refcount comment in patch 5,
   the uninterruptible wait and the transport-text wake in patch 6,
   "lock-free" wording in patch 11, cross-netns comment in patch 12).

Changes since v2 [2]:
 - New patches 1 and 2: pre-existing rds_ib_conn_free() interrupt
   state clobber and passive-path transport data leak, surfaced by
   review of the teardown changes.
 - Patch 6: rds_ib_destroy_nodev_conns() uses list_splice_init(), so
   the resweep from the unload wait cannot splice a stale list head.
 - Patch 8: SIOCRDSGETTOS reads rs_tos under rs_lock like SETTOS.
 - New patch 9: rds_send_queue_rm() refuses a connection whose destroy
   has begun, under cp_lock, and the quiesce purges cp_send_queue
   under cp_lock (list corruption against an in-flight sender, and a
   message that would pin the connection forever).
 - New patch 10: rds_tcp_accept_one() does not install a socket on a
   connection whose destroy has begun (socket left pointing at a freed
   path).

Changes since v1 [1]:
 - New patch 1: guard the five work-arming sites that never tested
   rds_destroy_pending(); patch 2's changelog and comments narrowed
   to what it actually newly covers.
 - Patch 4 moved ahead of the reference holders, so no bisect point
   has references without the unload wait; wait made unbounded with a
   periodic warning instead of a 10 s timeout; IB exit re-sweeps the
   nodev list for connections that detach from their device late.
 - New patch 5: transport nodes unlinked before destroy (stack list
   head use-after-free from a deferred conn_free).
 - Patch 6: c_passive RCU-annotated; a destroyed passive child is
   refused by __rds_conn_create() and clears the parent's pointer
   itself; SIOCRDSSETTOS uses rs_lock; lookup comment reworded;
   explicit not-for-stable note.
 - New patch 7: reference across the CM event handler, and a
   destroy-pending re-check in rds_ib_cm_handle_connect().
 - Patch 9: changelog states what a lingering inc keeps alive and
   that it blocks module unload.
 - Changelog corrections throughout (netns teardown paths named as the
   non-rmmod destroyers, stale rds_conn_path_destroy() reference).

[1] https://lore.kernel.org/netdev/20260904070248.160384-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260912035027.27447-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20260914033719.138057-1-achender@kernel.org/
[4] https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
[5] https://lore.kernel.org/netdev/20260825021223.3483044-1-ljp1205831794@gmail.com/
[6] https://lore.kernel.org/netdev/20260917073958.174056-1-achender@kernel.org/

Allison


Allison Henderson (8):
  net/rds: ib: don't enable interrupts in rds_ib_conn_free()
  net/rds: free every path's transport data on the passive create paths
  net/rds: guard every work-requeueing site with rds_destroy_pending()
  net/rds: make rds_destroy_pending() cover single-connection destroy
  net/rds: unlink transport nodes before a possibly deferred connection
    free
  net/rds: refuse to queue on a connection being destroyed
  net/rds: pin the connection across RDMA-CM event handling
  net/rds: drop rds_conn_count in favor of t_conn_count

Sharath Srinivasan (4):
  net/rds: split connection destroy into quiesce and kref-governed free
  net/rds: wait for connections to be freed on transport unload
  net/rds: hold connection references in lookup, sockets and c_passive
  net/rds: hold a connection reference from struct rds_incoming

 net/rds/af_rds.c         |  24 ++-
 net/rds/connection.c     | 327 +++++++++++++++++++++++++++++++++------
 net/rds/ib.c             |  22 ++-
 net/rds/ib.h             |   4 +
 net/rds/ib_cm.c          |  29 +++-
 net/rds/ib_rdma.c        |  67 ++++++--
 net/rds/ib_recv.c        |   6 +-
 net/rds/ib_send.c        |  18 ++-
 net/rds/loop.c           |  61 ++++++--
 net/rds/message.c        |  16 +-
 net/rds/rdma_transport.c |  16 +-
 net/rds/rds.h            |  45 +++++-
 net/rds/recv.c           |  26 +++-
 net/rds/send.c           |  96 ++++++++++--
 net/rds/tcp.c            |  53 ++++++-
 net/rds/tcp_listen.c     |  21 ++-
 16 files changed, 713 insertions(+), 118 deletions(-)

-- 
2.25.1

