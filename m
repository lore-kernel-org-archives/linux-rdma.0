From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/7] xprtrdma: Properly recover FRWRs with in-flight
 FASTREG WRs
Date: Tue, 31 Jan 2017 13:38:16 -0500
Message-ID: <20170131183816.5325.10968.stgit@manet.1015granger.net>
References: <20170131183345.5325.47072.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170131183345.5325.47072.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sriharsha (sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org) reports an occasional
double DMA unmap of an FRWR MR when a connection is lost. I see one
way this can happen.

When a request requires more than one segment or chunk,
rpcrdma_marshal_req loops, invoking ->frwr_op_map for each segment
(MR) in each chunk. Each call posts a FASTREG Work Request to
register one MR.

Now suppose that the transport connection is lost part-way through
marshaling this request. As part of recovering and resetting that
req, rpcrdma_marshal_req invokes ->frwr_op_unmap_safe, which hands
all the req's registered FRWRs to the MR recovery thread.

But note: FRWR registration is asynchronous. So it's possible that
some of these "already registered" FRWRs are fully registered, and
some are still waiting for their FASTREG WR to complete.

When the connection is lost, the "already registered" frmrs are
marked FRMR_IS_VALID, and the "still waiting" WRs flush. Then
frwr_wc_fastreg marks these frmrs FRMR_FLUSHED_FR.

But thanks to ->frwr_op_unmap_safe, the MR recovery thread is doing
an unreg / alloc_mr, a DMA unmap, and marking each of these frwrs
FRMR_IS_INVALID, at the same time frwr_wc_fastreg might be running.

- If the recovery thread runs last, then the frmr is marked
FRMR_IS_INVALID, and life continues.

- If frwr_wc_fastreg runs last, the frmr is marked FRMR_FLUSHED_FR,
but the recovery thread has already DMA unmapped that MR. When
->frwr_op_map later re-uses this frmr, it sees it is not marked
FRMR_IS_INVALID, and tries to recover it before using it, resulting
in a second DMA unmap of the same MR.

The fix is to guarantee in-flight FASTREG WRs have flushed before MR
recovery runs on those FRWRs. Thus we depend on ro_unmap_safe
(called from xprt_rdma_send_request on retransmit, or from
xprt_rdma_free) to clean up old registrations as needed.

Reported-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |   14 ++++++++------
 net/sunrpc/xprtrdma/transport.c |    4 ----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index d889883..72b3ca0 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -759,13 +759,13 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	iptr = headerp->rm_body.rm_chunks;
 	iptr = rpcrdma_encode_read_list(r_xprt, req, rqst, iptr, rtype);
 	if (IS_ERR(iptr))
-		goto out_unmap;
+		goto out_err;
 	iptr = rpcrdma_encode_write_list(r_xprt, req, rqst, iptr, wtype);
 	if (IS_ERR(iptr))
-		goto out_unmap;
+		goto out_err;
 	iptr = rpcrdma_encode_reply_chunk(r_xprt, req, rqst, iptr, wtype);
 	if (IS_ERR(iptr))
-		goto out_unmap;
+		goto out_err;
 	hdrlen = (unsigned char *)iptr - (unsigned char *)headerp;
 
 	dprintk("RPC: %5u %s: %s/%s: hdrlen %zd rpclen %zd\n",
@@ -776,12 +776,14 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	if (!rpcrdma_prepare_send_sges(&r_xprt->rx_ia, req, hdrlen,
 				       &rqst->rq_snd_buf, rtype)) {
 		iptr = ERR_PTR(-EIO);
-		goto out_unmap;
+		goto out_err;
 	}
 	return 0;
 
-out_unmap:
-	r_xprt->rx_ia.ri_ops->ro_unmap_safe(r_xprt, req, false);
+out_err:
+	pr_err("rpcrdma: rpcrdma_marshal_req failed, status %ld\n",
+	       PTR_ERR(iptr));
+	r_xprt->rx_stats.failed_marshal_count++;
 	return PTR_ERR(iptr);
 }
 
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 6990581..c717f54 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -709,10 +709,6 @@
 	return 0;
 
 failed_marshal:
-	dprintk("RPC:       %s: rpcrdma_marshal_req failed, status %i\n",
-		__func__, rc);
-	if (rc == -EIO)
-		r_xprt->rx_stats.failed_marshal_count++;
 	if (rc != -ENOTCONN)
 		return rc;
 drop_connection:

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
