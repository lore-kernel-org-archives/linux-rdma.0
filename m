From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 10/17] net/mlx5_core: Add support for page faults events and low level handling
Date: Thu, 11 Dec 2014 17:04:19 +0200
Message-ID: <1418310266-9584-11-git-send-email-haggaie@mellanox.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418310266-9584-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |  40 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 119 +++++++++++++++++++++++++++
 include/linux/mlx5/device.h                  |  54 +++++++++++-
 include/linux/mlx5/driver.h                  |  12 +++
 include/linux/mlx5/qp.h                      |  55 +++++++++++++
 6 files changed, 291 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index ad2c96a02a53..44cc16d4eff7 100644
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
@@ -279,6 +281,11 @@ static int mlx5_eq_int(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 			}
 			break;
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+		case MLX5_EVENT_TYPE_PAGE_FAULT:
+			mlx5_eq_pagefault(dev, eqe);
+			break;
+#endif
 
 		default:
 			mlx5_core_warn(dev, "Unhandled event 0x%x on EQ 0x%x\n",
@@ -446,8 +453,12 @@ void mlx5_eq_cleanup(struct mlx5_core_dev *dev)
 int mlx5_start_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	u32 async_event_mask = MLX5_ASYNC_EVENT_MASK;
 	int err;
 
+	if (dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_PAGE_FAULT);
+
 	err = mlx5_create_map_eq(dev, &table->cmd_eq, MLX5_EQ_VEC_CMD,
 				 MLX5_NUM_CMD_EQE, 1ull << MLX5_EVENT_TYPE_CMD,
 				 "mlx5_cmd_eq", &dev->priv.uuari.uars[0]);
@@ -459,7 +470,7 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 	mlx5_cmd_use_events(dev);
 
 	err = mlx5_create_map_eq(dev, &table->async_eq, MLX5_EQ_VEC_ASYNC,
-				 MLX5_NUM_ASYNC_EQE, MLX5_ASYNC_EVENT_MASK,
+				 MLX5_NUM_ASYNC_EQE, async_event_mask,
 				 "mlx5_async_eq", &dev->priv.uuari.uars[0]);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 087c4c797deb..06f9036acd83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -69,6 +69,46 @@ int mlx5_cmd_query_hca_cap(struct mlx5_core_dev *dev, struct mlx5_caps *caps)
 	return mlx5_core_get_caps(dev, caps, HCA_CAP_OPMOD_GET_CUR);
 }
 
+int mlx5_query_odp_caps(struct mlx5_core_dev *dev, struct mlx5_odp_caps *caps)
+{
+	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)];
+	int out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *out;
+	int err;
+
+	if (!(dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
+		return -ENOTSUPP;
+
+	memset(in, 0, sizeof(in));
+	out = kzalloc(out_sz, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, op_mod, HCA_CAP_OPMOD_GET_ODP_CUR);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, out_sz);
+	if (err)
+		goto out;
+
+	err = mlx5_cmd_status_to_err_v2(out);
+	if (err) {
+		mlx5_core_warn(dev, "query cur hca ODP caps failed, %d\n", err);
+		goto out;
+	}
+
+	memcpy(caps, MLX5_ADDR_OF(query_hca_cap_out, out, capability_struct),
+	       sizeof(*caps));
+
+	mlx5_core_dbg(dev, "on-demand paging capabilities:\nrc: %08x\nuc: %08x\nud: %08x\n",
+		be32_to_cpu(caps->per_transport_caps.rc_odp_caps),
+		be32_to_cpu(caps->per_transport_caps.uc_odp_caps),
+		be32_to_cpu(caps->per_transport_caps.ud_odp_caps));
+
+out:
+	kfree(out);
+	return err;
+}
+EXPORT_SYMBOL(mlx5_query_odp_caps);
+
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_init_hca_mbox_in in;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 5261a2b0da43..575d853dbe05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -88,6 +88,95 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 	mlx5_core_put_rsc(common);
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+void mlx5_eq_pagefault(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
+{
+	struct mlx5_eqe_page_fault *pf_eqe = &eqe->data.page_fault;
+	int qpn = be32_to_cpu(pf_eqe->flags_qpn) & MLX5_QPN_MASK;
+	struct mlx5_core_rsc_common *common = mlx5_get_rsc(dev, qpn);
+	struct mlx5_core_qp *qp =
+		container_of(common, struct mlx5_core_qp, common);
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
+	mlx5_core_put_rsc(common);
+}
+#endif
+
 int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
 			struct mlx5_create_qp_mbox_in *in,
@@ -322,3 +411,33 @@ int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn)
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_xrcd_dealloc);
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 qpn,
+				u8 flags, int error)
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
+#endif
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 3562b9732699..ec7389fe4822 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -120,6 +120,15 @@ enum {
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
@@ -215,6 +224,8 @@ enum mlx5_event {
 
 	MLX5_EVENT_TYPE_CMD		   = 0x0a,
 	MLX5_EVENT_TYPE_PAGE_REQUEST	   = 0xb,
+
+	MLX5_EVENT_TYPE_PAGE_FAULT	   = 0xc,
 };
 
 enum {
@@ -307,6 +318,8 @@ enum {
 enum {
 	HCA_CAP_OPMOD_GET_MAX	= 0,
 	HCA_CAP_OPMOD_GET_CUR	= 1,
+	HCA_CAP_OPMOD_GET_ODP_MAX = 4,
+	HCA_CAP_OPMOD_GET_ODP_CUR = 5
 };
 
 struct mlx5_inbox_hdr {
@@ -336,6 +349,23 @@ struct mlx5_cmd_query_adapter_mbox_out {
 	u8			vsd_psid[16];
 };
 
+enum mlx5_odp_transport_cap_bits {
+	MLX5_ODP_SUPPORT_SEND	 = 1 << 31,
+	MLX5_ODP_SUPPORT_RECV	 = 1 << 30,
+	MLX5_ODP_SUPPORT_WRITE	 = 1 << 29,
+	MLX5_ODP_SUPPORT_READ	 = 1 << 28,
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
+
 struct mlx5_cmd_init_hca_mbox_in {
 	struct mlx5_inbox_hdr	hdr;
 	u8			rsvd0[2];
@@ -456,6 +486,27 @@ struct mlx5_eqe_page_req {
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
@@ -467,6 +518,7 @@ union ev_data {
 	struct mlx5_eqe_congestion	cong;
 	struct mlx5_eqe_stall_vl	stall_vl;
 	struct mlx5_eqe_page_req	req_pages;
+	struct mlx5_eqe_page_fault	page_fault;
 } __packed;
 
 struct mlx5_eqe {
@@ -833,7 +885,7 @@ struct mlx5_query_special_ctxs_mbox_out {
 struct mlx5_create_mkey_mbox_in {
 	struct mlx5_inbox_hdr	hdr;
 	__be32			input_mkey_index;
-	u8			rsvd0[4];
+	__be32			flags;
 	struct mlx5_mkey_seg	seg;
 	u8			rsvd1[16];
 	__be32			xlat_oct_act_size;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 246310dc8bef..09c707dec29a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -113,6 +113,13 @@ enum {
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
@@ -711,6 +718,9 @@ void mlx5_eq_cleanup(struct mlx5_core_dev *dev);
 void mlx5_fill_page_array(struct mlx5_buf *buf, __be64 *pas);
 void mlx5_cq_completion(struct mlx5_core_dev *dev, u32 cqn);
 void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type);
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+void mlx5_eq_pagefault(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe);
+#endif
 void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type);
 struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn);
 void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, unsigned long vector);
@@ -748,6 +758,8 @@ int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index);
 int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
+int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
+			struct mlx5_odp_caps *odp_caps);
 
 static inline u32 mlx5_mkey_to_idx(u32 mkey)
 {
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 67f4b9660b06..6b1d6f60c7e6 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -50,6 +50,9 @@
 #define MLX5_BSF_APPTAG_ESCAPE	0x1
 #define MLX5_BSF_APPREF_ESCAPE	0x2
 
+#define MLX5_QPN_BITS		24
+#define MLX5_QPN_MASK		((1 << MLX5_QPN_BITS) - 1)
+
 enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
 	MLX5_QP_OPTPAR_RRE			= 1 << 1,
@@ -363,9 +366,46 @@ struct mlx5_stride_block_ctrl_seg {
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
 	struct mlx5_core_rsc_common	common; /* must be first */
 	void (*event)		(struct mlx5_core_qp *, int);
+	void (*pfault_handler)(struct mlx5_core_qp *, struct mlx5_pagefault *);
 	int			qpn;
 	struct mlx5_rsc_debug	*dbg;
 	int			pid;
@@ -533,6 +573,17 @@ static inline struct mlx5_core_mr *__mlx5_mr_lookup(struct mlx5_core_dev *dev, u
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
@@ -552,6 +603,10 @@ void mlx5_init_qp_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev);
 int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 qpn,
+				u8 context, int error);
+#endif
 
 static inline const char *mlx5_qp_type_str(int type)
 {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
