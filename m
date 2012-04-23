From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/15] uDAPL v2.0 common: dapls_ep_flush_cq will segfault
 when no CQ is attached to EP
Date: Mon, 23 Apr 2012 20:00:50 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120245@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

add check for NULL request/receive EVD (cq) before flushing.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_util.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/dapl/common/dapl_ep_util.c b/dapl/common/dapl_ep_util.c
index 6646528..5133f59 100644
--- a/dapl/common/dapl_ep_util.c
+++ b/dapl/common/dapl_ep_util.c
@@ -620,9 +620,11 @@ static void dapli_ep_flush_evd(DAPL_EVD *evd_ptr)
 
 void dapls_ep_flush_cqs(DAPL_EP * ep_ptr)
 {
-	dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.request_evd_handle);
-	while (dapls_cb_pending(&ep_ptr->recv_buffer))
-		dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.recv_evd_handle);
+	if (ep_ptr->param.request_evd_handle)
+		dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.request_evd_handle);
+	if (ep_ptr->param.recv_evd_handle)
+		while (dapls_cb_pending(&ep_ptr->recv_buffer))
+			dapli_ep_flush_evd((DAPL_EVD *) ep_ptr->param.recv_evd_handle);
 }
 
 /*
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
