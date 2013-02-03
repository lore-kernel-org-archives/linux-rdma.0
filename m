From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 26/62] infiniband/ehca: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:27 -0800
Message-ID: <1359854463-2538-27-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359854463-2538-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/ehca/ehca_cq.c | 27 +++++++--------------------
 drivers/infiniband/hw/ehca/ehca_qp.c | 34 +++++++++++++++-------------------
 2 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 8f52901..212150c 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -128,7 +128,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	void *vpage;
 	u32 counter;
 	u64 rpage, cqx_fec, h_ret;
-	int ipz_rc, ret, i;
+	int ipz_rc, i;
 	unsigned long flags;
 
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
@@ -163,32 +163,19 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	adapter_handle = shca->ipz_hca_handle;
 	param.eq_handle = shca->eq.ipz_eq_handle;
 
-	do {
-		if (!idr_pre_get(&ehca_cq_idr, GFP_KERNEL)) {
-			cq = ERR_PTR(-ENOMEM);
-			ehca_err(device, "Can't reserve idr nr. device=%p",
-				 device);
-			goto create_cq_exit1;
-		}
-
-		write_lock_irqsave(&ehca_cq_idr_lock, flags);
-		ret = idr_get_new(&ehca_cq_idr, my_cq, &my_cq->token);
-		write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-	} while (ret == -EAGAIN);
+	idr_preload(GFP_KERNEL);
+	write_lock_irqsave(&ehca_cq_idr_lock, flags);
+	my_cq->token = idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOWAIT);
+	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	idr_preload_end();
 
-	if (ret) {
+	if (my_cq->token < 0) {
 		cq = ERR_PTR(-ENOMEM);
 		ehca_err(device, "Can't allocate new idr entry. device=%p",
 			 device);
 		goto create_cq_exit1;
 	}
 
-	if (my_cq->token > 0x1FFFFFF) {
-		cq = ERR_PTR(-ENOMEM);
-		ehca_err(device, "Invalid number of cq. device=%p", device);
-		goto create_cq_exit2;
-	}
-
 	/*
 	 * CQs maximum depth is 4GB-64, but we need additional 20 as buffer
 	 * for receiving errors CQEs.
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 1493939..00d6861 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -636,30 +636,26 @@ static struct ehca_qp *internal_create_qp(
 		my_qp->send_cq =
 			container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
-	do {
-		if (!idr_pre_get(&ehca_qp_idr, GFP_KERNEL)) {
-			ret = -ENOMEM;
-			ehca_err(pd->device, "Can't reserve idr resources.");
-			goto create_qp_exit0;
-		}
+	idr_preload(GFP_KERNEL);
+	write_lock_irqsave(&ehca_qp_idr_lock, flags);
 
-		write_lock_irqsave(&ehca_qp_idr_lock, flags);
-		ret = idr_get_new(&ehca_qp_idr, my_qp, &my_qp->token);
-		write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
-	} while (ret == -EAGAIN);
+	ret = idr_alloc(&ehca_qp_idr, my_qp, 0, 0x2000000, GFP_NOWAIT);
+	if (ret >= 0)
+		my_qp->token = ret;
 
-	if (ret) {
-		ret = -ENOMEM;
-		ehca_err(pd->device, "Can't allocate new idr entry.");
+	write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	idr_preload_end();
+	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			ret = -EINVAL;
+			ehca_err(pd->device, "Invalid number of qp");
+		} else {
+			ret = -ENOMEM;
+			ehca_err(pd->device, "Can't allocate new idr entry.");
+		}
 		goto create_qp_exit0;
 	}
 
-	if (my_qp->token > 0x1FFFFFF) {
-		ret = -EINVAL;
-		ehca_err(pd->device, "Invalid number of qp");
-		goto create_qp_exit1;
-	}
-
 	if (has_srq)
 		parms.srq_token = my_qp->token;
 
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
