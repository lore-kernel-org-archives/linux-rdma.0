From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 04/14] uapi/rdma/hfi/hfi1_user.h: Add command and event for TID caching
Date: Thu, 17 Dec 2015 02:00:14 -0500
Message-ID: <1450335624-12134-5-git-send-email-ira.weiny@intel.com>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450335624-12134-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

TID caching will use a new event to signal userland that cache
invalidation has occurred and needs a matching command code that
will be used to read the invalidated TIDs.

Add the event bit and the new command to the exported header file.

The command is also added to the switch() statement in file_ops.c
for completeness and in preparation for its usage later.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c | 1 +
 include/uapi/rdma/hfi/hfi1_user.h    | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index d57d549052c8..c66693532be0 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -241,6 +241,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		must_be_root = 1;	/* validate user */
 		copy = 0;
 		break;
+	case HFI1_CMD_TID_INVAL_READ:
 	default:
 		ret = -EINVAL;
 		goto bail;
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index a65f2fe17660..959204df5318 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -134,6 +134,7 @@
 #define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
 #define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
 #define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
+#define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
 /* separate EPROM commands from normal PSM commands */
 #define HFI1_CMD_EP_INFO         64      /* read EPROM device ID */
 #define HFI1_CMD_EP_ERASE_CHIP   65      /* erase whole EPROM */
@@ -147,13 +148,15 @@
 #define _HFI1_EVENT_LID_CHANGE_BIT     2
 #define _HFI1_EVENT_LMC_CHANGE_BIT     3
 #define _HFI1_EVENT_SL2VL_CHANGE_BIT   4
-#define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_SL2VL_CHANGE_BIT
+#define _HFI1_EVENT_TID_MMU_NOTIFY_BIT 5
+#define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_TID_MMU_NOTIFY_BIT
 
 #define HFI1_EVENT_FROZEN            BIT(_HFI1_EVENT_FROZEN_BIT)
 #define HFI1_EVENT_LINKDOWN          BIT(_HFI1_EVENT_LINKDOWN_BIT)
 #define HFI1_EVENT_LID_CHANGE        BIT(_HFI1_EVENT_LID_CHANGE_BIT)
 #define HFI1_EVENT_LMC_CHANGE        BIT(_HFI1_EVENT_LMC_CHANGE_BIT)
 #define HFI1_EVENT_SL2VL_CHANGE      BIT(_HFI1_EVENT_SL2VL_CHANGE_BIT)
+#define HFI1_EVENT_TID_MMU_NOTIFY    BIT(_HFI1_EVENT_TID_MMU_NOTIFY_BIT)
 
 /*
  * These are the status bits readable (in ASCII form, 64bit value)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
