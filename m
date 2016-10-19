From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Set MAX IRD, MAX ORD size to max supported value
Date: Wed, 19 Oct 2016 15:33:58 -0500
Message-ID: <20161019203358.14276-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set the MAX_IRD and MAX_ORD size negotiated to the maximum
supported values.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 5 -----
 drivers/infiniband/hw/i40iw/i40iw_user.h | 5 ++---
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 31c4a0c..89eddbc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -2626,11 +2626,6 @@ static enum i40iw_status_code i40iw_sc_qp_setctx(
 			      152,
 			      LS_64(iw->last_byte_sent, I40IWQPC_LASTBYTESENT));
 
-		/*
-		* Hard-code IRD_SIZE to hw-limit, 128, in qpctx, i.e matching an
-		*advertisable IRD of 64
-		*/
-		iw->ird_size = I40IW_QPCTX_ENCD_MAXIRD;
 		set_64bit_val(qp_ctx,
 			      160,
 			      LS_64(iw->ord_size, I40IWQPC_ORDSIZE) |
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 276bcef..e65c2baa 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -72,10 +72,9 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_SQ_PAYLOAD_SIZE =		2145386496,
 	I40IW_MAX_INLINE_DATA_SIZE =		48,
 	I40IW_MAX_PUSHMODE_INLINE_DATA_SIZE =	48,
-	I40IW_MAX_IRD_SIZE =			32,
-	I40IW_QPCTX_ENCD_MAXIRD =		3,
+	I40IW_MAX_IRD_SIZE =			63,
+	I40IW_MAX_ORD_SIZE =			127,
 	I40IW_MAX_WQ_ENTRIES =			2048,
-	I40IW_MAX_ORD_SIZE =			32,
 	I40IW_Q2_BUFFER_SIZE =			(248 + 100),
 	I40IW_QP_CTX_SIZE =			248
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
