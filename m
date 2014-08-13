From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/7] Target/iser: Centralize ib_sig_domain setting
Date: Wed, 13 Aug 2014 19:54:34 +0300
Message-ID: <1407948875-733-7-git-send-email-sagig@mellanox.com>
References: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407948875-733-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Later there will be more parameters to set, so
we want to do it in a centralized place.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   33 +++++++++++++++----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index da8ff12..7309275 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2626,41 +2626,40 @@ se2ib_prot_type(enum target_prot_type prot_type)
 	}
 }
 
+static inline void
+isert_set_dif_domain(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs,
+		     struct ib_sig_domain *domain)
+{
+	enum ib_t10_dif_type ib_prot_type = se2ib_prot_type(se_cmd->prot_type);
+
+	domain->sig.dif.type = ib_prot_type;
+	domain->sig.dif.bg_type = IB_T10DIF_CRC;
+	domain->sig.dif.pi_interval = se_cmd->se_dev->dev_attrib.block_size;
+	domain->sig.dif.ref_tag = se_cmd->reftag_seed;
+};
+
 static int
 isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
 {
-	enum ib_t10_dif_type ib_prot_type = se2ib_prot_type(se_cmd->prot_type);
 
 	sig_attrs->mem.sig_type = IB_SIG_TYPE_T10_DIF;
 	sig_attrs->wire.sig_type = IB_SIG_TYPE_T10_DIF;
-	sig_attrs->mem.sig.dif.pi_interval =
-				se_cmd->se_dev->dev_attrib.block_size;
-	sig_attrs->wire.sig.dif.pi_interval =
-				se_cmd->se_dev->dev_attrib.block_size;
 
 	switch (se_cmd->prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
 		sig_attrs->mem.sig.dif.type = IB_T10DIF_NONE;
-		sig_attrs->wire.sig.dif.type = ib_prot_type;
-		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->wire.sig.dif.ref_tag = se_cmd->reftag_seed;
+		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->wire);
 		break;
 	case TARGET_PROT_DOUT_INSERT:
 	case TARGET_PROT_DIN_STRIP:
-		sig_attrs->mem.sig.dif.type = ib_prot_type;
-		sig_attrs->mem.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->mem.sig.dif.ref_tag = se_cmd->reftag_seed;
 		sig_attrs->wire.sig.dif.type = IB_T10DIF_NONE;
+		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->mem);
 		break;
 	case TARGET_PROT_DIN_PASS:
 	case TARGET_PROT_DOUT_PASS:
-		sig_attrs->mem.sig.dif.type = ib_prot_type;
-		sig_attrs->mem.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->mem.sig.dif.ref_tag = se_cmd->reftag_seed;
-		sig_attrs->wire.sig.dif.type = ib_prot_type;
-		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->wire.sig.dif.ref_tag = se_cmd->reftag_seed;
+		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->wire);
+		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->mem);
 		break;
 	default:
 		pr_err("Unsupported PI operation %d\n", se_cmd->prot_op);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
