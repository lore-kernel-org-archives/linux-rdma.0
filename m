From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 03/22] svcrdma: Remove unused sc_dto_q field
Date: Sat, 07 Jan 2017 12:15:41 -0500
Message-ID: <20170107171541.14126.17757.stgit@klimt.1015granger.net>
References: <20170107170258.14126.8503.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170107170258.14126.8503.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up. Commit be99bb11400c ('svcrdma: Use new CQ API for
RPC-over-RDMA server send CQs') removed code that used the sc_dto_q
field, but neglected to remove sc_dto_q at the same time.

Fixes: be99bb11400c ('svcrdma: Use new CQ API for RPC-over- ...')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    1 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index cb3d87a..8dc13d5 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -171,7 +171,6 @@ struct svcxprt_rdma {
 
 	wait_queue_head_t    sc_send_wait;	/* SQ exhaustion waitlist */
 	unsigned long	     sc_flags;
-	struct list_head     sc_dto_q;		/* DTO tasklet I/O pending Q */
 	struct list_head     sc_read_complete_q;
 	struct work_struct   sc_work;
 };
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index f246197..44bb337 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -557,7 +557,6 @@ static struct svcxprt_rdma *rdma_create_xprt(struct svc_serv *serv,
 		return NULL;
 	svc_xprt_init(&init_net, &svc_rdma_class, &cma_xprt->sc_xprt, serv);
 	INIT_LIST_HEAD(&cma_xprt->sc_accept_q);
-	INIT_LIST_HEAD(&cma_xprt->sc_dto_q);
 	INIT_LIST_HEAD(&cma_xprt->sc_rq_dto_q);
 	INIT_LIST_HEAD(&cma_xprt->sc_read_complete_q);
 	INIT_LIST_HEAD(&cma_xprt->sc_frmr_q);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
