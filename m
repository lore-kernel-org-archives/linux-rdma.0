From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2] {NET,IB}/mlx4: 64 byte CQE/EQE support
Date: Thu,  4 Oct 2012 15:05:55 +0200
Message-ID: <1349355955-12831-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

file at ~ogerlitz/tmp-patches/0001-NET-IB-mlx4-64-byte-CQE-EQE-support.patch

Jack, I'd like you to review the part in this patch which
relates to SRIOV, I've tested it now, applied on Roland's for-next,
and it works OK on a system with a VF probed on the host and
doing ipoib ping. Both VF and PF noticed they should use 64B CQE/EQE

The interface to user space part needs some more shaping, I'll get
there once I know that SRIOV wise I'm OK.

Basically, we had some comments on something related from Ben H.
see http://marc.info/?t=133923325000003&r=1&w=2 please let me know
if I can get away without doing the change you and him discussed
and if not, I'd love if you can create a pre-patch that does it.

I'd like to try and push this for 3.7 -- so need your feedback 
as soon as you can.

Or.


----------------------------------

CX3 devices can work with 64 or 32 byte CQEs/EQEs. Using 64 byte
EQEs/CQEs allow better utilization of new chipsets and gaining higher
performance. This patch queries the HCA's capabilities and if it
supports BOTH 64 byte CQEs and EQES will configure the HW to work
in 64 byte mode. Note that the 32B vs 64B working mode is global,
per HCA and not per CQ or EQ.

Since this mode is global, userspace (libmlx4) must be updated to
work with the configured CQE size, and similarily under SRIOV, guests
that use ConnectX virtual functions need to know both EQE and CQE size.

The patch makes sure that older guest drivers who follows the
QUERY_DEV_FUNC command (e.g as done in mlx4_core of Linux 3.3/3.4)
will notice that they need an update to be able to work with the
PPF since the returned pf_context_behaviour will not be zero any more.

User space notification is done through a new field introduced
in struct mlx4_ib_ucontext which holds device capabilities for
which user space must take action. This changes the binary interface so
the ABI is bumped from 3 to 4 but only when **needed** e.g only when the
driver does use 64B CQEs or future device capabilities which must be
in sync by user space. This would allow to work with unmodified libmlx4
on older devices (e.g A0, B0) which don't support 64 byte cookies.

---

V0 pointer
	mlx4 http://marc.info/?l=linux-rdma&m=131805712306677&w=2
	libmlx4 http://marc.info/?l=linux-rdma&m=131805712306678&w=2

V1 changes from V0

 - unified the 64B CQE and EQE patches to one patch which takes an approach of 
   apply both or none, under the thinking that 99% FW will support both or none.

 - bump the ABI version towards user-space/libmlx4 only when needed and not always

 - added support for SRIOV, using the PF_CONTEXT_BEHAVIOUR_MASK mechanism of
   the query func capabilities command, modified "sizeof (struct mlx4_eqe)" 
   to be 32 or 64 in mlx4_multi_func_init() and slave_event(), just to make sure
   Jack/Liran is that the correct thing to do?

V2 changes
  
  rebased to kernel 3.6+ (e.g pre 3.7-rc1) that includes the SRIOV/IB patches


 drivers/infiniband/hw/mlx4/cq.c                |   33 ++++++++++++++++++-----
 drivers/infiniband/hw/mlx4/main.c              |   26 +++++++++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |    1 +
 drivers/infiniband/hw/mlx4/user.h              |   15 ++++++++++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c       |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |    5 ++-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c     |    5 ++-
 drivers/net/ethernet/mellanox/mlx4/eq.c        |   25 +++++++++++------
 drivers/net/ethernet/mellanox/mlx4/fw.c        |   11 +++++++-
 drivers/net/ethernet/mellanox/mlx4/main.c      |   20 +++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1 +
 include/linux/mlx4/device.h                    |   16 +++++++++++
 14 files changed, 133 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index c9eb6a6..314bee0 100644
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
@@ -331,16 +334,23 @@ static void mlx4_ib_cq_resize_copy_cqes(struct mlx4_ib_cq *cq)
 {
 	struct mlx4_cqe *cqe, *new_cqe;
 	int i;
+	int cqe_size = cq->buf.entry_size;
+	int cqe_inc = cqe_size == 64 ? 1 : 0;
 
 	i = cq->mcq.cons_index;
 	cqe = get_cqe(cq, i & cq->ibcq.cqe);
+	cqe += cqe_inc;
+
 	while ((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) != MLX4_CQE_OPCODE_RESIZE) {
 		new_cqe = get_cqe_from_buf(&cq->resize_buf->buf,
 					   (i + 1) & cq->resize_buf->cqe);
-		memcpy(new_cqe, get_cqe(cq, i & cq->ibcq.cqe), sizeof(struct mlx4_cqe));
+		memcpy(new_cqe, get_cqe(cq, i & cq->ibcq.cqe), cqe_size);
+		new_cqe += cqe_inc;
+
 		new_cqe->owner_sr_opcode = (cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK) |
 			(((i + 1) & (cq->resize_buf->cqe + 1)) ? MLX4_CQE_OWNER_MASK : 0);
 		cqe = get_cqe(cq, ++i & cq->ibcq.cqe);
+		cqe += cqe_inc;
 	}
 	++cq->mcq.cons_index;
 }
@@ -438,6 +448,7 @@ err_buf:
 
 out:
 	mutex_unlock(&cq->resize_mutex);
+
 	return err;
 }
 
@@ -586,6 +597,9 @@ repoll:
 	if (!cqe)
 		return -EAGAIN;
 
+	if (cq->buf.entry_size == 64)
+		cqe++;
+
 	++cq->mcq.cons_index;
 
 	/*
@@ -807,6 +821,7 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
 	int nfreed = 0;
 	struct mlx4_cqe *cqe, *dest;
 	u8 owner_bit;
+	int cqe_inc = cq->buf.entry_size == 64 ? 1 : 0;
 
 	/*
 	 * First we need to find the current producer index, so we
@@ -825,12 +840,16 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
 	 */
 	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
+		cqe += cqe_inc;
+
 		if ((be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) == qpn) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_ib_free_srq_wqe(srq, be16_to_cpu(cqe->wqe_index));
 			++nfreed;
 		} else if (nfreed) {
 			dest = get_cqe(cq, (prod_index + nfreed) & cq->ibcq.cqe);
+			dest += cqe_inc;
+
 			owner_bit = dest->owner_sr_opcode & MLX4_CQE_OWNER_MASK;
 			memcpy(dest, cqe, sizeof *cqe);
 			dest->owner_sr_opcode = owner_bit |
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 718ec6b..bec9250 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -563,15 +563,23 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct mlx4_ib_ucontext *context;
+	struct mlx4_ib_alloc_ucontext_resp_v3 resp_v3;
 	struct mlx4_ib_alloc_ucontext_resp resp;
 	int err;
 
 	if (!dev->ib_active)
 		return ERR_PTR(-EAGAIN);
 
-	resp.qp_tab_size      = dev->dev->caps.num_qps;
-	resp.bf_reg_size      = dev->dev->caps.bf_reg_size;
-	resp.bf_regs_per_page = dev->dev->caps.bf_regs_per_page;
+	if (ibdev->uverbs_abi_ver == MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION) {
+		resp_v3.qp_tab_size      = dev->dev->caps.num_qps;
+		resp_v3.bf_reg_size      = dev->dev->caps.bf_reg_size;
+		resp_v3.bf_regs_per_page = dev->dev->caps.bf_regs_per_page;
+	} else {
+		resp.dev_caps	      = dev->dev->caps.userspace_caps;
+		resp.qp_tab_size      = dev->dev->caps.num_qps;
+		resp.bf_reg_size      = dev->dev->caps.bf_reg_size;
+		resp.bf_regs_per_page = dev->dev->caps.bf_regs_per_page;
+	}
 
 	context = kmalloc(sizeof *context, GFP_KERNEL);
 	if (!context)
@@ -586,7 +594,11 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
-	err = ib_copy_to_udata(udata, &resp, sizeof resp);
+	if (ibdev->uverbs_abi_ver == MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION)
+		err = ib_copy_to_udata(udata, &resp_v3, sizeof resp_v3);
+	else
+		err = ib_copy_to_udata(udata, &resp, sizeof resp);
+
 	if (err) {
 		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
 		kfree(context);
@@ -1342,7 +1354,11 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.num_comp_vectors	= dev->caps.num_comp_vectors;
 	ibdev->ib_dev.dma_device	= &dev->pdev->dev;
 
-	ibdev->ib_dev.uverbs_abi_ver	= MLX4_IB_UVERBS_ABI_VERSION;
+	if (dev->caps.userspace_caps)
+		ibdev->ib_dev.uverbs_abi_ver = MLX4_IB_UVERBS_ABI_VERSION;
+	else
+		ibdev->ib_dev.uverbs_abi_ver = MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION;
+
 	ibdev->ib_dev.uverbs_cmd_mask	=
 		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e04cbc9..dcd845b 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -90,6 +90,7 @@ struct mlx4_ib_xrcd {
 struct mlx4_ib_cq_buf {
 	struct mlx4_buf		buf;
 	struct mlx4_mtt		mtt;
+	int			entry_size;
 };
 
 struct mlx4_ib_cq_resize {
diff --git a/drivers/infiniband/hw/mlx4/user.h b/drivers/infiniband/hw/mlx4/user.h
index 13beede..07afc93 100644
--- a/drivers/infiniband/hw/mlx4/user.h
+++ b/drivers/infiniband/hw/mlx4/user.h
@@ -40,7 +40,13 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MLX4_IB_UVERBS_ABI_VERSION	3
+
+#define MLX4_IB_UVERBS_NO_DEV_CAPS_ABI_VERSION	3
+#define MLX4_IB_UVERBS_ABI_VERSION		4
+
+enum {
+	MLX4_64_BYTE_CQE	= 1 << 0
+};
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -50,7 +56,14 @@
  * instead.
  */
 
+struct mlx4_ib_alloc_ucontext_resp_v3 {
+	__u32	qp_tab_size;
+	__u16	bf_reg_size;
+	__u16	bf_regs_per_page;
+};
+
 struct mlx4_ib_alloc_ucontext_resp {
+	__u32	dev_caps;
 	__u32	qp_tab_size;
 	__u16	bf_reg_size;
 	__u16	bf_regs_per_page;
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 3d1899f..e791e70 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1755,7 +1755,7 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 			spin_lock_init(&s_state->lock);
 		}
 
-		memset(&priv->mfunc.master.cmd_eqe, 0, sizeof(struct mlx4_eqe));
+		memset(&priv->mfunc.master.cmd_eqe, 0, dev->caps.eqe_size);
 		priv->mfunc.master.cmd_eqe.type = MLX4_EVENT_TYPE_CMD;
 		INIT_WORK(&priv->mfunc.master.comm_work,
 			  mlx4_master_comm_channel);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index aa9c2f6..b8d0854 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -51,7 +51,7 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 	int err;
 
 	cq->size = entries;
-	cq->buf_size = cq->size * sizeof(struct mlx4_cqe);
+	cq->buf_size = cq->size * mdev->dev->caps.cqe_size;
 
 	cq->ring = ring;
 	cq->is_tx = mode;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index edd9cb8..93a3256 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1600,6 +1600,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		goto out;
 	}
 	priv->rx_ring_num = prof->rx_ring_num;
+	priv->cqe_factor = (mdev->dev->caps.cqe_size == 64) ? 1 : 0;
 	priv->mac_index = -1;
 	priv->msg_enable = MLX4_EN_MSG_LEVEL;
 	spin_lock_init(&priv->stats_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 5aba5ec..6fa106f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -566,6 +566,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	struct ethhdr *ethh;
 	dma_addr_t dma;
 	u64 s_mac;
+	int factor = priv->cqe_factor;
 
 	if (!priv->port_up)
 		return 0;
@@ -574,7 +575,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	 * descriptor offset can be deduced from the CQE index instead of
 	 * reading 'cqe->index' */
 	index = cq->mcq.cons_index & ring->size_mask;
-	cqe = &cq->buf[index];
+	cqe = &cq->buf[(index << factor) + factor];
 
 	/* Process all completed CQEs */
 	while (XNOR(cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK,
@@ -709,7 +710,7 @@ next:
 
 		++cq->mcq.cons_index;
 		index = (cq->mcq.cons_index) & ring->size_mask;
-		cqe = &cq->buf[index];
+		cqe = &cq->buf[(index << factor) + factor];
 		if (++polled == budget) {
 			/* We are here because we reached the NAPI budget -
 			 * flush only pending LRO sessions */
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c10e3a6..21e7ae6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -316,12 +316,13 @@ static void mlx4_en_process_tx_cq(struct net_device *dev, struct mlx4_en_cq *cq)
 	struct mlx4_cqe *buf = cq->buf;
 	u32 packets = 0;
 	u32 bytes = 0;
+	int factor = priv->cqe_factor;
 
 	if (!priv->port_up)
 		return;
 
 	index = cons_index & size_mask;
-	cqe = &buf[index];
+	cqe = &buf[(index << factor) + factor];
 	ring_index = ring->cons & size_mask;
 
 	/* Process all completed CQEs */
@@ -350,7 +351,7 @@ static void mlx4_en_process_tx_cq(struct net_device *dev, struct mlx4_en_cq *cq)
 
 		++cons_index;
 		index = cons_index & size_mask;
-		cqe = &buf[index];
+		cqe = &buf[(index << factor) + factor];
 	}
 
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 51c7649..99619c4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -101,15 +101,20 @@ static void eq_set_ci(struct mlx4_eq *eq, int req_not)
 	mb();
 }
 
-static struct mlx4_eqe *get_eqe(struct mlx4_eq *eq, u32 entry)
+static struct mlx4_eqe *get_eqe(struct mlx4_eq *eq, u32 entry, u8 eqe_factor)
 {
-	unsigned long off = (entry & (eq->nent - 1)) * MLX4_EQ_ENTRY_SIZE;
-	return eq->page_list[off / PAGE_SIZE].buf + off % PAGE_SIZE;
+	/* (entry & (eq->nent - 1)) gives us a cyclic array */
+	unsigned long offset = (entry & (eq->nent - 1)) * (MLX4_EQ_ENTRY_SIZE << eqe_factor);
+	/* CX3 is capable of extending the EQE from 32 to 64 bytes.
+	   When this feature is enabled, the first (in the lower addresses)
+	   32 bytes in the 64 byte EQE are reserved and the next 32
+	   bytes contain the legacy EQE information. */
+	return eq->page_list[offset / PAGE_SIZE].buf + (offset + (eqe_factor ? MLX4_EQ_ENTRY_SIZE : 0)) % PAGE_SIZE;
 }
 
-static struct mlx4_eqe *next_eqe_sw(struct mlx4_eq *eq)
+static struct mlx4_eqe *next_eqe_sw(struct mlx4_eq *eq, u8 eqe_factor)
 {
-	struct mlx4_eqe *eqe = get_eqe(eq, eq->cons_index);
+	struct mlx4_eqe *eqe = get_eqe(eq, eq->cons_index, eqe_factor);
 	return !!(eqe->owner & 0x80) ^ !!(eq->cons_index & eq->nent) ? NULL : eqe;
 }
 
@@ -177,7 +182,7 @@ static void slave_event(struct mlx4_dev *dev, u8 slave, struct mlx4_eqe *eqe)
 		return;
 	}
 
-	memcpy(s_eqe, eqe, sizeof(struct mlx4_eqe) - 1);
+	memcpy(s_eqe, eqe, dev->caps.eqe_size - 1);
 	s_eqe->slave_id = slave;
 	/* ensure all information is written before setting the ownersip bit */
 	wmb();
@@ -447,7 +452,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 	int i;
 	enum slave_port_gen_event gen_event;
 
-	while ((eqe = next_eqe_sw(eq))) {
+	while ((eqe = next_eqe_sw(eq, dev->caps.eqe_factor))) {
 		/*
 		 * Make sure we read EQ entry contents after we've
 		 * checked the ownership bit.
@@ -858,7 +863,8 @@ static int mlx4_create_eq(struct mlx4_dev *dev, int nent,
 
 	eq->dev   = dev;
 	eq->nent  = roundup_pow_of_two(max(nent, 2));
-	npages = PAGE_ALIGN(eq->nent * MLX4_EQ_ENTRY_SIZE) / PAGE_SIZE;
+	/* CX3 is capable of extending the CQE\EQE from 32 to 64 bytes */
+	npages = PAGE_ALIGN(eq->nent * (MLX4_EQ_ENTRY_SIZE << dev->caps.eqe_factor)) / PAGE_SIZE;
 
 	eq->page_list = kmalloc(npages * sizeof *eq->page_list,
 				GFP_KERNEL);
@@ -960,8 +966,9 @@ static void mlx4_free_eq(struct mlx4_dev *dev,
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
 	int err;
-	int npages = PAGE_ALIGN(MLX4_EQ_ENTRY_SIZE * eq->nent) / PAGE_SIZE;
 	int i;
+	/* CX3 is capable of extending the CQE\EQE from 32 to 64 bytes */
+	int npages = PAGE_ALIGN((MLX4_EQ_ENTRY_SIZE << dev->caps.eqe_factor) * eq->nent) / PAGE_SIZE;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 4f30b99..21e3c6e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -110,6 +110,8 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 		[42] = "Multicast VEP steering support",
 		[48] = "Counters support",
 		[59] = "Port management change event support",
+		[61] = "64 byte EQE support",
+		[62] = "64 byte CQE support",
 	};
 	int i;
 
@@ -235,7 +237,7 @@ int mlx4_QUERY_FUNC_CAP_wrapper(struct mlx4_dev *dev, int slave,
 		field = dev->caps.num_ports;
 		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_NUM_PORTS_OFFSET);
 
-		size = 0; /* no PF behaviour is set for now */
+		size = dev->caps.function_caps; /* set PF behaviours */
 		MLX4_PUT(outbox->buf, size, QUERY_FUNC_CAP_PF_BHVR_OFFSET);
 
 		field = 0; /* protected FMR support not available as yet */
@@ -1237,6 +1239,13 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_COUNTERS)
 		*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1 << 4);
 
+	/* CX3 is capable of extending the CQE\EQE from 32 to 64 bytes */
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_64B_CQE &&
+	    dev->caps.flags & MLX4_DEV_CAP_FLAG_64B_EQE) {
+		*(inbox + INIT_HCA_EQE_CQE_OFFSETS / 4) |= cpu_to_be32(1 << 29);
+		*(inbox + INIT_HCA_EQE_CQE_OFFSETS / 4) |= cpu_to_be32(1 << 30);
+	}
+
 	/* QPC/EEC/CQC/EQC/RDMARC attributes */
 
 	MLX4_PUT(inbox, param->qpc_base,      INIT_HCA_QPC_BASE_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 80df2ab..0cd8dee 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -96,7 +96,8 @@ MODULE_PARM_DESC(log_num_mgm_entry_size, "log mgm size, that defines the num"
 					 " flow steering");
 
 #define HCA_GLOBAL_CAP_MASK            0
-#define PF_CONTEXT_BEHAVIOUR_MASK      0
+
+#define PF_CONTEXT_BEHAVIOUR_MASK	MLX4_FUNC_CAP_64B_EQE_CQE
 
 static char mlx4_version[] __devinitdata =
 	DRV_NAME ": Mellanox ConnectX core driver v"
@@ -386,6 +387,23 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH];
 
 	dev->caps.sqp_demux = (mlx4_is_master(dev)) ? MLX4_MAX_NUM_SLAVES : 0;
+
+	/* CX3 is capable of extending the CQE\EQE from 32 to 64 bytes */
+	if (dev_cap->flags & MLX4_DEV_CAP_FLAG_64B_CQE &&
+	    dev_cap->flags & MLX4_DEV_CAP_FLAG_64B_EQE) {
+		dev->caps.cqe_size   = 64;
+		dev->caps.eqe_size   = 64;
+		dev->caps.eqe_factor = 1;
+	} else {
+		dev->caps.cqe_size   = 32;
+		dev->caps.eqe_size   = 32;
+		dev->caps.eqe_factor = 0;
+		if (dev_cap->flags & MLX4_DEV_CAP_FLAG_64B_CQE)
+			mlx4_err(dev, "64B CQEs supported but not 64B EQEs, ignoring\n");
+		else if (dev_cap->flags & MLX4_DEV_CAP_FLAG_64B_EQE)
+			mlx4_err(dev, "64B EQEs supported but not 64B CQEs, ignoring\n");
+	}
+
 	return 0;
 }
 /*The function checks if there are live vf, return the num of them*/
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 9d27e42..73b5c2a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -487,6 +487,7 @@ struct mlx4_en_priv {
 	int mac_index;
 	unsigned max_mtu;
 	int base_qpn;
+	int cqe_factor;
 
 	struct mlx4_en_rss_map rss_map;
 	__be32 ctrl_flags;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6d1acb0..7df1f26 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -142,6 +142,8 @@ enum {
 	MLX4_DEV_CAP_FLAG_COUNTERS	= 1LL << 48,
 	MLX4_DEV_CAP_FLAG_SENSE_SUPPORT	= 1LL << 55,
 	MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV = 1LL << 59,
+	MLX4_DEV_CAP_FLAG_64B_EQE	= 1LL << 61,
+	MLX4_DEV_CAP_FLAG_64B_CQE	= 1LL << 62
 };
 
 enum {
@@ -151,6 +153,15 @@ enum {
 	MLX4_DEV_CAP_FLAG2_FS_EN		= 1LL <<  3
 };
 
+enum {
+	MLX4_USER_DEV_CAP_64B_CQE	= 1L << 0
+};
+
+enum {
+	MLX4_FUNC_CAP_64B_EQE_CQE	= 1L << 0
+};
+
+
 #define MLX4_ATTR_EXTENDED_PORT_INFO	cpu_to_be16(0xff90)
 
 enum {
@@ -419,6 +430,11 @@ struct mlx4_caps {
 	u32			max_counters;
 	u8			port_ib_mtu[MLX4_MAX_PORTS + 1];
 	u16			sqp_demux;
+	u32			eqe_size;
+	u32			cqe_size;
+	u8			eqe_factor;
+	u32			userspace_caps; /* userspace must be aware to */
+	u32			function_caps;  /* functions must be aware to */
 };
 
 struct mlx4_buf_list {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
