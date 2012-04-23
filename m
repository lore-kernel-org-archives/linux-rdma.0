From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/15] uDAPL v2.0 common: add DAPL_DBG_TYPE_CM_STATS
 (0x40000) to debug log options
Date: Mon, 23 Apr 2012 20:00:53 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F94812024E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/include/dapl_debug.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/dapl/include/dapl_debug.h b/dapl/include/dapl_debug.h
index ff473e3..bb11c3d 100644
--- a/dapl/include/dapl_debug.h
+++ b/dapl/include/dapl_debug.h
@@ -70,7 +70,8 @@ typedef enum
     DAPL_DBG_TYPE_THREAD  	= 0x4000,
     DAPL_DBG_TYPE_CM_EST  	= 0x8000,
     DAPL_DBG_TYPE_CM_WARN  	= 0x10000,
-    DAPL_DBG_TYPE_EXTENSION	= 0x20000
+    DAPL_DBG_TYPE_EXTENSION	= 0x20000,
+    DAPL_DBG_TYPE_CM_STATS	= 0x40000
 
 } DAPL_DBG_TYPE;
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
