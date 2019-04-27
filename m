From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 49/79] RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove
Date: Fri, 26 Apr 2019 21:38:08 -0400
Message-ID: <20190427013838.6596-49-sashal@kernel.org>
References: <20190427013838.6596-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190427013838.6596-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kamal Heib <kamalheib1@gmail.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit ea7a5c706fa49273cf6d1d9def053ecb50db2076 ]

Make sure to free the DSR on pvrdma_pci_remove() to avoid the memory leak.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Acked-by: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 39c37b6fd715..76b8dda40edd 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -1125,6 +1125,8 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
 	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
 	pvrdma_free_slots(dev);
+	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
+			  dev->dsrbase);
 
 	iounmap(dev->regs);
 	kfree(dev->sgid_tbl);
-- 
2.19.1
