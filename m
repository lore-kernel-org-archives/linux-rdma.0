From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] IB/srp: remove forward declaration of srp_post_recv()
Date: Sat, 31 Jul 2010 10:15:58 +0200
Message-ID: <201007311015.58169.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch removes the forward declaration of srp_post_recv() that was
introduced in the patch called "IB/srp: receive buffer handling robustness
improvement" by changing the order of the function definitions in ib_srp.c.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b9a38c2..8420fbc 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -82,7 +82,6 @@ static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
-static int srp_post_recv(struct srp_target_port *target);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
 static struct scsi_transport_template *ib_srp_transport_template;
@@ -812,6 +811,45 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	return len;
 }
 
+static int __srp_post_recv(struct srp_target_port *target)
+{
+	struct srp_iu *iu;
+	struct ib_sge list;
+	struct ib_recv_wr wr, *bad_wr;
+	unsigned int next;
+	int ret;
+
+	next	 = target->rx_head & (SRP_RQ_SIZE - 1);
+	wr.wr_id = next;
+	iu	 = target->rx_ring[next];
+
+	list.addr   = iu->dma;
+	list.length = iu->size;
+	list.lkey   = target->srp_host->srp_dev->mr->lkey;
+
+	wr.next     = NULL;
+	wr.sg_list  = &list;
+	wr.num_sge  = 1;
+
+	ret = ib_post_recv(target->qp, &wr, &bad_wr);
+	if (!ret)
+		++target->rx_head;
+
+	return ret;
+}
+
+static int srp_post_recv(struct srp_target_port *target)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	ret = __srp_post_recv(target);
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+
+	return ret;
+}
+
 static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 {
 	struct srp_request *req;
@@ -961,45 +999,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 	}
 }
 
-static int __srp_post_recv(struct srp_target_port *target)
-{
-	struct srp_iu *iu;
-	struct ib_sge list;
-	struct ib_recv_wr wr, *bad_wr;
-	unsigned int next;
-	int ret;
-
-	next 	 = target->rx_head & (SRP_RQ_SIZE - 1);
-	wr.wr_id = next;
-	iu 	 = target->rx_ring[next];
-
-	list.addr   = iu->dma;
-	list.length = iu->size;
-	list.lkey   = target->srp_host->srp_dev->mr->lkey;
-
-	wr.next     = NULL;
-	wr.sg_list  = &list;
-	wr.num_sge  = 1;
-
-	ret = ib_post_recv(target->qp, &wr, &bad_wr);
-	if (!ret)
-		++target->rx_head;
-
-	return ret;
-}
-
-static int srp_post_recv(struct srp_target_port *target)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
-	ret = __srp_post_recv(target);
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
-
-	return ret;
-}
-
 /*
  * Must be called with target->scsi_host->host_lock held to protect
  * req_lim and tx_head.  Lock cannot be dropped between call here and
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
