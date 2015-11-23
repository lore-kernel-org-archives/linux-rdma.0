From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 8/8] svcrdma: Remove svc_rdma_fastreg_mr::access_flags
 field
Date: Mon, 23 Nov 2015 17:21:18 -0500
Message-ID: <20151123222118.13040.24258.stgit@klimt.1015granger.net>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151123221738.13040.26277.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: The access_flags field is not used outside of
rdma_read_chunk_frmr() and is always set to the same value.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h         |    1 -
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 243edf4..eee2a0d 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -107,7 +107,6 @@ struct svc_rdma_fastreg_mr {
 	struct ib_mr *mr;
 	struct scatterlist *sg;
 	int sg_nents;
-	unsigned long access_flags;
 	enum dma_data_direction direction;
 	struct list_head frmr_list;
 };
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 9480043..8ab1ab5 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -240,7 +240,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	read = min_t(int, (nents << PAGE_SHIFT) - *page_offset, rs_length);
 
 	frmr->direction = DMA_FROM_DEVICE;
-	frmr->access_flags = (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRITE);
 	frmr->sg_nents = nents;
 
 	for (pno = 0; pno < nents; pno++) {
@@ -308,7 +307,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = frmr->mr;
 	reg_wr.key = frmr->mr->lkey;
-	reg_wr.access = frmr->access_flags;
+	reg_wr.access = (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRITE);
 	reg_wr.wr.next = &read_wr.wr;
 
 	/* Prepare RDMA_READ */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
