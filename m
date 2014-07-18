From: Benoit Taine <benoit.taine@lip6.fr>
Subject: [PATCH 13/25] IB/mlx5: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:27:00 +0200
Message-ID: <1405697232-11785-14-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Eli Cohen <eli@mellanox.com>
Cc: benoit.taine@lip6.fr, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/infiniband/hw/mlx5/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 364d4b6..60f8155 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1515,7 +1515,7 @@ static void remove_one(struct pci_dev *pdev)
 	ib_dealloc_device(&dev->ib_dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(mlx5_ib_pci_table) = {
+static const struct pci_device_id mlx5_ib_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 4113) }, /* MT4113 Connect-IB */
 	{ 0, }
 };
