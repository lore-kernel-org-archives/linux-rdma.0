From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH - resend] mlx4: Enable 64 byte CQEs
Date: Wed, 5 Oct 2011 14:57:34 +0200
Message-ID: <20111005125734.GF2681@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CX3 devices can work with 64 or 32 byte CQEs. Using 64 byte CQEs allow better
utilization of new chipsets and gaining higher performance. This patch queries
the HCA's capabilities and if it supports 64 byte CQEs and will configure it to
work in 64 byte mode. Userspace need also be updated to work with the
configured CQE size so mlx4_ib_alloc_ucontext was modified to return the size
of the CQE. This changes the binary interface so the ABI is bumped from 3 to 4.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---

Roland, I am resending these patches again since the email did not
reach you at your kernel.org email address and you may have missed it.

 drivers/infiniband/hw/mlx4/cq.c      |   21 ++++++++++++++-------
 drivers/infiniband/hw/mlx4/main.c    |    1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 +
 drivers/infiniband/hw/mlx4/user.h    |    3 ++-
 drivers/net/mlx4/en_cq.c             |    4 ++--
 drivers/net/mlx4/en_rx.c             |    8 ++++++--
 drivers/net/mlx4/en_tx.c             |    2 ++
 drivers/net/mlx4/fw.c                |    6 ++++++
 drivers/net/mlx4/main.c              |    9 +++++++++
 include/linux/mlx4/device.h          |    2 ++
 10 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index e8df155..a3b4732 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -66,7 +66,7 @@ static void mlx4_ib_cq_event(struct mlx4_cq *cq, enum mlx4_event type)
 
 static void *get_cqe_from_buf(struct mlx4_ib_cq_buf *buf, int n)
 {
-	return mlx4_buf_offset(&buf->buf, n * sizeof (struct mlx4_cqe));
+	return mlx4_buf_offset(&buf->buf, n * buf->entry_size);
 }
 
 static void *get_cqe(struct mlx4_ib_cq *cq, int n)
@@ -77,8 +77,9 @@ static void *get_cqe(struct mlx4_ib_cq *cq, int n)
 static void *get_sw_cqe(struct mlx4_ib_cq *cq, int n)
 {
 	struct mlx4_cqe *cqe = get_cqe(cq, n & cq->ibcq.cqe);
+	struct mlx4_cqe *tcqe = ((cq->buf.entry_size == 64) ? (cqe + 1) : cqe);
 
-	return (!!(cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK) ^
+	return (!!(tcqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK) ^
 		!!(n & (cq->ibcq.cqe + 1))) ? NULL : cqe;
 }
 
@@ -99,12 +100,13 @@ static int mlx4_ib_alloc_cq_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq_buf *
 {
 	int err;
 
-	err = mlx4_buf_alloc(dev->dev, nent * sizeof(struct mlx4_cqe),
+	err = mlx4_buf_alloc(dev->dev, nent * dev->dev->caps.cqe_size,
 			     PAGE_SIZE * 2, &buf->buf);
 
 	if (err)
 		goto out;
 
+	buf->entry_size = dev->dev->caps.cqe_size;
 	err = mlx4_mtt_init(dev->dev, buf->buf.npages, buf->buf.page_shift,
 				    &buf->mtt);
 	if (err)
@@ -120,7 +122,7 @@ err_mtt:
 	mlx4_mtt_cleanup(dev->dev, &buf->mtt);
 
 err_buf:
-	mlx4_buf_free(dev->dev, nent * sizeof(struct mlx4_cqe),
+	mlx4_buf_free(dev->dev, nent * buf->entry_size,
 			      &buf->buf);
 
 out:
@@ -129,7 +131,7 @@ out:
 
 static void mlx4_ib_free_cq_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq_buf *buf, int cqe)
 {
-	mlx4_buf_free(dev->dev, (cqe + 1) * sizeof(struct mlx4_cqe), &buf->buf);
+	mlx4_buf_free(dev->dev, (cqe + 1) * buf->entry_size, &buf->buf);
 }
 
 static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_ucontext *context,
@@ -137,8 +139,9 @@ static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_ucontext *cont
 			       u64 buf_addr, int cqe)
 {
 	int err;
+	int cqe_size = dev->dev->caps.cqe_size;
 
-	*umem = ib_umem_get(context, buf_addr, cqe * sizeof (struct mlx4_cqe),
+	*umem = ib_umem_get(context, buf_addr, cqe * cqe_size,
 			    IB_ACCESS_LOCAL_WRITE, 1);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
@@ -328,13 +331,14 @@ static void mlx4_ib_cq_resize_copy_cqes(struct mlx4_ib_cq *cq)
 {
 	struct mlx4_cqe *cqe, *new_cqe;
 	int i;
+	int cqe_size = cq->buf.entry_size;
 
 	i = cq->mcq.cons_index;
 	cqe = get_cqe(cq, i & cq->ibcq.cqe);
 	while ((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) != MLX4_CQE_OPCODE_RESIZE) {
 		new_cqe = get_cqe_from_buf(&cq->resize_buf->buf,
 					   (i + 1) & cq->resize_buf->cqe);
-		memcpy(new_cqe, get_cqe(cq, i & cq->ibcq.cqe), sizeof(struct mlx4_cqe));
+		memcpy(new_cqe, get_cqe(cq, i & cq->ibcq.cqe), cqe_size);
 		new_cqe->owner_sr_opcode = (cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK) |
 			(((i + 1) & (cq->resize_buf->cqe + 1)) ? MLX4_CQE_OWNER_MASK : 0);
 		cqe = get_cqe(cq, ++i & cq->ibcq.cqe);
@@ -562,6 +566,9 @@ repoll:
 	if (!cqe)
 		return -EAGAIN;
 
+	if (cq->buf.entry_size == 64)
+		cqe++;
+
 	++cq->mcq.cons_index;
 
 	/*
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fa643f4..2a41040 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -469,6 +469,7 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 	resp.qp_tab_size      = dev->dev->caps.num_qps;
 	resp.bf_reg_size      = dev->dev->caps.bf_reg_size;
 	resp.bf_regs_per_page = dev->dev->caps.bf_regs_per_page;
+	resp.cqe_size         = dev->dev->caps.cqe_size;
 
 	context = kmalloc(sizeof *context, GFP_KERNEL);
 	if (!context)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e4bf2cf..0c325c4 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -59,6 +59,7 @@ struct mlx4_ib_pd {
 struct mlx4_ib_cq_buf {
 	struct mlx4_buf		buf;
 	struct mlx4_mtt		mtt;
+	int			entry_size;
 };
 
 struct mlx4_ib_cq_resize {
diff --git a/drivers/infiniband/hw/mlx4/user.h b/drivers/infiniband/hw/mlx4/user.h
index 13beede..2aa33f8 100644
--- a/drivers/infiniband/hw/mlx4/user.h
+++ b/drivers/infiniband/hw/mlx4/user.h
@@ -40,7 +40,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MLX4_IB_UVERBS_ABI_VERSION	3
+#define MLX4_IB_UVERBS_ABI_VERSION	4
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -54,6 +54,7 @@ struct mlx4_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
 	__u16	bf_reg_size;
 	__u16	bf_regs_per_page;
+	__u32	cqe_size;
 };
 
 struct mlx4_ib_alloc_pd_resp {
diff --git a/drivers/net/mlx4/en_cq.c b/drivers/net/mlx4/en_cq.c
index ec4b6d0..b60b547 100644
--- a/drivers/net/mlx4/en_cq.c
+++ b/drivers/net/mlx4/en_cq.c
@@ -52,9 +52,9 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 
 	cq->size = entries;
 	if (mode == RX)
-		cq->buf_size = cq->size * sizeof(struct mlx4_cqe);
+		cq->buf_size = cq->size * priv->mdev->dev->caps.cqe_size;
 	else
-		cq->buf_size = sizeof(struct mlx4_cqe);
+		cq->buf_size = priv->mdev->dev->caps.cqe_size;
 
 	cq->ring = ring;
 	cq->is_tx = mode;
diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 37cc9e5..dd15ccb 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -541,15 +541,19 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	unsigned int length;
 	int polled = 0;
 	int ip_summed;
+	int factor = 0;
 
 	if (!priv->port_up)
 		return 0;
 
+	if (priv->mdev->dev->caps.cqe_size == 64)
+		factor = 1;
+
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
 	 * descriptor offset can be deduced from the CQE index instead of
 	 * reading 'cqe->index' */
 	index = cq->mcq.cons_index & ring->size_mask;
-	cqe = &cq->buf[index];
+	cqe = &cq->buf[(index << factor) + factor];
 
 	/* Process all completed CQEs */
 	while (XNOR(cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK,
@@ -660,7 +664,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 next:
 		++cq->mcq.cons_index;
 		index = (cq->mcq.cons_index) & ring->size_mask;
-		cqe = &cq->buf[index];
+		cqe = &cq->buf[(index << factor) + factor];
 		if (++polled == budget) {
 			/* We are here because we reached the NAPI budget -
 			 * flush only pending LRO sessions */
diff --git a/drivers/net/mlx4/en_tx.c b/drivers/net/mlx4/en_tx.c
index 6e03de0..16337fb 100644
--- a/drivers/net/mlx4/en_tx.c
+++ b/drivers/net/mlx4/en_tx.c
@@ -318,6 +318,8 @@ static void mlx4_en_process_tx_cq(struct net_device *dev, struct mlx4_en_cq *cq)
 	u32 txbbs_skipped = 0;
 	u32 cq_last_sav;
 
+	if (priv->mdev->dev->caps.cqe_size == 64)
+		cqe++;
 	/* index always points to the first TXBB of the last polled descriptor */
 	index = ring->cons & ring->size_mask;
 	new_index = be16_to_cpu(cqe->wqe_index) & ring->size_mask;
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 7eb8ba8..3cf072e 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -106,6 +106,8 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 		[41] = "Unicast VEP steering support",
 		[42] = "Multicast VEP steering support",
 		[48] = "Counters support",
+		[61] = "64 byte EQE support",
+		[62] = "64 byte CQE support",
 	};
 	int i;
 
@@ -729,6 +731,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define INIT_HCA_CACHELINE_SZ_OFFSET	 0x0e
 #define INIT_HCA_FLAGS_OFFSET		 0x014
 #define INIT_HCA_QPC_OFFSET		 0x020
+#define INIT_HCA_EQE_CQE_OFFSETS	 (INIT_HCA_QPC_OFFSET + 0x38)
 #define	 INIT_HCA_QPC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x10)
 #define	 INIT_HCA_LOG_QP_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x17)
 #define	 INIT_HCA_SRQC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x28)
@@ -792,6 +795,9 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 
 	/* QPC/EEC/CQC/EQC/RDMARC attributes */
 
+	if (dev->caps.cqe_size == 64)
+		*(inbox + INIT_HCA_EQE_CQE_OFFSETS / 4) |= cpu_to_be32(1 << 30);
+
 	MLX4_PUT(inbox, param->qpc_base,      INIT_HCA_QPC_BASE_OFFSET);
 	MLX4_PUT(inbox, param->log_num_qps,   INIT_HCA_LOG_QP_OFFSET);
 	MLX4_PUT(inbox, param->srqc_base,     INIT_HCA_SRQC_BASE_OFFSET);
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index f0ee35d..3799710 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -274,6 +274,15 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_ADDR] +
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH];
 
+	if (dev_cap->flags & (1ULL << 62))
+		dev->caps.cqe_size = 64;
+	else
+		dev->caps.cqe_size = 32;
+
+	/* eqe size remains 32 byte regardles of device's capability */
+	dev->caps.eqe_size = 32;
+
+
 	return 0;
 }
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 53ef894..1b0915f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -276,6 +276,8 @@ struct mlx4_caps {
 	u32			port_mask;
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 	u32			max_counters;
+	int			eqe_size;
+	int			cqe_size;
 };
 
 struct mlx4_buf_list {
-- 
1.7.7.rc0.70.g82660

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
