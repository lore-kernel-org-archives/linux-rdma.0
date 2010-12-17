From: Ali Ayoub <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4_core: avoid vunmap of invalid pointer in allocation
 bad flow
Date: Fri, 17 Dec 2010 15:48:13 -0800
Message-ID: <4D0BF6BD.1060407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

commit 58d180731b22f9483288800cea8a8d6381c48c61
Author: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Fri Dec 10 11:11:55 2010 -0800

    [PATCH] mlx4_core: avoid vunmap of invalid pointer in allocation bad flow
 
    Signed-off-by: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c index ad95d5f..44a64f0 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -214,6 +214,7 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 	} else {
 		int i;

+		buf->direct.buf  = NULL;
 		buf->nbufs       = (size + PAGE_SIZE - 1) / PAGE_SIZE;
 		buf->npages      = buf->nbufs;
 		buf->page_shift  = PAGE_SHIFT;
@@ -265,7 +266,7 @@ void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf)
 		dma_free_coherent(&dev->pdev->dev, size, buf->direct.buf,
 				  buf->direct.map);
 	else {
-		if (BITS_PER_LONG == 64)
+		if (BITS_PER_LONG == 64 && buf->direct.buf)
 			vunmap(buf->direct.buf);

 		for (i = 0; i < buf->nbufs; ++i)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
