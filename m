From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: common: dapls_evd_dto_wait() dbg message should
 print status and not errno
Date: Thu, 20 Jan 2011 18:50:31 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011F5526BF@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_common/cq.c b/dapl/openib_common/cq.c
index f475d1d..f03400f 100644
--- a/dapl/openib_common/cq.c
+++ b/dapl/openib_common/cq.c
@@ -321,7 +321,7 @@ dapls_evd_dto_wait(IN DAPL_EVD * evd_ptr, IN uint32_t timeout)
 
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL,
 		     " cq_object_wait: RET evd %p ibv_cq %p %s\n",
-		     evd_ptr, ibv_cq, strerror(errno));
+		     evd_ptr, ibv_cq, strerror(status));
 
 	return dapl_convert_errno(status, "cq_wait_object_wait");
 }
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
