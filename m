From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/17] rdma/mlx4: Add support for XRC SRQs
Date: Wed, 15 Jun 2011 06:28:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302105D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the user to create XRC SRQs.  This patch is based on a
patch from Jack Morgenstrein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    3 ++-
 drivers/infiniband/hw/mlx4/srq.c  |    9 ++++++++-
 drivers/net/mlx4/srq.c            |   20 +++++++++++---------
 include/linux/mlx4/device.h       |    4 ++--
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1b911aa..d08cc2d 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1095,7 +1095,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
-		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ);
+		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ);	
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 818b7ec..361838f 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -76,6 +76,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 	struct mlx4_ib_srq *srq;
 	struct mlx4_wqe_srq_next_seg *next;
 	struct mlx4_wqe_data_seg *scatter;
+	u32 cqn;
+	u32 xrcdn;
 	int desc_size;
 	int buf_size;
 	int err;
@@ -174,12 +176,17 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		}
 	}
 
-	err = mlx4_srq_alloc(dev->dev, to_mpd(pd)->pdn, &srq->mtt,
+	cqn = (init_attr->srq_type == IB_SRQT_XRC) ?
+		to_mcq(init_attr->ext.xrc.cq)->mcq.cqn : 0;
+	xrcdn = (init_attr->srq_type == IB_SRQT_XRC) ?
+		to_mxrcd(init_attr->ext.xrc.xrcd)->xrcdn : 0;
+	err = mlx4_srq_alloc(dev->dev, to_mpd(pd)->pdn, cqn, xrcdn, &srq->mtt,
 			     srq->db.dma, &srq->msrq);
 	if (err)
 		goto err_wrid;
 
 	srq->msrq.event = mlx4_ib_srq_event;
+	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (pd->uobject)
 		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof (__u32))) {
diff --git a/drivers/net/mlx4/srq.c b/drivers/net/mlx4/srq.c
index 3b07b80..a20b141 100644
--- a/drivers/net/mlx4/srq.c
+++ b/drivers/net/mlx4/srq.c
@@ -40,20 +40,20 @@
 struct mlx4_srq_context {
 	__be32			state_logsize_srqn;
 	u8			logstride;
-	u8			reserved1[3];
-	u8			pg_offset;
-	u8			reserved2[3];
-	u32			reserved3;
+	u8			reserved1;
+	__be16			xrcd;
+	__be32			pg_offset_cqn;
+	u32			reserved2;
 	u8			log_page_size;
-	u8			reserved4[2];
+	u8			reserved3[2];
 	u8			mtt_base_addr_h;
 	__be32			mtt_base_addr_l;
 	__be32			pd;
 	__be16			limit_watermark;
 	__be16			wqe_cnt;
-	u16			reserved5;
+	u16			reserved4;
 	__be16			wqe_counter;
-	u32			reserved6;
+	u32			reserved5;
 	__be64			db_rec_addr;
 };
 
@@ -109,8 +109,8 @@ static int mlx4_QUERY_SRQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
 			    MLX4_CMD_TIME_CLASS_A);
 }
 
-int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
-		   u64 db_rec, struct mlx4_srq *srq)
+int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
+		   struct mlx4_mtt *mtt, u64 db_rec, struct mlx4_srq *srq)
 {
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 	struct mlx4_cmd_mailbox *mailbox;
@@ -148,6 +148,8 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
 	srq_context->state_logsize_srqn = cpu_to_be32((ilog2(srq->max) << 24) |
 						      srq->srqn);
 	srq_context->logstride          = srq->wqe_shift - 4;
+	srq_context->xrcd		= cpu_to_be16(xrcd);
+	srq_context->pg_offset_cqn	= cpu_to_be32(cqn & 0xffffff);
 	srq_context->log_page_size      = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
 
 	mtt_addr = mlx4_mtt_addr(dev, mtt);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 33a3516..46c249b 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -530,8 +530,8 @@ void mlx4_qp_release_range(struct mlx4_dev *dev, int base_qpn, int cnt);
 int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp);
 void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp);
 
-int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
-		   u64 db_rec, struct mlx4_srq *srq);
+int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcdn,
+		   struct mlx4_mtt *mtt, u64 db_rec, struct mlx4_srq *srq);
 void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq);
 int mlx4_srq_arm(struct mlx4_dev *dev, struct mlx4_srq *srq, int limit_watermark);
 int mlx4_srq_query(struct mlx4_dev *dev, struct mlx4_srq *srq, int *limit_watermark);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
