From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 05/11] xprtrdma: Do not wait if ib_post_send() fails
Date: Fri, 04 Mar 2016 11:28:01 -0500
Message-ID: <20160304162801.13590.89343.stgit@oracle120-ib.cthon.org>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304162447.13590.9524.stgit-HOT7RYQ5zl57mBIHr/i2/HG1qET/BF4J@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If ib_post_send() in ro_unmap_sync() fails, the WRs have not been
posted, no completions will fire, and wait_for_completion() will
wait forever. Skip the wait in that case.

To ensure the MRs are invalid, disconnect.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index e165673..ecb005f 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -520,14 +520,18 @@ frwr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 	 * unless ri_id->qp is a valid pointer.
 	 */
 	rc = ib_post_send(ia->ri_id->qp, invalidate_wrs, &bad_wr);
-	if (rc)
+	if (rc) {
 		pr_warn("%s: ib_post_send failed %i\n", __func__, rc);
+		rdma_disconnect(ia->ri_id);
+		goto unmap;
+	}
 
 	wait_for_completion(&f->fr_linv_done);
 
 	/* ORDER: Now DMA unmap all of the req's MRs, and return
 	 * them to the free MW list.
 	 */
+unmap:
 	for (i = 0, nchunks = req->rl_nchunks; nchunks; nchunks--) {
 		seg = &req->rl_segments[i];
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
