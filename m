From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 3/9] IB/srp: Introduce an additional local variable
Date: Tue, 13 May 2014 16:40:37 +0200
Message-ID: <53722EE5.9050508@acm.org>
References: <53722E4F.7070709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53722E4F.7070709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 32955fa..fa28ec3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -290,6 +290,7 @@ static int srp_new_cm_id(struct srp_target_port *target)
 
 static int srp_create_target_ib(struct srp_target_port *target)
 {
+	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_qp_init_attr *init_attr;
 	struct ib_cq *recv_cq, *send_cq;
 	struct ib_qp *qp;
@@ -299,16 +300,14 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (!init_attr)
 		return -ENOMEM;
 
-	recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-			       srp_recv_completion, NULL, target,
+	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, target,
 			       target->queue_size, target->comp_vector);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
-	send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-			       srp_send_completion, NULL, target,
+	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, target,
 			       target->queue_size, target->comp_vector);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
@@ -327,7 +326,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	init_attr->send_cq             = send_cq;
 	init_attr->recv_cq             = recv_cq;
 
-	qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
+	qp = ib_create_qp(dev->pd, init_attr);
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
 		goto err_send_cq;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
