Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51413A900B;
	Thu,  8 Oct 2026 03:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429217; cv=none; b=WoUfbp1UFXMY7GqBey8nrwra7C0zp7+OnSWfqnZQGO3G776v6UDEeBFNSA+pWTPS7/UlXbUCPo41LSXp5fzIgf7/rRry3DwvH1kBlptGdeY7Y1PrumNR/MSvbGgeI8JSP+L6tAO/Tm+OwLaY5Vwf5D2p8SPcpV6tdcI6vhP7UmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429217; c=relaxed/simple;
	bh=0CRzB8T06JkYeOSE5HdJCcRgMLX/p2bQ2N8Vu/5VjMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GTG8B0C8AbADgAhZJvqv6X68Eit1mxJ1lXv8QCS4n9Ocr/egCAzbyb0IR3j6iCVbSGLhWBJC9Gn7EWaNf7ThxG2ZOrfs4vNmQYPH5G1GNHWHELneyNTtsQbG/dTl0XtSW89HpED1cGIq+f+7OcwhdkAXdgROk2pdh6EuCAijUzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2nsmkwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2nsmkwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C08E1F0089A;
	Thu,  8 Oct 2026 03:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429215;
	bh=5STwV4gYWCLHmQsYR5ZmsFdYbhQyPZ271MNLJwcI1mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2nsmkwHRJxxOmvAkbvrYVuRILgpyvjsVC8B/Eg/HvqHRjAbI0CERyeqq2WBeMYuB
	 3fnmnVVFMcw05psoRqGOKNKPwjYFUE1E89tLWURJkzRysC56josnYOa/tN8ATLEWwR
	 b8Ds1+DUjpnHtLSRTb9x6+533z1RPUC9NJ26xcNTqKhjwAL4gBGdyh6NYOGg20t3s2
	 ufhjiDaK3lX2C3VR06uwIKa8NOX8lRnFVavDPJMTEUK+/GRqfHpIy4lLcs1hpsrTC2
	 6XloKzjGL6mLI4Wq28dXnRTdpAmSXSMnTfjloivcLvpbU227Z+lh2NfA5ra0O1W2QB
	 szVPRrvzT5enw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v9 03/13] net/rds: ib: refuse to attach a connection to a device being removed
Date: Wed,  7 Oct 2026 20:13:23 -0700
Message-Id: <20261008031333.1142174-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261008031333.1142174-1-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
client-data reference it already releases.

This mirrors the UEK gate on the device removal flag in
rds_ib_add_conn().

Fixes: fc19de38be92 ("RDS/IB: disconnect when IB devices are removed")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib.c      |  5 +++++
 net/rds/ib.h      |  7 ++++++-
 net/rds/ib_cm.c   |  4 +++-
 net/rds/ib_rdma.c | 17 +++++++++++++++--
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4ea9838d090c..a7647ec01a11 100644
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
index 8b16bd7c40ce..82ecbb9a3da1 100644
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
2.25.1

