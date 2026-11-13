Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545036;
	b=gKv1c4U86QVnoj4c8HlnvIgsCx1ZPYsgUwXjRw2gFisXagZCgzTWDUdBrPlNoR+k6dZQ
	 5C0MPrY17S2oKY/ybM+8f9FX9F9vS4qeOZmUlA4oh7HggUr6bKKWvzCpwx4CMzYwd8CMx
	 6sT18Yzs4Bq92Wdo5QwrBSHTuR8TkroRlC+BkMw3juK5UC+ZGeirHx6iRkUrco/fvXFJQ
	 Pl/V89hFrAWTep9k/kCdaBMTK4FUIW6vIvXS2WiTd3LVq7NX7iQSgbujTABXJ5LgHDMmV
	 oeTZ1Rw48p7bG4UmrD5o/pJPHbIVd5IdOsYvb8RBQvcUlOgUEnNmD3IOL3DKQ9TG0hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzDF/Kom9a3P4t3b09ogg+w7sfanNMsWWU8lX1hvjLE=;
	b=Ld35IwQLKT+HkrdTwo7PvfILh56Ece33mivF291cDsjmXqygr2fU8ftA6C3PNGRkvlRo
	 MCnNfQxAvJbZupKbMB17aMT+5NqSnbR/CvH2810w7VRk+Dkg8S6FrZCvz7KDJjNbSWKHO
	 9YWj9nvgynIIuLkiZgo/QxmuYso4dcEw4YWcIUNeVYy5N8PLF7Dug/+vCM0ivxmWqadAs
	 TBx9L8AHxCPjVuQuB+Syqrb8lxHQ/zvgcvlQYzHz1wijCqbYhANzyz1oazZx+7j6LW0lH
	 rL6y7jTs5fR9YXY7uaYtkKV2mZNqchlj6aipG504ppYuSWoKPbun7EohvBKrrnPuUlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FPTJCfVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985B0606A323;
	Fri, 13 Nov 2026 04:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FPTJCfVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF51F000C4;
	Fri, 13 Nov 2026 04:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545036;
	bh=zzDF/Kom9a3P4t3b09ogg+w7sfanNMsWWU8lX1hvjLE=;
	h=From:To:Cc:Subject:Date;
	b=FPTJCfVNQD33enbT6N4PusTVJrr0o2u4tJmEMccDLqOTIiCVGTQjkEzp7JUSaHdiE
	 AMefzipjdFYycJ2Usex9vMaWzpIyJHiE53eV4uxVcimMOjqb5Xhi+J+SKfozS26VPl
	 4JNmEKJqKMjrxf2og2ym9UrgivayFh9GNHYGYW19vTl6bXdcOnx93s8Vti1wW8joXw
	 auH4PwEKat9xz71agNIa57AMNGRnESAba2G4F9er3ke1Go+OlprReZ9B6Sdbv0zQA/
	 wEprlXe/7hNIYAHfJsrmAmIaUqU4EXcqyAvyteHx1mADcp5IkLBNf9GIlGs+VNmN77
	 ZDnavmxQpnswA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 00/12] net/rds: make connection lifetime reference-counted
Date: Thu, 12 Nov 2026 21:43:43 -0700
Message-ID: <20261113044355.2932029-1-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v12 of the connection-lifetime set (v1 at [1], v2 at [2],
v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10],
v9 at [11], v10 at [13], v11 at [14]), following
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

Patches 5, 8, 7 and 12 are ports of the connection kref work Sharath
Srinivasan did for Oracle UEK, adapted to the upstream code; patch 2
mirrors UEK's device-removal gate in rds_ib_add_conn().

The series has been validated with the RDS selftests over loopback-TCP
and RXE-RDMA, plus churn tests that delete network namespaces and
unload the modules under live rds-stress traffic.

  Patch 1 makes the passive-connection exits of __rds_conn_create()
  undo conn_alloc() the same way the lost-race exit does, through one
  helper (a refactor: the passive twin only exists for IB, so nothing
  leaked there).  It comes first because the reference-counted
  teardown calls conn_free() from more places.

  Patch 2 has rds_ib_dev_shutdown() mark a device as shutting down
  under the lock rds_ib_add_conn() attaches under, and makes
  rds_ib_add_conn() refuse a marked device: a connect that was past
  rds_ib_get_client_data() when the device's connections were dropped
  could attach to it afterwards and, on module unload, never be torn
  down.
  Based on UEK commit:
     8d0639e6ba2c ("net/rds: Clean up ib_nodev_conns list handling")
     https://github.com/oracle/linux-uek/commit/8d0639e6ba2c

  Patch 3 guards the five work-arming sites that never tested
  rds_destroy_pending(): two IB completion paths, the IB recv refill,
  the TCP accept kick and the multipath reconnect in sendmsg.

  Patch 4 gives the connection its own destroy-in-progress marker.
  One destroy caller does escape the old predicate - unloading the core
  module runs the loopback pernet exit for every live namespace, where
  check_net() is still true and the loop transport's unloading flag is
  not yet set - though nothing can queue work at that point today.  The
  later patches need the precise answer: the passive-twin creation must
  refuse a parent whose destroy has begun, and sendmsg must drop a
  cached connection whose destroy has.
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

  Patch 6 unlinks each transport node before its destroy, so a
  free deferred past the teardown loop cannot write into the loop's
  stack-local list head.  IB marks a gathered node as claimed by the
  sweep, since its connect and shutdown paths move the node too; for
  IB this also closes an existing corruption of the nodev list on
  module unload, through the stale spliced head.

  Patch 7 makes each transport's exit path wait for its connections to
  actually be freed before the module goes away.  It comes after the
  unlink patch now, so that the IB resweep only ever finds claimed
  nodes.  The wait is
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

  Patch 8 makes struct rds_incoming hold a reference on i_conn, the
  fix for the KASAN use-after-free Chengfeng Ye reported [4].
  Based on UEK commits:
      99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
      https://github.com/oracle/linux-uek/commit/99b9a3715419

  Patch 9 has the quiesce purge cp_send_queue under cp_lock, as every
  adder to that queue holds it, and clear RDS_MSG_ON_CONN as it does
  so, the way rds_send_drop_to() expects.  No sender can be in flight
  at any of today's destroy triggers (netns teardown, module unload),
  so this is hygiene rather than a race fix; the old BUG_ON() on a
  socket-owned message becomes a WARN_ON_ONCE().

  Patch 10 hands out real references everywhere a connection pointer
  previously escaped bare, RCU-annotates parent->c_passive, refuses to
  revive a passive connection whose destroy has begun, and serializes
  the SIOCRDSSETTOS check with the rs_conn cache.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

     0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
     https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7

  Patch 11 gives cm_id->context a reference on its connection, taken
  when the id is created or installed and dropped after
  rdma_destroy_id(), and, on both the passive and the active side,
  declines to set up a QP for a connection whose destroy has already
  begun.

  Patch 12 drops the now-unused global rds_conn_count.
  Based on UEK commits:
     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
     https://github.com/oracle/linux-uek/commit/905ec90e6166

Changes since v11 [14]:
 - Rebased onto current net-next (no net/rds changes in between).
 - Patch 4: the commit message's history of RDS_DESTROY_PENDING was
   wrong.  It now follows c14b0366813a -> c90ecbfaf50d2 ->
   ebeeb1ad9b8a -> cdc306a5c9cd3 and says that the patch brings back
   a per-connection flag mainline once had.
 - Patch 11: cm_id->context now owns a reference on the connection,
   taken in rds_ib_conn_path_connect() and rds_ib_cm_handle_connect()
   and dropped after rdma_destroy_id(), in place of the handler
   pinning the connection per event - a pin that could not have
   caught a connection freed before the handler ran.  Retitled.
 - Patch 8 is unchanged: the unload wait on unread datagrams stays,
   see the v11 thread.

Changes since v10 [13]:
 - Rebased onto current net-next.
 - The v10 patch 1 (rds_ib_conn_free() irqsave) is dropped: Nguyen
   Ngoc Thang's fix for the same bug [12] is in net-next as
   f6fa1d60ec3c.  Every later patch moves up by one.
 - Patch 6: the rds_ib_conn_free() comment merges with the one that
   fix added.
 - Patch 10: the sendmsg cache-hit test keeps the c_dev_if comparison
   from "net/rds: include the scope id in the sendmsg connection cache
   check", now in net-next.

Changes since v9 [11]:
 - Rebased onto net-next with the RDMA-CM handler fixes (492ba6ac1b1f,
   98d446b7c013); patch 12 no longer has the transport assignment lines
   to remove.
 - Patch 3: a connect refused by the gate can hold the device's last
   reference and drop it after the only rds_wq flush on unload, so
   rds_ib_exit() flushes rds_wq again after the sweep here; patch 8 then
   moves that flush after the wait.  The changelog says which half of
   the in-flight-connect race this closes and that the unload wait
   closes the other.
 - Patches 7 and 8 keep their Fixes: tags and gain a
   "Cc: <stable+noautosel@kernel.org>" naming the dependency on the
   reference counting, so stable tooling skips them; patch 9 gains a
   Fixes: for the original i_conn with the same Cc, and patch 11 a
   Fixes: for the sendmsg cache with the same Cc.
 - Patch 7: garbled paragraph fixed; the loop conn_free() description
   corrected.
 - Patch 11: authored by Sharath Srinivasan, matching its SoB chain and
   bracket note like patches 6 and 8.
 - Patch 1 carries the syzbot Reported-by/Closes.

Changes since v8 [10]:
 - Patch 3: changelog names unloading rds_rdma with a connect in flight
   as the trigger; a hot removal is caught by the rdma_cm's own
   DEVICE_REMOVAL event.
 - Patch 4: blank line before the trailers.
 - Patch 7: rds_ib_add_conn() refuses a node a sweep has claimed, as
   it refuses a device that is shutting down, so the "dropped or
   refused" invariant holds by construction; changelog describes the
   nodev-list corruption on unload the IB part fixes, with
   Fixes: 4716af3897e9, and says the IB unlink runs off the claimed
   stack list.
 - Patch 8: Fixes: 4716af3897e9 for the two unload holes the resweep
   and the rds_wq flush close; opening paragraph no longer calls the
   wait a no-op at that point in the series.
 - Patch 9: the reachable trigger is a cross-transport unload (a
   socket bound with one transport holding incs from another's
   connection); the deliberate absence of a Fixes: tag is stated; the
   stale XXX comment in rds_inc_on_sock_queue() is removed.
 - Patch 11: the eviction comments say the same sendmsg call creates
   the replacement, and the rs_conn comment lists the eviction.
 - Patch 12: the initiate_connect and handle_connect checks are
   described as defensive, like the pin; neither path is reachable
   today.
 - Rebased onto current net-next.
 - The scope-id comparison the review asked for in the sendmsg cache
   test is a separate fix in flight for net ("net/rds: scope-aware
   sendmsg connection cache").

Changes since v7 [9]:
 - New patch 3: rds_ib_add_conn() refuses a device that
   rds_ib_dev_shutdown() has marked, so a connect racing device removal
   or module unload cannot attach a connection nothing tears down; with
   the unload wait that race would have become an rmmod that never
   returns.
 - Patches 6 and 7 swapped (unlink/claim before the unload wait), so
   the resweep never runs over a list an in-flight connect can move a
   node out of; the nodev-list assertion goes with the other two in the
   unlink patch.
 - Patches 4 and 5 lose their Fixes: tags: the sites patch 4 guards
   cannot fire at a destroy with today's predicate, and the loopback
   pernet-exit window patch 5 describes has no queuer at module exit
   (every socket pins the module).  Both are described as preparation
   for the per-connection predicate the series needs.
 - Patch 5: the c_destroy_in_prog comment and the changelog describe
   the destroy == true rds_conn_path_drop() from IB device removal as
   flushed by the module exit's later destroy, not by the removal.
 - Patch 6: the first-caller guard is documented as the contract, not
   as closing a double destroy - no sweep hands a connection to
   rds_conn_destroy() twice now that every sweep unlinks or claims the
   node first; the "at this point in the series" wording is gone.
 - Patch 7: the IB unlink happens off the claimed stack list without
   the transport lock, and the changelog says so.
 - Patch 8: changelog names the two existing rmmod holes the resweep and
   the rds_wq flush close (a late-detaching connection outlived the
   module; rds_ib_dev_free() could run after unload).
 - Patch 10: the BUG_ON() on a socket-owned message is a WARN_ON_ONCE()
   rather than gone, and the changelog describes what the lock and the
   RDS_MSG_ON_CONN clear each do.
 - Patch 11: SIOCRDSSETTOS stores rs_tos with WRITE_ONCE() to pair with
   the lockless READ_ONCE() in sendmsg; the rs_lock comment places
   rs_tos correctly and names that exception; the dead
   rds_destroy_pending(passive) branch under rds_conn_lock is removed
   (a passive still installed cannot have its destroy begun); the
   c_destroy_in_prog comment says the c_passive checks use the
   predicate; the changelog says the functional change today is the
   rs_lock serialization.
 - Patch 12: changelog notes that an unload beginning after the
   initiate_connect check is covered by patch 3.
 - Patch 13: names the patch that introduced t_conn_count instead of
   "the previous patch".
 - Rebased onto net-next with the rdma_cm id restriction (c7fca8aae6fe).
 - The pre-existing rdma_resolve_route() failure return in the
   ADDR_RESOLVED case, and the active-side non-IB device case, are
   fixed separately for net (v4 of "net: rds: fix uninitialized trans
   dereference in CM event handler").

Changes since v6 [8]:
 - Rebased onto net-next with ba3d1f480c7a ("net/rds: size a
   connection's path set by the transport it ends up with"), which
   closes the pre-existing per-path workqueue leak the v5 review found
   under patch 8, and 5ccac2330deb ("net/rds: replace tasklets with
   workqueue").
 - Patch order: the rds_incoming reference patch (v6 patch 12) moves
   ahead of the purge and the reference-holder patches, and the purge
   precedes the reference holders, so no bisect point has a queued
   message or a cached connection without the reference that protects
   it, nor a pinned connection over an unlocked purge.
 - Changelogs and comments no longer describe a destroy under a live
   socket as reachable: no trigger in this tree (netns teardown, module
   unload) runs while a socket is sending, and IB device removal drops
   rather than destroys.  Patches 7, 8, 10, 11 and 12 are reworded
   accordingly; patch 7 no longer cites the version-mismatch destroy.
 - Patch 4 names the destroy == true rds_conn_path_drop() among the
   arming sites the predicate does not cover.
 - Patch 5 states the first-caller-wins semantics of the destroy guard,
   in the changelog and the function comment, and the c_destroy_in_prog
   comment records that it is set under rds_conn_lock as a test-and-set.
 - Patch 10: the rds_tcp_accept_one() comment credits
   rds_tcp_kill_sock() for the clear-then-flush ordering; the
   c_destroy_in_prog comment covers the direct reads at the c_passive
   sites.
 - Patch 11: the pin's rationale says what it guards - the holders
   outside the handler - and that it is defensive today.
 - Patch 4 is a fix after all: the loopback pernet exit at core-module
   unload destroys connections with the old predicate false.  Changelog
   rewritten around that path, Fixes: c809195f5523; the c_destroy_in_prog
   comment names the two exempt arming sites.
 - Patch 5: stale version-mismatch example removed; the first-caller
   guard documented as inert until the re-sweep needs it.
 - Patch 6: the nodev-list BUG_ON in rds_ib_add_conn() goes here, not
   two patches later, so no bisect point empties that list under it;
   changelog no longer describes holders that arrive later.
 - Patch 7: rds_ib_conn_free() comment describes the claimed state.
 - Patch 8: a cached connection found with its destroy begun is dropped
   from the cache on the spot, instead of staying pinned until close;
   rs_lock comment names rs_conn and rs_tos.
 - Patch 9: the purge clears RDS_MSG_ON_CONN under cp_lock, so
   rds_send_drop_to() can neither double-put nor unlink from the purge
   list, and the BUG_ON on a socket-linked message goes; send.c is no
   longer touched (v6 had accidentally dropped the READ_ONCE() on
   rs_tos there).
 - Patch 10: rds_ib_cm_initiate_connect() gets the same
   rds_destroy_pending() check as the passive side, so a connect that
   completes after the destroy's quiesce cannot leave a QP and a device
   reference nothing tears down.

Changes since v5 [7]:
 - Rebased; the version-mismatch destroy is now an rds_conn_drop() in
   net-next (f97d8c7bab78), so patch 4's Fixes: tag is gone and its
   changelog describes what still needs the per-connection flag, and
   the CM-callback deadlock reports against earlier versions no longer
   apply.
 - Patch 2: described as the refactor it is (the passive twin is
   IB-only, single path); Fixes: tag dropped.
 - Patch 9: reduced to the cp_lock purge; the send-side refusals and
   the negative *queued signalling are dropped, since no sender can be
   in flight at a destroy trigger.
 - Patch 6: wait comment describes the initial-sweep-plus-resweep
   contract; changelog notes the guarantee is complete only once incs
   hold references.
 - Patch 8: c_destroy_in_prog read through rds_destroy_pending() in
   __rds_conn_create(); the c_passive puts documented as possibly the
   last; READ_ONCE() on the unlocked rs_tos sample; rs_conn comment
   notes the rds_release() exception.
 - Patch 10: stale forward-reference comment fixed.

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
[7] https://lore.kernel.org/netdev/20260919061149.250658-1-achender@kernel.org/
[8] https://lore.kernel.org/netdev/20260922085410.391323-1-achender@kernel.org/
[9] https://lore.kernel.org/netdev/20260927061448.167862-1-achender@kernel.org/
[10] https://lore.kernel.org/netdev/20261003163215.250253-1-achender@kernel.org/
[11] https://lore.kernel.org/netdev/20261008031333.1142174-1-achender@kernel.org/
[12] https://lore.kernel.org/netdev/20261016161525.146537-1-ngocthang2710.1999@gmail.com/
[13] https://lore.kernel.org/netdev/20261017032319.2563014-1-achender@kernel.org/
[14] https://lore.kernel.org/netdev/20261106031615.1047052-1-achender@kernel.org/

Allison

Allison Henderson (9):
  net/rds: undo conn_alloc() the same way on every __rds_conn_create()
    exit
  net/rds: ib: refuse to attach a connection to a device being removed
  net/rds: guard every work-requeueing site with rds_destroy_pending()
  net/rds: make rds_destroy_pending() report a connection's own destroy
  net/rds: unlink transport nodes before a possibly deferred connection
    free
  net/rds: hold a connection reference from struct rds_incoming
  net/rds: take cp_lock to purge cp_send_queue in the quiesce
  net/rds: give cm_id->context a reference on its connection
  net/rds: drop rds_conn_count in favor of t_conn_count

Sharath Srinivasan (3):
  net/rds: split connection destroy into quiesce and kref-governed free
  net/rds: wait for connections to be freed on transport unload
  net/rds: hold connection references in lookup, sockets and c_passive

 net/rds/af_rds.c         |  26 ++-
 net/rds/connection.c     | 346 ++++++++++++++++++++++++++++++++++-----
 net/rds/ib.c             |  27 ++-
 net/rds/ib.h             |  11 +-
 net/rds/ib_cm.c          |  59 ++++++-
 net/rds/ib_rdma.c        |  81 +++++++--
 net/rds/ib_recv.c        |   6 +-
 net/rds/ib_send.c        |  18 +-
 net/rds/loop.c           |  61 +++++--
 net/rds/message.c        |  16 +-
 net/rds/rdma_transport.c |   7 +
 net/rds/rds.h            |  64 +++++++-
 net/rds/recv.c           |  27 ++-
 net/rds/send.c           |  82 ++++++++--
 net/rds/tcp.c            |  53 +++++-
 net/rds/tcp_listen.c     |  22 ++-
 16 files changed, 781 insertions(+), 125 deletions(-)


base-commit: c88fd6989aea9237a60a4859139a265bfb7ddc0b
-- 
2.50.1

