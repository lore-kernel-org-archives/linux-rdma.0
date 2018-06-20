From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V2 2/5] IB/hfi1: use pci_reset_bus() for initiating pci
 secondary bus reset
Date: Wed, 20 Jun 2018 00:12:55 -0400
Message-ID: <1529467995-28780-2-git-send-email-okaya@codeaurora.org>
References: <1529467995-28780-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1529467995-28780-1-git-send-email-okaya@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-pci@vger.kernel.org, timur@codeaurora.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, open list <linux-kernel@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

Getting ready to hide pci_reset_bridge_secondary_bus() from the drivers.
pci_reset_bridge_secondary_bus() should only be used internally by the
PCI code itself.

Other drivers should rely on higher level pci_reset_xxx() API.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/hfi1/pcie.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 4d4371b..a6d695a 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -905,9 +905,7 @@ static int trigger_sbr(struct hfi1_devdata *dd)
 	 * delay after a reset is required.  Per spec requirements,
 	 * the link is either working or not after that point.
 	 */
-	pci_reset_bridge_secondary_bus(dev->bus->self);
-
-	return 0;
+	return pci_reset_bus(dev->bus);
 }
 
 /*
-- 
2.7.4
