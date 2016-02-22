From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 05/13] svcrdma: Close connection when a send error occurs
Date: Mon, 22 Feb 2016 15:41:28 -0500
Message-ID: <20160222204128.3274.64201.stgit@sisley.1015granger.net>
References: <20160222203550.3274.82777.stgit@sisley.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160222203550.3274.82777.stgit-MxQ+bVWvw4zwdl/1UfZZQIVfYA8g3rJ/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index a8fab99..0f8798d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -314,7 +314,6 @@ static int send_write(struct svcxprt_rdma *xprt, struct svc_rqst *rqstp,
  err:
 	svc_rdma_unmap_dma(ctxt);
 	svc_rdma_put_context(ctxt, 0);
-	/* Fatal error, close transport */
 	return -EIO;
 }
 
@@ -571,6 +570,7 @@ static int send_reply(struct svcxprt_rdma *rdma,
  err:
 	svc_rdma_unmap_dma(ctxt);
 	svc_rdma_put_context(ctxt, 1);
+	pr_err("svcrdma: failed to send reply, rc=%d\n", ret);
 	return -EIO;
 }
 
@@ -642,6 +642,9 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 
 	ret = send_reply(rdma, rqstp, res_page, rdma_resp, ctxt, vec,
 			 inline_bytes);
+	if (ret < 0)
+		goto err1;
+
 	svc_rdma_put_req_map(rdma, vec);
 	dprintk("svcrdma: send_reply returns %d\n", ret);
 	return ret;
@@ -651,5 +654,6 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
  err0:
 	svc_rdma_put_req_map(rdma, vec);
 	svc_rdma_put_context(ctxt, 0);
-	return ret;
+	set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
+	return -ENOTCONN;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
