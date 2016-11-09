From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 02/14] xprtrdma: Cap size of callback buffer resources
Date: Wed, 09 Nov 2016 14:05:05 -0500
Message-ID: <20161109190505.15007.42767.stgit@manet.1015granger.net>
References: <20161109184735.15007.96507.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109184735.15007.96507.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the inline threshold size is set to large values (say, 32KB)
any NFSv4.1 CB request from the server gets a reply with status
NFS4ERR_RESOURCE.

Looks like there are some upper layer assumptions about the maximum
size of a reply (for example, in process_op). Cap the size of the
NFSv4 client's reply resources at a page.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/backchannel.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index 2c472e1..24fedd4 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -55,7 +55,8 @@ static int rpcrdma_bc_setup_rqst(struct rpcrdma_xprt *r_xprt,
 	if (IS_ERR(rb))
 		goto out_fail;
 	req->rl_sendbuf = rb;
-	xdr_buf_init(&rqst->rq_snd_buf, rb->rg_base, size);
+	xdr_buf_init(&rqst->rq_snd_buf, rb->rg_base,
+		     min_t(size_t, size, PAGE_SIZE));
 	rpcrdma_set_xprtdata(rqst, req);
 	return 0;
 
@@ -191,6 +192,7 @@ size_t xprt_rdma_bc_maxpayload(struct rpc_xprt *xprt)
 	size_t maxmsg;
 
 	maxmsg = min_t(unsigned int, cdata->inline_rsize, cdata->inline_wsize);
+	maxmsg = min_t(unsigned int, maxmsg, PAGE_SIZE);
 	return maxmsg - RPCRDMA_HDRLEN_MIN;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
