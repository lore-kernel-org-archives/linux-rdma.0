From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/9] staging/rdma/hfi1: Clean up macro indentation
Date: Fri, 30 Oct 2015 18:41:51 -0400
Message-ID: <1446244918-12089-3-git-send-email-ira.weiny@intel.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446244918-12089-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In preparation for implementing Expected TID caching we do some simple clean up
of header file macros.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/common.h | 15 ++++++++-------
 include/uapi/rdma/hfi/hfi1_user.h  | 26 +++++++++++++-------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index 5e203239c5b0..5dd92720faae 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -132,13 +132,14 @@
  * HFI1_CAP_RESERVED_MASK bits.
  */
 #define HFI1_CAP_WRITABLE_MASK   (HFI1_CAP_SDMA_AHG |			\
-				 HFI1_CAP_HDRSUPP |			\
-				 HFI1_CAP_MULTI_PKT_EGR |		\
-				 HFI1_CAP_NODROP_RHQ_FULL |		\
-				 HFI1_CAP_NODROP_EGR_FULL |		\
-				 HFI1_CAP_ALLOW_PERM_JKEY |		\
-				 HFI1_CAP_STATIC_RATE_CTRL |		\
-				 HFI1_CAP_PRINT_UNIMPL)
+				  HFI1_CAP_HDRSUPP |			\
+				  HFI1_CAP_MULTI_PKT_EGR |		\
+				  HFI1_CAP_NODROP_RHQ_FULL |		\
+				  HFI1_CAP_NODROP_EGR_FULL |		\
+				  HFI1_CAP_ALLOW_PERM_JKEY |		\
+				  HFI1_CAP_STATIC_RATE_CTRL |		\
+				  HFI1_CAP_PRINT_UNIMPL |		\
+				  HFI1_CAP_TID_UNMAP)
 /*
  * A set of capability bits that are "global" and are not allowed to be
  * set in the user bitmask.
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 599562fe5d57..a2fc6cbfe414 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -127,13 +127,13 @@
 #define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
 #define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
 #define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
-#define HFI1_CMD_SDMA_STATUS_UPD 7       /* force update of SDMA status ring */
+#define HFI1_CMD_SDMA_STATUS_UPD 7      /* force update of SDMA status ring */
 
 #define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
 #define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
 #define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
-#define HFI1_CMD_SET_PKEY        11      /* set context's pkey */
-#define HFI1_CMD_CTXT_RESET      12      /* reset context's HW send context */
+#define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
+#define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
 /* separate EPROM commands from normal PSM commands */
 #define HFI1_CMD_EP_INFO         64      /* read EPROM device ID */
 #define HFI1_CMD_EP_ERASE_CHIP   65      /* erase whole EPROM */
@@ -144,18 +144,18 @@
 #define HFI1_CMD_EP_WRITE_P0     70      /* write EPROM partition 0 */
 #define HFI1_CMD_EP_WRITE_P1     71      /* write EPROM partition 1 */
 
-#define _HFI1_EVENT_FROZEN_BIT       0
-#define _HFI1_EVENT_LINKDOWN_BIT     1
-#define _HFI1_EVENT_LID_CHANGE_BIT   2
-#define _HFI1_EVENT_LMC_CHANGE_BIT   3
-#define _HFI1_EVENT_SL2VL_CHANGE_BIT 4
+#define _HFI1_EVENT_FROZEN_BIT         0
+#define _HFI1_EVENT_LINKDOWN_BIT       1
+#define _HFI1_EVENT_LID_CHANGE_BIT     2
+#define _HFI1_EVENT_LMC_CHANGE_BIT     3
+#define _HFI1_EVENT_SL2VL_CHANGE_BIT   4
 #define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_SL2VL_CHANGE_BIT
 
-#define HFI1_EVENT_FROZEN                (1UL << _HFI1_EVENT_FROZEN_BIT)
-#define HFI1_EVENT_LINKDOWN_BIT		(1UL << _HFI1_EVENT_LINKDOWN_BIT)
-#define HFI1_EVENT_LID_CHANGE_BIT	(1UL << _HFI1_EVENT_LID_CHANGE_BIT)
-#define HFI1_EVENT_LMC_CHANGE_BIT	(1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
-#define HFI1_EVENT_SL2VL_CHANGE_BIT	(1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
+#define HFI1_EVENT_FROZEN            (1UL << _HFI1_EVENT_FROZEN_BIT)
+#define HFI1_EVENT_LINKDOWN          (1UL << _HFI1_EVENT_LINKDOWN_BIT)
+#define HFI1_EVENT_LID_CHANGE        (1UL << _HFI1_EVENT_LID_CHANGE_BIT)
+#define HFI1_EVENT_LMC_CHANGE        (1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
+#define HFI1_EVENT_SL2VL_CHANGE      (1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
 
 /*
  * These are the status bits readable (in ASCII form, 64bit value)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
