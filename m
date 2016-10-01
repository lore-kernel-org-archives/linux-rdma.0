From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] IB/hfi1: Update SMA ingress checks for response packets
Date: Fri, 30 Sep 2016 20:11:09 -0700
Message-ID: <20161001031109.15264.1242.stgit@scvm10.sc.intel.com>
References: <20161001030935.15264.34730.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161001030935.15264.34730.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix "unsupported method" error by skipping ingress pkey checks on
response SMA packets.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ud.c |   49 +++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 090e716..97ae24b 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -559,8 +559,8 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 
 /*
  * opa_smp_check() - Do the regular pkey checking, and the additional
- * checks for SMPs specified in OPAv1 rev 0.90, section 9.10.26
- * ("SMA Packet Checks").
+ * checks for SMPs specified in OPAv1 rev 1.0, 9/19/2016 update, section
+ * 9.10.25 ("SMA Packet Checks").
  *
  * Note that:
  *   - Checks are done using the pkey directly from the packet's BTH,
@@ -603,23 +603,28 @@ static int opa_smp_check(struct hfi1_ibport *ibp, u16 pkey, u8 sc5,
 
 	/*
 	 * SMPs fall into one of four (disjoint) categories:
-	 * SMA request, SMA response, trap, or trap repress.
-	 * Our response depends, in part, on which type of
-	 * SMP we're processing.
+	 * SMA request, SMA response, SMA trap, or SMA trap repress.
+	 * Our response depends, in part, on which type of SMP we're
+	 * processing.
 	 *
-	 * If this is not an SMA request, or trap repress:
-	 *   - accept MAD if the port is running an SM
-	 *   - pkey == FULL_MGMT_P_KEY =>
-	 *       reply with unsupported method (i.e., just mark
-	 *       the smp's status field here, and let it be
-	 *       processed normally)
-	 *   - pkey != LIM_MGMT_P_KEY =>
-	 *       increment port recv constraint errors, drop MAD
-	 * If this is an SMA request or trap repress:
+	 * If this is an SMA response, skip the check here.
+	 *
+	 * If this is an SMA request or SMA trap repress:
 	 *   - pkey != FULL_MGMT_P_KEY =>
 	 *       increment port recv constraint errors, drop MAD
+	 *
+	 * Otherwise:
+	 *    - accept if the port is running an SM
+	 *    - drop MAD if it's an SMA trap
+	 *    - pkey == FULL_MGMT_P_KEY =>
+	 *        reply with unsupported method
+	 *    - pkey != FULL_MGMT_P_KEY =>
+	 *	  increment port recv constraint errors, drop MAD
 	 */
 	switch (smp->method) {
+	case IB_MGMT_METHOD_GET_RESP:
+	case IB_MGMT_METHOD_REPORT_RESP:
+		break;
 	case IB_MGMT_METHOD_GET:
 	case IB_MGMT_METHOD_SET:
 	case IB_MGMT_METHOD_REPORT:
@@ -629,23 +634,17 @@ static int opa_smp_check(struct hfi1_ibport *ibp, u16 pkey, u8 sc5,
 			return 1;
 		}
 		break;
-	case IB_MGMT_METHOD_SEND:
-	case IB_MGMT_METHOD_TRAP:
-	case IB_MGMT_METHOD_GET_RESP:
-	case IB_MGMT_METHOD_REPORT_RESP:
+	default:
 		if (ibp->rvp.port_cap_flags & IB_PORT_SM)
 			return 0;
+		if (smp->method == IB_MGMT_METHOD_TRAP)
+			return 1;
 		if (pkey == FULL_MGMT_P_KEY) {
 			smp->status |= IB_SMP_UNSUP_METHOD;
 			return 0;
 		}
-		if (pkey != LIM_MGMT_P_KEY) {
-			ingress_pkey_table_fail(ppd, pkey, slid);
-			return 1;
-		}
-		break;
-	default:
-		break;
+		ingress_pkey_table_fail(ppd, pkey, slid);
+		return 1;
 	}
 	return 0;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
