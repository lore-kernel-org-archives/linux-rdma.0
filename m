From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 02/12] xprtrdma: On invalidation failure,
 remove MWs from rl_registered
Date: Tue, 23 May 2017 10:53:54 -0400
Message-ID: <20170523145354.961.18377.stgit@manet.1015granger.net>
References: <20170523142629.961.81233.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523142629.961.81233.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Callers assume the ro_unmap_sync and ro_unmap_safe methods empty
the list of registered MRs. Ensure that all paths through
fmr_op_unmap_sync() remove MWs from that list.

Fixes: 9d6b04097882 ("xprtrdma: Place registered MWs on a ... ")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 9ee573f..7b2de86 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -295,6 +295,7 @@ enum {
 	pr_err("rpcrdma: ib_unmap_fmr failed (%i)\n", rc);
 
 	list_for_each_entry_safe(mw, tmp, &req->rl_registered, mw_list) {
+		list_del_init(&mw->mw_list);
 		list_del_init(&mw->fmr.fm_mr->list);
 		fmr_op_recover_mr(mw);
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
