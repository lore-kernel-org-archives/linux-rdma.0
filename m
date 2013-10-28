From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC v1 08/10] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Mon, 28 Oct 2013 16:26:14 +0200
Message-ID: <1382970376-13776-9-git-send-email-sagig@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382970376-13776-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch implements IB_WR_REG_SIG_MR posted by the user.

Baisically this WR involvs 3 WQEs in order to prepare and properly
register the signature layout:

1. post UMR WR to register the sig_mr in one of two possible ways:
    * In case the user registered a single MR for data so the UMR data segment
      consists of:
      - single klm (data MR) passed by the user
      - BSF with signature attributes requested by the user.
    * In case the user registered 2 MRs, one for data and one for protection,
      the UMR consists of:
      - strided block format which includes data and protection MRs and
        their repetitive block format.
      - BSF with signature attributes requested by the user.

2. post SET_PSV in order to set the for the memory domain initial
   signature parameters passed by the user.

3. post SET_PSV in order to set the for the wire domain initial
   signature parameters passed by the user.

This patch also introduces some helper functions to set the BSF correctly
and determining the signature format selectors.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c |  416 +++++++++++++++++++++++++++++++++++++++
 include/linux/mlx5/qp.h         |   56 ++++++
 2 files changed, 472 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ca78078..d791e41 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1719,6 +1719,26 @@ static __be64 frwr_mkey_mask(void)
 	return cpu_to_be64(result);
 }
 
+static __be64 sig_mkey_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_LEN		|
+		MLX5_MKEY_MASK_PAGE_SIZE	|
+		MLX5_MKEY_MASK_START_ADDR	|
+		MLX5_MKEY_MASK_EN_RINVAL	|
+		MLX5_MKEY_MASK_KEY		|
+		MLX5_MKEY_MASK_LR		|
+		MLX5_MKEY_MASK_LW		|
+		MLX5_MKEY_MASK_RR		|
+		MLX5_MKEY_MASK_RW		|
+		MLX5_MKEY_MASK_SMALL_FENCE	|
+		MLX5_MKEY_MASK_FREE		|
+		MLX5_MKEY_MASK_BSF_EN;
+
+	return cpu_to_be64(result);
+}
+
 static void set_frwr_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 				 struct ib_send_wr *wr, int li)
 {
@@ -1901,6 +1921,339 @@ static int set_data_inl_seg(struct mlx5_ib_qp *qp, struct ib_send_wr *wr,
 	return 0;
 }
 
+static u16 prot_field_size(enum ib_signature_type type, u16 block_size)
+{
+	switch (type) {
+	case IB_SIG_TYPE_T10_DIF:
+		return MLX5_DIF_SIZE;
+	default:
+		return 0;
+	}
+}
+
+static u8 bs_selector(int block_size)
+{
+	switch (block_size) {
+	case 512:	    return 0x1;
+	case 520:	    return 0x2;
+	case 4096:	    return 0x3;
+	case 4160:	    return 0x4;
+	case 1073741824:    return 0x5;
+	default:	    return 0;
+	}
+}
+
+static int format_selector(struct ib_sig_attrs *attr,
+			   struct ib_sig_domain *domain,
+			   int *selector)
+{
+
+#define FORMAT_DIF_NONE		0
+#define FORMAT_DIF_CRC_INC	4
+#define FORMAT_DIF_CSUM_INC	12
+#define FORMAT_DIF_CRC_NO_INC	13
+#define FORMAT_DIF_CSUM_NO_INC	14
+
+	switch (domain->sig.dif.type) {
+	case IB_T10DIF_NONE:
+		/* No DIF */
+		*selector = FORMAT_DIF_NONE;
+		break;
+	case IB_T10DIF_TYPE1: /* Fall through */
+	case IB_T10DIF_TYPE2:
+		switch (domain->sig.dif.bg_type) {
+		case IB_T10DIF_CRC:
+			*selector = FORMAT_DIF_CRC_INC;
+			break;
+		case IB_T10DIF_CSUM:
+			*selector = FORMAT_DIF_CSUM_INC;
+			break;
+		default:
+			return 1;
+		}
+		break;
+	case IB_T10DIF_TYPE3:
+		switch (domain->sig.dif.bg_type) {
+		case IB_T10DIF_CRC:
+			*selector = domain->sig.dif.type3_inc_reftag ?
+					   FORMAT_DIF_CRC_INC :
+					   FORMAT_DIF_CRC_NO_INC;
+			break;
+		case IB_T10DIF_CSUM:
+			*selector = domain->sig.dif.type3_inc_reftag ?
+					   FORMAT_DIF_CSUM_INC :
+					   FORMAT_DIF_CSUM_NO_INC;
+			break;
+		default:
+			return 1;
+		}
+		break;
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static int mlx5_set_bsf(struct ib_mr *sig_mr,
+			struct ib_sig_attrs *sig_attrs,
+			struct mlx5_bsf *bsf, u32 data_size)
+{
+	struct mlx5_core_sig_ctx *msig = to_mmr(sig_mr)->sig;
+	struct mlx5_bsf_basic *basic = &bsf->basic;
+	struct ib_sig_domain *mem = &sig_attrs->mem;
+	struct ib_sig_domain *wire = &sig_attrs->wire;
+	int ret, selector;
+
+	switch (sig_attrs->mem.sig_type) {
+	case IB_SIG_TYPE_T10_DIF:
+		if (sig_attrs->wire.sig_type != IB_SIG_TYPE_T10_DIF)
+			return -EINVAL;
+
+		/* Input domain check byte mask */
+		basic->check_byte_mask = sig_attrs->check_mask;
+		if (mem->sig.dif.block_size == wire->sig.dif.block_size &&
+		    mem->sig.dif.type == wire->sig.dif.type) {
+			/* Same block structure */
+			basic->bsf_size_sbs = 1 << 4;
+			if (mem->sig.dif.bg_type == wire->sig.dif.bg_type)
+				basic->wire.copy_byte_mask = 0xff;
+			else
+				basic->wire.copy_byte_mask = 0x3f;
+		} else
+			basic->wire.bs_selector = bs_selector(wire->sig.dif.block_size);
+
+		basic->mem.bs_selector = bs_selector(mem->sig.dif.block_size);
+		basic->raw_data_size = cpu_to_be32(data_size);
+
+		ret = format_selector(sig_attrs, mem, &selector);
+		if (ret)
+			return -EINVAL;
+		basic->m_bfs_psv = cpu_to_be32(selector << 24 |
+					       msig->psv_memory.psv_idx);
+
+		ret = format_selector(sig_attrs, wire, &selector);
+		if (ret)
+			return -EINVAL;
+		basic->w_bfs_psv = cpu_to_be32(selector << 24 |
+					       msig->psv_wire.psv_idx);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int set_sig_data_segment(struct ib_send_wr *wr, void **seg, int *size)
+{
+	struct ib_sig_attrs *sig_attrs = wr->wr.sig_handover.sig_attrs;
+	struct ib_mr *sig_mr = wr->wr.sig_handover.sig_mr;
+	struct ib_mr *data_mr = wr->wr.sig_handover.data_mr;
+	struct mlx5_bsf *bsf;
+	u32 data_size = wr->wr.sig_handover.data_size;
+	u64 data_va = wr->wr.sig_handover.data_va;
+	int ret;
+	int wqe_size;
+
+	if (!wr->wr.sig_handover.prot_mr) {
+		/**
+		 * Source domain doesn't contain signature information
+		 * So need construct:
+		 * 		    ------------------
+		 * 		   |     data_klm     |
+		 * 		    ------------------
+		 * 		   |       BSF        |
+		 * 		    ------------------
+		 **/
+		struct mlx5_klm *data_klm = *seg;
+
+		data_klm->bcount = cpu_to_be32(data_size);
+		data_klm->key = cpu_to_be32(data_mr->lkey);
+		data_klm->va = cpu_to_be64(data_va);
+		wqe_size = ALIGN(sizeof(*data_klm), 64);
+	} else {
+		/**
+		 * Source domain contains signature information
+		 * So need construct a strided block format:
+		 * 		 ---------------------------
+		 * 		|     stride_block_ctrl	    |
+		 * 		 ---------------------------
+		 * 		|          data_klm	    |
+		 * 		 ---------------------------
+		 * 		|          prot_klm	    |
+		 * 		 ---------------------------
+		 * 		|             BSF           |
+		 * 		 ---------------------------
+		 **/
+		struct ib_mr *prot_mr = wr->wr.sig_handover.prot_mr;
+		struct mlx5_stride_block_ctrl_seg *sblock_ctrl;
+		struct mlx5_stride_block_entry *data_sentry;
+		struct mlx5_stride_block_entry *prot_sentry;
+		u64 prot_va = wr->wr.sig_handover.prot_va;
+		u16 block_size = sig_attrs->mem.sig.dif.block_size;
+		int prot_size;
+
+		sblock_ctrl = *seg;
+		data_sentry = (void *)sblock_ctrl + sizeof(*sblock_ctrl);
+		prot_sentry = (void *)data_sentry + sizeof(*data_sentry);
+
+		prot_size = prot_field_size(sig_attrs->mem.sig_type,
+					    block_size);
+		if (!prot_size) {
+			pr_err("Bad block size given: %u\n", block_size);
+			return -EINVAL;
+		}
+		sblock_ctrl->bcount_per_cycle = cpu_to_be32(block_size +
+							    prot_size);
+		sblock_ctrl->op = cpu_to_be32(MLX5_STRIDE_BLOCK_OP);
+		sblock_ctrl->repeat_count = cpu_to_be32(data_size / block_size);
+		sblock_ctrl->num_entries = cpu_to_be16(2);
+
+		data_sentry->bcount = cpu_to_be16(block_size);
+		data_sentry->key = cpu_to_be32(data_mr->lkey);
+		data_sentry->va = cpu_to_be64(data_va);
+		prot_sentry->bcount = cpu_to_be16(prot_size);
+		prot_sentry->key = cpu_to_be32(prot_mr->lkey);
+
+		if (prot_mr == data_mr && prot_va == data_va) {
+			/**
+			 * The data and protection are interleaved
+			 * in a single memory region
+			 **/
+			prot_sentry->va = cpu_to_be64(data_va + block_size);
+			prot_sentry->stride = sblock_ctrl->bcount_per_cycle;
+			data_sentry->stride = prot_sentry->stride;
+		} else {
+			/* The data and protection are two different buffers */
+			prot_sentry->va = cpu_to_be64(prot_va);
+			data_sentry->stride = cpu_to_be16(block_size);
+			prot_sentry->stride = cpu_to_be16(prot_size);
+		}
+		wqe_size = ALIGN(sizeof(*sblock_ctrl) + sizeof(*data_sentry) +
+				 sizeof(*prot_sentry), 64);
+	}
+
+	bsf = *seg + wqe_size;
+	ret = mlx5_set_bsf(sig_mr, sig_attrs, bsf, data_size);
+	if (ret)
+		return -EINVAL;
+
+	*seg = (void *)bsf + ALIGN(sizeof(*bsf), 64);
+	*size += (wqe_size + sizeof(*bsf)) / 16;
+
+	return 0;
+}
+
+static void set_sig_mkey_segment(struct mlx5_mkey_seg *seg,
+				 struct ib_send_wr *wr, u32 nelements,
+				 u32 length, u32 pdn)
+{
+	struct ib_mr *sig_mr = wr->wr.sig_handover.sig_mr;
+	u32 sig_key = sig_mr->rkey;
+
+	memset(seg, 0, sizeof(*seg));
+
+	seg->status = 0x4; /*set free*/
+	seg->flags = get_umr_flags(wr->wr.sig_handover.access_flags) |
+				   MLX5_ACCESS_MODE_KLM;
+	seg->qpn_mkey7_0 = cpu_to_be32((sig_key & 0xff) | 0xffffff00);
+	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL |
+				    MLX5_MKEY_BSF_EN | pdn);
+	seg->start_addr = 0;
+	seg->len = cpu_to_be64(length);
+	seg->xlt_oct_size = cpu_to_be32(be16_to_cpu(get_klm_octo(nelements)));
+	seg->bsfs_octo_size = cpu_to_be32(MLX5_MKEY_BSF_OCTO_SIZE);
+}
+
+static void set_sig_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
+				struct ib_send_wr *wr, u32 nelements)
+{
+	memset(umr, 0, sizeof(*umr));
+
+	umr->flags = 1 << 7 | 1 << 5; /* inline | check free */
+	umr->klm_octowords = get_klm_octo(nelements);
+	umr->bsf_octowords = cpu_to_be16(MLX5_MKEY_BSF_OCTO_SIZE);
+	umr->mkey_mask = sig_mkey_mask();
+}
+
+
+static int set_sig_umr_wr(struct ib_send_wr *wr, struct mlx5_ib_qp *qp,
+			  void **seg, int *size)
+{
+	struct mlx5_ib_mr *sig_mr = to_mmr(wr->wr.sig_handover.sig_mr);
+	u32 pdn = get_pd(qp)->pdn;
+	u32 klm_oct_size;
+	int region_len, ret;
+
+	if (unlikely(wr->wr.sig_handover.access_flags &
+		     IB_ACCESS_REMOTE_ATOMIC) ||
+	    unlikely(!sig_mr->sig) || unlikely(!qp->signature_en))
+		return -EINVAL;
+
+	/* length of the protected region, data + protection */
+	region_len = wr->wr.sig_handover.data_size;
+	if (wr->wr.sig_handover.data_mr == wr->wr.sig_handover.prot_mr &&
+	    wr->wr.sig_handover.data_va == wr->wr.sig_handover.prot_va)
+		region_len = wr->wr.sig_handover.data_size;
+	else
+		region_len = wr->wr.sig_handover.data_size +
+			     wr->wr.sig_handover.prot_size;
+
+	/**
+	 * KLM octoword size - if protection was provided
+	 * then we use strided block format (3 octowords),
+	 * else we use single KLM (1 octoword)
+	 **/
+	klm_oct_size = wr->wr.sig_handover.prot_mr ? 3 : 1;
+
+	set_sig_umr_segment(*seg, wr, klm_oct_size);
+	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
+	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	set_sig_mkey_segment(*seg, wr, klm_oct_size, region_len, pdn);
+	*seg += sizeof(struct mlx5_mkey_seg);
+	*size += sizeof(struct mlx5_mkey_seg) / 16;
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	ret = set_sig_data_segment(wr, seg, size);
+	if (ret)
+		return ret;
+
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	return 0;
+}
+
+static int set_psv_wr(struct ib_sig_domain *domain,
+		      u32 psv_idx, void **seg, int *size)
+{
+	struct mlx5_seg_set_psv *psv_seg = *seg;
+
+	psv_seg->psv_num = cpu_to_be32(psv_idx);
+	switch (domain->sig_type) {
+	case IB_SIG_TYPE_T10_DIF:
+		psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
+						     domain->sig.dif.app_tag);
+		psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
+
+		*seg += sizeof(*psv_seg);
+		*size += sizeof(*psv_seg) / 16;
+		break;
+
+	default:
+		pr_err("Bad signature type given.\n");
+		return 1;
+	}
+
+	return 0;
+}
+
 static int set_frwr_li_wr(void **seg, struct ib_send_wr *wr, int *size,
 			  struct mlx5_core_dev *mdev, struct mlx5_ib_pd *pd, struct mlx5_ib_qp *qp)
 {
@@ -2042,6 +2395,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx5_core_dev *mdev = &dev->mdev;
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
+	struct mlx5_ib_mr *mr;
 	struct mlx5_wqe_data_seg *dpseg;
 	struct mlx5_wqe_xrc_seg *xrc;
 	struct mlx5_bf *bf = qp->bf;
@@ -2154,6 +2508,67 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				num_sge = 0;
 				break;
 
+			case IB_WR_REG_SIG_MR:
+				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
+				qp->sq.wr_data[idx] = IB_WR_REG_SIG_MR;
+				mr = to_mmr(wr->wr.sig_handover.sig_mr);
+
+				ctrl->imm = cpu_to_be32(mr->ibmr.rkey);
+				err = set_sig_umr_wr(wr, qp, &seg, &size);
+				if (err) {
+					mlx5_ib_warn(dev, "\n");
+					*bad_wr = wr;
+					goto out;
+				}
+
+				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
+					   &nreq, get_fence(fence, wr),
+					   next_fence, MLX5_OPCODE_UMR);
+				err = begin_wqe(qp, &seg, &ctrl, wr,
+						&idx, &size, nreq);
+				if (err) {
+						mlx5_ib_warn(dev, "\n");
+						err = -ENOMEM;
+						*bad_wr = wr;
+						goto out;
+				}
+
+				err = set_psv_wr(&wr->wr.sig_handover.sig_attrs->mem,
+						 mr->sig->psv_memory.psv_idx, &seg,
+						 &size);
+				if (err) {
+					mlx5_ib_warn(dev, "\n");
+					*bad_wr = wr;
+					goto out;
+				}
+
+				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
+					   &nreq, get_fence(fence, wr),
+					   next_fence, MLX5_OPCODE_SET_PSV);
+				err = begin_wqe(qp, &seg, &ctrl, wr,
+						&idx, &size, nreq);
+				if (err) {
+						mlx5_ib_warn(dev, "\n");
+						err = -ENOMEM;
+						*bad_wr = wr;
+						goto out;
+				}
+
+				err = set_psv_wr(&wr->wr.sig_handover.sig_attrs->wire,
+						 mr->sig->psv_wire.psv_idx, &seg,
+						 &size);
+				if (err) {
+					mlx5_ib_warn(dev, "\n");
+					*bad_wr = wr;
+					goto out;
+				}
+
+				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
+					   &nreq, get_fence(fence, wr),
+					   next_fence, MLX5_OPCODE_SET_PSV);
+				num_sge = 0;
+				goto skip_psv;
+
 			default:
 				break;
 			}
@@ -2237,6 +2652,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		finish_wqe(qp, ctrl, size, idx, wr->wr_id,&nreq,
 			   get_fence(fence, wr), next_fence,
 			   mlx5_ib_opcode[wr->opcode]);
+skip_psv:
 		if (0)
 			dump_wqe(qp, idx, size);
 	}
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 174805c..9ea6cf6 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -38,6 +38,8 @@
 
 #define MLX5_INVALID_LKEY	0x100
 #define MLX5_SIGNATURE_SQ_MULT	3
+#define MLX5_DIF_SIZE		8
+#define MLX5_STRIDE_BLOCK_OP	0x400
 
 enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
@@ -279,6 +281,60 @@ struct mlx5_wqe_inline_seg {
 	__be32	byte_count;
 };
 
+struct mlx5_bsf {
+	struct mlx5_bsf_basic {
+		u8		bsf_size_sbs;
+		u8		check_byte_mask;
+		union {
+			u8	copy_byte_mask;
+			u8	bs_selector;
+			u8	rsvd_wflags;
+		} wire;
+		union {
+			u8	bs_selector;
+			u8	rsvd_mflags;
+		} mem;
+		__be32		raw_data_size;
+		__be32		w_bfs_psv;
+		__be32		m_bfs_psv;
+	} basic;
+	struct mlx5_bsf_ext {
+		__be32		t_init_gen_pro_size;
+		__be32		rsvd_epi_size;
+		__be32		w_tfs_psv;
+		__be32		m_tfs_psv;
+	} ext;
+	struct mlx5_bsf_inl {
+		__be32		w_inl_vld;
+		__be32		w_rsvd;
+		__be64		w_block_format;
+		__be32		m_inl_vld;
+		__be32		m_rsvd;
+		__be64		m_block_format;
+	} inl;
+};
+
+struct mlx5_klm {
+	__be32		bcount;
+	__be32		key;
+	__be64		va;
+};
+
+struct mlx5_stride_block_entry {
+	__be16		stride;
+	__be16		bcount;
+	__be32		key;
+	__be64		va;
+};
+
+struct mlx5_stride_block_ctrl_seg {
+	__be32		bcount_per_cycle;
+	__be32		op;
+	__be32		repeat_count;
+	u16		rsvd;
+	__be16		num_entries;
+};
+
 struct mlx5_core_qp {
 	void (*event)		(struct mlx5_core_qp *, int);
 	int			qpn;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
