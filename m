From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: ibal: output completion code in deciaml & hex as
 intended
Date: Wed, 19 May 2010 10:02:34 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012F09@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 

sign-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/ibal/dapl_ibal_util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/ibal/dapl_ibal_util.c b/dapl/ibal/dapl_ibal_util.c
index 513d7c9..7f9b819 100644
--- a/dapl/ibal/dapl_ibal_util.c
+++ b/dapl/ibal/dapl_ibal_util.c
@@ -2011,7 +2011,7 @@ dapls_ib_get_dto_status(
 
     default:
 #ifdef DAPL_DBG
-    dapl_dbg_log (DAPL_DBG_TYPE_ERR,"%s() unknown IB_COMP_ST %x(0x%x)\n",
+    dapl_dbg_log (DAPL_DBG_TYPE_ERR,"%s() unknown IB_COMP_ST %d(0x%x)\n",
                   __FUNCTION__,ib_status,ib_status);
 #endif
 	return DAT_DTO_FAILURE;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
