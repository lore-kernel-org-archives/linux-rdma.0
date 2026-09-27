Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DFB5C613;
	Sun, 27 Sep 2026 06:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790489691; cv=none; b=M8mRfno3vDSBc+tJkdZAq1kvO7/dtp2ldRdtKuVigpz5TDsCIj89ryvHGHVBbZG8y6Yad8LYbR1XgMJIWUqI0MWRl1QI1mPXub8ob+fRKuH5rzQT0qeLWYHpzj+TYp78fVEDCqeqwJ5xYR/LmNFrllEttCGxRAIF7o5L+3SQA04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790489691; c=relaxed/simple;
	bh=whacxx2lkD/Qi4GGAF69V24kLYSbKcME+xYUPy9n5ZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iB3bhc+UpLNXiTs5VZbc3bMd6DLku9MSd15Im7/bugTu3XgPzX+RqW8Rs5LFjDbmQFbeNtu8Eeow0RLQl+nQ4mLf8D6tRRVEhJIWPyHDb3G9N3xoTepOKEUj0TgeEiP1klvbfbA+JQO6AcpguH55Bj+UqpJjKyhW1iZ8Jr+9okA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9tAKAoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9tAKAoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1301C1F000FF;
	Sun, 27 Sep 2026 06:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790489689;
	bh=hjPsvPIyei+vIUk0dLLLkNM5iPyNServ4Tk1S/tMY7Q=;
	h=From:To:Cc:Subject:Date;
	b=Y9tAKAoqcA+575Yo+5dhXr0fANXS9Tkf1KSKOoi1aYORLhkTTU7TbFR5ABk04qc33
	 QlF/HIxSlqK+qfobzS9XXZ8F0dQxXjzoC7GVcqXYfslAEA7W82KvHyPUiQmoKY0GBl
	 Q53wWc5XQeE1jpk+bGf+omHEako6917h6eTnpIfEXv1Qvf/tsL4AEz9W9yi/9r9Pum
	 I9J/SB0bTyr20AdfazlPaRX3Epwxbd0RdYfC4mZnODWv3gvKoPXSau+cP9nlNFgjTn
	 364b2qUrvTIIrToXZ/EtuHjQg9/y3JCdG6zrGm2+WqJYiIUtXc2awl8RpFh/8zzpc1
	 nvUcSJXvZPjmg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v7 00/12] net/rds: make connection lifetime reference-counted
Date: Sat, 26 Sep 2026 23:14:36 -0700
Message-Id: <20260927061448.167862-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v7 of the connection-lifetime set (v1 at [1], v2 at [2],
v3 at [3], v4 at [6], v5 at [7], v6 at [8]), following
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

Patches 5, 8, 6 and 12 are ports of the connection kref work Sharath
Srinivasan did for Oracle UEK, adapted to the upstream code.

The series has been validated with the RDS selftests over loopback-TCP
and RXE-RDMA, plus churn tests that delete network namespaces and
unload the modules under live rds-stress traffic.

  Patch 1 fixes rds_ib_conn_free() re-enabling interrupts under
  a caller's irqsave lock.

  Patch 2 makes the passive-connection exits of __rds_conn_create()
  undo conn_alloc() the same way the lost-race exit does, through one
  helper (a refactor: the passive twin only exists for IB, so nothing
  leaked there).  Both are first in the series because the
  reference-counted teardown calls conn_free() from more places.

  Patch 3 guards the five work-arming sites that never tested
  rds_destroy_pending(): two IB completion paths, the IB recv refill,
  the TCP accept kick and the multipath reconnect in sendmsg.

  Patch 4 gives the connection its own destroy-in-progress marker.
  One destroy caller does escape the old predicate: unloading the core
  module runs the loopback pernet exit for every live namespace, where
  check_net() is still true and the loop transport's unloading flag is
  not yet set.  The later patches also need the precise answer: the IB
  unload re-sweep hands a connection to rds_conn_destroy() more than
  once, and the passive-twin creation must refuse a parent whose
  destroy has begun.
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

  Patch 8 makes struct rds_incoming hold a reference on i_conn, the
  fix for the KASAN use-after-free Chengfeng Ye reported [4].
  Based on UEK commits:
      99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
      https://github.com/oracle/linux-uek/commit/99b9a3715419

  Patch 9 has the quiesce purge cp_send_queue under cp_lock, as every
  adder to that queue holds it, and clear RDS_MSG_ON_CONN as it does
  so, the way rds_send_drop_to() expects.  No sender can be in flight
  at any of today's destroy triggers (netns teardown, module unload),
  so this is hygiene rather than a race fix.

  Patch 10 hands out real references everywhere a connection pointer
  previously escaped bare, RCU-annotates parent->c_passive, refuses to
  revive a passive connection whose destroy has begun, and serializes
  the SIOCRDSSETTOS check with the rs_conn cache.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

     0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
     https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7

  Patch 11 pins the connection across the RDMA-CM event handler and,
  on both the passive and the active side, declines to set up a QP for
  a connection whose destroy has already begun.

  Patch 12 drops the now-unused global rds_conn_count.
  Based on UEK commits:
     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
     https://github.com/oracle/linux-uek/commit/905ec90e6166

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

Allison


Allison Henderson (8):
  net/rds: ib: don't enable interrupts in rds_ib_conn_free()
  net/rds: undo conn_alloc() the same way on every __rds_conn_create()
    exit
  net/rds: guard every work-requeueing site with rds_destroy_pending()
  net/rds: make rds_destroy_pending() report a connection's own destroy
  net/rds: unlink transport nodes before a possibly deferred connection
    free
  net/rds: take cp_lock to purge cp_send_queue in the quiesce
  net/rds: pin the connection across RDMA-CM event handling
  net/rds: drop rds_conn_count in favor of t_conn_count

Sharath Srinivasan (4):
  net/rds: split connection destroy into quiesce and kref-governed free
  net/rds: wait for connections to be freed on transport unload
  net/rds: hold connection references in lookup, sockets and c_passive
  net/rds: hold a connection reference from struct rds_incoming

 net/rds/af_rds.c         |  24 ++-
 net/rds/connection.c     | 341 +++++++++++++++++++++++++++++++++------
 net/rds/ib.c             |  22 ++-
 net/rds/ib.h             |   4 +
 net/rds/ib_cm.c          |  49 +++++-
 net/rds/ib_rdma.c        |  67 ++++++--
 net/rds/ib_recv.c        |   6 +-
 net/rds/ib_send.c        |  18 ++-
 net/rds/loop.c           |  61 +++++--
 net/rds/message.c        |  16 +-
 net/rds/rdma_transport.c |  16 +-
 net/rds/rds.h            |  54 ++++++-
 net/rds/recv.c           |  26 ++-
 net/rds/send.c           |  80 +++++++--
 net/rds/tcp.c            |  53 +++++-
 net/rds/tcp_listen.c     |  21 ++-
 16 files changed, 735 insertions(+), 123 deletions(-)

-- 
2.25.1

