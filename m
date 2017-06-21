From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/13] RDMA/bnxt_re: Enable atomics only if host bios supports
Date: Wed, 21 Jun 2017 10:18:21 -0700
Message-ID: <1498065504-27902-11-git-send-email-selvin.xavier@broadcom.com>
References: <1498065504-27902-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498065504-27902-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Driver shall check if the host system bios has enabled
Atomic operations capability in PCI Device Control 2
register of the pci-device. Expose the ATOMIC_HCA
flag only if the Atomic operations capability is set.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  6 ++++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 14 ++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |  3 +++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index e7d667f..5653467 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -173,8 +173,10 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_pd = dev_attr->max_pd;
 	ib_attr->max_qp_rd_atom = dev_attr->max_qp_rd_atom;
 	ib_attr->max_qp_init_rd_atom = dev_attr->max_qp_init_rd_atom;
-	ib_attr->atomic_cap = IB_ATOMIC_HCA;
-	ib_attr->masked_atomic_cap = IB_ATOMIC_HCA;
+	if (dev_attr->is_atomic) {
+		ib_attr->atomic_cap = IB_ATOMIC_HCA;
+		ib_attr->masked_atomic_cap = IB_ATOMIC_HCA;
+	}
 
 	ib_attr->max_ee_rd_atom = 0;
 	ib_attr->max_res_rd_atom = 0;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 33c04a0..e277e54 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -51,6 +51,19 @@ const struct bnxt_qplib_gid bnxt_qplib_gid_zero = {{ 0, 0, 0, 0, 0, 0, 0, 0,
 						     0, 0, 0, 0, 0, 0, 0, 0 } };
 
 /* Device */
+
+static bool bnxt_qplib_is_atomic_cap(struct bnxt_qplib_rcfw *rcfw)
+{
+	int rc;
+	u16 pcie_ctl2;
+
+	rc = pcie_capability_read_word(rcfw->pdev, PCI_EXP_DEVCTL2,
+				       &pcie_ctl2);
+	if (rc)
+		return false;
+	return !!(pcie_ctl2 & PCI_EXP_DEVCTL2_ATOMIC_REQ);
+}
+
 int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 			    struct bnxt_qplib_dev_attr *attr)
 {
@@ -131,6 +144,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 		attr->tqm_alloc_reqs[i * 4 + 3] = *(++tqm_alloc);
 	}
 
+	attr->is_atomic = bnxt_qplib_is_atomic_cap(rcfw);
 bail:
 	bnxt_qplib_rcfw_free_sbuf(rcfw, sbuf);
 	return rc;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index e3a3ed9..1132258 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -42,6 +42,8 @@
 
 #define BNXT_QPLIB_RESERVED_QP_WRS	128
 
+#define PCI_EXP_DEVCTL2_ATOMIC_REQ      0x0040
+
 struct bnxt_qplib_dev_attr {
 	char				fw_ver[32];
 	u16				max_sgid;
@@ -70,6 +72,7 @@ struct bnxt_qplib_dev_attr {
 	u32				max_inline_data;
 	u32				l2_db_size;
 	u8				tqm_alloc_reqs[MAX_TQM_ALLOC_REQ];
+	bool				is_atomic;
 };
 
 struct bnxt_qplib_pd {
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
