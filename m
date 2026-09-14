Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7EA35C19F;
	Mon, 14 Sep 2026 03:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357043; cv=none; b=k2fIeRixWvkw+VwlaSBYLQEJoEghtBbHQ3hA3duXqHTUEdzpT31O5He6ws3sXs7V+XYQZgmPavPevTvpllJPn99Ge1LW7nFGVPtk6Jgf3VXnDtfEpzbYYEo/HgvrWQ0rnhsYJ7whgpcDtJ3GhG9tB5I1LIpErVcnaXxLhgYQwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357043; c=relaxed/simple;
	bh=Uoj5zIEAqEMFyeYTGarszLsg97Bumn2Zpm7uMYC2K0s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hP6mdKU+Jl2QzX6y+hvdQlVpEYY3ndN7d6XN/yM7/nRIAYhLliqL1p9WbHOY+TkkrO7VFO0rP/XSCIqjMYVjb0wtKSNx/IMZs6Pt7l9GcrffzOXE46lI8NSWUav/uBYU+S/RX/+aqRiOMbCsmU0vm4OZZHeBhSjLJRN7x7K41uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUaM0kmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUaM0kmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F871F000FF;
	Mon, 14 Sep 2026 03:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357040;
	bh=4KKnDJeqg5PCYRRcF6V4nZbuCBHF+iq8SlgLMfA0TYI=;
	h=From:To:Cc:Subject:Date;
	b=VUaM0kmjpR1Eg0jy+Vw/8nCio/uuGtWFf2r0yR9DH2p6YpLm76zXhODYz4Kh04E8U
	 yueU7QERDT2PgaXBoMmqzqG+SVQIZ7NtyF34E3SZNUXmPJcs4GqEvEnhDMRKfBzmWt
	 NWF3TMv1CAZqWQ/VmMJEYwrSOlQZ1O5t8Mm6SwrFHOUIal8u7n0tZwkhxnKNROyvQi
	 mV0f2//EY8n8dPFZgjL66Kyngebhpcd7/yslhChdOk/VQmNtWlE3besz0uVfs6eq9Y
	 tjU3JwowOln219ZWiBMuiQAsxxSbN0CiGsumzoRn8U8JuYHf2dMDA12dD133JL7z0F
	 rd1YiqDZ0CrbA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v3 00/13] net/rds: make connection lifetime reference-counted
Date: Sun, 13 Sep 2026 20:37:06 -0700
Message-Id: <20260914033719.138057-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v3 of the connection-lifetime set (v1 at [1], v2 at [2]),
following
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

  Patch 1 (new) fixes rds_ib_conn_free() re-enabling interrupts under
  a caller's irqsave lock.

  Patch 2 (new) frees every path's transport data on the
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
  stack-local list head.

  Patch 8 hands out real references everywhere a connection pointer
  previously escaped bare, RCU-annotates parent->c_passive, refuses to
  revive a passive connection whose destroy has begun, and serializes
  the SIOCRDSSETTOS check with the rs_conn cache.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

     0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
     https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7

  Patch 9 (new) has rds_send_queue_rm() refuse, under cp_lock, to
  queue on a connection whose destroy has begun, and has the quiesce
  splice cp_send_queue away under the same lock: a message queued
  after the purge would hold a connection reference nothing ever
  drops.

  Patch 10 (new) has rds_tcp_accept_one() refuse to install an
  accepted socket on a connection whose destroy has begun.

  Patch 11 pins the connection across the RDMA-CM event handler
  and rejects a connect request for a connection whose destroy has
  already quiesced it.

  Patch 12 drops the now-unused global rds_conn_count.
  Based on UEK commits:
     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
     https://github.com/oracle/linux-uek/commit/905ec90e6166

  Patch 13 makes struct rds_incoming hold a reference on i_conn, the
  fix for the KASAN use-after-free Chengfeng Ye reported [3].
  Based on UEK commits:
      99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
      https://github.com/oracle/linux-uek/commit/99b9a3715419

Patches 5, 8, 6 and 13 are ports of the connection kref work Sharath
Srinivasan did for Oracle UEK, adapted to the upstream code.

The series has been validated with the RDS selftests over loopback-TCP
and RXE-RDMA, plus churn tests that delete network namespaces and
unload the modules under live rds-stress traffic.

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
[3] https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

Allison


Allison Henderson (9):
  net/rds: ib: don't enable interrupts in rds_ib_conn_free()
  net/rds: free every path's transport data on the passive create paths
  net/rds: guard every work-requeueing site with rds_destroy_pending()
  net/rds: make rds_destroy_pending() cover single-connection destroy
  net/rds: unlink transport nodes before a possibly deferred connection
    free
  net/rds: refuse to queue a message on a connection being destroyed
  net/rds: tcp: don't attach an accepted socket to a connection being
    destroyed
  net/rds: pin the connection across RDMA-CM event handling
  net/rds: drop rds_conn_count in favor of t_conn_count

Sharath Srinivasan (4):
  net/rds: split connection destroy into quiesce and kref-governed free
  net/rds: wait for connections to be freed on transport unload
  net/rds: hold connection references in lookup, sockets and c_passive
  net/rds: hold a connection reference from struct rds_incoming

 net/rds/af_rds.c         |  24 ++-
 net/rds/connection.c     | 326 +++++++++++++++++++++++++++++++++------
 net/rds/ib.c             |  22 ++-
 net/rds/ib_cm.c          |  28 +++-
 net/rds/ib_rdma.c        |  14 +-
 net/rds/ib_recv.c        |   6 +-
 net/rds/ib_send.c        |  18 ++-
 net/rds/loop.c           |  39 +++--
 net/rds/message.c        |  16 +-
 net/rds/rdma_transport.c |  16 +-
 net/rds/rds.h            |  40 ++++-
 net/rds/recv.c           |  21 ++-
 net/rds/send.c           |  77 +++++++--
 net/rds/tcp.c            |  29 +++-
 net/rds/tcp_listen.c     |  25 ++-
 15 files changed, 602 insertions(+), 99 deletions(-)

-- 
2.25.1

