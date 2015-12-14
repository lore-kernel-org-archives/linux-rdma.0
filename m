From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 02/11] xprtrdma: xprt_rdma_free() must not release
 backchannel reqs
Date: Mon, 14 Dec 2015 16:17:54 -0500
Message-ID: <20151214211754.16295.84487.stgit@manet.1015granger.net>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214211317.16295.70115.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Preserve any rpcrdma_req that is attached to rpc_rqst's allocated
for the backchannel. Otherwise, after all the pre-allocated
backchannel req's are consumed, incoming backward calls start
writing on freed memory.

Somehow this hunk got lost.

Fixes: f531a5dbc451 ('xprtrdma: Pre-allocate backward rpc_rqst')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 8c545f7..740bddc 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -576,6 +576,9 @@ xprt_rdma_free(void *buffer)
 
 	rb = container_of(buffer, struct rpcrdma_regbuf, rg_base[0]);
 	req = rb->rg_owner;
+	if (req->rl_backchannel)
+		return;
+
 	r_xprt = container_of(req->rl_buffer, struct rpcrdma_xprt, rx_buf);
 
 	dprintk("RPC:       %s: called on 0x%p\n", __func__, req->rl_reply);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
