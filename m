Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755359;
	b=I1WqNho9YZb4zHcl36jAOtRBkpCHZQudSPCDONUFe1kjU3Swth99bbIkeagi+eh8kiqz
	 t0CU1YO56ijtWY8xIeP5Io0MnT+4CVIea3hGuzxAGM/9FSee2k6GwAufdooTs8fhU9ZAv
	 +fbaqsamh7gj1s0KjN4HhTsPL90vkpMjZ6bonjVbYM/5RprH29sQh3QKWw2FLS1z2SrFZ
	 9bkPP4UssGd93XXwEfd9gifRXrPZuN0YWqNQ5O9ABGBTgmcdDIfk6tecR3DTiotWkoORN
	 eEeRHFyuomLI+Ifeq9h+aCBQKFyl+sKf5RUzWA1VfbGerOemkU7qcnKf7eSauwBYXFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVa6CCAH519bjAZCKZQVejZVAzQohLPWeK+tg1l7Elc=;
	b=E1R23JWCCEbspvug4zTnsL2nR7EXJXhoFlhxRMEZnjKKZc8SWciyOTtad1HXmApgyvVe
	 mLRlrZjDDNN5c20HVxq7i/chGbgPV5EC0YxWT7fDk/A5zK9rEWtybmS8jUa39v+X8YSu2
	 1GExq0PEeZWNH/spdFAxGLIcYEa2dfw8MKPGmdARtl3uvDD0sWG04uz3N8FwOH/9d6DYB
	 CEZ4IJcjIvoDsMpKZS0/z3lGiWFMoCWTMothhCIVwfBhJ+fy0vmVMsVoQbDwbkoK02zZK
	 mCVhfvlf4M7AUh5yYhQFlsx8jdOpxngZE1XAv5kohD7ZbrZ6RkcsuaTLbEcepo4kfzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Cgk0NTTs;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8D9606A332
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B8D9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Cgk0NTTs
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ad787b79ffso141367a91.1
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 17:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755359; x=1794360159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oVa6CCAH519bjAZCKZQVejZVAzQohLPWeK+tg1l7Elc=;
        b=Cgk0NTTskmuLHyMe/kNtLI5mIVL2UGmnLqBiz7xpN6eWiwiGkiMfLuk85AK2+rOBlA
         9wamgJEa0BUzB595qBudhPW2koiNdxeOhw82vCjUNxgvjhgvVKensbFV6T8UK3epkdM3
         1bWF/FSHjuRYXZY5hoG1Fq76SG0SmEoUb+WzAWCC8yDnATia/Hh51DcO2I1bLJjMN5N4
         ZKZ8+mjJHaNUrBBz1MfWTcPuGS2Rv2RNkm9HlgBXucm1vKdIUx83ZbP2yZQZv5FTmCJ/
         QJsZX6hCmdzc7fN9le4ZtAhI01LmlIJbZlk+73d3Zkga6K4m2LE6jvUFtuOzxW8r/Dl7
         2kbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755359; x=1794360159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oVa6CCAH519bjAZCKZQVejZVAzQohLPWeK+tg1l7Elc=;
        b=v7IaD+cS6wGrD88baWYRTRPDU4b00zVQJn0AeUgcz7IVlCnuvc8eHSypiCcqt7crzk
         hMsSe2B7fq1pRwZeFHNeOWPTGATfupbYN0L+fddRFRs8E4vBEg61wxSuPvnwC+Ou5m6a
         842XTuCudYlHxkD+6k0H+I0N0SC2KycpHcpGyGrLbfRMNtLlyzYGSG3srX5qOe7nACI/
         yklR8jSDxRwmsS657Wm7nLufqgaUstshI05h768FF2UQN3bablDLEsTaVI0/46e5/SSM
         B9M9qKJ5+1M4TMHsIkpjYfv6hfBcJn8isNyIXcNIHZ73nLUsEWYQeLvJg5Vzjz6omF5Z
         +AMw==
X-Forwarded-Encrypted: i=1; AKwUvBzkISzNE9m7P2+HiXNk1KdF2bT/7ERXH1osaACLPAgKHiB/iD8pgPbYlfMx+sUUrnRSW6P35fq4f92F@vger.kernel.org
X-Gm-Message-State: APuU4Z+fv8JXoCgnsm/UAlCGzy/ZnmitoUByLK9UtXaG/RDZXOLDz7pF
	sI52SfsOVhppyrYirjCSLqGL4jYeTlr//qRZKSJaZ8Pml25F1jj/Cs2B9udDH5oOpaE=
X-Gm-Gg: AYBFou07IaGAwpBJObezCWYc19yV+hyg5kyCkUcvELCx3e17rNugEWow3utOMWxgeSA
	xzqklCFFbpk/GrOdxTE8h1RfEEho6wC/MSL7Lwkl4UYkM3KPKq8Yr+Ar8t/6UpGqj46g2DwhqY1
	o1axLk0183g4+zGNUeiWF8o1mXQicpU2wA5Xet0M+G/XrpaWw3yx3SHUQp1HmqG9vpiwUePmV5W
	aawlk/IjJ3/eXuXFPmbi1ffFTfKiHmCaL16ykivEFSBSHl7FQht0cl4DQNKwbrtqOvHBM0fkl70
	0uDNlSbbjqxW8Bcv7sB7AsSebgePLWFw8n9dN3bbjUpL9a3G8rkbh7vR+NwRHIhSx9Vllj7CBMD
	UVOpzrKImTTjq9AUMGEjUC+euSPfj8RlSp/KtiKewhZGRKaT4axSkLCqniShmM6j7vUjFSFX/yI
	hRJXkuB503dNyD5JzyUbQvXMPLSZOO7qgh6A7TPt4n78lKnFEeStyoyiX/18EwgGrzpaxX6Xp/W
	aSwh9EDAe5MakcFLiixrEUGJlO8CxNGnP+4Tml4W7aGsVGpllQpcvi0ipyLzjWc80hjSm3pr8+e
	PaY7WvnBKcDGsZkok393adjzTPIrCXsaZ92ivEZxrXOnhfk5Rdw+DyP41Zv9ffv0gd3gRsZgguQ
	lUhZOs26+QNJK69Q4PM+m0F+A2u2Bb+G+1U9w
X-Received: by 2002:a17:90b:2549:b0:3ac:a7ee:678c with SMTP id 98e67ed59e1d1-3ae89536be7mr12035010a91.2.1793755358528;
        Tue, 03 Nov 2026 17:22:38 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09452d89bsm678045a91.0.2026.11.03.17.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:22:38 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v7 2/6] IB/isert: drain the QP without holding isert_conn->mutex
Date: Wed,  4 Nov 2026 10:22:15 +0900
Message-ID: <20261104012219.1759523-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
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

isert_disconnected_handler() drains the QP with isert_conn->mutex held.
The drain waits for the flush completions of the send and receive queues,
and those are reaped by ib_cq_poll_work() on ib-comp-wq, where
isert_login_recv_done() takes isert_conn->mutex before it looks at the
connection state.  If a login receive completes while the handler holds
the mutex, the completion handler blocks on the mutex and the drain blocks
on the completion that handler would have reaped.

Return from isert_conn_terminate() whether this caller moved the
connection to ISER_CONN_TERMINATING, and drain after dropping
isert_conn->mutex.  Only the owner of isert_conn->node drains, so two
callers cannot drain the same QP; the send and receive queues reserve room
for one drain each, and a second concurrent drain hits the WARN_ONCE in
__ib_drain_sq() and returns without draining.

Two test-only delays open the window, one in isert_login_recv_done() and
one before the drain.  Three runs of 7.4-rc1 plus patch 1 of this series
printed ten hung task warnings each, eight, five and five of them waiting
in ib_drain_qp().  Three runs with this patch printed none, and
PROVE_LOCKING reported no splat in two runs a side.

  INFO: task kworker/0:1:10 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-NS1-00002-g7b7ecb49489e #121
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/0:1     state:D stack:26248 pid:10    tgid:10    ppid:2      task_flags:0x4208060 flags:0x00080000
  Workqueue: ib_cm cm_work_handler
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? _raw_spin_lock_irq+0x1/0xe0
   ? __pfx___schedule+0x10/0x10
   schedule+0x70/0x1f0
   schedule_timeout+0x1cd/0x200
   ? __pfx_schedule_timeout+0x10/0x10
   ? rxe_qp_from_attr+0x1497/0x18c0
   ? __pfx__raw_spin_lock_irq+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? _raw_spin_lock_irqsave+0x86/0xe0
   __wait_for_common+0x29e/0x420
   ? __pfx_schedule_timeout+0x10/0x10
   ? __pfx___wait_for_common+0x10/0x10
   __ib_drain_sq+0x251/0x340
   ? __pfx___ib_drain_sq+0x10/0x10
   ? __pfx_ib_drain_qp_done+0x10/0x10
   ? irq_work_queue+0x1c/0xb0
   ? __pfx__printk+0x10/0x10
   ? __pfx_process_timeout+0x10/0x10
   ib_drain_sq+0x146/0x1a0
   ib_drain_qp+0xd/0x50
   isert_disconnected_handler.isra.0+0xc4/0x3f0
   isert_cma_handler+0xd74/0x27d0
   ? kasan_save_stack+0x42/0x60
   ? kasan_save_stack+0x33/0x60
   ? kasan_save_track+0x14/0x30
   ? kasan_save_free_info+0x3b/0x60
   ? __kasan_slab_free+0x43/0x70
   ? kfree+0x121/0x390
   ? cm_process_work+0x8b/0x330
   ? __pfx_isert_cma_handler+0x10/0x10
   ? kthread+0x2c8/0x3b0
   ? ret_from_fork+0x36e/0x5a0
   ? ret_from_fork_asm+0x1a/0x30
   ? _raw_spin_lock_irqsave+0x86/0xe0
   cma_cm_event_handler+0x3e/0x240
   cma_ib_handler+0x190/0x750
   ? __pfx_cma_ib_handler+0x10/0x10
   cm_process_work+0x41/0x330
   cm_work_handler+0x582b/0xc160
   ? _raw_spin_lock_irqsave+0x86/0xe0
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? hrtimer_start_range_ns+0xa6/0x2c0
   ? __pfx_cm_work_handler+0x10/0x10
   ? finish_task_switch.isra.0+0x1d9/0xa70
   process_one_work+0x697/0x1060
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_cm_work_handler+0x10/0x10
   ? assign_work+0x11d/0x370
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 75 ++++++++++++-------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index ef2edaa3218fee..61b214012a70b0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -556,43 +556,21 @@ isert_put_conn(struct isert_conn *isert_conn)
 	kref_put(&isert_conn->kref, isert_release_kref);
 }
 
-static void
-isert_handle_unbound_conn(struct isert_conn *isert_conn)
-{
-	struct isert_np *isert_np = isert_conn->cm_id->context;
-
-	mutex_lock(&isert_np->mutex);
-	if (!list_empty(&isert_conn->node)) {
-		/*
-		 * This means iscsi doesn't know this connection
-		 * so schedule a cleanup ourselves
-		 */
-		list_del_init(&isert_conn->node);
-		isert_put_conn(isert_conn);
-		queue_work(isert_release_wq, &isert_conn->release_work);
-	}
-	mutex_unlock(&isert_np->mutex);
-}
-
 /**
  * isert_conn_terminate() - Initiate connection termination
  * @isert_conn: isert connection struct
  *
- * Notes:
- * In case the connection state is BOUND, move state
- * to TEMINATING and start teardown sequence (rdma_disconnect).
- * In case the connection state is UP, complete flush as well.
- *
- * This routine must be called with mutex held. Thus it is
- * safe to call multiple times.
+ * Return: true if this caller moved the connection to ISER_CONN_TERMINATING.
  */
-static void
+static bool
 isert_conn_terminate(struct isert_conn *isert_conn)
 {
 	int err;
 
+	lockdep_assert_held(&isert_conn->mutex);
+
 	if (isert_conn->state >= ISER_CONN_TERMINATING)
-		return;
+		return false;
 
 	isert_info("Terminating conn %p state %d\n",
 		   isert_conn, isert_conn->state);
@@ -601,6 +579,8 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 	if (err)
 		isert_warn("Failed rdma_disconnect isert_conn %p\n",
 			   isert_conn);
+
+	return true;
 }
 
 static int
@@ -635,26 +615,44 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 			   enum rdma_cm_event_type event)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
+	struct isert_np *isert_np = cma_id->context;
+	bool owned = false, bound = false, terminated = false;
 
 	mutex_lock(&isert_conn->mutex);
 	switch (isert_conn->state) {
-	case ISER_CONN_TERMINATING:
-		break;
 	case ISER_CONN_UP:
-		isert_conn_terminate(isert_conn);
-		ib_drain_qp(isert_conn->qp);
-		isert_handle_unbound_conn(isert_conn);
+		mutex_lock(&isert_np->mutex);
+		if (list_empty(&isert_conn->node)) {
+			bound = isert_conn->state == ISER_CONN_BOUND ||
+				isert_conn->state == ISER_CONN_FULL_FEATURE;
+		} else {
+			owned = true;
+			list_del_init(&isert_conn->node);
+		}
+		mutex_unlock(&isert_np->mutex);
 		break;
 	case ISER_CONN_BOUND:
 	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
-		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		bound = true;
 		break;
 	default:
-		isert_warn("conn %p terminating in state %d\n",
-			   isert_conn, isert_conn->state);
+		break;
 	}
+
+	if (owned)
+		terminated = isert_conn_terminate(isert_conn);
+	else if (bound)
+		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
 	mutex_unlock(&isert_conn->mutex);
 
+	if (!owned)
+		return 0;
+
+	if (terminated)
+		ib_drain_qp(isert_conn->qp);
+	isert_put_conn(isert_conn);
+	queue_work(isert_release_wq, &isert_conn->release_work);
+
 	return 0;
 }
 
@@ -665,8 +663,6 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 	struct isert_np *isert_np = cma_id->context;
 	bool owned;
 
-	ib_drain_qp(isert_conn->qp);
-
 	mutex_lock(&isert_np->mutex);
 	owned = !list_empty(&isert_conn->node);
 	list_del_init(&isert_conn->node);
@@ -677,6 +673,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 		return 0;
 	}
 
+	ib_drain_qp(isert_conn->qp);
 	isert_conn->cm_id = NULL;
 	isert_put_conn(isert_conn);
 
@@ -2479,11 +2476,10 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 	isert_conn = list_first_entry(&isert_np->pending,
 			struct isert_conn, node);
 	list_del_init(&isert_conn->node);
-	mutex_unlock(&isert_np->mutex);
-
 	conn->context = isert_conn;
 	isert_conn->conn = conn;
 	isert_conn->state = ISER_CONN_BOUND;
+	mutex_unlock(&isert_np->mutex);
 
 	isert_set_conn_info(np, conn, isert_conn);
 
@@ -2547,6 +2543,7 @@ isert_free_np(struct iscsi_np *np)
 
 		isert_info("cleaning isert_conn %p state (%d)\n",
 			   isert_conn, isert_conn->state);
+		ib_drain_qp(isert_conn->qp);
 		if (promoted)
 			isert_put_conn(isert_conn);
 		isert_put_conn(isert_conn);
-- 
2.43.0

