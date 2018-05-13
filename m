From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH net] qede: Fix ref-cnt usage count
Date: Sun, 13 May 2018 20:54:06 +0300
Message-ID: <20180513175406.21350-1-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@cavium.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, chad.dupuis@cavium.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <ariel.elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

Rebooting while qedr is loaded with a VLAN interface present
results in unregister_netdevice waiting for the usage count
to become free.
The fix is that rdma devices should be removed before unregistering
the netdevice, to assure all references to ndev are decreased.

Fixes: cee9fbd8e2e9 ("qede: Add qedr framework")
Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
Signed-off-by: Michal Kalderon <michal.kalderon@cavium.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index a01e7d6..f6655e2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1066,13 +1066,12 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 
 	DP_INFO(edev, "Starting qede_remove\n");
 
+	qede_rdma_dev_remove(edev);
 	unregister_netdev(ndev);
 	cancel_delayed_work_sync(&edev->sp_task);
 
 	qede_ptp_disable(edev);
 
-	qede_rdma_dev_remove(edev);
-
 	edev->ops->common->set_power_state(cdev, PCI_D0);
 
 	pci_set_drvdata(pdev, NULL);
-- 
2.9.5
