From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] RDMA/amso1100: integer overflow in c2_alloc_cq_buf()
Date: Thu, 17 Jul 2014 10:44:47 +0300
Message-ID: <20140717074447.GA477@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a static checker fix.  The static checker says that q_size comes
from the user and can be any 32 bit value.  The call tree is:
  --> ib_uverbs_create_cq()
      --> c2_create_cq()
          --> c2_init_cq()

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index 49e0e85..1b63185 100644
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
