From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/13] staging/rdma/hfi1: remove RxCtxRHQS from hfi1stats
Date: Wed, 11 Nov 2015 02:33:23 -0500
Message-ID: <1447227213-15122-3-git-send-email-jubin.john@intel.com>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447227213-15122-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Removed the RxCtxRHQS counter being dumped into dev_cntrs

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c           |    2 --
 drivers/staging/rdma/hfi1/chip.h           |    1 -
 drivers/staging/rdma/hfi1/chip_registers.h |    1 -
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 16302d6..9db141d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1587,8 +1587,6 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 [C_RX_TID_FLGMS] = RXE32_DEV_CNTR_ELEM(RxTidFLGMs,
 			RCV_TID_FLOW_GEN_MISMATCH_CNT,
 			CNTR_NORMAL),
-[C_RX_CTX_RHQS] = RXE32_DEV_CNTR_ELEM(RxCtxRHQS, RCV_CONTEXT_RHQ_STALL,
-			CNTR_NORMAL),
 [C_RX_CTX_EGRS] = RXE32_DEV_CNTR_ELEM(RxCtxEgrS, RCV_CONTEXT_EGR_STALL,
 			CNTR_NORMAL),
 [C_RCV_TID_FLSMS] = RXE32_DEV_CNTR_ELEM(RxTidFLSMs,
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index ccfaf6d..6946fae 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -721,7 +721,6 @@ enum {
 	C_RX_TID_FULL,
 	C_RX_TID_INVALID,
 	C_RX_TID_FLGMS,
-	C_RX_CTX_RHQS,
 	C_RX_CTX_EGRS,
 	C_RCV_TID_FLSMS,
 	C_CCE_PCI_CR_ST,
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index bf45de2..5056c84 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -379,7 +379,6 @@
 #define DC_LCB_STS_ROUND_TRIP_LTP_CNT (DC_LCB_CSRS + 0x0000000004B0)
 #define RCV_BUF_OVFL_CNT 10
 #define RCV_CONTEXT_EGR_STALL 22
-#define RCV_CONTEXT_RHQ_STALL 21
 #define RCV_DATA_PKT_CNT 0
 #define RCV_DWORD_CNT 1
 #define RCV_TID_FLOW_GEN_MISMATCH_CNT 20
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
