From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 02/10] xprtrdma: xprt_rdma_free() must not release
 backchannel reqs
Date: Wed, 16 Dec 2015 17:22:14 -0500
Message-ID: <20151216222214.13110.23751.stgit@manet.1015granger.net>
References: <20151216221444.13110.43538.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151216221444.13110.43538.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
Tested-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
