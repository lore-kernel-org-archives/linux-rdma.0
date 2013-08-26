From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/14] RDMA/ocrdma: Fix to work with even single msix vector.
Date: Mon, 26 Aug 2013 15:27:41 +0530
Message-ID: <37403264-213c-4fad-b14e-e54525341074@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

There are cases like SRIOV where can get only one MSIC vector
allocated for RoCE. In that case we need to use the vector for
both data plane and control plane. We need to use EQ create version
V2.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h    |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 133 ++++++++-----------------------
 2 files changed, 36 insertions(+), 100 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 634c2e1..9cc966a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -132,8 +132,7 @@ struct ocrdma_dev {
 	struct ocrdma_cq **cq_tbl;
 	struct ocrdma_qp **qp_tbl;
 
-	struct ocrdma_eq meq;
-	struct ocrdma_eq *qp_eq_tbl;
+	struct ocrdma_eq *eq_tbl;
 	int eq_cnt;
 	u16 base_eqid;
 	u16 max_eq;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 6a62b23..1b14ef8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -364,22 +364,6 @@ static void ocrdma_build_q_pages(struct ocrdma_pa *q_pa, int cnt,
 	}
 }
 
-static void ocrdma_assign_eq_vect_gen2(struct ocrdma_dev *dev,
-				       struct ocrdma_eq *eq)
-{
-	/* assign vector and update vector id for next EQ */
-	eq->vector = dev->nic_info.msix.start_vector;
-	dev->nic_info.msix.start_vector += 1;
-}
-
-static void ocrdma_free_eq_vect_gen2(struct ocrdma_dev *dev)
-{
-	/* this assumes that EQs are freed in exactly reverse order
-	 * as its allocation.
-	 */
-	dev->nic_info.msix.start_vector -= 1;
-}
-
 static int ocrdma_mbx_delete_q(struct ocrdma_dev *dev, struct ocrdma_queue_info *q,
 			       int queue_type)
 {
@@ -420,11 +404,8 @@ static int ocrdma_mbx_create_eq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
 	memset(cmd, 0, sizeof(*cmd));
 	ocrdma_init_mch(&cmd->req, OCRDMA_CMD_CREATE_EQ, OCRDMA_SUBSYS_COMMON,
 			sizeof(*cmd));
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY)
-		cmd->req.rsvd_version = 0;
-	else
-		cmd->req.rsvd_version = 2;
 
+	cmd->req.rsvd_version = 2;
 	cmd->num_pages = 4;
 	cmd->valid = OCRDMA_CREATE_EQ_VALID;
 	cmd->cnt = 4 << OCRDMA_CREATE_EQ_CNT_SHIFT;
@@ -435,12 +416,7 @@ static int ocrdma_mbx_create_eq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
 				 NULL);
 	if (!status) {
 		eq->q.id = rsp->vector_eqid & 0xffff;
-		if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
-			ocrdma_assign_eq_vect_gen2(dev, eq);
-		} else {
-			eq->vector = (rsp->vector_eqid >> 16) & 0xffff;
-			dev->nic_info.msix.start_vector += 1;
-		}
+		eq->vector = (rsp->vector_eqid >> 16) & 0xffff;
 		eq->q.created = true;
 	}
 	return status;
@@ -483,8 +459,6 @@ static void _ocrdma_destroy_eq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
 {
 	if (eq->q.created) {
 		ocrdma_mbx_delete_q(dev, &eq->q, QTYPE_EQ);
-		if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY)
-			ocrdma_free_eq_vect_gen2(dev);
 		ocrdma_free_q(dev, &eq->q);
 	}
 }
@@ -503,13 +477,12 @@ static void ocrdma_destroy_eq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
 	_ocrdma_destroy_eq(dev, eq);
 }
 
-static void ocrdma_destroy_qp_eqs(struct ocrdma_dev *dev)
+static void ocrdma_destroy_eqs(struct ocrdma_dev *dev)
 {
 	int i;
 
-	/* deallocate the data path eqs */
 	for (i = 0; i < dev->eq_cnt; i++)
-		ocrdma_destroy_eq(dev, &dev->qp_eq_tbl[i]);
+		ocrdma_destroy_eq(dev, &dev->eq_tbl[i]);
 }
 
 static int ocrdma_mbx_mq_cq_create(struct ocrdma_dev *dev,
@@ -598,7 +571,7 @@ static int ocrdma_create_mq(struct ocrdma_dev *dev)
 	if (status)
 		goto alloc_err;
 
-	status = ocrdma_mbx_mq_cq_create(dev, &dev->mq.cq, &dev->meq.q);
+	status = ocrdma_mbx_mq_cq_create(dev, &dev->mq.cq, &dev->eq_tbl[0].q);
 	if (status)
 		goto mbx_cq_free;
 
@@ -1304,19 +1277,19 @@ static u16 ocrdma_bind_eq(struct ocrdma_dev *dev)
 	u16 eq_id;
 
 	mutex_lock(&dev->dev_lock);
-	cq_cnt = dev->qp_eq_tbl[0].cq_cnt;
-	eq_id = dev->qp_eq_tbl[0].q.id;
+	cq_cnt = dev->eq_tbl[0].cq_cnt;
+	eq_id = dev->eq_tbl[0].q.id;
 	/* find the EQ which is has the least number of
 	 * CQs associated with it.
 	 */
 	for (i = 0; i < dev->eq_cnt; i++) {
-		if (dev->qp_eq_tbl[i].cq_cnt < cq_cnt) {
-			cq_cnt = dev->qp_eq_tbl[i].cq_cnt;
-			eq_id = dev->qp_eq_tbl[i].q.id;
+		if (dev->eq_tbl[i].cq_cnt < cq_cnt) {
+			cq_cnt = dev->eq_tbl[i].cq_cnt;
+			eq_id = dev->eq_tbl[i].q.id;
 			selected_eq = i;
 		}
 	}
-	dev->qp_eq_tbl[selected_eq].cq_cnt += 1;
+	dev->eq_tbl[selected_eq].cq_cnt += 1;
 	mutex_unlock(&dev->dev_lock);
 	return eq_id;
 }
@@ -1327,9 +1300,9 @@ static void ocrdma_unbind_eq(struct ocrdma_dev *dev, u16 eq_id)
 
 	mutex_lock(&dev->dev_lock);
 	for (i = 0; i < dev->eq_cnt; i++) {
-		if (dev->qp_eq_tbl[i].q.id != eq_id)
+		if (dev->eq_tbl[i].q.id != eq_id)
 			continue;
-		dev->qp_eq_tbl[i].cq_cnt -= 1;
+		dev->eq_tbl[i].cq_cnt -= 1;
 		break;
 	}
 	mutex_unlock(&dev->dev_lock);
@@ -2434,38 +2407,7 @@ int ocrdma_free_av(struct ocrdma_dev *dev, struct ocrdma_ah *ah)
 	return 0;
 }
 
-static int ocrdma_create_mq_eq(struct ocrdma_dev *dev)
-{
-	int status;
-	int irq;
-	unsigned long flags = 0;
-	int num_eq = 0;
-
-	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX) {
-		flags = IRQF_SHARED;
-	} else {
-		num_eq = dev->nic_info.msix.num_vectors -
-				dev->nic_info.msix.start_vector;
-		/* minimum two vectors/eq are required for rdma to work.
-		 * one for control path and one for data path.
-		 */
-		if (num_eq < 2)
-			return -EBUSY;
-	}
-
-	status = ocrdma_create_eq(dev, &dev->meq, OCRDMA_EQ_LEN);
-	if (status)
-		return status;
-	sprintf(dev->meq.irq_name, "ocrdma_mq%d", dev->id);
-	irq = ocrdma_get_irq(dev, &dev->meq);
-	status = request_irq(irq, ocrdma_irq_handler, flags, dev->meq.irq_name,
-			     &dev->meq);
-	if (status)
-		_ocrdma_destroy_eq(dev, &dev->meq);
-	return status;
-}
-
-static int ocrdma_create_qp_eqs(struct ocrdma_dev *dev)
+static int ocrdma_create_eqs(struct ocrdma_dev *dev)
 {
 	int num_eq, i, status = 0;
 	int irq;
@@ -2480,46 +2422,43 @@ static int ocrdma_create_qp_eqs(struct ocrdma_dev *dev)
 		num_eq = min_t(u32, num_eq, num_online_cpus());
 	}
 
-	dev->qp_eq_tbl = kzalloc(sizeof(struct ocrdma_eq) * num_eq, GFP_KERNEL);
-	if (!dev->qp_eq_tbl)
+	if (!num_eq)
+		return -EINVAL;
+
+	dev->eq_tbl = kzalloc(sizeof(struct ocrdma_eq) * num_eq, GFP_KERNEL);
+	if (!dev->eq_tbl)
 		return -ENOMEM;
 
 	for (i = 0; i < num_eq; i++) {
-		status = ocrdma_create_eq(dev, &dev->qp_eq_tbl[i],
+		status = ocrdma_create_eq(dev, &dev->eq_tbl[i],
 					  OCRDMA_EQ_LEN);
 		if (status) {
 			status = -EINVAL;
 			break;
 		}
-		sprintf(dev->qp_eq_tbl[i].irq_name, "ocrdma_qp%d-%d",
+		sprintf(dev->eq_tbl[i].irq_name, "ocrdma%d-%d",
 			dev->id, i);
-		irq = ocrdma_get_irq(dev, &dev->qp_eq_tbl[i]);
+		irq = ocrdma_get_irq(dev, &dev->eq_tbl[i]);
 		status = request_irq(irq, ocrdma_irq_handler, flags,
-				     dev->qp_eq_tbl[i].irq_name,
-				     &dev->qp_eq_tbl[i]);
-		if (status) {
-			_ocrdma_destroy_eq(dev, &dev->qp_eq_tbl[i]);
-			status = -EINVAL;
-			break;
-		}
+				     dev->eq_tbl[i].irq_name,
+				     &dev->eq_tbl[i]);
+		if (status)
+			goto done;
 		dev->eq_cnt += 1;
 	}
 	/* one eq is sufficient for data path to work */
-	if (dev->eq_cnt >= 1)
-		return 0;
-	ocrdma_destroy_qp_eqs(dev);
+	return 0;
+done:
+	ocrdma_destroy_eqs(dev);
 	return status;
 }
 
 int ocrdma_init_hw(struct ocrdma_dev *dev)
 {
 	int status;
-	/* set up control path eq */
-	status = ocrdma_create_mq_eq(dev);
-	if (status)
-		return status;
-	/* set up data path eq */
-	status = ocrdma_create_qp_eqs(dev);
+
+	/* create the eqs  */
+	status = ocrdma_create_eqs(dev);
 	if (status)
 		goto qpeq_err;
 	status = ocrdma_create_mq(dev);
@@ -2542,9 +2481,8 @@ int ocrdma_init_hw(struct ocrdma_dev *dev)
 conf_err:
 	ocrdma_destroy_mq(dev);
 mq_err:
-	ocrdma_destroy_qp_eqs(dev);
+	ocrdma_destroy_eqs(dev);
 qpeq_err:
-	ocrdma_destroy_eq(dev, &dev->meq);
 	pr_err("%s() status=%d\n", __func__, status);
 	return status;
 }
@@ -2553,10 +2491,9 @@ void ocrdma_cleanup_hw(struct ocrdma_dev *dev)
 {
 	ocrdma_mbx_delete_ah_tbl(dev);
 
-	/* cleanup the data path eqs */
-	ocrdma_destroy_qp_eqs(dev);
+	/* cleanup the eqs */
+	ocrdma_destroy_eqs(dev);
 
 	/* cleanup the control path */
 	ocrdma_destroy_mq(dev);
-	ocrdma_destroy_eq(dev, &dev->meq);
 }
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
