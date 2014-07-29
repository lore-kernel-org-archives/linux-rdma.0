From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 08/21] xprtrdma: Back off rkey when FAST_REG_MR fails
Date: Tue, 29 Jul 2014 17:24:19 -0400
Message-ID: <20140729212419.2812.56123.stgit@manet.1015granger.net>
References: <20140729211534.2812.3128.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729211534.2812.3128.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If posting a FAST_REG_MR Work Reqeust fails, revert the rkey update
to avoid subsequent IB_WC_MW_BIND_ERR completions.

Suggested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 8bb7945..dc53ea2 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1574,6 +1574,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	if (rc) {
 		dprintk("RPC:       %s: failed ib_post_send for register,"
 			" status %i\n", __func__, rc);
+		ib_update_fast_reg_key(mr, --key);
 		goto out_err;
 	} else {
 		seg1->mr_rkey = mr->rkey;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
