From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 12/20] net/mlx5_core: Add support for page faults events and low level handling
Date: Sun,  2 Mar 2014 12:49:30 +0200
Message-ID: <1393757378-16412-13-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

* Add a handler function pointer in the mlx5_core_qp struct for page fault
  events. Handle page fault events by calling the handler function, if not
  NULL.
* Add on-demand paging capability query command.
* Export command for resuming QPs after page faults.
* Add various constants related to paging support.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c                |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   |  35 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c   | 134 ++++++++++++++++++++++++-
 include/linux/mlx5/device.h                    |  60 ++++++++++-
 include/linux/mlx5/driver.h                    |  18 ++++
 include/linux/mlx5/qp.h                        |  53 ++++++++++
 9 files changed, 308 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fa0bcd6..d1e8426 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -147,7 +147,7 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 		mr->order = ent->order;
 		mr->umred = 1;
 		mr->dev = dev;
-		in->seg.status = 1 << 6;
+		in->seg.status = MLX5_MKEY_STATUS_FREE;
 		in->seg.xlt_oct_size = cpu_to_be32((npages + 1) / 2);
 		in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 		in->seg.flags = MLX5_ACCESS_MODE_MTT | MLX5_PERM_UMR_EN;
@@ -1029,7 +1029,7 @@ struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 		goto err_free;
 	}
 
-	in->seg.status = 1 << 6; /* free */
+	in->seg.status = MLX5_MKEY_STATUS_FREE;
 	in->seg.xlt_oct_size = cpu_to_be32(ndescs);
 	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
@@ -1144,7 +1144,7 @@ struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 		goto err_free;
 	}
 
-	in->seg.status = 1 << 6; /* free */
+	in->seg.status = MLX5_MKEY_STATUS_FREE;
 	in->seg.xlt_oct_size = cpu_to_be32((max_page_list_len + 1) / 2);
 	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
 	in->seg.flags = MLX5_PERM_UMR_EN | MLX5_ACCESS_MODE_MTT;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e48b699..385501b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1890,7 +1890,7 @@ static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
 {
 	memset(seg, 0, sizeof(*seg));
 	if (li) {
-		seg->status = 1 << 6;
+		seg->status = MLX5_MKEY_STATUS_FREE;
 		return;
 	}
 
@@ -1911,7 +1911,7 @@ static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *w
 
 	memset(seg, 0, sizeof(*seg));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UNREG) {
-		seg->status = 1 << 6;
+		seg->status = MLX5_MKEY_STATUS_FREE;
 		return;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 64a61b2..23bccbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -157,6 +157,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_CMD";
 	case MLX5_EVENT_TYPE_PAGE_REQUEST:
 		return "MLX5_EVENT_TYPE_PAGE_REQUEST";
+	case MLX5_EVENT_TYPE_PAGE_FAULT:
+		return "MLX5_EVENT_TYPE_PAGE_FAULT";
 	default:
 		return "Unrecognized event";
 	}
@@ -275,6 +277,9 @@ static int mlx5_eq_int(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 			}
 			break;
 
+		case MLX5_EVENT_TYPE_PAGE_FAULT:
+			mlx5_eq_pagefault(dev, eqe);
+			break;
 
 		default:
 			mlx5_core_warn(dev, "Unhandled event 0x%x on EQ 0x%x\n", eqe->type, eq->eqn);
@@ -441,8 +446,12 @@ void mlx5_eq_cleanup(struct mlx5_core_dev *dev)
 int mlx5_start_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	u32 async_event_mask = MLX5_ASYNC_EVENT_MASK;
 	int err;
 
+	if (dev->caps.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_PAGE_FAULT);
+
 	err = mlx5_create_map_eq(dev, &table->cmd_eq, MLX5_EQ_VEC_CMD,
 				 MLX5_NUM_CMD_EQE, 1ull << MLX5_EVENT_TYPE_CMD,
 				 "mlx5_cmd_eq", &dev->priv.uuari.uars[0]);
@@ -454,7 +463,7 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 	mlx5_cmd_use_events(dev);
 
 	err = mlx5_create_map_eq(dev, &table->async_eq, MLX5_EQ_VEC_ASYNC,
-				 MLX5_NUM_ASYNC_EQE, MLX5_ASYNC_EVENT_MASK,
+				 MLX5_NUM_ASYNC_EQE, async_event_mask,
 				 "mlx5_async_eq", &dev->priv.uuari.uars[0]);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index f012658..eed8b9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -80,7 +80,7 @@ int mlx5_cmd_query_hca_cap(struct mlx5_core_dev *dev,
 
 	memset(&in, 0, sizeof(in));
 	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_QUERY_HCA_CAP);
-	in.hdr.opmod  = cpu_to_be16(0x1);
+	in.hdr.opmod  = cpu_to_be16(MLX5_CMD_OPMOD_QUERY_HCA_CAP_CUR_CAPS);
 	err = mlx5_cmd_exec(dev, &in, sizeof(in), out, sizeof(*out));
 	if (err)
 		goto out_out;
@@ -146,6 +146,39 @@ out_out:
 	return err;
 }
 
+int mlx5_query_odp_caps(struct mlx5_core_dev *dev, struct mlx5_odp_caps *caps)
+{
+	int err;
+	struct mlx5_cmd_query_hca_cap_mbox_in  in;
+	struct mlx5_cmd_query_hca_cap_mbox_out out;
+
+	if (!(dev->caps.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
+		return -ENOTSUPP;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_QUERY_HCA_CAP);
+	in.hdr.opmod = cpu_to_be16(MLX5_CMD_OPMOD_QUERY_HCA_CAP_ODP_CUR_CAPS);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		goto out;
+
+	if (out.hdr.status) {
+		err = mlx5_cmd_status_to_err(&out.hdr);
+		goto out;
+	}
+
+	*caps = out.odp_caps;
+
+	mlx5_core_dbg(dev, "on-demand paging capabilities:\nrc: %08x\nuc: %08x\nud: %08x\n",
+		      be32_to_cpu(out.odp_caps.per_transport_caps.rc_odp_caps),
+		      be32_to_cpu(out.odp_caps.per_transport_caps.uc_odp_caps),
+		      be32_to_cpu(out.odp_caps.per_transport_caps.ud_odp_caps));
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(mlx5_query_odp_caps);
+
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_init_hca_mbox_in in;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 96a0617..5a5ff5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -184,11 +184,6 @@ static void copy_rw_fields(struct mlx5_hca_cap *to, struct mlx5_hca_cap *from)
 	to->flags = cpu_to_be64(v64);
 }
 
-enum {
-	HCA_CAP_OPMOD_GET_MAX	= 0,
-	HCA_CAP_OPMOD_GET_CUR	= 1,
-};
-
 static int handle_hca_cap(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_query_hca_cap_mbox_out *query_out = NULL;
@@ -210,7 +205,8 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 	}
 
 	query_ctx.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_QUERY_HCA_CAP);
-	query_ctx.hdr.opmod  = cpu_to_be16(HCA_CAP_OPMOD_GET_CUR);
+	query_ctx.hdr.opmod  =
+		cpu_to_be16(MLX5_CMD_OPMOD_QUERY_HCA_CAP_CUR_CAPS);
 	err = mlx5_cmd_exec(dev, &query_ctx, sizeof(query_ctx),
 				 query_out, sizeof(*query_out));
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 5105762..aa6ed06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -39,7 +39,7 @@
 
 #include "mlx5_core.h"
 
-void mlx5_qp_event(struct mlx5_core_dev *dev, u32 qpn, int event_type)
+static struct mlx5_core_qp *mlx5_core_get_qp(struct mlx5_core_dev *dev, u32 qpn)
 {
 	struct mlx5_qp_table *table = &dev->priv.qp_table;
 	struct mlx5_core_qp *qp;
@@ -52,6 +52,19 @@ void mlx5_qp_event(struct mlx5_core_dev *dev, u32 qpn, int event_type)
 
 	spin_unlock(&table->lock);
 
+	return qp;
+}
+
+static void mlx5_core_put_qp(struct mlx5_core_qp *qp)
+{
+	if (atomic_dec_and_test(&qp->refcount))
+		complete(&qp->free);
+}
+
+void mlx5_qp_event(struct mlx5_core_dev *dev, u32 qpn, int event_type)
+{
+	struct mlx5_core_qp *qp = mlx5_core_get_qp(dev, qpn);
+
 	if (!qp) {
 		mlx5_core_warn(dev, "Async event for bogus QP 0x%x\n", qpn);
 		return;
@@ -59,8 +72,92 @@ void mlx5_qp_event(struct mlx5_core_dev *dev, u32 qpn, int event_type)
 
 	qp->event(qp, event_type);
 
-	if (atomic_dec_and_test(&qp->refcount))
-		complete(&qp->free);
+	mlx5_core_put_qp(qp);
+}
+
+void mlx5_eq_pagefault(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
+{
+	struct mlx5_eqe_page_fault *pf_eqe = &eqe->data.page_fault;
+	int qpn = be32_to_cpu(pf_eqe->flags_qpn) & MLX5_QPN_MASK;
+	struct mlx5_core_qp *qp = mlx5_core_get_qp(dev, qpn);
+	struct mlx5_pagefault pfault;
+
+	if (!qp) {
+		mlx5_core_warn(dev, "ODP event for non-existent QP %06x\n",
+			       qpn);
+		return;
+	}
+
+	pfault.event_subtype = eqe->sub_type;
+	pfault.flags = (be32_to_cpu(pf_eqe->flags_qpn) >> MLX5_QPN_BITS) &
+		(MLX5_PFAULT_REQUESTOR | MLX5_PFAULT_WRITE | MLX5_PFAULT_RDMA);
+	pfault.bytes_committed = be32_to_cpu(
+		pf_eqe->bytes_committed);
+
+	mlx5_core_dbg(dev,
+		      "PAGE_FAULT: subtype: 0x%02x, flags: 0x%02x,\n",
+		      eqe->sub_type, pfault.flags);
+
+	switch (eqe->sub_type) {
+	case MLX5_PFAULT_SUBTYPE_RDMA:
+		/* RDMA based event */
+		pfault.rdma.r_key =
+			be32_to_cpu(pf_eqe->rdma.r_key);
+		pfault.rdma.packet_size =
+			be16_to_cpu(pf_eqe->rdma.packet_length);
+		pfault.rdma.rdma_op_len =
+			be32_to_cpu(pf_eqe->rdma.rdma_op_len);
+		pfault.rdma.rdma_va =
+			be64_to_cpu(pf_eqe->rdma.rdma_va);
+		mlx5_core_dbg(dev,
+			      "PAGE_FAULT: qpn: 0x%06x, r_key: 0x%08x,\n",
+			      qpn, pfault.rdma.r_key);
+		mlx5_core_dbg(dev,
+			      "PAGE_FAULT: rdma_op_len: 0x%08x,\n",
+			      pfault.rdma.rdma_op_len);
+		mlx5_core_dbg(dev,
+			      "PAGE_FAULT: rdma_va: 0x%016llx,\n",
+			      pfault.rdma.rdma_va);
+		mlx5_core_dbg(dev,
+			      "PAGE_FAULT: bytes_committed: 0x%06x\n",
+			      pfault.bytes_committed);
+		break;
+
+	case MLX5_PFAULT_SUBTYPE_WQE:
+		/* WQE based event */
+		pfault.wqe.wqe_index =
+			be16_to_cpu(pf_eqe->wqe.wqe_index);
+		pfault.wqe.packet_size =
+			be16_to_cpu(pf_eqe->wqe.packet_length);
+		mlx5_core_dbg(dev,
+			      "PAGE_FAULT: qpn: 0x%06x, wqe_index: 0x%04x,\n",
+			      qpn, pfault.wqe.wqe_index);
+		mlx5_core_dbg(dev,
+			      "PAGE_FAULT: bytes_committed: 0x%06x\n",
+			      pfault.bytes_committed);
+		break;
+
+	default:
+		mlx5_core_warn(dev,
+			       "Unsupported page fault event sub-type: 0x%02hhx, QP %06x\n",
+			       eqe->sub_type, qpn);
+		/* Unsupported page faults should still be resolved by the
+		 * page fault handler
+		 */
+	}
+
+	if (qp->pfault_handler) {
+		qp->pfault_handler(qp, &pfault);
+	} else {
+		mlx5_core_err(dev,
+			      "ODP event for QP %08x, without a fault handler in QP\n",
+			      qpn);
+		/* Page fault will remain unresolved. QP will hang until it is
+		 * destroyed
+		 */
+	}
+
+	mlx5_core_put_qp(qp);
 }
 
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
@@ -138,8 +235,7 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 	radix_tree_delete(&table->tree, qp->qpn);
 	spin_unlock_irqrestore(&table->lock, flags);
 
-	if (atomic_dec_and_test(&qp->refcount))
-		complete(&qp->free);
+	mlx5_core_put_qp(qp);
 	wait_for_completion(&qp->free);
 
 	memset(&in, 0, sizeof(in));
@@ -300,3 +396,31 @@ int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn)
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_xrcd_dealloc);
+
+int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 qpn,
+				 u8 flags, int error)
+{
+	struct mlx5_page_fault_resume_mbox_in in;
+	struct mlx5_page_fault_resume_mbox_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_PAGE_FAULT_RESUME);
+	in.hdr.opmod = 0;
+	flags &= (MLX5_PAGE_FAULT_RESUME_REQUESTOR |
+		  MLX5_PAGE_FAULT_RESUME_WRITE	   |
+		  MLX5_PAGE_FAULT_RESUME_RDMA);
+	flags |= (error ? MLX5_PAGE_FAULT_RESUME_ERROR : 0);
+	in.flags_qpn = cpu_to_be32((qpn & MLX5_QPN_MASK) |
+				   (flags << MLX5_QPN_BITS));
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	if (out.hdr.status)
+		err = mlx5_cmd_status_to_err(&out.hdr);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_page_fault_resume);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 9d7d239..0a6fe1b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -71,6 +71,15 @@ enum {
 };
 
 enum {
+	MLX5_MKEY_INBOX_PG_ACCESS = 1 << 31
+};
+
+enum {
+	MLX5_PFAULT_SUBTYPE_WQE = 0,
+	MLX5_PFAULT_SUBTYPE_RDMA = 1,
+};
+
+enum {
 	MLX5_PERM_LOCAL_READ	= 1 << 2,
 	MLX5_PERM_LOCAL_WRITE	= 1 << 3,
 	MLX5_PERM_REMOTE_READ	= 1 << 4,
@@ -166,6 +175,8 @@ enum mlx5_event {
 
 	MLX5_EVENT_TYPE_CMD		   = 0x0a,
 	MLX5_EVENT_TYPE_PAGE_REQUEST	   = 0xb,
+
+	MLX5_EVENT_TYPE_PAGE_FAULT	   = 0xc,
 };
 
 enum {
@@ -350,6 +361,21 @@ struct mlx5_hca_cap {
 	u8	rsvd28[76];
 };
 
+enum mlx5_odp_transport_cap_bits {
+	MLX5_ODP_SUPPORT_SEND	 = 1 << 31,
+	MLX5_ODP_SUPPORT_RECV	 = 1 << 30,
+	MLX5_ODP_SUPPORT_WRITE	 = 1 << 29,
+};
+
+struct mlx5_odp_caps {
+	char reserved[0x10];
+	struct {
+		__be32			rc_odp_caps;
+		__be32			uc_odp_caps;
+		__be32			ud_odp_caps;
+	} per_transport_caps;
+	char reserved2[0xe4];
+};
 
 struct mlx5_cmd_query_hca_cap_mbox_in {
 	struct mlx5_inbox_hdr	hdr;
@@ -360,10 +386,12 @@ struct mlx5_cmd_query_hca_cap_mbox_in {
 struct mlx5_cmd_query_hca_cap_mbox_out {
 	struct mlx5_outbox_hdr	hdr;
 	u8			rsvd0[8];
-	struct mlx5_hca_cap     hca_cap;
+	union {
+		struct mlx5_hca_cap     hca_cap;
+		struct mlx5_odp_caps	odp_caps;
+	};
 };
 
-
 struct mlx5_cmd_set_hca_cap_mbox_in {
 	struct mlx5_inbox_hdr	hdr;
 	u8			rsvd[8];
@@ -500,6 +528,27 @@ struct mlx5_eqe_page_req {
 	__be32		rsvd1[5];
 };
 
+struct mlx5_eqe_page_fault {
+	__be32 bytes_committed;
+	union {
+		struct {
+			u16     reserved1;
+			__be16  wqe_index;
+			u16	reserved2;
+			__be16  packet_length;
+			u8	reserved3[12];
+		} __packed wqe;
+		struct {
+			__be32  r_key;
+			u16	reserved1;
+			__be16  packet_length;
+			__be32  rdma_op_len;
+			__be64  rdma_va;
+		} __packed rdma;
+	} __packed;
+	__be32 flags_qpn;
+} __packed;
+
 union ev_data {
 	__be32				raw[7];
 	struct mlx5_eqe_cmd		cmd;
@@ -512,6 +561,7 @@ union ev_data {
 	struct mlx5_eqe_congestion	cong;
 	struct mlx5_eqe_stall_vl	stall_vl;
 	struct mlx5_eqe_page_req	req_pages;
+	struct mlx5_eqe_page_fault	page_fault;
 } __packed;
 
 struct mlx5_eqe {
@@ -838,6 +888,10 @@ struct mlx5_query_eq_mbox_out {
 	struct mlx5_eq_context	ctx;
 };
 
+enum {
+	MLX5_MKEY_STATUS_FREE = 1 << 6,
+};
+
 struct mlx5_mkey_seg {
 	/* This is a two bit field occupying bits 31-30.
 	 * bit 31 is always 0,
@@ -874,7 +928,7 @@ struct mlx5_query_special_ctxs_mbox_out {
 struct mlx5_create_mkey_mbox_in {
 	struct mlx5_inbox_hdr	hdr;
 	__be32			input_mkey_index;
-	u8			rsvd0[4];
+	__be32			flags;
 	struct mlx5_mkey_seg	seg;
 	u8			rsvd1[16];
 	__be32			xlat_oct_act_size;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2bce4aa..4f162e8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -113,6 +113,7 @@ enum {
 	MLX5_CMD_OP_QUERY_MKEY			= 0x201,
 	MLX5_CMD_OP_DESTROY_MKEY		= 0x202,
 	MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS	= 0x203,
+	MLX5_CMD_OP_PAGE_FAULT_RESUME		= 0x204,
 
 	MLX5_CMD_OP_CREATE_EQ			= 0x301,
 	MLX5_CMD_OP_DESTROY_EQ			= 0x302,
@@ -174,6 +175,13 @@ enum {
 };
 
 enum {
+	MLX5_CMD_OPMOD_QUERY_HCA_CAP_MAX_CAPS = 0,
+	MLX5_CMD_OPMOD_QUERY_HCA_CAP_CUR_CAPS = 1,
+	MLX5_CMD_OPMOD_QUERY_HCA_CAP_ODP_MAX_CAPS = 4,
+	MLX5_CMD_OPMOD_QUERY_HCA_CAP_ODP_CUR_CAPS = 5,
+};
+
+enum {
 	MLX5_REG_PCAP		 = 0x5001,
 	MLX5_REG_PMTU		 = 0x5003,
 	MLX5_REG_PTYS		 = 0x5004,
@@ -187,6 +195,13 @@ enum {
 	MLX5_REG_HOST_ENDIANNESS = 0x7004,
 };
 
+enum mlx5_page_fault_resume_flags {
+	MLX5_PAGE_FAULT_RESUME_REQUESTOR = 1 << 0,
+	MLX5_PAGE_FAULT_RESUME_WRITE	 = 1 << 1,
+	MLX5_PAGE_FAULT_RESUME_RDMA	 = 1 << 2,
+	MLX5_PAGE_FAULT_RESUME_ERROR	 = 1 << 7,
+};
+
 enum dbg_rsc_type {
 	MLX5_DBG_RSC_QP,
 	MLX5_DBG_RSC_EQ,
@@ -750,6 +765,7 @@ void mlx5_eq_cleanup(struct mlx5_core_dev *dev);
 void mlx5_fill_page_array(struct mlx5_buf *buf, __be64 *pas);
 void mlx5_cq_completion(struct mlx5_core_dev *dev, u32 cqn);
 void mlx5_qp_event(struct mlx5_core_dev *dev, u32 qpn, int event_type);
+void mlx5_eq_pagefault(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe);
 void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type);
 struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn);
 void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, unsigned long vector);
@@ -786,6 +802,8 @@ void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index);
 int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
+int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
+			struct mlx5_odp_caps *odp_caps);
 
 static inline u32 mlx5_mkey_to_idx(u32 mkey)
 {
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 48212c6..8db515c 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -41,6 +41,9 @@
 #define MLX5_DIF_SIZE		8
 #define MLX5_STRIDE_BLOCK_OP	0x400
 
+#define MLX5_QPN_BITS		24
+#define MLX5_QPN_MASK		((1 << MLX5_QPN_BITS) - 1)
+
 enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
 	MLX5_QP_OPTPAR_RRE			= 1 << 1,
@@ -340,8 +343,45 @@ struct mlx5_stride_block_ctrl_seg {
 	__be16		num_entries;
 };
 
+enum mlx5_pagefault_flags {
+	MLX5_PFAULT_REQUESTOR = 1 << 0,
+	MLX5_PFAULT_WRITE     = 1 << 1,
+	MLX5_PFAULT_RDMA      = 1 << 2,
+};
+
+/* Contains the details of a pagefault. */
+struct mlx5_pagefault {
+	u32			bytes_committed;
+	u8			event_subtype;
+	enum mlx5_pagefault_flags flags;
+	union {
+		/* Initiator or send message responder pagefault details. */
+		struct {
+			/* Received packet size, only valid for responders. */
+			u32	packet_size;
+			/*
+			 * WQE index. Refers to either the send queue or
+			 * receive queue, according to event_subtype.
+			 */
+			u16	wqe_index;
+		} wqe;
+		/* RDMA responder pagefault details */
+		struct {
+			u32	r_key;
+			/*
+			 * Received packet size, minimal size page fault
+			 * resolution required for forward progress.
+			 */
+			u32	packet_size;
+			u32	rdma_op_len;
+			u64	rdma_va;
+		} rdma;
+	};
+};
+
 struct mlx5_core_qp {
 	void (*event)		(struct mlx5_core_qp *, int);
+	void (*pfault_handler)(struct mlx5_core_qp *, struct mlx5_pagefault *);
 	int			qpn;
 	atomic_t		refcount;
 	struct completion	free;
@@ -511,6 +551,17 @@ static inline struct mlx5_core_mr *__mlx5_mr_lookup(struct mlx5_core_dev *dev, u
 	return radix_tree_lookup(&dev->priv.mr_table.tree, key);
 }
 
+struct mlx5_page_fault_resume_mbox_in {
+	struct mlx5_inbox_hdr	hdr;
+	__be32			flags_qpn;
+	u8			reserved[4];
+};
+
+struct mlx5_page_fault_resume_mbox_out {
+	struct mlx5_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
 			struct mlx5_create_qp_mbox_in *in,
@@ -530,6 +581,8 @@ void mlx5_init_qp_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev);
 int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
+int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 qpn,
+				u8 context, int error);
 
 static inline const char *mlx5_qp_type_str(int type)
 {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
