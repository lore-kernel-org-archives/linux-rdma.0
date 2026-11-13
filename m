Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545037;
	b=qEqmx39o/bgDWwEXPKC/0IwNylTJRagNKkr6RLSdtj/h/vSYq3pAPvJg5IV72Kx0TWIZ
	 Ru/joNRSTZbd8v77VDkR6ezN6EqWfS4Qno1oMBYB163oVt9MdZpnag9dz/cMO/FkK1DVT
	 xwuttotUVuFzzOUNN5P6KgnSRa46Fd7Gikw3wQUpSdUHXkQ/5khAkj4z6dIai0tNW9p4I
	 wMNVSKLf7gFqNV0mGnsvKMHQHtGWtR/H8foU5zA5rHKpfUN4e6Eq+SO4S3EDn4WVEA6U/
	 k55A0FEP9D4ctZkLupz+cW1t/m324pGUOlL6iOqbhun1U1Ekw2qVjmnghZLptUO8k8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kWrqpQdW3eFWvTDbVP1woMyFzomYqq4J9cnkshJxnWs=;
	b=Rkf2By4k2xSC0L0pUM1ZG02zWde55vXDC916L408HZrbVtzOCNaSm2MI9u++IRUfCoyH
	 JfD8dntrymWNSEUIKLCF0h81TpPVRMW+KlK/sznYPrYWcJFcFkbBiQLPU3oq8iUqFQUjI
	 ByqaV7Bj4FwORJNs5N9C+xCMXvjvZ8XojerfYz7ymJDESBKlc/cQHtkCwYsA3YAw0xsp1
	 wKXQpWS/n4E/v0xb906cg3as9mQYzOLxgiB3kHZRAdWZ3IIl5h+Czhe9v8770XwZRsEZD
	 V1j9QHoMM5GRRnv3FhFiSrWsaPcQx8mYiraW/nY3ZQIv4SwVAsTIqVOWOCTeEBbszJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YJEhcdvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7B0606A337;
	Fri, 13 Nov 2026 04:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YJEhcdvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9881F000C5;
	Fri, 13 Nov 2026 04:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545037;
	bh=kWrqpQdW3eFWvTDbVP1woMyFzomYqq4J9cnkshJxnWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJEhcdvTkyQRBv7EcaP9qIRydz29OnbLbo6QvhoIo44PBgGDzCTN+qjP/7D1IMkyp
	 CqctSUsV+oCpbyOovkaC9WjtXOBuulMmmJy+uxNXepmo35KbcdAbIKQEn7BOPfRmzl
	 lUiy6ssSIEpxhCUoLeCcbvL5CeZH0RqRjPKR8bYeVxzayuPTCvJIhEbnuwqvSmDGOI
	 grqSFHjhdlXFet6BlbfeW0ZjQYFl/Msg8XdnTRrPC25OfILafA2OpQy/OY0HIOCodU
	 OAnEz3tq+mm5h7slIzb4MSnxx9eBYMSRK4F5fpB6Hs8ES1Kz/pvk983EAbfJWTOsW7
	 BtUIKc4Z7KPcQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 02/12] net/rds: ib: refuse to attach a connection to a device being removed
Date: Thu, 12 Nov 2026 21:43:45 -0700
Message-ID: <20261113044355.2932029-3-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113044355.2932029-1-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
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

rds_ib_remove_one() drops every connection on the device's conn_list
in rds_ib_dev_shutdown(), then clears the client data so that no new
connect can find the device.  A connect that is already past
rds_ib_get_client_data() when the walk runs is not covered by either:
rds_ib_setup_qp() goes on to rds_ib_add_conn(), which moves the
connection onto the conn_list the walk has just finished with, and
builds a QP on a device that is on its way out.

On a hot removal the rdma_cm still catches that: its own client
removal runs after RDS's and delivers RDMA_CM_EVENT_DEVICE_REMOVAL to
the connection's id, whose drop shuts the connection down and returns
it to ib_nodev_conns.  On module unload there is no such event - the
device stays registered - and rds_destroy_pending() is already true,
so every drop short of a destroy returns early.  Nothing drops that
connection then: the device's shutdown walk is over, and the
connection never returns to ib_nodev_conns, which is the only list the
transport exit sweeps.  So it outlives the module, QP, device
reference and all.  The trigger is unloading rds_rdma while a connect
is in flight.

Make rds_ib_dev_shutdown() mark the device as shutting down under
rds_ibdev->spinlock before it walks conn_list, and have
rds_ib_add_conn() refuse, under the same lock, to attach a connection
to a device so marked.  Every connection is then either on the list
when the walk drops it, or refused: the connect fails, the connection
stays on ib_nodev_conns, and either its own drop or the exit sweep
tears it down.  rds_ib_setup_qp() has not taken anything from the
device at that point, so the failure needs no unwinding beyond the
client-data reference it already releases - but on the unload path
that release can now be the device's last: rds_ib_remove_one() has
dropped its own references by then, and the refused connect, holding
c_cm_lock, releases its reference only when the exit sweep's
rds_conn_destroy() of that connection waits for the lock, after
rds_ib_unregister_client()'s flush of rds_wq.  rds_ib_dev_free()
would then run on rds_wq with no flush left before the module text
goes away, so rds_ib_exit() flushes rds_wq once more after the sweep.

This covers the connect that attaches after rds_ib_dev_shutdown()'s
walk.  Its twin - a connection still on conn_list when the exit sweep
runs, because its shutdown work has not yet moved it back to
ib_nodev_conns - is left for the unload wait later in the series,
which re-sweeps that list until every connection is gone.

This mirrors the UEK gate on the device removal flag in
rds_ib_add_conn().

Fixes: fc19de38be92 ("RDS/IB: disconnect when IB devices are removed")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib.c      | 12 ++++++++++++
 net/rds/ib.h      |  7 ++++++-
 net/rds/ib_cm.c   |  4 +++-
 net/rds/ib_rdma.c | 17 +++++++++++++++--
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4ea9838d090c..8758ae4cef36 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -86,6 +86,11 @@ static void rds_ib_dev_shutdown(struct rds_ib_device *rds_ibdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rds_ibdev->spinlock, flags);
+	/* Close the device to new connections under the same lock that
+	 * rds_ib_add_conn() attaches them under, so that every
+	 * connection is either dropped by the walk below or refused.
+	 */
+	rds_ibdev->shutting_down = true;
 	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
 		rds_conn_path_drop(&ic->conn->c_path[0], true);
 	spin_unlock_irqrestore(&rds_ibdev->spinlock, flags);
@@ -539,6 +544,13 @@ void rds_ib_exit(void)
 #endif
 	rds_ib_unregister_client();
 	rds_ib_destroy_nodev_conns();
+	/* A connect that was refused above may have held the last
+	 * reference on its device, and dropped it - deferring
+	 * rds_ib_dev_free() to rds_wq - only once the sweep had destroyed
+	 * its connection, after rds_ib_unregister_client()'s flush.
+	 * Drain rds_wq again before this module's text goes away.
+	 */
+	flush_workqueue(rds_wq);
 	rds_ib_sysctl_exit();
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 1901226368c9..d1a3d421d439 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -258,6 +258,10 @@ struct rds_ib_device {
 	unsigned int		max_initiator_depth;
 	unsigned int		max_responder_resources;
 	spinlock_t		spinlock;	/* protect the above */
+	/* set under spinlock by rds_ib_dev_shutdown(): the device is
+	 * going away and no connection may attach to it any more
+	 */
+	bool			shutting_down;
 	refcount_t		refcount;
 	struct work_struct	free_work;
 	int			*vector_load;
@@ -384,7 +388,8 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn,
 struct rds_ib_device *rds_ib_get_device(__be32 ipaddr);
 int rds_ib_update_ipaddr(struct rds_ib_device *rds_ibdev,
 			 struct in6_addr *ipaddr);
-void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn);
+int rds_ib_add_conn(struct rds_ib_device *rds_ibdev,
+		    struct rds_connection *conn);
 void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn);
 void rds_ib_destroy_nodev_conns(void);
 void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 16bfeaaf3b97..ebb5e7aab580 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -524,7 +524,9 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	fr_queue_space = RDS_IB_DEFAULT_FR_WR;
 
 	/* add the conn now so that connection establishment has the dev */
-	rds_ib_add_conn(rds_ibdev, conn);
+	ret = rds_ib_add_conn(rds_ibdev, conn);
+	if (ret)
+		goto out;
 
 	max_wrs = rds_ibdev->max_wrs < rds_ib_sysctl_max_send_wr + 1 ?
 		rds_ibdev->max_wrs - 1 : rds_ib_sysctl_max_send_wr;
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index db7e92e7bd29..50c02f47cf68 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -119,7 +119,8 @@ int rds_ib_update_ipaddr(struct rds_ib_device *rds_ibdev,
 	return 0;
 }
 
-void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn)
+int rds_ib_add_conn(struct rds_ib_device *rds_ibdev,
+		    struct rds_connection *conn)
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
 
@@ -127,15 +128,27 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
 	spin_lock_irq(&ib_nodev_conns_lock);
 	BUG_ON(list_empty(&ib_nodev_conns));
 	BUG_ON(list_empty(&ic->ib_node));
-	list_del(&ic->ib_node);
 
 	spin_lock(&rds_ibdev->spinlock);
+	/* rds_ib_dev_shutdown() has walked conn_list, or is about to
+	 * with this lock held: a connection attached now would never be
+	 * dropped by it, so leave the connection on the nodev list for
+	 * the caller to fail and the transport exit to find.
+	 */
+	if (rds_ibdev->shutting_down) {
+		spin_unlock(&rds_ibdev->spinlock);
+		spin_unlock_irq(&ib_nodev_conns_lock);
+		return -ENODEV;
+	}
+	list_del(&ic->ib_node);
 	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
 	spin_unlock(&rds_ibdev->spinlock);
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
 	ic->rds_ibdev = rds_ibdev;
 	refcount_inc(&rds_ibdev->refcount);
+
+	return 0;
 }
 
 void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn)
-- 
2.50.1

