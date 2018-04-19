From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Thu, 19 Apr 2018 15:56:23 -0400
Message-ID: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

The infiniband adapter might be connected to a PCI hotplug slot. Performing
secondary bus reset on a hotplug slot causes PCI link up/down interrupts.

Hotplug driver removes the device from system when a link down interrupt
is observed and performs re-enumeration when link up interrupt is observed.

This conflicts with what this code is trying to do. Try secondary bus reset
only if pci_reset_slot() fails/unsupported.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/hfi1/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 83d66e8..75f49e3 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -908,7 +908,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
 	 * delay after a reset is required.  Per spec requirements,
 	 * the link is either working or not after that point.
 	 */
-	pci_reset_bridge_secondary_bus(dev->bus->self);
+	if (pci_reset_slot(dev->slot))
+		pci_reset_bridge_secondary_bus(dev->bus->self);
 
 	return 0;
 }
-- 
2.7.4
