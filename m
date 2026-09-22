Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76477419FBE
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790110375; cv=none; b=iWh3tQEf9n7rRV590H4fdFKbUihXuNx/LF8WpFG797JOVQd6PN5HkVHfdoWbBrPAJT4x4kGsMOCFgIO26nGprr1+kCBWw+DRNNBZJqGLbs9BHY+hXXB2WIPEOVh8prA4AbfTMokPA2WJ88seCp8ytdApQPFgZ+5Q8K0K5leljNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790110375; c=relaxed/simple;
	bh=NbjEBeyu2VLG3EhojRaSrC/sVKTJa1ExSwsAOz1USUQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rOB3Ykxogol7yHA1k66VavXDPPc4gEcBHbRWfL8/15a9XP1MYmPjIlbybyhK8TNhNwPzq3a/WAXE+zNeOH1AY+caWR5IDGvfx/ngvbQ6OXl4EaJp0xDQ1DKHvFS4pzGyCErXlJtqwGmzpFrnU29a381+n/FllPQ0HZBwODqpAxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sunnytiwari.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lA25J6lg; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sunnytiwari.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lA25J6lg"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc73f47bdcso2793275ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 13:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790110360; x=1790715160; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+kls6zOn4bhEu16C4wUuQeZkdxufVxysuFtvApSFdDQ=;
        b=lA25J6lg8CmdsTdDZr26h2PjdxLq2i/Z4ERNmmh8KWwCVm0D+yDpEkoV5C8711NuH6
         5DhtvlMGqlN9uhiTgFfhq7EFElrL/aX1yCosTInyXuvfIIRoAn4o3f4rpqt065rwJ8Ux
         DSfCQe7q91nOc1GV0yyRtQclTMfKUhZ8LVJYkTBZ7qyugMZND3ESEqHEQeEHgykSDgg5
         B5W4dz8StT+RGKPgBoX6zZv+GK3fIiVM0WNYB4ZIevSUvmfmgOqCcb3CiIELDKolaZ7C
         8TdwnwV3vpqT4vXQ8Dz44alQOsVKHh7SEc8QK9EjoYfRmZPfbG7icPF8YnO4dXvQje/Z
         dBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790110360; x=1790715160;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+kls6zOn4bhEu16C4wUuQeZkdxufVxysuFtvApSFdDQ=;
        b=yZNYa88TbCx6+0yZHTnCW5/wj6xHJGZH/C5LflHF+96DIjXI7rTV+1CYFwtoCTvIT+
         EgOGa4YueD2ESqZOgIq+5EnRsdQuEZARxEt+IUTqDZ2KUPnAquWBS9sqsdhmNQJkvq9+
         6J78q+sNY3EdoFkfZiSTJKOoN1ZR/+YOz6CMC/X51sVskiOvMeAVvKwaG4j5i8ZUoFK5
         AKNrDSQChpxJE5y9rWa0qgMCTEfb7vcy6o7LjhZwLCrygE43cxHLRoYlcrn1hLgbFuox
         3VQjb4PPM+gDbJp8mfsvelsKdoYWN6LQ0vSooH7YUcMGVKntkPOYqJZTk+Q8j0dnPOoc
         4zoA==
X-Forwarded-Encrypted: i=1; AKwUvBwkhZIY1W5mu/3PYPIFOXeOauCrYfKBlLeoRPWC0U6tysstAMdUOINo/djdspeo+7/qgOkxzxlMv87A@vger.kernel.org
X-Gm-Message-State: AFuF++kfbc1fy8ia+I23ZUYvoMHF62dFou0kUiKH1jN9eNRrQvZb6PzZ
	mWHbVnK0T7qOj9RgfFv6+5L5cqAR2x2joW5K1Cte0nptXPjYOwx4k+iU3Tad4dWl9H7dfApU1kj
	nwok+Gud5t6B+rINgMw56CoVkrg==
X-Received: from plrp17.prod.google.com ([2002:a17:902:b091:b0:2db:1a39:c145])
 (user=sunnytiwari job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a2d:b0:2dd:c053:82f1 with SMTP id d9443c01a7336-2df69dc4162mr4741375ad.40.1790110359533;
 Tue, 22 Sep 2026 13:52:39 -0700 (PDT)
Date: Tue, 22 Sep 2026 20:52:36 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com>
Subject: [PATCH net-next] net/rds: replace tasklets with workqueue
From: Sunny Tiwari <sunnytiwari@google.com>
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, Allison Henderson <achender@kernel.org>, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Sunny Tiwari <sunnytiwari@google.com>
Content-Type: text/plain; charset="UTF-8"

tasklet_struct is deprecated. Convert the send and receive completion
handlers in net/rds/ib to work items on a dedicated high-priority
workqueue.

Allocate per-CPU bound rds_ib_wq with WQ_HIGHPRI | WQ_MEM_RECLAIM in
rds_ib_init() and destroy it in rds_ib_exit(). Per-CPU binding preserves
cache locality with the completion vector, matching original tasklet
affinity without cross-core migration.

Replace i_send_tasklet and i_recv_tasklet with struct work_struct. Order
quiescence via atomic_set_release() and atomic_read_acquire() prior to
cancel_work_sync() during connection shutdown.

Assisted-by: Gemini
Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>
---
 net/rds/ib.c    | 22 +++++++++++++++++++++-
 net/rds/ib.h    |  7 +++++--
 net/rds/ib_cm.c | 39 +++++++++++++++++++++++----------------
 3 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 786f39169..3e3551c6a 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -50,6 +50,7 @@ static unsigned int rds_ib_mr_1m_pool_size = RDS_MR_1M_POOL_SIZE;
 static unsigned int rds_ib_mr_8k_pool_size = RDS_MR_8K_POOL_SIZE;
 unsigned int rds_ib_retry_count = RDS_IB_DEFAULT_RETRY_COUNT;
 static atomic_t rds_ib_unloading;
+struct workqueue_struct *rds_ib_wq;
 
 module_param(rds_ib_mr_1m_pool_size, int, 0444);
 MODULE_PARM_DESC(rds_ib_mr_1m_pool_size, " Max number of 1M mr per HCA");
@@ -533,6 +534,8 @@ static bool rds_ib_is_unloading(struct rds_connection *conn)
 
 void rds_ib_exit(void)
 {
+	struct workqueue_struct *wq = rds_ib_wq;
+
 	rds_ib_set_unloading();
 	synchronize_rcu();
 	rds_info_deregister_func(RDS_INFO_IB_CONNECTIONS, rds_ib_ic_info);
@@ -545,6 +548,10 @@ void rds_ib_exit(void)
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
 	rds_ib_mr_exit();
+
+	rds_ib_wq = NULL;
+	if (wq)
+		destroy_workqueue(wq);
 }
 
 static u8 rds_ib_get_tos_map(u8 tos)
@@ -587,6 +594,7 @@ struct rds_transport rds_ib_transport = {
 
 int rds_ib_init(void)
 {
+	struct workqueue_struct *wq;
 	int ret;
 
 	INIT_LIST_HEAD(&rds_ib_devices);
@@ -595,9 +603,16 @@ int rds_ib_init(void)
 	if (ret)
 		goto out;
 
+	rds_ib_wq = alloc_workqueue("rds_ib_wq",
+				    WQ_HIGHPRI | WQ_MEM_RECLAIM, 0);
+	if (!rds_ib_wq) {
+		ret = -ENOMEM;
+		goto out_mr_exit;
+	}
+
 	ret = ib_register_client(&rds_ib_client);
 	if (ret)
-		goto out_mr_exit;
+		goto out_wq;
 
 	ret = rds_ib_sysctl_init();
 	if (ret)
@@ -620,6 +635,11 @@ int rds_ib_init(void)
 	rds_ib_sysctl_exit();
 out_ibreg:
 	rds_ib_unregister_client();
+out_wq:
+	wq = rds_ib_wq;
+	rds_ib_wq = NULL;
+	if (wq)
+		destroy_workqueue(wq);
 out_mr_exit:
 	rds_ib_mr_exit();
 out:
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 5ff346a1e..5f617f66e 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -159,8 +159,8 @@ struct rds_ib_connection {
 	atomic_t		i_fastreg_inuse_count;
 
 	/* interrupt handling */
-	struct tasklet_struct	i_send_tasklet;
-	struct tasklet_struct	i_recv_tasklet;
+	struct work_struct	i_send_work;
+	struct work_struct	i_recv_work;
 
 	/* tx */
 	struct rds_ib_work_ring	i_send_ring;
@@ -276,6 +276,7 @@ struct rds_ib_statistics {
 	uint64_t	s_ib_connect_raced;
 	uint64_t	s_ib_listen_closed_stale;
 	uint64_t	s_ib_evt_handler_call;
+	/* Retained as s_ib_tasklet_call for userspace rds-info -I ABI */
 	uint64_t	s_ib_tasklet_call;
 	uint64_t	s_ib_tx_cq_event;
 	uint64_t	s_ib_tx_ring_full;
@@ -452,4 +453,6 @@ extern unsigned long rds_ib_sysctl_max_unsig_bytes;
 extern unsigned long rds_ib_sysctl_max_recv_allocation;
 extern unsigned int rds_ib_sysctl_flow_control;
 
+extern struct workqueue_struct *rds_ib_wq;
+
 #endif
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 6e3110a04..976a9d7e8 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -253,7 +253,10 @@ static void rds_ib_cq_comp_handler_recv(struct ib_cq *cq, void *context)
 
 	rds_ib_stats_inc(s_ib_evt_handler_call);
 
-	tasklet_schedule(&ic->i_recv_tasklet);
+	if (unlikely(!rds_ib_wq || atomic_read_acquire(&ic->i_cq_quiesce)))
+		return;
+
+	queue_work(rds_ib_wq, &ic->i_recv_work);
 }
 
 static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
@@ -279,9 +282,10 @@ static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_send(unsigned long data)
+static void rds_ib_send_worker(struct work_struct *work)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic =
+		container_of(work, struct rds_ib_connection, i_send_work);
 	struct rds_connection *conn = ic->conn;
 
 	rds_ib_stats_inc(s_ib_tasklet_call);
@@ -319,9 +323,10 @@ static void poll_rcq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_recv(unsigned long data)
+static void rds_ib_recv_worker(struct work_struct *work)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic =
+		container_of(work, struct rds_ib_connection, i_recv_work);
 	struct rds_connection *conn = ic->conn;
 	struct rds_ib_device *rds_ibdev = ic->rds_ibdev;
 	struct rds_ib_ack_state state;
@@ -381,7 +386,10 @@ static void rds_ib_cq_comp_handler_send(struct ib_cq *cq, void *context)
 
 	rds_ib_stats_inc(s_ib_evt_handler_call);
 
-	tasklet_schedule(&ic->i_send_tasklet);
+	if (unlikely(!rds_ib_wq || atomic_read_acquire(&ic->i_cq_quiesce)))
+		return;
+
+	queue_work(rds_ib_wq, &ic->i_send_work);
 }
 
 static inline int ibdev_get_unused_vector(struct rds_ib_device *rds_ibdev)
@@ -1099,14 +1107,15 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		while (!wait_event_timeout(rds_ib_ring_empty_wait,
 					   rds_ib_conn_path_shutdown_check_wait(cp) == 0,
 					   msecs_to_jiffies(1000))) {
-			tasklet_schedule(&ic->i_send_tasklet);
-			tasklet_schedule(&ic->i_recv_tasklet);
+			if (rds_ib_wq) {
+				queue_work(rds_ib_wq, &ic->i_send_work);
+				queue_work(rds_ib_wq, &ic->i_recv_work);
+			}
 		}
 
-		tasklet_kill(&ic->i_send_tasklet);
-		tasklet_kill(&ic->i_recv_tasklet);
-
-		atomic_set(&ic->i_cq_quiesce, 1);
+		atomic_set_release(&ic->i_cq_quiesce, 1);
+		cancel_work_sync(&ic->i_send_work);
+		cancel_work_sync(&ic->i_recv_work);
 
 		/* first destroy the ib state that generates callbacks */
 		if (ic->i_cm_id->qp)
@@ -1234,10 +1243,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	}
 
 	INIT_LIST_HEAD(&ic->ib_node);
-	tasklet_init(&ic->i_send_tasklet, rds_ib_tasklet_fn_send,
-		     (unsigned long)ic);
-	tasklet_init(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv,
-		     (unsigned long)ic);
+	INIT_WORK(&ic->i_send_work, rds_ib_send_worker);
+	INIT_WORK(&ic->i_recv_work, rds_ib_recv_worker);
 	mutex_init(&ic->i_recv_mutex);
 #ifndef KERNEL_HAS_ATOMIC64
 	spin_lock_init(&ic->i_ack_lock);
