From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 1/6] RDMA/bnxt_re: Disable atomic capability on bnxt_re adapters
Date: Thu, 15 Feb 2018 21:20:08 -0800
Message-ID: <1518758413-20850-2-git-send-email-selvin.xavier@broadcom.com>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518758413-20850-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

More testing needs to be done before enabling this feature.
Disabling the feature temporarily

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  6 ++----
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 14 +-------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 9b8fa77..ce2a6d0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -174,10 +174,8 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_pd = dev_attr->max_pd;
 	ib_attr->max_qp_rd_atom = dev_attr->max_qp_rd_atom;
 	ib_attr->max_qp_init_rd_atom = dev_attr->max_qp_init_rd_atom;
-	if (dev_attr->is_atomic) {
-		ib_attr->atomic_cap = IB_ATOMIC_HCA;
-		ib_attr->masked_atomic_cap = IB_ATOMIC_HCA;
-	}
+	ib_attr->atomic_cap = IB_ATOMIC_NONE;
+	ib_attr->masked_atomic_cap = IB_ATOMIC_NONE;
 
 	ib_attr->max_ee_rd_atom = 0;
 	ib_attr->max_res_rd_atom = 0;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index c015c18..0305798 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -52,18 +52,6 @@ const struct bnxt_qplib_gid bnxt_qplib_gid_zero = {{ 0, 0, 0, 0, 0, 0, 0, 0,
 
 /* Device */
 
-static bool bnxt_qplib_is_atomic_cap(struct bnxt_qplib_rcfw *rcfw)
-{
-	int rc;
-	u16 pcie_ctl2;
-
-	rc = pcie_capability_read_word(rcfw->pdev, PCI_EXP_DEVCTL2,
-				       &pcie_ctl2);
-	if (rc)
-		return false;
-	return !!(pcie_ctl2 & PCI_EXP_DEVCTL2_ATOMIC_REQ);
-}
-
 static void bnxt_qplib_query_version(struct bnxt_qplib_rcfw *rcfw,
 				     char *fw_ver)
 {
@@ -165,7 +153,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 		attr->tqm_alloc_reqs[i * 4 + 3] = *(++tqm_alloc);
 	}
 
-	attr->is_atomic = bnxt_qplib_is_atomic_cap(rcfw);
+	attr->is_atomic = 0;
 bail:
 	bnxt_qplib_rcfw_free_sbuf(rcfw, sbuf);
 	return rc;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
