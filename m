From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 rdma-next 3/3] RDMA/qedr: Add iWARP doorbell recovery support
Date: Thu, 13 Jun 2019 11:38:19 +0300
Message-ID: <20190613083819.6998-4-michal.kalderon@marvell.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190613083819.6998-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch adds the iWARP specific doorbells to the doorbell
recovery mechanism

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/qedr.h  | 12 +++++++-----
 drivers/infiniband/hw/qedr/verbs.c | 38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 006712ac1c88..6c5524d6b04e 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -238,6 +238,11 @@ struct qedr_ucontext {
 	struct mutex mm_list_lock;
 };
 
+union db_prod32 {
+	struct rdma_pwm_val16_data data;
+	u32 raw;
+};
+
 union db_prod64 {
 	struct rdma_pwm_val32_data data;
 	u64 raw;
@@ -268,6 +273,8 @@ struct qedr_userq {
 	void __iomem *db_addr;
 	struct qedr_user_db_rec *db_rec_data;
 	u64 db_rec_phys;
+	void __iomem *db_rec_db2_addr;
+	union db_prod32 db_rec_db2_data;
 };
 
 struct qedr_cq {
@@ -317,11 +324,6 @@ struct qedr_mm {
 	struct list_head entry;
 };
 
-union db_prod32 {
-	struct rdma_pwm_val16_data data;
-	u32 raw;
-};
-
 struct qedr_qp_hwq_info {
 	/* WQE Elements */
 	struct qed_chain pbl;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 4c19e172ecd6..c4c7e86d342b 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1793,6 +1793,10 @@ static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 				     &qp->urq.db_rec_data->db_data);
 		free_page((unsigned long)qp->urq.db_rec_data);
 	}
+
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		qedr_db_recovery_del(dev, qp->urq.db_rec_db2_addr,
+				     &qp->urq.db_rec_db2_data);
 }
 
 static int qedr_create_user_qp(struct qedr_dev *dev,
@@ -1867,6 +1871,18 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	qp->usq.db_addr = (u8 __iomem *)ctx->dpi_addr + uresp.sq_db_offset;
 	qp->urq.db_addr = (u8 __iomem *)ctx->dpi_addr + uresp.rq_db_offset;
 
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		qp->urq.db_rec_db2_addr =
+			(u8 __iomem *)ctx->dpi_addr + uresp.rq_db2_offset;
+
+		/* calculate the db_rec_db2 data since it is constant so no
+		 *  need to reflect from user
+		 */
+		qp->urq.db_rec_db2_data.data.icid = cpu_to_le16(qp->icid);
+		qp->urq.db_rec_db2_data.data.value =
+			cpu_to_le16(DQ_TCM_IWARP_POST_RQ_CF_CMD);
+	}
+
 	rc = qedr_db_recovery_add(dev, qp->usq.db_addr,
 				  &qp->usq.db_rec_data->db_data,
 				  DB_REC_WIDTH_32B,
@@ -1880,6 +1896,15 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 				  DB_REC_USER);
 	if (rc)
 		goto err;
+
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		rc = qedr_db_recovery_add(dev, qp->urq.db_rec_db2_addr,
+					  &qp->urq.db_rec_db2_data,
+					  DB_REC_WIDTH_32B,
+					  DB_REC_USER);
+		if (rc)
+			goto err;
+	}
 	qedr_qp_user_print(dev, qp);
 
 	return rc;
@@ -1920,7 +1945,13 @@ static int qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
 				  &qp->rq.db_data,
 				  DB_REC_WIDTH_32B,
 				  DB_REC_KERNEL);
+	if (rc)
+		return rc;
 
+	rc = qedr_db_recovery_add(dev, qp->rq.iwarp_db2,
+				  &qp->rq.iwarp_db2_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_KERNEL);
 	return rc;
 }
 
@@ -2049,8 +2080,13 @@ static void qedr_cleanup_kernel(struct qedr_dev *dev, struct qedr_qp *qp)
 
 	qedr_db_recovery_del(dev, qp->sq.db, &qp->sq.db_data);
 
-	if (!qp->srq)
+	if (!qp->srq) {
 		qedr_db_recovery_del(dev, qp->rq.db, &qp->rq.db_data);
+
+		if (rdma_protocol_iwarp(&dev->ibdev, 1))
+			qedr_db_recovery_del(dev, qp->rq.iwarp_db2,
+					     &qp->rq.iwarp_db2_data);
+	}
 }
 
 static int qedr_create_kernel_qp(struct qedr_dev *dev,
-- 
2.14.5
