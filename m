From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 06/21] xprtrdma: Don't invalidate FRMRs if registration
 fails
Date: Wed, 09 Jul 2014 12:57:22 -0400
Message-ID: <20140709165722.3496.93133.stgit@manet.1015granger.net>
References: <20140709163326.3496.37893.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140709163326.3496.37893.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If FRMR registration fails, it's likely to transition the QP to the
error state. Or, registration may have failed because the QP is
_already_ in ERROR.

Thus calling rpcrdma_deregister_external() in
rpcrdma_create_chunks() is useless in FRMR mode: the LOCAL_INVs just
get flushed.

It is safe to leave existing registrations: when FRMR registration
is tried again, rpcrdma_register_frmr_external() checks if each FRMR
is already/still VALID, and knocks it down first if it is.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 54422f7..6166c98 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -271,9 +271,11 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 	return (unsigned char *)iptr - (unsigned char *)headerp;
 
 out:
-	for (pos = 0; nchunks--;)
-		pos += rpcrdma_deregister_external(
-				&req->rl_segments[pos], r_xprt);
+	if (r_xprt->rx_ia.ri_memreg_strategy != RPCRDMA_FRMR) {
+		for (pos = 0; nchunks--;)
+			pos += rpcrdma_deregister_external(
+					&req->rl_segments[pos], r_xprt);
+	}
 	return n;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
