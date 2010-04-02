From: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] RDMA/amso1100: use the dma state API instead of the pci
 equivalents
Date: Fri, 2 Apr 2010 13:29:41 +0900
Message-ID: <20100402132901M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The DMA API is preferred.

No functional change.

Signed-off-by: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2.h          |    2 +-
 drivers/infiniband/hw/amso1100/c2_alloc.c    |    4 ++--
 drivers/infiniband/hw/amso1100/c2_cq.c       |    4 ++--
 drivers/infiniband/hw/amso1100/c2_mq.h       |    2 +-
 drivers/infiniband/hw/amso1100/c2_provider.h |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c     |   12 ++++++------
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index f7ff66f..6ae698e 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -250,7 +250,7 @@ struct c2_array {
 struct sp_chunk {
 	struct sp_chunk *next;
 	dma_addr_t dma_addr;
-	DECLARE_PCI_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	u16 head;
 	u16 shared_ptr[0];
 };
diff --git a/drivers/infiniband/hw/amso1100/c2_alloc.c b/drivers/infiniband/hw/amso1100/c2_alloc.c
index e911016..31b5a7b 100644
--- a/drivers/infiniband/hw/amso1100/c2_alloc.c
+++ b/drivers/infiniband/hw/amso1100/c2_alloc.c
@@ -50,7 +50,7 @@ static int c2_alloc_mqsp_chunk(struct c2_dev *c2dev, gfp_t gfp_mask,
 		return -ENOMEM;
 
 	new_head->dma_addr = dma_addr;
-	pci_unmap_addr_set(new_head, mapping, new_head->dma_addr);
+	dma_unmap_addr_set(new_head, mapping, new_head->dma_addr);
 
 	new_head->next = NULL;
 	new_head->head = 0;
@@ -82,7 +82,7 @@ void c2_free_mqsp_pool(struct c2_dev *c2dev, struct sp_chunk *root)
 	while (root) {
 		next = root->next;
 		dma_free_coherent(&c2dev->pcidev->dev, PAGE_SIZE, root,
-				  pci_unmap_addr(root, mapping));
+				  dma_unmap_addr(root, mapping));
 		root = next;
 	}
 }
diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index f5c45b1..17b9663 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -255,7 +255,7 @@ int c2_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 static void c2_free_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq)
 {
 	dma_free_coherent(&c2dev->pcidev->dev, mq->q_size * mq->msg_size,
-			  mq->msg_pool.host, pci_unmap_addr(mq, mapping));
+			  mq->msg_pool.host, dma_unmap_addr(mq, mapping));
 }
 
 static int c2_alloc_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq, int q_size,
@@ -276,7 +276,7 @@ static int c2_alloc_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq, int q_size,
 		       NULL,	/* peer (currently unknown) */
 		       C2_MQ_HOST_TARGET);
 
-	pci_unmap_addr_set(mq, mapping, mq->host_dma);
+	dma_unmap_addr_set(mq, mapping, mq->host_dma);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/amso1100/c2_mq.h b/drivers/infiniband/hw/amso1100/c2_mq.h
index acede00..fc1b9a7 100644
--- a/drivers/infiniband/hw/amso1100/c2_mq.h
+++ b/drivers/infiniband/hw/amso1100/c2_mq.h
@@ -71,7 +71,7 @@ struct c2_mq {
 		u8 __iomem *adapter;
 	} msg_pool;
 	dma_addr_t host_dma;
-	DECLARE_PCI_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	u16 hint_count;
 	u16 priv;
 	struct c2_mq_shared __iomem *peer;
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.h b/drivers/infiniband/hw/amso1100/c2_provider.h
index 1076df2..bf18998 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.h
+++ b/drivers/infiniband/hw/amso1100/c2_provider.h
@@ -50,7 +50,7 @@
 
 struct c2_buf_list {
 	void *buf;
-	 DECLARE_PCI_UNMAP_ADDR(mapping)
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 };
 
 
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index dd05c48..a2e863c 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -523,7 +523,7 @@ int __devinit c2_rnic_init(struct c2_dev *c2dev)
 		err = -ENOMEM;
 		goto bail1;
 	}
-	pci_unmap_addr_set(&c2dev->rep_vq, mapping, c2dev->rep_vq.host_dma);
+	dma_unmap_addr_set(&c2dev->rep_vq, mapping, c2dev->rep_vq.host_dma);
 	pr_debug("%s rep_vq va %p dma %llx\n", __func__, q1_pages,
 		 (unsigned long long) c2dev->rep_vq.host_dma);
 	c2_mq_rep_init(&c2dev->rep_vq,
@@ -544,7 +544,7 @@ int __devinit c2_rnic_init(struct c2_dev *c2dev)
 		err = -ENOMEM;
 		goto bail2;
 	}
-	pci_unmap_addr_set(&c2dev->aeq, mapping, c2dev->aeq.host_dma);
+	dma_unmap_addr_set(&c2dev->aeq, mapping, c2dev->aeq.host_dma);
 	pr_debug("%s aeq va %p dma %llx\n", __func__, q2_pages,
 		 (unsigned long long) c2dev->aeq.host_dma);
 	c2_mq_rep_init(&c2dev->aeq,
@@ -595,11 +595,11 @@ int __devinit c2_rnic_init(struct c2_dev *c2dev)
       bail3:
 	dma_free_coherent(&c2dev->pcidev->dev,
 			  c2dev->aeq.q_size * c2dev->aeq.msg_size,
-			  q2_pages, pci_unmap_addr(&c2dev->aeq, mapping));
+			  q2_pages, dma_unmap_addr(&c2dev->aeq, mapping));
       bail2:
 	dma_free_coherent(&c2dev->pcidev->dev,
 			  c2dev->rep_vq.q_size * c2dev->rep_vq.msg_size,
-			  q1_pages, pci_unmap_addr(&c2dev->rep_vq, mapping));
+			  q1_pages, dma_unmap_addr(&c2dev->rep_vq, mapping));
       bail1:
 	c2_free_mqsp_pool(c2dev, c2dev->kern_mqsp_pool);
       bail0:
@@ -636,13 +636,13 @@ void __devexit c2_rnic_term(struct c2_dev *c2dev)
 	dma_free_coherent(&c2dev->pcidev->dev,
 			  c2dev->aeq.q_size * c2dev->aeq.msg_size,
 			  c2dev->aeq.msg_pool.host,
-			  pci_unmap_addr(&c2dev->aeq, mapping));
+			  dma_unmap_addr(&c2dev->aeq, mapping));
 
 	/* Free the verbs reply queue */
 	dma_free_coherent(&c2dev->pcidev->dev,
 			  c2dev->rep_vq.q_size * c2dev->rep_vq.msg_size,
 			  c2dev->rep_vq.msg_pool.host,
-			  pci_unmap_addr(&c2dev->rep_vq, mapping));
+			  dma_unmap_addr(&c2dev->rep_vq, mapping));
 
 	/* Free the MQ shared pointer pool */
 	c2_free_mqsp_pool(c2dev, c2dev->kern_mqsp_pool);
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
