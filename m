From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH] IB/nes: fix nes_netdev_start_xmit()'s return type
Date: Tue, 24 Apr 2018 15:15:45 +0200
Message-ID: <20180424131545.2810-1-luc.vanoostenryck@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/infiniband/hw/nes/nes_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 0a75164ce..007d5e8a0 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -461,7 +461,7 @@ static bool nes_nic_send(struct sk_buff *skb, struct net_device *netdev)
 /**
  * nes_netdev_start_xmit
  */
-static int nes_netdev_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t nes_netdev_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct nes_vnic *nesvnic = netdev_priv(netdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
-- 
2.17.0
