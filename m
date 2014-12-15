From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/3] openib: add new TIMEWAIT state for CM
Date: Mon, 15 Dec 2014 10:11:38 -0800
Message-ID: <1418667099-32449-3-git-send-email-arlin.r.davis@intel.com>
References: <1418667099-32449-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418667099-32449-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 3b565b4..42391b2 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -340,6 +340,7 @@ typedef enum dapl_cm_state
 	DCM_RTU_PENDING,
 	DCM_DISC_RECV,
 	DCM_FREE,
+	DCM_TIMEWAIT
 
 } DAPL_CM_STATE;
 
@@ -433,9 +434,10 @@ STATIC _INLINE_ char * dapl_cm_state_str(IN int st)
 		"CM_DESTROY",
 		"CM_RTU_PENDING",
 		"CM_DISC_RECV",
-		"CM_FREE"
+		"CM_FREE",
+		"CM_TIMEWAIT"
         };
-        return ((st < 0 || st > 16) ? "Invalid CM state?" : state[st]);
+        return ((st < 0 || st > 17) ? "Invalid CM state?" : state[st]);
 }
 
 STATIC _INLINE_ char * dapl_cm_op_str(IN int op)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
