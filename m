From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 08/11] staging/rdma/hfi1: Remove spurious error messages
Date: Fri,  6 Nov 2015 20:07:03 -0500
Message-ID: <1446858426-30509-9-git-send-email-jubin.john@intel.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446858426-30509-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ignacio Hernandez <ignacio.hernandez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changed the order in which diagnostics messages are printed,
taking into account the cases where the errors are handled in
rcv_hdrerr() and no further message is needed to report.

Reviewed-by: Mark Debbage <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ignacio Hernandez <ignacio.hernandez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ce69141..61fc626 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -1163,20 +1163,20 @@ void handle_eflags(struct hfi1_packet *packet)
 	struct hfi1_ctxtdata *rcd = packet->rcd;
 	u32 rte = rhf_rcv_type_err(packet->rhf);
 
-	dd_dev_err(rcd->dd,
-		"receive context %d: rhf 0x%016llx, errs [ %s%s%s%s%s%s%s%s] rte 0x%x\n",
-		rcd->ctxt, packet->rhf,
-		packet->rhf & RHF_K_HDR_LEN_ERR ? "k_hdr_len " : "",
-		packet->rhf & RHF_DC_UNC_ERR ? "dc_unc " : "",
-		packet->rhf & RHF_DC_ERR ? "dc " : "",
-		packet->rhf & RHF_TID_ERR ? "tid " : "",
-		packet->rhf & RHF_LEN_ERR ? "len " : "",
-		packet->rhf & RHF_ECC_ERR ? "ecc " : "",
-		packet->rhf & RHF_VCRC_ERR ? "vcrc " : "",
-		packet->rhf & RHF_ICRC_ERR ? "icrc " : "",
-		rte);
-
 	rcv_hdrerr(rcd, rcd->ppd, packet);
+	if (rhf_err_flags(packet->rhf))
+		dd_dev_err(rcd->dd,
+			   "receive context %d: rhf 0x%016llx, errs [ %s%s%s%s%s%s%s%s] rte 0x%x\n",
+			   rcd->ctxt, packet->rhf,
+			   packet->rhf & RHF_K_HDR_LEN_ERR ? "k_hdr_len " : "",
+			   packet->rhf & RHF_DC_UNC_ERR ? "dc_unc " : "",
+			   packet->rhf & RHF_DC_ERR ? "dc " : "",
+			   packet->rhf & RHF_TID_ERR ? "tid " : "",
+			   packet->rhf & RHF_LEN_ERR ? "len " : "",
+			   packet->rhf & RHF_ECC_ERR ? "ecc " : "",
+			   packet->rhf & RHF_VCRC_ERR ? "vcrc " : "",
+			   packet->rhf & RHF_ICRC_ERR ? "icrc " : "",
+			   rte);
 }
 
 /*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
