From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: Fix LinkDownReason define for consistency
Date: Wed, 11 Nov 2015 02:56:34 -0500
Message-ID: <1447228594-15764-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

LinkDownReason LocalMediaNotInstalled lacked an underscore
and was inconsistent with other defines in the same family.
This patch fixes this.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/opa_port_info.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/rdma/opa_port_info.h b/include/rdma/opa_port_info.h
index a0fa975..2b95c2c 100644
--- a/include/rdma/opa_port_info.h
+++ b/include/rdma/opa_port_info.h
@@ -97,7 +97,7 @@
 #define OPA_LINKDOWN_REASON_WIDTH_POLICY			41
 /* 42-48 reserved */
 #define OPA_LINKDOWN_REASON_DISCONNECTED			49
-#define OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED		50
+#define OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED		50
 #define OPA_LINKDOWN_REASON_NOT_INSTALLED			51
 #define OPA_LINKDOWN_REASON_CHASSIS_CONFIG			52
 /* 53 reserved */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
