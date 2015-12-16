From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 09/10] xprtrdma: Invalidate in the RPC reply handler
Date: Wed, 16 Dec 2015 17:23:11 -0500
Message-ID: <20151216222311.13110.96831.stgit@manet.1015granger.net>
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

There is a window between the time the RPC reply handler wakes the
waiting RPC task and when xprt_release() invokes ops->buf_free.
During this time, memory regions containing the data payload may
still be accessed by a broken or malicious server, but the RPC
application has already been allowed access to the memory containing
the RPC request's data payloads.

The server should be fenced from client memory containing RPC data
payloads _before_ the RPC application is allowed to continue.

This change also more strongly enforces send queue accounting. There
is a maximum number of RPC calls allowed to be outstanding. When an
RPC/RDMA transport is set up, just enough send queue resources are
allocated to handle registration, Send, and invalidation WRs for
each those RPCs at the same time.

Before, additional RPC calls could be dispatched while invalidation
WRs were still consuming send WQEs. When invalidation WRs backed
up, dispatching additional RPCs resulted in a send queue overrun.

Now, the reply handler prevents RPC dispatch until invalidation is
complete. This prevents RPC call dispatch until there are enough
send queue resources to proceed.

Still to do: If an RPC exits early (say, ^C), the reply handler has
no opportunity to perform invalidation. Currently, xprt_rdma_free()
still frees remaining RDMA resources, which could deadlock.
Additional changes are needed to handle invalidation properly in this
case.

Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index c10d969..0f28f2d 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -804,6 +804,11 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	if (req->rl_reply)
 		goto out_duplicate;
 
+	/* Sanity checking has passed. We are now committed
+	 * to complete this transaction.
+	 */
+	list_del_init(&rqst->rq_list);
+	spin_unlock_bh(&xprt->transport_lock);
 	dprintk("RPC:       %s: reply 0x%p completes request 0x%p\n"
 		"                   RPC request 0x%p xid 0x%08x\n",
 			__func__, rep, req, rqst,
@@ -888,12 +893,23 @@ badheader:
 		break;
 	}
 
+	/* Invalidate and flush the data payloads before waking the
+	 * waiting application. This guarantees the memory region is
+	 * properly fenced from the server before the application
+	 * accesses the data. It also ensures proper send flow
+	 * control: waking the next RPC waits until this RPC has
+	 * relinquished all its Send Queue entries.
+	 */
+	if (req->rl_nchunks)
+		r_xprt->rx_ia.ri_ops->ro_unmap_sync(r_xprt, req);
+
 	credits = be32_to_cpu(headerp->rm_credit);
 	if (credits == 0)
 		credits = 1;	/* don't deadlock */
 	else if (credits > r_xprt->rx_buf.rb_max_requests)
 		credits = r_xprt->rx_buf.rb_max_requests;
 
+	spin_lock_bh(&xprt->transport_lock);
 	cwnd = xprt->cwnd;
 	xprt->cwnd = credits << RPC_CWNDSHIFT;
 	if (xprt->cwnd > cwnd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
