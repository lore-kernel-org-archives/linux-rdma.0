From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/14] uapi/rdma/hfi/hfi1_user.h: Correct comment for capability bit
Date: Thu, 17 Dec 2015 02:00:12 -0500
Message-ID: <1450335624-12134-3-git-send-email-ira.weiny@intel.com>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450335624-12134-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The HFI1_CAP_TID_UNMAP comment was incorrectly implying the
opposite of what capability actually did. Correct this error.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/uapi/rdma/hfi/hfi1_user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 288694e422fb..cf172718e3d5 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -93,7 +93,7 @@
 #define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
 #define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
 #define HFI1_CAP_NODROP_EGR_FULL  (1UL <<  9) /* Don't drop on EGR buffs full */
-#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Enable Expected TID caching */
+#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Disable Expected TID caching */
 #define HFI1_CAP_PRINT_UNIMPL     (1UL << 11) /* Show for unimplemented feats */
 #define HFI1_CAP_ALLOW_PERM_JKEY  (1UL << 12) /* Allow use of permissive JKEY */
 #define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
