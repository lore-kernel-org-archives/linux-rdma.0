From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 10/10] svcrdma: Further clean-up of
 svc_rdma_get_inv_rkey()
Date: Fri, 18 Nov 2016 10:11:31 -0500
Message-ID: <20161118151130.13658.36018.stgit@klimt.1015granger.net>
References: <20161118145940.13658.59105.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161118145940.13658.59105.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No longer any need for the dprintk().

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 30eeab5..ad4d286 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -199,31 +199,22 @@ static u32 svc_rdma_get_inv_rkey(struct rpcrdma_msg *rdma_argp,
 {
 	struct rpcrdma_read_chunk *rd_ary;
 	struct rpcrdma_segment *arg_ch;
-	u32 inv_rkey;
-
-	inv_rkey = 0;
 
 	rd_ary = (struct rpcrdma_read_chunk *)&rdma_argp->rm_body.rm_chunks[0];
-	if (rd_ary->rc_discrim != xdr_zero) {
-		inv_rkey = be32_to_cpu(rd_ary->rc_target.rs_handle);
-		goto out;
-	}
+	if (rd_ary->rc_discrim != xdr_zero)
+		return be32_to_cpu(rd_ary->rc_target.rs_handle);
 
 	if (wr_ary && be32_to_cpu(wr_ary->wc_nchunks)) {
 		arg_ch = &wr_ary->wc_array[0].wc_target;
-		inv_rkey = be32_to_cpu(arg_ch->rs_handle);
-		goto out;
+		return be32_to_cpu(arg_ch->rs_handle);
 	}
 
 	if (rp_ary && be32_to_cpu(rp_ary->wc_nchunks)) {
 		arg_ch = &rp_ary->wc_array[0].wc_target;
-		inv_rkey = be32_to_cpu(arg_ch->rs_handle);
-		goto out;
+		return be32_to_cpu(arg_ch->rs_handle);
 	}
 
-out:
-	dprintk("svcrdma: Send With Invalidate rkey=%08x\n", inv_rkey);
-	return inv_rkey;
+	return 0;
 }
 
 /* Assumptions:

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
