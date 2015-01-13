From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/10] svcrdma: Clean up dprintk
Date: Tue, 13 Jan 2015 11:02:37 -0500
Message-ID: <20150113160237.8118.29686.stgit@klimt.1015granger.net>
References: <20150113155904.8118.57718.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113155904.8118.57718.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Nit: Fix inconsistent white space in dprintk messages.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index e011027..2c67de0 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -501,8 +501,8 @@ static int rdma_read_complete(struct svc_rqst *rqstp,
 	ret = rqstp->rq_arg.head[0].iov_len
 		+ rqstp->rq_arg.page_len
 		+ rqstp->rq_arg.tail[0].iov_len;
-	dprintk("svcrdma: deferred read ret=%d, rq_arg.len =%d, "
-		"rq_arg.head[0].iov_base=%p, rq_arg.head[0].iov_len = %zd\n",
+	dprintk("svcrdma: deferred read ret=%d, rq_arg.len=%u, "
+		"rq_arg.head[0].iov_base=%p, rq_arg.head[0].iov_len=%zu\n",
 		ret, rqstp->rq_arg.len,	rqstp->rq_arg.head[0].iov_base,
 		rqstp->rq_arg.head[0].iov_len);
 
@@ -591,8 +591,8 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		+ rqstp->rq_arg.tail[0].iov_len;
 	svc_rdma_put_context(ctxt, 0);
  out:
-	dprintk("svcrdma: ret = %d, rq_arg.len =%d, "
-		"rq_arg.head[0].iov_base=%p, rq_arg.head[0].iov_len = %zd\n",
+	dprintk("svcrdma: ret=%d, rq_arg.len=%u, "
+		"rq_arg.head[0].iov_base=%p, rq_arg.head[0].iov_len=%zd\n",
 		ret, rqstp->rq_arg.len,
 		rqstp->rq_arg.head[0].iov_base,
 		rqstp->rq_arg.head[0].iov_len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
