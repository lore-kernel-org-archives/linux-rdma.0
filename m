From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl 2.0:  scm, ucm: set RAI_NOROUTE flag with
 rdma_getaddrinfo() call to avoid blocking.
Date: Fri, 10 Dec 2010 13:58:46 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011EBD7098@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

if path is not returned, print warning message and use default SL.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/qp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 8db6f8e..1e5b6d4 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -374,6 +374,9 @@ void dapls_ib_reinit_ep(IN DAPL_EP * ep_ptr)
 #endif				// _WIN32 || _WIN64
 
 #if DAPL_USE_IBACM
+#ifndef RAI_NOROUTE 
+#define RAI_NOROUTE 0
+#endif
 uint8_t dapls_get_sl(DAPL_HCA *hca_ptr, uint16_t dlid)
 {
 	struct rdma_addrinfo hint, *res;
@@ -387,6 +390,7 @@ uint8_t dapls_get_sl(DAPL_HCA *hca_ptr, uint16_t dlid)
 	path.dlid = dlid;
 
 	memset(&hint, 0, sizeof hint);
+	hint.ai_flags = RAI_NOROUTE;
 	hint.ai_route = &path;
 	hint.ai_route_len = sizeof(path);
 
@@ -397,6 +401,10 @@ uint8_t dapls_get_sl(DAPL_HCA *hca_ptr, uint16_t dlid)
 	if (res->ai_route_len)
 		sl = ntohs(((struct ibv_path_record *) res->ai_route)->
 			   qosclass_sl) & 0xF;
+	else 
+		dapl_log(DAPL_DBG_TYPE_CM_WARNING,
+			" dapls_get_sl: Warning, route miss 0x%x -> 0x%x\n",
+			slid, dlid);
 
 	rdma_freeaddrinfo(res);
 out:	
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
