From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 10/15] IB/hfi1: Implement hfi1 support for AH
 notification
Date: Mon, 14 Dec 2015 12:29:02 -0500
Message-ID: <20151214172900.11576.41173.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214172509.11576.19722.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For OPA devices additional work is required to create an AH.
This patch adds support to set the VL correctly.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index e007c52..6d69491 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1629,6 +1629,29 @@ static int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 	return 0;
 }
 
+static void hfi1_notify_new_ah(struct ib_device *ibdev,
+			       struct ib_ah_attr *ah_attr,
+			       struct rvt_ah *ah)
+{
+	struct hfi1_ibport *ibp;
+	struct hfi1_pportdata *ppd;
+	struct hfi1_devdata *dd;
+	u8 sc5;
+
+	/*
+	 * Do not trust reading anything from rvt_ah at this point as it is not
+	 * done being setup. We can however modify things which we need to set.
+	 */
+
+	ibp = to_iport(ibdev, ah_attr->port_num);
+	ppd = ppd_from_ibp(ibp);
+	sc5 = ibp->sl_to_sc[ah->attr.sl];
+	dd = dd_from_ppd(ppd);
+	ah->vl = sc_to_vlt(dd, sc5);
+	if (ah->vl < num_vls || ah->vl == 15)
+		ah->log_pmtu = ilog2(dd->vld[ah->vl].mtu);
+}
+
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
 {
 	struct ib_ah_attr attr;
@@ -1919,6 +1942,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_card_name = get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = hfi1_check_ah;
+	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
 	dd->verbs_dev.rdi.dparms.props.max_ah = hfi1_max_ahs;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
