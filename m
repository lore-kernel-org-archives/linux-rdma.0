From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 13/29] IB/mlx4: SRIOV IB context objects and proxy/tunnel sqp support
Date: Mon, 11 Jun 2012 13:45:54 +0300
Message-ID: <1339411570-4689-14-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Introduce the basic sriov parvirtualization context objects
   for multiplexing and demultiplexing MADs.
2. Introduce support for the new proxy and tunnel QP types.

This patch introduces the objects required by the master
for managing QP paravirtualization for guests.

struct mlx4_ib_sriov{} is created by the master only.
It is a container for the following:
1. All the info required by the PPF to multiplex and de-multiplex MADs
   (including those from the PF). (struct mlx4_ib_demux_ctx demux)
2. All the info required to manage alias GUIDs (i.e., the GUID at
   index 0 that each guest perceives.  In fact, this is not the
   GUID which is actually at index 0, but is, in fact, the GUID
   which is at index[<VF number>] in the physical table.

3. structures which are used to manage CM paravirtualization
4. structures for managing the real special QPs when running in
   sriov mode.
   The real SQPs are controlled by the PPF in this case.  All SQPs
   created and controlled by the ib core layer are proxy sqps

struct mlx4_ib_demux_ctx{} contains the information per port needed
to manage paravirtualization.
This includes:
1. All multicast paravirt info
2. All tunnel-qp paravirt info for the port.
3. GUID-table and GUID-prefix for the port
4. work queues.

struct mlx4_ib_demux_pv_ctx{} contains all the info for managing
the paravirtualized QPs for one slave/port.

struct mlx4_ib_demux_pv_qp{} contains the info need to run an
individual QP (either tunnel qp or real SQP).

Note:  We made use of the 2 most-significant bits in enum
mlx4_ib_qp_flags (based upon enum ib_qp_create_flags (ib_verbs.h))
However, these bits are not currently reserved in ib_qp_create_flags.

We need these bits in the low-level driver for internal purposes.
In the V1 patch set, we will add a patch for the core which will
indicate some of the most-significant bits in ib_qp_create_flags
as reserved for low-level driver use.  Something like:
enum ib_qp_create_flags {
        IB_QP_CREATE_IPOIB_UD_LSO               = 1 << 0,
        IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK   = 1 << 1,
        /* reserve bits 27-31 for low level drivers' internal use */
        IB_QP_CREATE_RESERVED_START             = 1 << 27,
        IB_QP_CREATE_RESERVED_END               = 1 << 31,
};

Currently, only two of the flag bits are used, and we do not
expect to get to the point where there are more than 27 qp-create
flag bits.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      |   31 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  121 +++++++-
 drivers/infiniband/hw/mlx4/qp.c      |  628 ++++++++++++++++++++++++++++++----
 include/linux/mlx4/device.h          |    1 +
 include/linux/mlx4/qp.h              |    3 +-
 5 files changed, 707 insertions(+), 77 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 6d4ef71..9401df0 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -547,6 +547,26 @@ static int mlx4_ib_ipoib_csum_ok(__be16 status, __be16 checksum)
 		checksum == cpu_to_be16(0xffff);
 }
 
+static int use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq, struct ib_wc *wc,
+			   unsigned tail, struct mlx4_cqe *cqe)
+{
+	struct mlx4_ib_proxy_sqp_hdr *hdr;
+
+	ib_dma_sync_single_for_cpu(qp->ibqp.device,
+				   qp->sqp_proxy_rcv[tail].map,
+				   sizeof(struct mlx4_ib_proxy_sqp_hdr),
+				   DMA_FROM_DEVICE);
+	hdr = (struct mlx4_ib_proxy_sqp_hdr *) (qp->sqp_proxy_rcv[tail].addr);
+	wc->pkey_index	= be16_to_cpu(hdr->tun.pkey_index);
+	wc->slid	= be16_to_cpu(hdr->tun.slid);
+	wc->sl		= hdr->tun.sl;
+	wc->src_qp	= be32_to_cpu(hdr->tun.src_qp);
+	wc->wc_flags   |= be32_to_cpu(hdr->tun.wc_flags) & IB_WC_GRH;
+	wc->dlid_path_bits = 0;
+
+	return 0;
+}
+
 static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 			    struct mlx4_ib_qp **cur_qp,
 			    struct ib_wc *wc)
@@ -559,6 +579,7 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 	int is_error;
 	u32 g_mlpath_rqpn;
 	u16 wqe_ctr;
+	unsigned tail = 0;
 
 repoll:
 	cqe = next_cqe_sw(cq);
@@ -634,7 +655,8 @@ repoll:
 		mlx4_ib_free_srq_wqe(srq, wqe_ctr);
 	} else {
 		wq	  = &(*cur_qp)->rq;
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		tail	  = wq->tail & (wq->wqe_cnt - 1);
+		wc->wr_id = wq->wrid[tail];
 		++wq->tail;
 	}
 
@@ -717,6 +739,13 @@ repoll:
 			break;
 		}
 
+		if (mlx4_is_mfunc(to_mdev(cq->ibcq.device)->dev)) {
+			if ((*cur_qp)->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+			    (*cur_qp)->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI       ||
+			    (*cur_qp)->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI)
+				return use_tunnel_data(*cur_qp, cq, wc, tail, cqe);
+		}
+
 		wc->slid	   = be16_to_cpu(cqe->rlid);
 		g_mlpath_rqpn	   = be32_to_cpu(cqe->g_mlpath_rqpn);
 		wc->src_qp	   = g_mlpath_rqpn & 0xffffff;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index d6d14f4..3100f62 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -144,8 +144,10 @@ struct mlx4_ib_wq {
 };
 
 enum mlx4_ib_qp_flags {
-	MLX4_IB_QP_LSO				= 1 << 0,
-	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+	MLX4_IB_QP_LSO = IB_QP_CREATE_IPOIB_UD_LSO,
+	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK = IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
+	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
+	MLX4_IB_SRIOV_SQP = 1 << 31,
 };
 
 struct mlx4_ib_gid_entry {
@@ -155,6 +157,60 @@ struct mlx4_ib_gid_entry {
 	u8			port;
 };
 
+enum mlx4_ib_qp_type {
+	/*
+	 * IB_QPT_SMI and IB_QPT_GSI have to be the first two entries
+	 * here (and in that order) since the MAD layer uses them as
+	 * indices into a 2-entry table.
+	 */
+	MLX4_IB_QPT_SMI = IB_QPT_SMI,
+	MLX4_IB_QPT_GSI = IB_QPT_GSI,
+
+	MLX4_IB_QPT_RC = IB_QPT_RC,
+	MLX4_IB_QPT_UC = IB_QPT_UC,
+	MLX4_IB_QPT_UD = IB_QPT_UD,
+	MLX4_IB_QPT_RAW_IPV6 = IB_QPT_RAW_IPV6,
+	MLX4_IB_QPT_RAW_ETHERTYPE = IB_QPT_RAW_ETHERTYPE,
+	MLX4_IB_QPT_RAW_PACKET = IB_QPT_RAW_PACKET,
+	MLX4_IB_QPT_XRC_INI = IB_QPT_XRC_INI,
+	MLX4_IB_QPT_XRC_TGT = IB_QPT_XRC_TGT,
+
+	MLX4_IB_QPT_SRIOV_BASE = 99,
+	MLX4_IB_QPT_PROXY_SMI_OWNER = 100,
+	MLX4_IB_QPT_PROXY_SMI,
+	MLX4_IB_QPT_PROXY_GSI,
+	MLX4_IB_QPT_TUN_SMI_OWNER,
+	MLX4_IB_QPT_TUN_SMI,
+	MLX4_IB_QPT_TUN_GSI,
+};
+
+struct mlx4_ib_tunnel_header {
+	struct mlx4_av av;
+	__be32 remote_qpn;
+	__be32 qkey;
+	__be16 pkey_index;
+	u8 reserved[6]; /* align to 8 bytes */
+};
+
+struct mlx4_ib_buf {
+	void *addr;
+	dma_addr_t map;
+};
+
+struct mlx4_rcv_tunnel_hdr {
+	__be32			src_qp;
+	__be32			wc_flags;
+	__be16			pkey_index;
+	__be16			slid;
+	u8			sl;
+	u8			reserved[5]; /* align to 16 bytes */
+};
+
+struct mlx4_ib_proxy_sqp_hdr {
+	struct ib_grh grh;
+	struct mlx4_rcv_tunnel_hdr tun;
+}  __packed;
+
 struct mlx4_ib_qp {
 	struct ib_qp		ibqp;
 	struct mlx4_qp		mqp;
@@ -170,6 +226,7 @@ struct mlx4_ib_qp {
 	int			sq_spare_wqes;
 	struct mlx4_ib_wq	sq;
 
+	enum mlx4_ib_qp_type	mlx4_ib_qp_type;
 	struct ib_umem	       *umem;
 	struct mlx4_mtt		mtt;
 	int			buf_size;
@@ -184,6 +241,8 @@ struct mlx4_ib_qp {
 	u8			state;
 	int			mlx_type;
 	struct list_head	gid_list;
+	struct mlx4_ib_buf	*sqp_proxy_rcv;
+
 };
 
 struct mlx4_ib_srq {
@@ -206,6 +265,56 @@ struct mlx4_ib_ah {
 	union mlx4_ext_av       av;
 };
 
+struct mlx4_ib_tun_tx_buf {
+	struct mlx4_ib_buf buf;
+	struct ib_ah *ah;
+};
+
+struct mlx4_ib_demux_pv_qp {
+	struct ib_qp *qp;
+	enum ib_qp_type proxy_qpt;
+	struct mlx4_ib_buf *ring;
+	struct mlx4_ib_tun_tx_buf *tx_ring;
+	spinlock_t tx_lock;
+	unsigned tx_ix_head;
+	unsigned tx_ix_tail;
+};
+
+struct mlx4_ib_demux_pv_ctx {
+	int port;
+	int slave;
+	int has_smi;
+	struct ib_device *ib_dev;
+	struct ib_cq *cq;
+	struct ib_pd *pd;
+	struct ib_mr *mr;
+	struct work_struct work;
+	struct workqueue_struct *wq;
+	struct mlx4_ib_demux_pv_qp qp[2];
+};
+
+struct mlx4_ib_demux_ctx {
+	struct ib_device *ib_dev;
+	int port;
+	struct workqueue_struct *wq;
+	struct workqueue_struct *ud_wq;
+	spinlock_t ud_lock;
+	__be64 subnet_prefix;
+	__be64 guid_cache[128];
+	struct mlx4_ib_dev *dev;
+	struct mlx4_ib_demux_pv_ctx **tun;
+};
+
+struct mlx4_ib_sriov {
+	struct mlx4_ib_demux_ctx demux[MLX4_MAX_PORTS];
+	u16 local_lid[MLX4_MAX_PORTS];
+	struct mlx4_ib_demux_pv_ctx *sqps[MLX4_MAX_PORTS];
+	/* when using this spinlock you should use "irq" because
+	 * it may be called from interrupt context.*/
+	spinlock_t going_down_lock;
+	int is_going_down;
+};
+
 struct mlx4_ib_iboe {
 	spinlock_t		lock;
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
@@ -226,6 +335,7 @@ struct mlx4_ib_dev {
 	struct ib_mad_agent    *send_agent[MLX4_MAX_PORTS][2];
 	struct ib_ah	       *sm_ah[MLX4_MAX_PORTS];
 	spinlock_t		sm_lock;
+	struct mlx4_ib_sriov	sriov;
 
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
@@ -241,6 +351,13 @@ struct ib_event_work {
 	struct mlx4_eqe		ib_eqe;
 };
 
+struct mlx4_ib_qp_tunnel_init_attr {
+	struct ib_qp_init_attr init_attr;
+	int slave;
+	enum ib_qp_type proxy_qp_type;
+	u8 port;
+};
+
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct mlx4_ib_dev, ib_dev);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 81f95eb..be8fa61 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -38,6 +38,7 @@
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_mad.h>
 
 #include <linux/mlx4/qp.h>
 
@@ -110,16 +111,38 @@ static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
 	return container_of(mqp, struct mlx4_ib_sqp, qp);
 }
 
+static int is_tunnel_qp(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
+{
+	if (!mlx4_is_master(dev->dev))
+		return 0;
+
+	return qp->mqp.qpn >= dev->dev->caps.base_sqpn &&
+	       qp->mqp.qpn < dev->dev->caps.base_sqpn +
+	       8 + 16 * MLX4_MFUNC_MAX;
+}
+
 static int is_sqp(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 {
-	return qp->mqp.qpn >= dev->dev->caps.sqp_start &&
-		qp->mqp.qpn <= dev->dev->caps.sqp_start + 3;
+	return ((mlx4_is_master(dev->dev) &&
+		 qp->mqp.qpn >= dev->dev->caps.base_sqpn &&
+		 qp->mqp.qpn <= dev->dev->caps.base_sqpn + 3) ||
+		(qp->mqp.qpn >= dev->dev->caps.sqp_start &&
+		 qp->mqp.qpn <= dev->dev->caps.sqp_start + 3));
 }
 
+/* used for INIT/CLOSE port logic */
 static int is_qp0(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 {
-	return qp->mqp.qpn >= dev->dev->caps.sqp_start &&
-		qp->mqp.qpn <= dev->dev->caps.sqp_start + 1;
+	int qp0;
+
+	/* qp0 is either the proxy qp0, or the real qp0 */
+	qp0 = (qp->mqp.qpn >= dev->dev->caps.sqp_start &&
+		qp->mqp.qpn <= dev->dev->caps.sqp_start + 1) ||
+		(mlx4_is_mfunc(dev->dev) &&
+		 qp->mqp.qpn >= dev->dev->caps.base_sqpn &&
+		 qp->mqp.qpn <= dev->dev->caps.base_sqpn + 1);
+
+	return qp0;
 }
 
 static void *get_wqe(struct mlx4_ib_qp *qp, int offset)
@@ -270,7 +293,7 @@ static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
 	}
 }
 
-static int send_wqe_overhead(enum ib_qp_type type, u32 flags)
+static int send_wqe_overhead(enum mlx4_ib_qp_type type, u32 flags)
 {
 	/*
 	 * UD WQEs must have a datagram segment.
@@ -279,19 +302,29 @@ static int send_wqe_overhead(enum ib_qp_type type, u32 flags)
 	 * header and space for the ICRC).
 	 */
 	switch (type) {
-	case IB_QPT_UD:
+	case MLX4_IB_QPT_UD:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_datagram_seg) +
 			((flags & MLX4_IB_QP_LSO) ? MLX4_IB_LSO_HEADER_SPARE : 0);
-	case IB_QPT_UC:
+	case MLX4_IB_QPT_PROXY_SMI_OWNER:
+	case MLX4_IB_QPT_PROXY_SMI:
+	case MLX4_IB_QPT_PROXY_GSI:
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_datagram_seg) + 64;
+	case MLX4_IB_QPT_TUN_SMI_OWNER:
+	case MLX4_IB_QPT_TUN_GSI:
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_datagram_seg);
+
+	case MLX4_IB_QPT_UC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_raddr_seg);
-	case IB_QPT_RC:
+	case MLX4_IB_QPT_RC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_atomic_seg) +
 			sizeof (struct mlx4_wqe_raddr_seg);
-	case IB_QPT_SMI:
-	case IB_QPT_GSI:
+	case MLX4_IB_QPT_SMI:
+	case MLX4_IB_QPT_GSI:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			ALIGN(MLX4_IB_UD_HEADER_SIZE +
 			      DIV_ROUND_UP(MLX4_IB_UD_HEADER_SIZE,
@@ -345,7 +378,7 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 }
 
 static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
-			      enum ib_qp_type type, struct mlx4_ib_qp *qp)
+			      enum mlx4_ib_qp_type type, struct mlx4_ib_qp *qp)
 {
 	int s;
 
@@ -360,7 +393,9 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	 * For MLX transport we need 2 extra S/G entries:
 	 * one for the header and one for the checksum at the end
 	 */
-	if ((type == IB_QPT_SMI || type == IB_QPT_GSI) &&
+	if ((type == MLX4_IB_QPT_SMI || type == MLX4_IB_QPT_GSI ||
+	     type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+	     type == MLX4_IB_QPT_TUN_SMI_OWNER) &&
 	    cap->max_send_sge + 2 > dev->dev->caps.max_sq_sg)
 		return -EINVAL;
 
@@ -404,7 +439,11 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	 */
 	if (dev->dev->caps.fw_ver >= MLX4_FW_VER_WQE_CTRL_NEC &&
 	    qp->sq_signal_bits && BITS_PER_LONG == 64 &&
-	    type != IB_QPT_SMI && type != IB_QPT_GSI)
+	    type != MLX4_IB_QPT_SMI && type != MLX4_IB_QPT_GSI &&
+	    type != MLX4_IB_QPT_PROXY_SMI_OWNER &&
+	    type != MLX4_IB_QPT_PROXY_SMI &&
+	    type != MLX4_IB_QPT_PROXY_GSI &&
+	    type != MLX4_IB_QPT_TUN_SMI_OWNER)
 		qp->sq.wqe_shift = ilog2(64);
 	else
 		qp->sq.wqe_shift = ilog2(roundup_pow_of_two(s));
@@ -476,6 +515,54 @@ static int set_user_sq_size(struct mlx4_ib_dev *dev,
 	return 0;
 }
 
+static int alloc_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
+{
+	int i;
+
+	qp->sqp_proxy_rcv =
+		kmalloc(sizeof(struct mlx4_ib_buf) * qp->rq.wqe_cnt,
+			GFP_KERNEL);
+	if (!qp->sqp_proxy_rcv)
+		return -ENOMEM;
+	for (i = 0; i < qp->rq.wqe_cnt; i++) {
+		qp->sqp_proxy_rcv[i].addr =
+			kmalloc(sizeof(struct mlx4_ib_proxy_sqp_hdr),
+				GFP_KERNEL);
+		if (!qp->sqp_proxy_rcv[i].addr)
+			goto err;
+		qp->sqp_proxy_rcv[i].map =
+			ib_dma_map_single(dev, qp->sqp_proxy_rcv[i].addr,
+					  sizeof(struct mlx4_ib_proxy_sqp_hdr),
+					  DMA_FROM_DEVICE);
+	}
+	return 0;
+
+err:
+	while (i > 0) {
+		--i;
+		ib_dma_unmap_single(dev, qp->sqp_proxy_rcv[i].map,
+				    sizeof(struct mlx4_ib_proxy_sqp_hdr),
+				    DMA_FROM_DEVICE);
+		kfree(qp->sqp_proxy_rcv[i].addr);
+	}
+	kfree(qp->sqp_proxy_rcv);
+	qp->sqp_proxy_rcv = NULL;
+	return -ENOMEM;
+}
+
+static void free_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
+{
+	int i;
+
+	for (i = 0; i < qp->rq.wqe_cnt; i++) {
+		ib_dma_unmap_single(dev, qp->sqp_proxy_rcv[i].map,
+				    sizeof(struct mlx4_ib_proxy_sqp_hdr),
+				    DMA_FROM_DEVICE);
+		kfree(qp->sqp_proxy_rcv[i].addr);
+	}
+	kfree(qp->sqp_proxy_rcv);
+}
+
 static int qp_has_rq(struct ib_qp_init_attr *attr)
 {
 	if (attr->qp_type == IB_QPT_XRC_INI || attr->qp_type == IB_QPT_XRC_TGT)
@@ -486,10 +573,73 @@ static int qp_has_rq(struct ib_qp_init_attr *attr)
 
 static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
-			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp *qp)
+			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp **caller_qp)
 {
 	int qpn;
 	int err;
+	struct mlx4_ib_sqp *sqp;
+	struct mlx4_ib_qp *qp;
+	enum mlx4_ib_qp_type qp_type = (enum mlx4_ib_qp_type) init_attr->qp_type;
+
+	/* When tunneling special qps, we use a plain UD qp */
+	if (sqpn) {
+		if (mlx4_is_mfunc(dev->dev) &&
+		    (!mlx4_is_master(dev->dev) ||
+		     !(init_attr->create_flags & MLX4_IB_SRIOV_SQP))) {
+			if (init_attr->qp_type == IB_QPT_GSI)
+				qp_type = MLX4_IB_QPT_PROXY_GSI;
+			else if (mlx4_is_master(dev->dev))
+				qp_type = MLX4_IB_QPT_PROXY_SMI_OWNER;
+			else
+				qp_type = MLX4_IB_QPT_PROXY_SMI;
+		}
+		qpn = sqpn;
+		/* add extra sg entry for tunneling */
+		init_attr->cap.max_recv_sge++;
+	} else if (init_attr->create_flags & MLX4_IB_SRIOV_TUNNEL_QP) {
+		struct mlx4_ib_qp_tunnel_init_attr *tnl_init =
+			container_of(init_attr,
+				     struct mlx4_ib_qp_tunnel_init_attr, init_attr);
+		if ((tnl_init->proxy_qp_type != IB_QPT_SMI &&
+		     tnl_init->proxy_qp_type != IB_QPT_GSI)   ||
+		    !mlx4_is_master(dev->dev))
+			return -EINVAL;
+		if (tnl_init->proxy_qp_type == IB_QPT_GSI)
+			qp_type = MLX4_IB_QPT_TUN_GSI;
+		else if (tnl_init->slave == dev->dev->caps.function)
+			qp_type = MLX4_IB_QPT_TUN_SMI_OWNER;
+		else
+			qp_type = MLX4_IB_QPT_TUN_SMI;
+		qpn = dev->dev->caps.base_tunnel_sqpn + 8 * tnl_init->slave +
+		      tnl_init->proxy_qp_type * 2 + tnl_init->port - 1;
+		sqpn = qpn;
+	}
+
+	if (!*caller_qp) {
+		if (qp_type == MLX4_IB_QPT_SMI || qp_type == MLX4_IB_QPT_GSI ||
+		    qp_type == MLX4_IB_QPT_PROXY_SMI               ||
+		    qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER         ||
+		    qp_type == MLX4_IB_QPT_PROXY_GSI               ||
+		    qp_type == MLX4_IB_QPT_TUN_SMI_OWNER) {
+			sqp = kzalloc(sizeof(struct mlx4_ib_sqp), GFP_KERNEL);
+			if (!sqp)
+				return -ENOMEM;
+			qp = &sqp->qp;
+		} else {
+			qp = kzalloc(sizeof(struct mlx4_ib_qp), GFP_KERNEL);
+			if (!qp)
+				return -ENOMEM;
+		}
+	} else
+		qp = *caller_qp;
+
+	qp->mlx4_ib_qp_type = qp_type;
+
+	if (mlx4_is_mfunc(dev->dev) &&
+	    (qp_type == MLX4_IB_QPT_SMI || qp_type == MLX4_IB_QPT_GSI)) {
+		qpn -= 8;
+		sqpn -= 8;
+	}
 
 	mutex_init(&qp->mutex);
 	spin_lock_init(&qp->sq.lock);
@@ -549,7 +699,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
 			qp->flags |= MLX4_IB_QP_LSO;
 
-		err = set_kernel_sq_size(dev, &init_attr->cap, init_attr->qp_type, qp);
+		err = set_kernel_sq_size(dev, &init_attr->cap, qp_type, qp);
 		if (err)
 			goto err;
 
@@ -585,7 +735,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	}
 
 	if (sqpn) {
-		qpn = sqpn;
+		if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI       ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI) {
+			if (alloc_proxy_bufs(pd->device, qp)) {
+				err = -ENOMEM;
+				goto err_wrid;
+			}
+		}
 	} else {
 		/* Raw packet QPNs must be aligned to 8 bits. If not, the WQE
 		 * BlueFlame setup flow wrongly causes VLAN insertion. */
@@ -594,7 +751,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		else
 			err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
 		if (err)
-			goto err_wrid;
+			goto err_proxy;
 	}
 
 	err = mlx4_qp_alloc(dev->dev, qpn, &qp->mqp);
@@ -612,13 +769,16 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
 
 	qp->mqp.event = mlx4_ib_qp_event;
-
+	if (!*caller_qp)
+		*caller_qp = qp;
 	return 0;
 
 err_qpn:
 	if (!sqpn)
 		mlx4_qp_release_range(dev->dev, qpn, 1);
-
+err_proxy:
+	if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI)
+		free_proxy_bufs(pd->device, qp);
 err_wrid:
 	if (pd->uobject) {
 		if (qp_has_rq(init_attr))
@@ -642,6 +802,8 @@ err_db:
 		mlx4_db_free(dev->dev, &qp->db);
 
 err:
+	if (!*caller_qp)
+		kfree(qp);
 	return err;
 }
 
@@ -754,7 +916,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 
 	mlx4_qp_free(dev->dev, &qp->mqp);
 
-	if (!is_sqp(dev, qp))
+	if (!is_sqp(dev, qp) && !is_tunnel_qp(dev, qp))
 		mlx4_qp_release_range(dev->dev, qp->mqp.qpn, 1);
 
 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
@@ -767,6 +929,10 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	} else {
 		kfree(qp->sq.wrid);
 		kfree(qp->rq.wrid);
+		if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI       ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI)
+			free_proxy_bufs(&dev->ib_dev, qp);
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
 		if (qp->rq.wqe_cnt)
 			mlx4_db_free(dev->dev, &qp->db);
@@ -779,21 +945,25 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 				struct ib_qp_init_attr *init_attr,
 				struct ib_udata *udata)
 {
-	struct mlx4_ib_sqp *sqp;
-	struct mlx4_ib_qp *qp;
+	struct mlx4_ib_qp *qp = NULL;
 	int err;
 	u16 xrcdn = 0;
 
 	/*
-	 * We only support LSO and multicast loopback blocking, and
-	 * only for kernel UD QPs.
+	 * We only support LSO, vendor flag1, and multicast loopback blocking,
+	 * and only for kernel UD QPs.
 	 */
-	if (init_attr->create_flags & ~(IB_QP_CREATE_IPOIB_UD_LSO |
-					IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK))
+	if (init_attr->create_flags & ~(MLX4_IB_QP_LSO |
+					MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK |
+					MLX4_IB_SRIOV_TUNNEL_QP | MLX4_IB_SRIOV_SQP))
 		return ERR_PTR(-EINVAL);
 
 	if (init_attr->create_flags &&
-	    (udata || init_attr->qp_type != IB_QPT_UD))
+	    (udata ||
+	     ((init_attr->create_flags & ~MLX4_IB_SRIOV_SQP) &&
+	      init_attr->qp_type != IB_QPT_UD) ||
+	     ((init_attr->create_flags & MLX4_IB_SRIOV_SQP) &&
+	      init_attr->qp_type > IB_QPT_GSI)))
 		return ERR_PTR(-EINVAL);
 
 	switch (init_attr->qp_type) {
@@ -809,18 +979,17 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 		/* fall through */
 	case IB_QPT_RC:
 	case IB_QPT_UC:
-	case IB_QPT_UD:
 	case IB_QPT_RAW_PACKET:
-	{
 		qp = kzalloc(sizeof *qp, GFP_KERNEL);
 		if (!qp)
 			return ERR_PTR(-ENOMEM);
-
-		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata, 0, qp);
-		if (err) {
-			kfree(qp);
+		/* fall through */
+	case IB_QPT_UD:
+	{
+		err = create_qp_common(to_mdev(pd->device), pd, init_attr,
+				       udata, 0, &qp);
+		if (err)
 			return ERR_PTR(err);
-		}
 
 		qp->ibqp.qp_num = qp->mqp.qpn;
 		qp->xrcdn = xrcdn;
@@ -834,21 +1003,13 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 		if (udata)
 			return ERR_PTR(-EINVAL);
 
-		sqp = kzalloc(sizeof *sqp, GFP_KERNEL);
-		if (!sqp)
-			return ERR_PTR(-ENOMEM);
-
-		qp = &sqp->qp;
-
 		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata,
 				       to_mdev(pd->device)->dev->caps.sqp_start +
 				       (init_attr->qp_type == IB_QPT_SMI ? 0 : 2) +
 				       init_attr->port_num - 1,
-				       qp);
-		if (err) {
-			kfree(sqp);
+				       &qp);
+		if (err)
 			return ERR_PTR(err);
-		}
 
 		qp->port	= init_attr->port_num;
 		qp->ibqp.qp_num = init_attr->qp_type == IB_QPT_SMI ? 0 : 1;
@@ -883,18 +1044,27 @@ int mlx4_ib_destroy_qp(struct ib_qp *qp)
 	return 0;
 }
 
-static int to_mlx4_st(enum ib_qp_type type)
+static int to_mlx4_st(struct mlx4_ib_dev *dev, enum mlx4_ib_qp_type type)
 {
 	switch (type) {
-	case IB_QPT_RC:		return MLX4_QP_ST_RC;
-	case IB_QPT_UC:		return MLX4_QP_ST_UC;
-	case IB_QPT_UD:		return MLX4_QP_ST_UD;
-	case IB_QPT_XRC_INI:
-	case IB_QPT_XRC_TGT:	return MLX4_QP_ST_XRC;
-	case IB_QPT_SMI:
-	case IB_QPT_GSI:
-	case IB_QPT_RAW_PACKET:	return MLX4_QP_ST_MLX;
-	default:		return -1;
+	case MLX4_IB_QPT_RC:		return MLX4_QP_ST_RC;
+	case MLX4_IB_QPT_UC:		return MLX4_QP_ST_UC;
+	case MLX4_IB_QPT_UD:		return MLX4_QP_ST_UD;
+	case MLX4_IB_QPT_XRC_INI:
+	case MLX4_IB_QPT_XRC_TGT:	return MLX4_QP_ST_XRC;
+	case MLX4_IB_QPT_SMI:
+	case MLX4_IB_QPT_GSI:
+	case MLX4_IB_QPT_RAW_PACKET:	return MLX4_QP_ST_MLX;
+
+	case MLX4_IB_QPT_PROXY_SMI_OWNER:
+	case MLX4_IB_QPT_TUN_SMI_OWNER:	return (mlx4_is_mfunc(dev->dev) ?
+						MLX4_QP_ST_MLX : -1);
+	case MLX4_IB_QPT_PROXY_SMI:
+	case MLX4_IB_QPT_TUN_SMI:
+	case MLX4_IB_QPT_PROXY_GSI:
+	case MLX4_IB_QPT_TUN_GSI:	return (mlx4_is_mfunc(dev->dev) ?
+						MLX4_QP_ST_UD : -1);
+	default:			return -1;
 	}
 }
 
@@ -1042,7 +1212,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		return -ENOMEM;
 
 	context->flags = cpu_to_be32((to_mlx4_state(new_state) << 28) |
-				     (to_mlx4_st(ibqp->qp_type) << 16));
+				     (to_mlx4_st(dev, qp->mlx4_ib_qp_type) << 16));
 
 	if (!(attr_mask & IB_QP_PATH_MIG_STATE))
 		context->flags |= cpu_to_be32(MLX4_QP_PM_MIGRATED << 11);
@@ -1120,13 +1290,16 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
+		if (qp->mlx4_ib_qp_type > MLX4_IB_QPT_SRIOV_BASE)
+			context->pri_path.disable_pkey_check = 0x40;
 		context->pri_path.pkey_index = attr->pkey_index;
 		optpar |= MLX4_QP_OPTPAR_PKEY_INDEX;
 	}
 
 	if (attr_mask & IB_QP_AV) {
 		if (mlx4_set_path(dev, &attr->ah_attr, &context->pri_path,
-				  attr_mask & IB_QP_PORT ? attr->port_num : qp->port))
+				  attr_mask & IB_QP_PORT ?
+				  attr->port_num : qp->port))
 			goto out;
 
 		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
@@ -1209,8 +1382,24 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_RQ_PSN)
 		context->rnr_nextrecvpsn |= cpu_to_be32(attr->rq_psn);
 
+	/* proxy and tunnel qp qkeys will be changed in modify-qp wrappers */
 	if (attr_mask & IB_QP_QKEY) {
-		context->qkey = cpu_to_be32(attr->qkey);
+		if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_TUN_SMI_OWNER)
+			context->qkey = cpu_to_be32(IB_QP_SET_QKEY);
+		else {
+			if (mlx4_is_mfunc(dev->dev) &&
+			    qp->mlx4_ib_qp_type <= MLX4_IB_QPT_SRIOV_BASE &&
+			    (attr->qkey & MLX4_RESERVED_QKEY_MASK) ==
+			    MLX4_RESERVED_QKEY_BASE) {
+				pr_err("Cannot use reserved QKEY"
+				       " 0x%x (range 0xffff0000..0xffffffff"
+				       " is reserved)\n", attr->qkey);
+				err = -EINVAL;
+				goto out;
+			}
+			context->qkey = cpu_to_be32(attr->qkey);
+		}
 		optpar |= MLX4_QP_OPTPAR_Q_KEY;
 	}
 
@@ -1226,10 +1415,17 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	     ibqp->qp_type == IB_QPT_UD ||
 	     ibqp->qp_type == IB_QPT_RAW_PACKET)) {
 		context->pri_path.sched_queue = (qp->port - 1) << 6;
-		if (is_qp0(dev, qp))
+		if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_SMI ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_TUN_SMI_OWNER) {
 			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_QP0_SCHED_QUEUE;
-		else
+			if (qp->mlx4_ib_qp_type != MLX4_IB_QPT_SMI)
+				context->pri_path.fl = 0x80;
+		} else {
+			if (qp->mlx4_ib_qp_type > MLX4_IB_QPT_SRIOV_BASE)
+				context->pri_path.fl = 0x80;
 			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_SCHED_QUEUE;
+		}
 	}
 
 	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
@@ -1345,7 +1541,7 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	}
 
 	if ((attr_mask & IB_QP_PORT) &&
-	    (attr->port_num == 0 || attr->port_num > dev->dev->caps.num_ports)) {
+	    (attr->port_num == 0 || attr->port_num > dev->num_ports)) {
 		mlx4_ib_dbg("qpn 0x%x: invalid port number (%d) specified "
 			    "for transition %d to %d. qp_type %d\n",
 			    ibqp->qp_num, attr->port_num, cur_state,
@@ -1405,6 +1601,120 @@ out:
 	return err;
 }
 
+static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
+				  struct ib_send_wr *wr,
+				  void *wqe, unsigned *mlx_seg_len)
+{
+	struct mlx4_ib_dev *mdev = to_mdev(sqp->qp.ibqp.device);
+	struct ib_device *ib_dev = &mdev->ib_dev;
+	struct mlx4_wqe_mlx_seg *mlx = wqe;
+	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
+	struct mlx4_ib_ah *ah = to_mah(wr->wr.ud.ah);
+	u16 pkey;
+	u32 qkey;
+	int send_size;
+	int header_size;
+	int spc;
+	int i;
+
+	if (wr->opcode != IB_WR_SEND)
+		return -EINVAL;
+
+	send_size = 0;
+
+	for (i = 0; i < wr->num_sge; ++i)
+		send_size += wr->sg_list[i].length;
+
+	/* for proxy-qp0 sends, need to add in size of tunnel header */
+	/* for tunnel-qp0 sends, tunnel header is already in s/g list */
+	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER)
+		send_size += sizeof(struct mlx4_ib_tunnel_header);
+
+	ib_ud_header_init(send_size, 1, 0, 0, 0, 0, &sqp->ud_header);
+
+	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER) {
+		sqp->ud_header.lrh.service_level =
+			be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 28;
+		sqp->ud_header.lrh.destination_lid =
+			cpu_to_be16(ah->av.ib.g_slid & 0x7f);
+		sqp->ud_header.lrh.source_lid =
+			cpu_to_be16(ah->av.ib.g_slid & 0x7f);
+	} else {
+		sqp->ud_header.lrh.destination_lid =
+			cpu_to_be16(mdev->sriov.local_lid[sqp->qp.port - 1]);
+		sqp->ud_header.lrh.source_lid =
+			cpu_to_be16(mdev->sriov.local_lid[sqp->qp.port - 1]);
+	}
+
+	mlx->flags &= cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
+
+	/* force loopback */
+	mlx->flags |= cpu_to_be32(MLX4_WQE_MLX_VL15 | 0x1 | MLX4_WQE_MLX_SLR);
+	mlx->rlid = sqp->ud_header.lrh.destination_lid;
+
+	sqp->ud_header.lrh.virtual_lane    = 0;
+	sqp->ud_header.bth.solicited_event = !!(wr->send_flags & IB_SEND_SOLICITED);
+	ib_get_cached_pkey(ib_dev, sqp->qp.port, 0, &pkey);
+	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
+	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_TUN_SMI_OWNER)
+		sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->wr.ud.remote_qpn);
+	else
+		sqp->ud_header.bth.destination_qpn =
+			cpu_to_be32(mdev->dev->caps.base_tunnel_sqpn +
+				    sqp->qp.port - 1);
+
+	sqp->ud_header.bth.psn = cpu_to_be32((sqp->send_psn++) & ((1 << 24) - 1));
+	if (mlx4_get_parav_qkey(mdev->dev, sqp->qp.mqp.qpn, &qkey))
+		return -EINVAL;
+	sqp->ud_header.deth.qkey = cpu_to_be32(qkey);
+	sqp->ud_header.deth.source_qpn = cpu_to_be32(sqp->qp.mqp.qpn);
+
+	sqp->ud_header.bth.opcode        = IB_OPCODE_UD_SEND_ONLY;
+	sqp->ud_header.immediate_present = 0;
+
+	header_size = ib_ud_header_pack(&sqp->ud_header, sqp->header_buf);
+
+	/*
+	 * Inline data segments may not cross a 64 byte boundary.  If
+	 * our UD header is bigger than the space available up to the
+	 * next 64 byte boundary in the WQE, use two inline data
+	 * segments to hold the UD header.
+	 */
+	spc = MLX4_INLINE_ALIGN -
+	      ((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
+	if (header_size <= spc) {
+		inl->byte_count = cpu_to_be32(1 << 31 | header_size);
+		memcpy(inl + 1, sqp->header_buf, header_size);
+		i = 1;
+	} else {
+		inl->byte_count = cpu_to_be32(1 << 31 | spc);
+		memcpy(inl + 1, sqp->header_buf, spc);
+
+		inl = (void *) (inl + 1) + spc;
+		memcpy(inl + 1, sqp->header_buf + spc, header_size - spc);
+		/*
+		 * Need a barrier here to make sure all the data is
+		 * visible before the byte_count field is set.
+		 * Otherwise the HCA prefetcher could grab the 64-byte
+		 * chunk with this inline segment and get a valid (!=
+		 * 0xffffffff) byte count but stale data, and end up
+		 * generating a packet with bad headers.
+		 *
+		 * The first inline segment's byte_count field doesn't
+		 * need a barrier, because it comes after a
+		 * control/MLX segment and therefore is at an offset
+		 * of 16 mod 64.
+		 */
+		wmb();
+		inl->byte_count = cpu_to_be32(1 << 31 | (header_size - spc));
+		i = 2;
+	}
+
+	*mlx_seg_len =
+	ALIGN(i * sizeof(struct mlx4_wqe_inline_seg) + header_size, 16);
+	return 0;
+}
+
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
@@ -1422,6 +1732,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	int is_vlan = 0;
 	int is_grh;
 	u16 vlan;
+	int err = 0;
 
 	send_size = 0;
 	for (i = 0; i < wr->num_sge; ++i)
@@ -1430,8 +1741,24 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
-				  ah->av.ib.gid_index, &sgid);
+		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
+			/* When multi-function is enabled, the ib_core gid
+			 * indexes don't necessarily match the hw ones, so
+			 * we must use our own cache */
+			sgid.global.subnet_prefix =
+				to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+				subnet_prefix;
+			sgid.global.interface_id =
+				to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+				guid_cache[ah->av.ib.gid_index];
+		} else  {
+			err = ib_get_cached_gid(ib_dev,
+						be32_to_cpu(ah->av.ib.port_pd) >> 24,
+						ah->av.ib.gid_index, &sgid);
+			if (err)
+				return err;
+		}
+
 		vlan = rdma_get_vlan_id(&sgid);
 		is_vlan = vlan < 0x1000;
 	}
@@ -1450,8 +1777,21 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		sqp->ud_header.grh.flow_label    =
 			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
 		sqp->ud_header.grh.hop_limit     = ah->av.ib.hop_limit;
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
-				  ah->av.ib.gid_index, &sqp->ud_header.grh.source_gid);
+		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
+			/* When multi-function is enabled, the ib_core gid
+			 * indexes don't necessarily match the hw ones, so
+			 * we must use our own cache */
+			sqp->ud_header.grh.source_gid.global.subnet_prefix =
+				to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+						       subnet_prefix;
+			sqp->ud_header.grh.source_gid.global.interface_id =
+				to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+					       guid_cache[ah->av.ib.gid_index];
+		} else
+			ib_get_cached_gid(ib_dev,
+					  be32_to_cpu(ah->av.ib.port_pd) >> 24,
+					  ah->av.ib.gid_index,
+					  &sqp->ud_header.grh.source_gid);
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
 	}
@@ -1463,6 +1803,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 					  (sqp->ud_header.lrh.destination_lid ==
 					   IB_LID_PERMISSIVE ? MLX4_WQE_MLX_SLR : 0) |
 					  (sqp->ud_header.lrh.service_level << 8));
+		if (ah->av.ib.port_pd & cpu_to_be32(0x80000000))
+			mlx->flags |= cpu_to_be32(0x1); /* force loopback */
 		mlx->rlid = sqp->ud_header.lrh.destination_lid;
 	}
 
@@ -1668,6 +2010,64 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->av.eth.mac, 6);
 }
 
+static void set_tunnel_datagram_seg(struct mlx4_ib_dev *dev,
+				    struct mlx4_wqe_datagram_seg *dseg,
+				    struct ib_send_wr *wr, enum ib_qp_type qpt)
+{
+	union mlx4_ext_av *av = &to_mah(wr->wr.ud.ah)->av;
+	struct mlx4_av sqp_av = {0};
+	int port = *((u8 *) &av->ib.port_pd) & 0x3;
+
+	/* force loopback */
+	sqp_av.port_pd = av->ib.port_pd | cpu_to_be32(0x80000000);
+	sqp_av.g_slid = av->ib.g_slid & 0x7f; /* no GRH */
+	sqp_av.dlid = cpu_to_be16(dev->sriov.local_lid[port - 1]);
+	sqp_av.sl_tclass_flowlabel = av->ib.sl_tclass_flowlabel &
+			cpu_to_be32(0xf0000000);
+
+	memcpy(dseg->av, &sqp_av, sizeof(struct mlx4_av));
+	dseg->dqpn = cpu_to_be32(dev->dev->caps.base_tunnel_sqpn +
+				 qpt * 2 + port - 1);
+	/* use well-known qkey from the QPC */
+	dseg->qkey = cpu_to_be32(0x80000000);
+}
+
+static void build_tunnel_header(struct ib_send_wr *wr, void *wqe, unsigned *mlx_seg_len)
+{
+	struct mlx4_wqe_inline_seg *inl = wqe;
+	struct mlx4_ib_tunnel_header hdr;
+	struct mlx4_ib_ah *ah = to_mah(wr->wr.ud.ah);
+	int spc;
+	int i;
+
+	memcpy(&hdr.av, &ah->av, sizeof hdr.av);
+	hdr.remote_qpn = cpu_to_be32(wr->wr.ud.remote_qpn);
+	hdr.pkey_index = cpu_to_be16(wr->wr.ud.pkey_index);
+	hdr.qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
+
+	spc = MLX4_INLINE_ALIGN -
+		((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
+	if (sizeof(hdr) <= spc) {
+		memcpy(inl + 1, &hdr, sizeof(hdr));
+		wmb();
+		inl->byte_count = cpu_to_be32(1 << 31 | sizeof(hdr));
+		i = 1;
+	} else {
+		memcpy(inl + 1, &hdr, spc);
+		wmb();
+		inl->byte_count = cpu_to_be32(1 << 31 | spc);
+
+		inl = (void *) (inl + 1) + spc;
+		memcpy(inl + 1, (void *) &hdr + spc, sizeof(hdr) - spc);
+		wmb();
+		inl->byte_count = cpu_to_be32(1 << 31 | (sizeof(hdr) - spc));
+		i = 2;
+	}
+
+	*mlx_seg_len =
+		ALIGN(i * sizeof(struct mlx4_wqe_inline_seg) + sizeof(hdr), 16);
+}
+
 static void set_mlx_icrc_seg(void *dseg)
 {
 	u32 *t = dseg;
@@ -1749,6 +2149,13 @@ static __be32 send_ieth(struct ib_send_wr *wr)
 	}
 }
 
+static void add_zero_len_inline(void *wqe)
+{
+	struct mlx4_wqe_inline_seg *inl = wqe;
+	memset(wqe, 0, 16);
+	inl->byte_count = cpu_to_be32(1 << 31);
+}
+
 int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		      struct ib_send_wr **bad_wr)
 {
@@ -1807,9 +2214,9 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		wqe += sizeof *ctrl;
 		size = sizeof *ctrl / 16;
 
-		switch (ibqp->qp_type) {
-		case IB_QPT_RC:
-		case IB_QPT_UC:
+		switch (qp->mlx4_ib_qp_type) {
+		case MLX4_IB_QPT_RC:
+		case MLX4_IB_QPT_UC:
 			switch (wr->opcode) {
 			case IB_WR_ATOMIC_CMP_AND_SWP:
 			case IB_WR_ATOMIC_FETCH_AND_ADD:
@@ -1870,7 +2277,23 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 			break;
 
-		case IB_QPT_UD:
+		case MLX4_IB_QPT_TUN_SMI_OWNER:
+			err =  build_sriov_qp0_header(to_msqp(qp), wr, ctrl, &seglen);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				goto out;
+			}
+			wqe  += seglen;
+			size += seglen / 16;
+			break;
+		case MLX4_IB_QPT_TUN_SMI:
+		case MLX4_IB_QPT_TUN_GSI:
+			/* this is a UD qp used in MAD responses to slaves. */
+			set_datagram_seg(wqe, wr);
+			wqe  += sizeof(struct mlx4_wqe_datagram_seg);
+			size += sizeof(struct mlx4_wqe_datagram_seg) / 16;
+			break;
+		case MLX4_IB_QPT_UD:
 			set_datagram_seg(wqe, wr);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
@@ -1887,8 +2310,47 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 			break;
 
-		case IB_QPT_SMI:
-		case IB_QPT_GSI:
+		case MLX4_IB_QPT_PROXY_SMI_OWNER:
+			if (unlikely(!mlx4_is_master(to_mdev(ibqp->device)->dev))) {
+				err = -ENOSYS;
+				*bad_wr = wr;
+				goto out;
+			}
+			err = build_sriov_qp0_header(to_msqp(qp), wr, ctrl, &seglen);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				goto out;
+			}
+			wqe  += seglen;
+			size += seglen / 16;
+			/* to start tunnel header on a cache-line boundary */
+			add_zero_len_inline(wqe);
+			wqe += 16;
+			size++;
+			build_tunnel_header(wr, wqe, &seglen);
+			wqe  += seglen;
+			size += seglen / 16;
+			break;
+		case MLX4_IB_QPT_PROXY_SMI:
+			/* don't allow QP0 sends on guests */
+			err = -ENOSYS;
+			*bad_wr = wr;
+			goto out;
+		case MLX4_IB_QPT_PROXY_GSI:
+			/* If we are tunneling special qps, this is a UD qp.
+			 * In this case we first add a UD segment targeting
+			 * the tunnel qp, and then add a header with address
+			 * information */
+			set_tunnel_datagram_seg(to_mdev(ibqp->device), wqe, wr, ibqp->qp_type);
+			wqe  += sizeof(struct mlx4_wqe_datagram_seg);
+			size += sizeof(struct mlx4_wqe_datagram_seg) / 16;
+			build_tunnel_header(wr, wqe, &seglen);
+			wqe  += seglen;
+			size += seglen / 16;
+			break;
+
+		case MLX4_IB_QPT_SMI:
+		case MLX4_IB_QPT_GSI:
 			err = build_mlx_header(to_msqp(qp), wr, ctrl, &seglen);
 			if (unlikely(err)) {
 				*bad_wr = wr;
@@ -1914,8 +2376,10 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		size += wr->num_sge * (sizeof (struct mlx4_wqe_data_seg) / 16);
 
 		/* Add one more inline data segment for ICRC for MLX sends */
-		if (unlikely(qp->ibqp.qp_type == IB_QPT_SMI ||
-			     qp->ibqp.qp_type == IB_QPT_GSI)) {
+		if (unlikely(qp->mlx4_ib_qp_type == MLX4_IB_QPT_SMI ||
+			     qp->mlx4_ib_qp_type == MLX4_IB_QPT_GSI ||
+			     qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+			     qp->mlx4_ib_qp_type == MLX4_IB_QPT_TUN_SMI_OWNER)) {
 			set_mlx_icrc_seg(dseg + 1);
 			size += sizeof (struct mlx4_wqe_data_seg) / 16;
 		}
@@ -2007,8 +2471,10 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	int err = 0;
 	int nreq;
 	int ind;
+	int max_gs;
 	int i;
 
+	max_gs = qp->rq.max_gs;
 	spin_lock_irqsave(&qp->rq.lock, flags);
 
 	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
@@ -2028,10 +2494,26 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 		scat = get_recv_wqe(qp, ind);
 
+		if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI ||
+		    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI) {
+			ib_dma_sync_single_for_device(ibqp->device,
+						      qp->sqp_proxy_rcv[ind].map,
+						      sizeof(struct mlx4_ib_proxy_sqp_hdr),
+						      DMA_FROM_DEVICE);
+			scat->byte_count =
+				cpu_to_be32(sizeof(struct mlx4_ib_proxy_sqp_hdr));
+			/* use dma lkey from upper layer entry */
+			scat->lkey = cpu_to_be32(wr->sg_list->lkey);
+			scat->addr = cpu_to_be64(qp->sqp_proxy_rcv[ind].map);
+			scat++;
+			max_gs--;
+		}
+
 		for (i = 0; i < wr->num_sge; ++i)
 			__set_data_seg(scat + i, wr->sg_list + i);
 
-		if (i < qp->rq.max_gs) {
+		if (i < max_gs) {
 			scat[i].byte_count = 0;
 			scat[i].lkey       = cpu_to_be32(MLX4_INVALID_LKEY);
 			scat[i].addr       = 0;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index da45e79..663277d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -356,6 +356,7 @@ struct mlx4_caps {
 	enum mlx4_port_type	possible_type[MLX4_MAX_PORTS + 1];
 	u32			max_counters;
 	u8			port_ib_mtu[MLX4_MAX_PORTS + 1];
+	u16			sqp_demux;
 };
 
 struct mlx4_buf_list {
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 338388b..4b4ad6f 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -126,7 +126,8 @@ struct mlx4_rss_context {
 
 struct mlx4_qp_path {
 	u8			fl;
-	u8			reserved1[2];
+	u8			reserved1[1];
+	u8			disable_pkey_check;
 	u8			pkey_index;
 	u8			counter_index;
 	u8			grh_mylmc;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
