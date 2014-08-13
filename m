From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/7] IB/iser: Centralize ib_sig_domain settings
Date: Wed, 13 Aug 2014 19:54:33 +0300
Message-ID: <1407948875-733-6-git-send-email-sagig@mellanox.com>
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
 drivers/infiniband/ulp/iser/iser_memory.c |   36 ++++++++++++++--------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index bf0d1cc..5842d50 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -457,44 +457,44 @@ scsi2ib_prot_type(unsigned char prot_type)
 	}
 }
 
+static inline void
+iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs,
+		    struct ib_sig_domain *domain)
+{
+	unsigned char scsi_ptype = scsi_get_prot_type(sc);
+
+	domain->sig.dif.type = scsi2ib_prot_type(scsi_ptype);
+	domain->sig.dif.pi_interval = sc->device->sector_size;
+	domain->sig.dif.ref_tag = scsi_get_lba(sc) & 0xffffffff;
+};
 
 static int
 iser_set_sig_attrs(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs)
 {
-	unsigned char scsi_ptype = scsi_get_prot_type(sc);
-
 	sig_attrs->mem.sig_type = IB_SIG_TYPE_T10_DIF;
 	sig_attrs->wire.sig_type = IB_SIG_TYPE_T10_DIF;
-	sig_attrs->mem.sig.dif.pi_interval = sc->device->sector_size;
-	sig_attrs->wire.sig.dif.pi_interval = sc->device->sector_size;
 
 	switch (scsi_get_prot_op(sc)) {
 	case SCSI_PROT_WRITE_INSERT:
 	case SCSI_PROT_READ_STRIP:
 		sig_attrs->mem.sig.dif.type = IB_T10DIF_NONE;
-		sig_attrs->wire.sig.dif.type = scsi2ib_prot_type(scsi_ptype);
+		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->wire);
 		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->wire.sig.dif.ref_tag = scsi_get_lba(sc) &
-						  0xffffffff;
 		break;
 	case SCSI_PROT_READ_INSERT:
 	case SCSI_PROT_WRITE_STRIP:
-		sig_attrs->mem.sig.dif.type = scsi2ib_prot_type(scsi_ptype);
-		sig_attrs->mem.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->mem.sig.dif.ref_tag = scsi_get_lba(sc) &
-						 0xffffffff;
 		sig_attrs->wire.sig.dif.type = IB_T10DIF_NONE;
+		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->mem);
+		sig_attrs->mem.sig.dif.bg_type = iser_pi_guard ? IB_T10DIF_CSUM :
+						 IB_T10DIF_CRC;
 		break;
 	case SCSI_PROT_READ_PASS:
 	case SCSI_PROT_WRITE_PASS:
-		sig_attrs->mem.sig.dif.type = scsi2ib_prot_type(scsi_ptype);
-		sig_attrs->mem.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->mem.sig.dif.ref_tag = scsi_get_lba(sc) &
-						 0xffffffff;
-		sig_attrs->wire.sig.dif.type = scsi2ib_prot_type(scsi_ptype);
+		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->wire);
 		sig_attrs->wire.sig.dif.bg_type = IB_T10DIF_CRC;
-		sig_attrs->wire.sig.dif.ref_tag = scsi_get_lba(sc) &
-						  0xffffffff;
+		iser_set_dif_domain(sc, sig_attrs, &sig_attrs->mem);
+		sig_attrs->mem.sig.dif.bg_type = iser_pi_guard ? IB_T10DIF_CSUM :
+						 IB_T10DIF_CRC;
 		break;
 	default:
 		iser_err("Unsupported PI operation %d\n",
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
