From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 02/11] xprtrdma: Clean up physical_op_map()
Date: Fri, 04 Mar 2016 11:27:35 -0500
Message-ID: <20160304162735.13590.96884.stgit@oracle120-ib.cthon.org>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304162447.13590.9524.stgit-HOT7RYQ5zl57mBIHr/i2/HG1qET/BF4J@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

physical_op_unmap{_sync} don't use mr_nsegs, so don't bother to set
it in physical_op_map.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/physical_ops.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
index dbb302e..481b9b6 100644
--- a/net/sunrpc/xprtrdma/physical_ops.c
+++ b/net/sunrpc/xprtrdma/physical_ops.c
@@ -68,7 +68,6 @@ physical_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	rpcrdma_map_one(ia->ri_device, seg, rpcrdma_data_dir(writing));
 	seg->mr_rkey = ia->ri_dma_mr->rkey;
 	seg->mr_base = seg->mr_dma;
-	seg->mr_nsegs = 1;
 	return 1;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
