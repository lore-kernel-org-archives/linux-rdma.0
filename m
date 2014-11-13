From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 02/16] ib/core: add IB_DEVICE_JUMBO_MAD_SUPPORT device cap flag
Date: Thu, 13 Nov 2014 14:54:11 -0500
Message-ID: <1415908465-24392-3-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a device capability flag for OPA devices to signal their support of "jumbo"
MADs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 470a011..04be3c8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -123,7 +123,8 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
-	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30)
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
+	IB_DEVICE_JUMBO_MAD_SUPPORT	= (1<<31)
 };
 
 enum ib_signature_prot_cap {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
