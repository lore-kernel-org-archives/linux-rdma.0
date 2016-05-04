From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/9] svcrdma: Remove superfluous line from
 rdma_read_chunks()
Date: Wed, 04 May 2016 10:53:14 -0400
Message-ID: <20160504145314.6602.32998.stgit@klimt.1015granger.net>
References: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504144730.6602.89073.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: svc_rdma_get_read_chunk() already returns a pointer
to the Read list. No need to set "ch" again to the value it
already contains.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 234be9d..12e7899 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -447,10 +447,8 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	head->arg.len = rqstp->rq_arg.len;
 	head->arg.buflen = rqstp->rq_arg.buflen;
 
-	ch = (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[0];
-	position = be32_to_cpu(ch->rc_position);
-
 	/* RDMA_NOMSG: RDMA READ data should land just after RDMA RECV data */
+	position = be32_to_cpu(ch->rc_position);
 	if (position == 0) {
 		head->arg.pages = &head->pages[0];
 		page_offset = head->byte_len;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
