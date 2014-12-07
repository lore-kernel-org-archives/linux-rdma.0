From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 15/16] IB/iser: DIX update
Date: Sun,  7 Dec 2014 16:10:06 +0200
Message-ID: <1417961407-10139-16-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Following few recent Block integrity updates, we align the
iSER data integrity offload settings with:

- Deprecate pi_guard module param
- Expose support for DIX type 0.
- Use scsi_transfer_length for the transfer length
- Get pi_interval, ref_tag, ref_remap, bg_type and
  check_mask setting from scsi_cmnd

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c  |   21 +++++-----
 drivers/infiniband/ulp/iser/iser_memory.c |   62 +++++++---------------------
 2 files changed, 26 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index a2dbd04..4dce90d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -97,7 +97,7 @@ module_param_named(pi_enable, iser_pi_enable, bool, 0644);
 MODULE_PARM_DESC(pi_enable, "Enable T10-PI offload support (default:disabled)");
 
 module_param_named(pi_guard, iser_pi_guard, int, 0644);
-MODULE_PARM_DESC(pi_guard, "T10-PI guard_type, 0:CRC|1:IP_CSUM (default:IP_CSUM)");
+MODULE_PARM_DESC(pi_guard, "T10-PI guard_type [deprecated]");
 
 static struct workqueue_struct *release_wq;
 struct iser_global ig;
@@ -574,12 +574,13 @@ iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 static inline unsigned int
 iser_dif_prot_caps(int prot_caps)
 {
-	return ((prot_caps & IB_PROT_T10DIF_TYPE_1) ? SHOST_DIF_TYPE1_PROTECTION |
-						      SHOST_DIX_TYPE1_PROTECTION : 0) |
-	       ((prot_caps & IB_PROT_T10DIF_TYPE_2) ? SHOST_DIF_TYPE2_PROTECTION |
-						      SHOST_DIX_TYPE2_PROTECTION : 0) |
-	       ((prot_caps & IB_PROT_T10DIF_TYPE_3) ? SHOST_DIF_TYPE3_PROTECTION |
-						      SHOST_DIX_TYPE3_PROTECTION : 0);
+	return ((prot_caps & IB_PROT_T10DIF_TYPE_1) ?
+		SHOST_DIF_TYPE1_PROTECTION | SHOST_DIX_TYPE0_PROTECTION |
+		SHOST_DIX_TYPE1_PROTECTION : 0) |
+	       ((prot_caps & IB_PROT_T10DIF_TYPE_2) ?
+		SHOST_DIF_TYPE2_PROTECTION | SHOST_DIX_TYPE2_PROTECTION : 0) |
+	       ((prot_caps & IB_PROT_T10DIF_TYPE_3) ?
+		SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE3_PROTECTION : 0);
 }
 
 /**
@@ -635,10 +636,8 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
 
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
-			if (iser_pi_guard)
-				scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP);
-			else
-				scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
+						   SHOST_DIX_GUARD_CRC);
 		}
 
 		if (iscsi_host_add(shost,
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index d832705..abce933 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -438,13 +438,13 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	return 0;
 }
 
-static inline void
+static void
 iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs,
 		    struct ib_sig_domain *domain)
 {
 	domain->sig_type = IB_SIG_TYPE_T10_DIF;
-	domain->sig.dif.pi_interval = sc->device->sector_size;
-	domain->sig.dif.ref_tag = scsi_get_lba(sc) & 0xffffffff;
+	domain->sig.dif.pi_interval = scsi_prot_interval(sc);
+	domain->sig.dif.ref_tag = scsi_prot_ref_tag(sc);
 	/*
 	 * At the moment we hard code those, but in the future
 	 * we will take them from sc.
@@ -452,8 +452,7 @@ iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs,
 	domain->sig.dif.apptag_check_mask = 0xffff;
 	domain->sig.dif.app_escape = true;
 	domain->sig.dif.ref_escape = true;
-	if (scsi_get_prot_type(sc) == SCSI_PROT_DIF_TYPE1 ||
-	    scsi_get_prot_type(sc) == SCSI_PROT_DIF_TYPE2)
+	if (sc->prot_flags & SCSI_PROT_REF_INCREMENT)
 		domain->sig.dif.ref_remap = true;
 };
 
@@ -471,26 +470,16 @@ iser_set_sig_attrs(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs)
 	case SCSI_PROT_WRITE_STRIP:
 		sig_attrs->wire.sig_type = IB_SIG_TYPE_NONE;
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->mem);
-		/*
-		 * At the moment we use this modparam to tell what is
-		 * the memory bg_type, in the future we will take it
-		 * from sc.
-		 */
-		sig_attrs->mem.sig.dif.bg_type = iser_pi_guard ? IB_T10DIF_CSUM :
-						 IB_T10DIF_CRC;
+		sig_attrs->mem.sig.dif.bg_type = sc->prot_flags & SCSI_PROT_IP_CHECKSUM ?
+						IB_T10DIF_CSUM : IB_T10DIF_CRC;
 		break;
 	case SCSI_PROT_READ_PASS:
 	case SCSI_PROT_WRITE_PASS:
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->wire);
 		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
 		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->mem);
-		/*
-		 * At the moment we use this modparam to tell what is
-		 * the memory bg_type, in the future we will take it
-		 * from sc.
-		 */
-		sig_attrs->mem.sig.dif.bg_type = iser_pi_guard ? IB_T10DIF_CSUM :
-						 IB_T10DIF_CRC;
+		sig_attrs->mem.sig.dif.bg_type = sc->prot_flags & SCSI_PROT_IP_CHECKSUM ?
+						IB_T10DIF_CSUM : IB_T10DIF_CRC;
 		break;
 	default:
 		iser_err("Unsupported PI operation %d\n",
@@ -501,26 +490,14 @@ iser_set_sig_attrs(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs)
 	return 0;
 }
 
-static int
+static inline void
 iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 {
-	switch (scsi_get_prot_type(sc)) {
-	case SCSI_PROT_DIF_TYPE0:
-		break;
-	case SCSI_PROT_DIF_TYPE1:
-	case SCSI_PROT_DIF_TYPE2:
-		*mask = ISER_CHECK_GUARD | ISER_CHECK_REFTAG;
-		break;
-	case SCSI_PROT_DIF_TYPE3:
-		*mask = ISER_CHECK_GUARD;
-		break;
-	default:
-		iser_err("Unsupported protection type %d\n",
-			 scsi_get_prot_type(sc));
-		return -EINVAL;
-	}
-
-	return 0;
+	*mask = 0;
+	if (sc->prot_flags & SCSI_PROT_REF_CHECK)
+		*mask |= ISER_CHECK_REFTAG;
+	if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
+		*mask |= ISER_CHECK_GUARD;
 }
 
 static void
@@ -554,9 +531,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	if (ret)
 		goto err;
 
-	ret = iser_set_prot_checks(iser_task->sc, &sig_attrs.check_mask);
-	if (ret)
-		goto err;
+	iser_set_prot_checks(iser_task->sc, &sig_attrs.check_mask);
 
 	if (!(desc->reg_indicators & ISER_SIG_KEY_VALID)) {
 		iser_inv_rkey(&inv_wr, pi_ctx->sig_mr);
@@ -590,12 +565,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 
 	sig_sge->lkey = pi_ctx->sig_mr->lkey;
 	sig_sge->addr = 0;
-	sig_sge->length = data_sge->length + prot_sge->length;
-	if (scsi_get_prot_op(iser_task->sc) == SCSI_PROT_WRITE_INSERT ||
-	    scsi_get_prot_op(iser_task->sc) == SCSI_PROT_READ_STRIP) {
-		sig_sge->length += (data_sge->length /
-				   iser_task->sc->device->sector_size) * 8;
-	}
+	sig_sge->length = scsi_transfer_length(iser_task->sc);
 
 	iser_dbg("sig_sge: addr: 0x%llx  length: %u lkey: 0x%x\n",
 		 sig_sge->addr, sig_sge->length,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
