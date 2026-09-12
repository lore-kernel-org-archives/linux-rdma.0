Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1888D15A85A;
	Sat, 12 Sep 2026 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789185030; cv=none; b=oYi2alAi7Sfl2KRBOpJm0dvb/fP8d/4cS6WHNSRoVoc8fDHmIuJMvDvUU6ch6q4+huggw1wyM5ima1sfycs9icQf3c2OhaxeaiOuVZfx764v7lTvACr2dqtiFsXc1XFqGaBnIdHL2X7i/SperGBtrYc5GLLBivp8psYxsxR2npQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789185030; c=relaxed/simple;
	bh=lgtTQkGxJIb1ad5eu9R1vRp2m+E7TN9AWWjcITDVdmo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rvtY243OambCuugJJvTn3+zXSEB4DQt9goUFOnPvKVFiYWCBasQCW3Aexn8DXxbq9YGaf2cv5TQV7SoAd2Elu16ZsQ9kwXUYLTNhjwYE+Vi7XGuphkbB28PKCSdgtQ8tOGLtTl3KsWX0D51pCBAsR/6E7TyXyg07X5r4EHPWMnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbCqemTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbCqemTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABEE1F000FF;
	Sat, 12 Sep 2026 03:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789185028;
	bh=B3lVT+6DEejdhrMrylgnkxm6O45JqE8Xw4Fynn+zjLo=;
	h=From:To:Cc:Subject:Date;
	b=kbCqemTjDoMgTI35/SPYhfHUw4BUjhdVld0yaB/QYbBAczs4QlbjSaYggbgLhXEVQ
	 HvdK+JohvmgH2lDpT1ibB58tIts8tjB3d9ZqFowDQolBVNb4tz8J9LUqUQRL+97YrI
	 dk9PKz6x4MwQJaM4/MtmDFWYGL+KCP6qTCAGHcD4A5rMaqywifeRut6bqveastyTiN
	 QoP65jKJMfpAPbD3IQu/+Ik2Hyoppg7V4+ppR0MePAC0Ir3zfvue91DzxanAvzA7jC
	 dUpE7zMS5rPzT29DapjTuvJI6EBcmDa8ta3nMhi7nMfVKShBIQG5v00moRR33NgGJE
	 ONXeQGbxeoNkQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v2 0/9] net/rds: make connection lifetime reference-counted
Date: Fri, 11 Sep 2026 20:50:18 -0700
Message-Id: <20260912035027.27447-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v2 of the connection-lifetime set (v1 at [1]), following
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

  Patch 1 (new) guards the five work-arming sites that never tested
  rds_destroy_pending(): two IB completion paths, the IB recv refill,
  the TCP accept kick and the multipath reconnect in sendmsg.

  Patch 2 gives the connection its own destroy-in-progress marker so
  that the predicate also covers the one single-connection destroy.
  Based on UEK commits:
     e2f5005adf63 net/rds: Add krefs to struct rds_connection
     https://github.com/oracle/linux-uek/commit/e2f5005adf63

     6c53ef92f46e net/rds: Merge uses of conn->c_destroy_in_prog & RDS_DESTROY_PENDING
     https://github.com/oracle/linux-uek/commit/6c53ef92f46e

  Patch 3 splits rds_conn_destroy() into a synchronous quiesce and a
  kref-governed free.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection").
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

  Patch 4 makes each transport's exit path wait for its connections to
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

  Patch 5 (new) unlinks each transport node before its destroy, so a
  free deferred past the teardown loop cannot write into the loop's
  stack-local list head.

  Patch 6 hands out real references everywhere a connection pointer
  previously escaped bare, RCU-annotates parent->c_passive, refuses to
  revive a passive connection whose destroy has begun, and serializes
  the SIOCRDSSETTOS check with the rs_conn cache.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

     0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
     https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7

  Patch 7 (new) pins the connection across the RDMA-CM event handler
  and rejects a connect request for a connection whose destroy has
  already quiesced it.

  Patch 8 drops the now-unused global rds_conn_count.
  Based on UEK commits:
     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
     https://github.com/oracle/linux-uek/commit/905ec90e6166

  Patch 9 makes struct rds_incoming hold a reference on i_conn, the
  fix for the KASAN use-after-free Chengfeng Ye reported [2].
  Based on UEK commits:
      99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
      https://github.com/oracle/linux-uek/commit/99b9a3715419

Patches 3, 6, 4 and 9 are ports of the connection kref work Sharath
Srinivasan did for Oracle UEK, adapted to the upstream code.

The series has been validated with the RDS selftests over loopback-TCP
and RXE-RDMA, plus churn tests that delete network namespaces and
unload the modules under live rds-stress traffic.

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
[2] https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

Allison


Allison Henderson (5):
  net/rds: guard every work-requeueing site with rds_destroy_pending()
  net/rds: make rds_destroy_pending() cover single-connection destroy
  net/rds: unlink transport nodes before a possibly deferred connection
    free
  net/rds: pin the connection across RDMA-CM event handling
  net/rds: drop rds_conn_count in favor of t_conn_count

Sharath Srinivasan (4):
  net/rds: split connection destroy into quiesce and kref-governed free
  net/rds: wait for connections to be freed on transport unload
  net/rds: hold connection references in lookup, sockets and c_passive
  net/rds: hold a connection reference from struct rds_incoming

 net/rds/af_rds.c         |  20 ++-
 net/rds/connection.c     | 274 +++++++++++++++++++++++++++++++++++----
 net/rds/ib.c             |  21 ++-
 net/rds/ib_cm.c          |  19 ++-
 net/rds/ib_rdma.c        |  12 +-
 net/rds/ib_recv.c        |   6 +-
 net/rds/ib_send.c        |  18 ++-
 net/rds/loop.c           |  39 ++++--
 net/rds/message.c        |  16 ++-
 net/rds/rdma_transport.c |  16 ++-
 net/rds/rds.h            |  40 +++++-
 net/rds/recv.c           |  21 ++-
 net/rds/send.c           |  56 ++++++--
 net/rds/tcp.c            |  29 ++++-
 net/rds/tcp_listen.c     |  15 ++-
 15 files changed, 527 insertions(+), 75 deletions(-)

-- 
2.25.1

