From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 7/7] IB/mlx5, iser, isert: Add Signature API additions
Date: Wed, 13 Aug 2014 19:54:35 +0300
Message-ID: <1407948875-733-8-git-send-email-sagig@mellanox.com>
References: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407948875-733-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Expose more signature setting parameters. We modify the signature
API to allow usage of some new execution parameters relevant to
data integrity feature.

This patch modifies ib_sig_domain structure by:
- Deprecate DIF type in signature API (operation will
  be determined by the parameters alone, no DIF type awareness)
- Add APPTAG check bitmask (for input domain)
- Add REFTAG remap (increment) flag for each domain
- Add APPTAG/REFTAG escape options for each domain

The mlx5 driver is modified to follow the new parameters in
HW signature setup.

At the moment the callers (iser/isert) hard-code new parameters
(by DIF type). In the future, callers will retrieve them from the
scsi command structure.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c           |  104 ++++++++++++----------------
 drivers/infiniband/ulp/iser/iser_memory.c |   50 +++++++-------
 drivers/infiniband/ulp/isert/ib_isert.c   |   40 ++++-------
 include/rdma/ib_verbs.h                   |   32 ++++-----
 4 files changed, 97 insertions(+), 129 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8377816..b71c2bc 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2020,50 +2020,31 @@ static u8 bs_selector(int block_size)
 	}
 }
 
-static int mlx5_fill_inl_bsf(struct ib_sig_domain *domain,
-			     struct mlx5_bsf_inl *inl)
+static void mlx5_fill_inl_bsf(struct ib_sig_domain *domain,
+			      struct mlx5_bsf_inl *inl)
 {
 	/* Valid inline section and allow BSF refresh */
 	inl->vld_refresh = cpu_to_be16(MLX5_BSF_INL_VALID |
 				       MLX5_BSF_REFRESH_DIF);
 	inl->dif_apptag = cpu_to_be16(domain->sig.dif.app_tag);
 	inl->dif_reftag = cpu_to_be32(domain->sig.dif.ref_tag);
+	/* repeating block */
+	inl->rp_inv_seed = MLX5_BSF_REPEAT_BLOCK;
+	inl->sig_type = domain->sig.dif.bg_type == IB_T10DIF_CRC ?
+			MLX5_DIF_CRC : MLX5_DIF_IPCS;
 
-	switch (domain->sig.dif.type) {
-	case IB_T10DIF_NONE:
-		/* No DIF */
-		break;
-	case IB_T10DIF_TYPE1: /* Fall through */
-	case IB_T10DIF_TYPE2:
-		inl->sig_type = domain->sig.dif.bg_type == IB_T10DIF_CRC ?
-				MLX5_DIF_CRC : MLX5_DIF_IPCS;
-		/*
-		 * increment reftag and don't check if
-		 * apptag=0xffff and reftag=0xffffffff
-		 */
-		inl->dif_inc_ref_guard_check = MLX5_BSF_INC_REFTAG |
-					       MLX5_BSF_APPREF_ESCAPE;
-		inl->dif_app_bitmask_check = 0xffff;
-		/* repeating block */
-		inl->rp_inv_seed = MLX5_BSF_REPEAT_BLOCK;
-		break;
-	case IB_T10DIF_TYPE3:
-		inl->sig_type = domain->sig.dif.bg_type == IB_T10DIF_CRC ?
-				MLX5_DIF_CRC : MLX5_DIF_IPCS;
-		/*
-		 * Don't inc reftag and don't check if
-		 * apptag=0xffff and reftag=0xffffffff
-		 */
-		inl->dif_inc_ref_guard_check = MLX5_BSF_APPREF_ESCAPE;
-		inl->dif_app_bitmask_check = 0xffff;
-		/* Repeating block */
-		inl->rp_inv_seed = MLX5_BSF_REPEAT_BLOCK;
-		break;
-	default:
-		return -EINVAL;
+	if (domain->sig.dif.ref_remap)
+		inl->dif_inc_ref_guard_check |= MLX5_BSF_INC_REFTAG;
+
+	if (domain->sig.dif.app_escape) {
+		if (domain->sig.dif.ref_escape)
+			inl->dif_inc_ref_guard_check |= MLX5_BSF_APPREF_ESCAPE;
+		else
+			inl->dif_inc_ref_guard_check |= MLX5_BSF_APPTAG_ESCAPE;
 	}
 
-	return 0;
+	inl->dif_app_bitmask_check =
+		cpu_to_be16(domain->sig.dif.apptag_check_mask);
 }
 
 static int mlx5_set_bsf(struct ib_mr *sig_mr,
@@ -2074,20 +2055,35 @@ static int mlx5_set_bsf(struct ib_mr *sig_mr,
 	struct mlx5_bsf_basic *basic = &bsf->basic;
 	struct ib_sig_domain *mem = &sig_attrs->mem;
 	struct ib_sig_domain *wire = &sig_attrs->wire;
-	int ret;
 
 	memset(bsf, 0, sizeof(*bsf));
+
+	/* Basic + Extended + Inline */
+	basic->bsf_size_sbs = 1 << 7;
+	/* Input domain check byte mask */
+	basic->check_byte_mask = sig_attrs->check_mask;
+	basic->raw_data_size = cpu_to_be32(data_size);
+
+	/* Memory domain */
 	switch (sig_attrs->mem.sig_type) {
+	case IB_SIG_TYPE_NONE:
+		break;
 	case IB_SIG_TYPE_T10_DIF:
-		if (sig_attrs->wire.sig_type != IB_SIG_TYPE_T10_DIF)
-			return -EINVAL;
+		basic->mem.bs_selector = bs_selector(mem->sig.dif.pi_interval);
+		basic->m_bfs_psv = cpu_to_be32(msig->psv_memory.psv_idx);
+		mlx5_fill_inl_bsf(mem, &bsf->m_inl);
+		break;
+	default:
+		return -EINVAL;
+	}
 
-		/* Basic + Extended + Inline */
-		basic->bsf_size_sbs = 1 << 7;
-		/* Input domain check byte mask */
-		basic->check_byte_mask = sig_attrs->check_mask;
+	/* Wire domain */
+	switch (sig_attrs->wire.sig_type) {
+	case IB_SIG_TYPE_NONE:
+		break;
+	case IB_SIG_TYPE_T10_DIF:
 		if (mem->sig.dif.pi_interval == wire->sig.dif.pi_interval &&
-		    mem->sig.dif.type == wire->sig.dif.type) {
+		    mem->sig_type == wire->sig_type) {
 			/* Same block structure */
 			basic->bsf_size_sbs |= 1 << 4;
 			if (mem->sig.dif.bg_type == wire->sig.dif.bg_type)
@@ -2099,20 +2095,9 @@ static int mlx5_set_bsf(struct ib_mr *sig_mr,
 		} else
 			basic->wire.bs_selector = bs_selector(wire->sig.dif.pi_interval);
 
-		basic->mem.bs_selector = bs_selector(mem->sig.dif.pi_interval);
-		basic->raw_data_size = cpu_to_be32(data_size);
-		basic->m_bfs_psv = cpu_to_be32(msig->psv_memory.psv_idx);
 		basic->w_bfs_psv = cpu_to_be32(msig->psv_wire.psv_idx);
-
-		ret = mlx5_fill_inl_bsf(wire, &bsf->w_inl);
-		if (ret)
-			return -EINVAL;
-
-		ret = mlx5_fill_inl_bsf(mem, &bsf->m_inl);
-		if (ret)
-			return -EINVAL;
+		mlx5_fill_inl_bsf(wire, &bsf->w_inl);
 		break;
-
 	default:
 		return -EINVAL;
 	}
@@ -2311,20 +2296,21 @@ static int set_psv_wr(struct ib_sig_domain *domain,
 	memset(psv_seg, 0, sizeof(*psv_seg));
 	psv_seg->psv_num = cpu_to_be32(psv_idx);
 	switch (domain->sig_type) {
+	case IB_SIG_TYPE_NONE:
+		break;
 	case IB_SIG_TYPE_T10_DIF:
 		psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
 						     domain->sig.dif.app_tag);
 		psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
-
-		*seg += sizeof(*psv_seg);
-		*size += sizeof(*psv_seg) / 16;
 		break;
-
 	default:
 		pr_err("Bad signature type given.\n");
 		return 1;
 	}
 
+	*seg += sizeof(*psv_seg);
+	*size += sizeof(*psv_seg) / 16;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 5842d50..df65309 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -440,51 +440,44 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	return 0;
 }
 
-static inline enum ib_t10_dif_type
-scsi2ib_prot_type(unsigned char prot_type)
-{
-	switch (prot_type) {
-	case SCSI_PROT_DIF_TYPE0:
-		return IB_T10DIF_NONE;
-	case SCSI_PROT_DIF_TYPE1:
-		return IB_T10DIF_TYPE1;
-	case SCSI_PROT_DIF_TYPE2:
-		return IB_T10DIF_TYPE2;
-	case SCSI_PROT_DIF_TYPE3:
-		return IB_T10DIF_TYPE3;
-	default:
-		return IB_T10DIF_NONE;
-	}
-}
-
 static inline void
 iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs,
 		    struct ib_sig_domain *domain)
 {
-	unsigned char scsi_ptype = scsi_get_prot_type(sc);
-
-	domain->sig.dif.type = scsi2ib_prot_type(scsi_ptype);
+	domain->sig_type = IB_SIG_TYPE_T10_DIF;
 	domain->sig.dif.pi_interval = sc->device->sector_size;
 	domain->sig.dif.ref_tag = scsi_get_lba(sc) & 0xffffffff;
+	/*
+	 * At the moment we hard code those, but in the future
+	 * we will take them from sc.
+	 */
+	domain->sig.dif.apptag_check_mask = 0xffff;
+	domain->sig.dif.app_escape = true;
+	domain->sig.dif.ref_escape = true;
+	if (scsi_get_prot_type(sc) == SCSI_PROT_DIF_TYPE1 ||
+	    scsi_get_prot_type(sc) == SCSI_PROT_DIF_TYPE2)
+		domain->sig.dif.ref_remap = true;
 };
 
 static int
 iser_set_sig_attrs(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs)
 {
-	sig_attrs->mem.sig_type = IB_SIG_TYPE_T10_DIF;
-	sig_attrs->wire.sig_type = IB_SIG_TYPE_T10_DIF;
-
 	switch (scsi_get_prot_op(sc)) {
 	case SCSI_PROT_WRITE_INSERT:
 	case SCSI_PROT_READ_STRIP:
-		sig_attrs->mem.sig.dif.type = IB_T10DIF_NONE;
+		sig_attrs->mem.sig_type = IB_SIG_TYPE_NONE;
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->wire);
 		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
 		break;
 	case SCSI_PROT_READ_INSERT:
 	case SCSI_PROT_WRITE_STRIP:
-		sig_attrs->wire.sig.dif.type = IB_T10DIF_NONE;
+		sig_attrs->wire.sig_type = IB_SIG_TYPE_NONE;
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->mem);
+		/*
+		 * At the moment we use this modparam to tell what is
+		 * the memory bg_type, in the future we will take it
+		 * from sc.
+		 */
 		sig_attrs->mem.sig.dif.bg_type = iser_pi_guard ? IB_T10DIF_CSUM :
 						 IB_T10DIF_CRC;
 		break;
@@ -493,6 +486,11 @@ iser_set_sig_attrs(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs)
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->wire);
 		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->mem);
+		/*
+		 * At the moment we use this modparam to tell what is
+		 * the memory bg_type, in the future we will take it
+		 * from sc.
+		 */
 		sig_attrs->mem.sig.dif.bg_type = iser_pi_guard ? IB_T10DIF_CSUM :
 						 IB_T10DIF_CRC;
 		break;
@@ -501,10 +499,10 @@ iser_set_sig_attrs(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs)
 			 scsi_get_prot_op(sc));
 		return -EINVAL;
 	}
+
 	return 0;
 }
 
-
 static int
 iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 {
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 7309275..0bea577 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2609,51 +2609,39 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	return ret;
 }
 
-static inline enum ib_t10_dif_type
-se2ib_prot_type(enum target_prot_type prot_type)
-{
-	switch (prot_type) {
-	case TARGET_DIF_TYPE0_PROT:
-		return IB_T10DIF_NONE;
-	case TARGET_DIF_TYPE1_PROT:
-		return IB_T10DIF_TYPE1;
-	case TARGET_DIF_TYPE2_PROT:
-		return IB_T10DIF_TYPE2;
-	case TARGET_DIF_TYPE3_PROT:
-		return IB_T10DIF_TYPE3;
-	default:
-		return IB_T10DIF_NONE;
-	}
-}
-
 static inline void
 isert_set_dif_domain(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs,
 		     struct ib_sig_domain *domain)
 {
-	enum ib_t10_dif_type ib_prot_type = se2ib_prot_type(se_cmd->prot_type);
-
-	domain->sig.dif.type = ib_prot_type;
+	domain->sig_type = IB_SIG_TYPE_T10_DIF;
 	domain->sig.dif.bg_type = IB_T10DIF_CRC;
 	domain->sig.dif.pi_interval = se_cmd->se_dev->dev_attrib.block_size;
 	domain->sig.dif.ref_tag = se_cmd->reftag_seed;
+	/*
+	 * At the moment we hard code those, but if in the future
+	 * the target core would like to use it, we will take it
+	 * from se_cmd.
+	 */
+	domain->sig.dif.apptag_check_mask = 0xffff;
+	domain->sig.dif.app_escape = true;
+	domain->sig.dif.ref_escape = true;
+	if (se_cmd->prot_type == TARGET_DIF_TYPE1_PROT ||
+	    se_cmd->prot_type == TARGET_DIF_TYPE2_PROT)
+		domain->sig.dif.ref_remap = true;
 };
 
 static int
 isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
 {
-
-	sig_attrs->mem.sig_type = IB_SIG_TYPE_T10_DIF;
-	sig_attrs->wire.sig_type = IB_SIG_TYPE_T10_DIF;
-
 	switch (se_cmd->prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
-		sig_attrs->mem.sig.dif.type = IB_T10DIF_NONE;
+		sig_attrs->mem.sig_type = IB_SIG_TYPE_NONE;
 		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->wire);
 		break;
 	case TARGET_PROT_DOUT_INSERT:
 	case TARGET_PROT_DIN_STRIP:
-		sig_attrs->wire.sig.dif.type = IB_T10DIF_NONE;
+		sig_attrs->wire.sig_type = IB_SIG_TYPE_NONE;
 		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->mem);
 		break;
 	case TARGET_PROT_DIN_PASS:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7ccef34..d3e2462 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -491,20 +491,14 @@ struct ib_mr_init_attr {
 	u32	    flags;
 };
 
-enum ib_signature_type {
-	IB_SIG_TYPE_T10_DIF,
-};
-
 /**
- * T10-DIF Signature types
- * T10-DIF types are defined by SCSI
- * specifications.
+ * Signature types
+ * IB_SIG_TYPE_NONE: Unprotected.
+ * IB_SIG_TYPE_T10_DIF: Type T10-DIF
  */
-enum ib_t10_dif_type {
-	IB_T10DIF_NONE,
-	IB_T10DIF_TYPE1,
-	IB_T10DIF_TYPE2,
-	IB_T10DIF_TYPE3
+enum ib_signature_type {
+	IB_SIG_TYPE_NONE,
+	IB_SIG_TYPE_T10_DIF,
 };
 
 /**
@@ -520,24 +514,26 @@ enum ib_t10_dif_bg_type {
 /**
  * struct ib_t10_dif_domain - Parameters specific for T10-DIF
  *     domain.
- * @type: T10-DIF type (0|1|2|3)
  * @bg_type: T10-DIF block guard type (CRC|CSUM)
  * @pi_interval: protection information interval.
  * @bg: seed of guard computation.
  * @app_tag: application tag of guard block
  * @ref_tag: initial guard block reference tag.
- * @type3_inc_reftag: T10-DIF type 3 does not state
- *     about the reference tag, it is the user
- *     choice to increment it or not.
+ * @ref_remap: Indicate wethear the reftag increments each block
+ * @app_escape: Indicate to skip block check if apptag=0xffff
+ * @ref_escape: Indicate to skip block check if reftag=0xffffffff
+ * @apptag_check_mask: check bitmask of application tag.
  */
 struct ib_t10_dif_domain {
-	enum ib_t10_dif_type	type;
 	enum ib_t10_dif_bg_type bg_type;
 	u16			pi_interval;
 	u16			bg;
 	u16			app_tag;
 	u32			ref_tag;
-	bool			type3_inc_reftag;
+	bool			ref_remap;
+	bool			app_escape;
+	bool			ref_escape;
+	u16			apptag_check_mask;
 };
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
