From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/3] xprtrdma: don't log warnings for flushed completions
Date: Mon, 21 Sep 2015 12:24:34 -0500
Message-ID: <20150921172434.9761.97255.stgit@build2.ogc.int>
References: <20150921172423.9761.92399.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150921172423.9761.92399.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Unsignaled send WRs can get flushed as part of normal unmount, so don't
log them as warnings.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/frwr_ops.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index d6653f5..f1868ba 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -257,8 +257,11 @@ frwr_sendcompletion(struct ib_wc *wc)
 
 	/* WARNING: Only wr_id and status are reliable at this point */
 	r = (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
-	pr_warn("RPC:       %s: frmr %p flushed, status %s (%d)\n",
-		__func__, r, ib_wc_status_msg(wc->status), wc->status);
+	if (wc->status == IB_WC_WR_FLUSH_ERR)
+		dprintk("RPC:       %s: frmr %p flushed\n", __func__, r);
+	else
+		pr_warn("RPC:       %s: frmr %p error, status %s (%d)\n",
+			__func__, r, ib_wc_status_msg(wc->status), wc->status);
 	r->r.frmr.fr_state = FRMR_IS_STALE;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
