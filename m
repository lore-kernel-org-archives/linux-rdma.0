From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/12] xprtrdma: rpcrdma_bc_receive_call() should init
 rq_private_buf.len
Date: Thu, 18 Feb 2016 12:30:02 -0500
Message-ID: <20160218173002.14009.22426.stgit@manet.1015granger.net>
References: <20160218172449.14009.47311.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218172449.14009.47311.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some NFSv4.1 OPEN requests were hanging waiting for the NFS server
to finish recalling delegations. Turns out that each NFSv4.1 CB
request on RDMA gets a GARBAGE_ARGS reply from the Linux client.

Commit 756b9b37cfb2e3dc added a line in bc_svc_process that
overwrites the incoming rq_rcv_buf's length with the value in
rq_private_buf.len. But rpcrdma_bc_receive_call() does not invoke
xprt_complete_bc_request(), thus rq_private_buf.len is not
initialized. svc_process_common() is invoked with a zero-length
RPC message, and fails.

Fixes: 756b9b37cfb2e3dc ('SUNRPC: Fix callback channel')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/backchannel.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index cc1251d..2dcd764 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -341,6 +341,8 @@ void rpcrdma_bc_receive_call(struct rpcrdma_xprt *r_xprt,
 	rqst->rq_reply_bytes_recvd = 0;
 	rqst->rq_bytes_sent = 0;
 	rqst->rq_xid = headerp->rm_xid;
+
+	rqst->rq_private_buf.len = size;
 	set_bit(RPC_BC_PA_IN_USE, &rqst->rq_bc_pa_state);
 
 	buf = &rqst->rq_rcv_buf;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
