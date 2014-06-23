From: Joe Perches <joe@perches.com>
Subject: [PATCH 05/22] infiniband: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:33 -0700
Message-ID: <ed5fb1adbe665a8e4a4e18bc316bab261bc55556.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Faisal Latif <faisal.latif@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/amso1100/c2.c   |  6 ++----
 drivers/infiniband/hw/nes/nes_hw.c    | 12 ++++++------
 drivers/infiniband/hw/nes/nes_verbs.c |  5 ++---
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 00400c3..766a71c 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -604,16 +604,14 @@ static int c2_up(struct net_device *netdev)
 	tx_size = c2_port->tx_ring.count * sizeof(struct c2_tx_desc);
 
 	c2_port->mem_size = tx_size + rx_size;
-	c2_port->mem = pci_alloc_consistent(c2dev->pcidev, c2_port->mem_size,
-					    &c2_port->dma);
+	c2_port->mem = pci_zalloc_consistent(c2dev->pcidev, c2_port->mem_size,
+					     &c2_port->dma);
 	if (c2_port->mem == NULL) {
 		pr_debug("Unable to allocate memory for "
 			"host descriptor rings\n");
 		return -ENOMEM;
 	}
 
-	memset(c2_port->mem, 0, c2_port->mem_size);
-
 	/* Create the Rx host descriptor ring */
 	if ((ret =
 	     c2_rx_ring_alloc(&c2_port->rx_ring, c2_port->mem, c2_port->dma,
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 9020024..02120d3 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1003,13 +1003,13 @@ int nes_init_cqp(struct nes_device *nesdev)
 			(sizeof(struct nes_hw_aeqe) * nesadapter->max_qp) +
 			sizeof(struct nes_hw_cqp_qp_context);
 
-	nesdev->cqp_vbase = pci_alloc_consistent(nesdev->pcidev, nesdev->cqp_mem_size,
-			&nesdev->cqp_pbase);
+	nesdev->cqp_vbase = pci_zalloc_consistent(nesdev->pcidev,
+						  nesdev->cqp_mem_size,
+						  &nesdev->cqp_pbase);
 	if (!nesdev->cqp_vbase) {
 		nes_debug(NES_DBG_INIT, "Unable to allocate memory for host descriptor rings\n");
 		return -ENOMEM;
 	}
-	memset(nesdev->cqp_vbase, 0, nesdev->cqp_mem_size);
 
 	/* Allocate a twice the number of CQP requests as the SQ size */
 	nesdev->nes_cqp_requests = kzalloc(sizeof(struct nes_cqp_request) *
@@ -1691,13 +1691,13 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 			(NES_NIC_WQ_SIZE * 2 * sizeof(struct nes_hw_nic_cqe)) +
 			sizeof(struct nes_hw_nic_qp_context);
 
-	nesvnic->nic_vbase = pci_alloc_consistent(nesdev->pcidev, nesvnic->nic_mem_size,
-			&nesvnic->nic_pbase);
+	nesvnic->nic_vbase = pci_zalloc_consistent(nesdev->pcidev,
+						   nesvnic->nic_mem_size,
+						   &nesvnic->nic_pbase);
 	if (!nesvnic->nic_vbase) {
 		nes_debug(NES_DBG_INIT, "Unable to allocate memory for NIC host descriptor rings\n");
 		return -ENOMEM;
 	}
-	memset(nesvnic->nic_vbase, 0, nesvnic->nic_mem_size);
 	nes_debug(NES_DBG_INIT, "Allocated NIC QP structures at %p (phys = %016lX), size = %u.\n",
 			nesvnic->nic_vbase, (unsigned long)nesvnic->nic_pbase, nesvnic->nic_mem_size);
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 218dd35..fef067c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1616,8 +1616,8 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 				entries, nescq->cq_mem_size, nescq->hw_cq.cq_number);
 
 		/* allocate the physical buffer space */
-		mem = pci_alloc_consistent(nesdev->pcidev, nescq->cq_mem_size,
-				&nescq->hw_cq.cq_pbase);
+		mem = pci_zalloc_consistent(nesdev->pcidev, nescq->cq_mem_size,
+					    &nescq->hw_cq.cq_pbase);
 		if (!mem) {
 			printk(KERN_ERR PFX "Unable to allocate pci memory for cq\n");
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
@@ -1625,7 +1625,6 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 			return ERR_PTR(-ENOMEM);
 		}
 
-		memset(mem, 0, nescq->cq_mem_size);
 		nescq->hw_cq.cq_vbase = mem;
 		nescq->hw_cq.cq_head = 0;
 		nes_debug(NES_DBG_CQ, "CQ%u virtual address @ %p, phys = 0x%08X\n",
-- 
1.8.1.2.459.gbcd45b4.dirty
