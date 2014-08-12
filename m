From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/8] RDMA/amso1100: integer overflow in c2_alloc_cq_buf()
Date: Tue, 12 Aug 2014 19:20:04 -0400
Message-ID: <1848ee41c745f136ddd258dd0e21c1bc05e98f44.1407885084.git.dledford@redhat.com>
References: <cover.1407885084.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

This is a static checker fix.  The static checker says that q_size comes
from the user and can be any 32 bit value.  The call tree is:
  --> ib_uverbs_create_cq()
      --> c2_create_cq()
          --> c2_init_cq()

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_cq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index 49e0e8533f7..1b63185b4ad 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -260,11 +260,14 @@ static void c2_free_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq)
 			  mq->msg_pool.host, dma_unmap_addr(mq, mapping));
 }
 
-static int c2_alloc_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq, int q_size,
-			   int msg_size)
+static int c2_alloc_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq,
+			   size_t q_size, size_t msg_size)
 {
 	u8 *pool_start;
 
+	if (q_size > SIZE_MAX / msg_size)
+		return -EINVAL;
+
 	pool_start = dma_alloc_coherent(&c2dev->pcidev->dev, q_size * msg_size,
 					&mq->host_dma, GFP_KERNEL);
 	if (!pool_start)
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
