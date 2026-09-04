Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0533932E1;
	Fri,  4 Sep 2026 07:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505371; cv=none; b=UgGb6eQumaHwBnC8FIhYJyQuvkDPsCbeMQrN1VjQVl8b6rpzGCC9rfUrMCb7hj0L+PsWG/ObCD0M0t+jp1U+FhS0TIn/2fpgfpj5VIZ/xTdLHsj9V3djzc2L/0QPCM0SkYreWy4ojSSA308FloTBpUmyHWdQUyCYzJISDzsTP98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505371; c=relaxed/simple;
	bh=2x0UUSQzfkPS1nfjFDYK4m0MbvWtWlQ74cxd6TmjI9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=COTnStt0+42jRUcG7fY2+Ea7oD9CrgfwmbOadhi36jqNbks6rf8mbueEwti/tkubUgQzfuuedam+8LcPZxb9TZB5/oyD6VIwb4XI/HBqW5FLAbjiwrPPKIKtcRBGayzamirQnMHXGfecUb4xX0Q1vNBmNG7Wj1Y1ZB+5y93wNz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUA+CG1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUA+CG1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689DC1F00A3D;
	Fri,  4 Sep 2026 07:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505369;
	bh=anFcLtO6Ah4HidMYiPOW81QlmYKA4TzQgsqOVmRInhU=;
	h=From:To:Cc:Subject:Date;
	b=kUA+CG1qni2ieMxc9NYPQudcbHK8uU/d52L9ElFgbV+0r2VfDqqtJ0+cXRWDz2JuK
	 VLTuMbU4/rG5DQrzvLZCB4mURzd7sRi+ZY8FfSr9+sPpYMxAh1h1BTLBHWjwk/Qd5P
	 FReMbCU6l3QiVyK9o3fLTsX7vAeA0d8ZenM3723vDJMahsRi+vRHd8igpeH9xeUNGd
	 zfx/PYvAfWDyqwJZkR7PdJGn9b/Tf8oQw4S2wr8rQSLE9hAy1lz1dd3eiUVZxFooOE
	 +SQmnsFSITsSSK1I4iW5quf7C0R0ABTQ69svD+LIEE7DBtSLGRTIHXIKFSkRLkbHU0
	 EfaJpy+xse9PQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next 0/6] net/rds: make connection lifetime reference-counted
Date: Fri,  4 Sep 2026 00:02:42 -0700
Message-Id: <20260904070248.160384-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This set is the next stage of the RDS stabilization work, following
"net/rds: own the fastpath locks across connection teardown", now
net-next.  This series is targeted to net-next as well. Though the 
series fixes real use-after-frees (one syzbot report and one report
from Chengfeng Ye below), it does so by reworking connection lifetime,
which is a substantial change.

rds_conn_destroy() frees the connection, its paths and its workqueues
on the spot, relying on the documented assumption that "no one else is
referencing the connection".  That assumption stopped being true a
long time ago.  Connections are destroyed not only on rmmod but also
on IB device removal and on protocol-version mismatch, while pointers
to them still live in socket rs_conn caches, congestion-map conn
lists, CM callbacks and workers, and - for as long as an application
leaves data unread - in every rds_incoming sitting on a receive
queue.  Each of those is a use-after-free waiting for its trigger, and
no single Fixes: commit covers the rot, so the series carries
Reported-by tags where there are concrete reports instead.

  Patch 1 gives the connection itself a destroy-in-progress marker so
  that rds_destroy_pending() covers single-connection destroy, not
  just the netns-teardown and module-unload cases.  Without it, the
  work-requeueing sites can re-arm works on a connection whose
  workqueues are about to be destroyed.
  Based on UEK commits:
     e2f5005adf63 net/rds: Add krefs to struct rds_connection
     https://github.com/oracle/linux-uek/commit/e2f5005adf63

     6c53ef92f46e net/rds: Merge uses of conn->c_destroy_in_prog & RDS_DESTROY_PENDING
     https://github.com/oracle/linux-uek/commit/6c53ef92f46e

  Patch 2 splits rds_conn_destroy() into a quiesce phase and a
  kref-governed free, so a connection with references still
  outstanding stays allocated (quiesced, unhashed and unusable) until
  the last reference is dropped.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection").
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

  Patch 3 hands out real references everywhere a connection pointer
  previously escaped bare: rds_conn_lookup(), __rds_conn_create()'s
  return, the rs_conn sendmsg cache, and the parent's c_passive
  pointer.
  Based on UEK commits:
     2c8569e4c880 ("net/rds: Add krefs to struct rds_connection")
     https://github.com/oracle/linux-uek/commit/2c8569e4c880

     0e9e3a72b7f7 ("net/rds: rds_sendmsg must use rs_conn only when not being destroyed").
     https://github.com/oracle/linux-uek/commit/0e9e3a72b7f7

  Patch 4 makes each transport's exit path wait for its own
  connections to actually be freed before the module text goes away,
  since the free - including the transport's conn_free - is now
  asynchronous.
  Based on UEK commits:
     ece4b4e39afa ("net/rds: wait_event_timeout until zero connections during rmmod")
     https://github.com/oracle/linux-uek/commit/ece4b4e39afa

     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count")
     https://github.com/oracle/linux-uek/commit/905ec90e6166

  Patch 5 is the cleanup fallout of patch 4: the global rds_conn_count
  has no remaining consumer besides a workqueue-name seed, so switch
  the seed to the per-transport count and remove it.
  Based on UEK commits:
     905ec90e6166 ("net/rds: Each RDS transport should keep its own connection count").
     https://github.com/oracle/linux-uek/commit/905ec90e6166

  Patch 6 makes struct rds_incoming hold a reference on i_conn, which
  is the fix for the KASAN use-after-free Chengfeng Ye reported [1],
  where rds_info_getsockopt() walks a socket receive queue whose incs
  point at connections rmmod already freed.
  Based on UEK commits:
      99b9a3715419 ("net/rds: fix crash by expanding kref coverage to rds_incoming.i_conn").
      https://github.com/oracle/linux-uek/commit/99b9a3715419

Patches 2, 3, 4 and 6 are ports of the connection kref work Sharath
Srinivasan did for Oracle UEK, adapted to the upstream code.

The series has been validated with the RDS selftests over both
loopback-TCP and RXE-RDMA transports, plus targeted churn tests that
delete network namespaces and unload the modules under live rds-stress
traffic - the paths this series changes.

[1] https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

Allison


Allison Henderson (2):
  net/rds: make rds_destroy_pending() cover single-connection destroy
  net/rds: drop rds_conn_count in favor of t_conn_count

Sharath Srinivasan (4):
  net/rds: split connection destroy into quiesce and kref-governed free
  net/rds: hold connection references in lookup, sockets and c_passive
  net/rds: wait for connections to be freed on transport unload
  net/rds: hold a connection reference from struct rds_incoming

 net/rds/af_rds.c     |   8 ++
 net/rds/connection.c | 189 ++++++++++++++++++++++++++++++++++++++-----
 net/rds/ib.c         |  14 +++-
 net/rds/ib_cm.c      |   8 +-
 net/rds/loop.c       |   2 +
 net/rds/message.c    |  16 +++-
 net/rds/rds.h        |  25 +++++-
 net/rds/recv.c       |  21 ++++-
 net/rds/send.c       |  45 +++++++++--
 net/rds/tcp.c        |   1 +
 net/rds/tcp_listen.c |   5 +-
 11 files changed, 297 insertions(+), 37 deletions(-)

-- 
2.25.1

