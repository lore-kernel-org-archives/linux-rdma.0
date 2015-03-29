From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 4/4] cxgb4: Drop unneeded cast on netdev_priv
Date: Sun, 29 Mar 2015 14:54:15 +0200
Message-ID: <1427633655-32103-4-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The result of netdev_priv is already implicitly cast to the type of the
left side of the assignment.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
@@

x = 
- (T *)
  netdev_priv(...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/cxgb4/cm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3677,14 +3677,14 @@ static int rx_pkt(struct c4iw_dev *dev,
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
 				    pdev, 0);
-		pi = (struct port_info *)netdev_priv(pdev);
+		pi = netdev_priv(pdev);
 		tx_chan = cxgb4_port_chan(pdev);
 		dev_put(pdev);
 	} else {
 		pdev = get_real_dev(neigh->dev);
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
 					pdev, 0);
-		pi = (struct port_info *)netdev_priv(pdev);
+		pi = netdev_priv(pdev);
 		tx_chan = cxgb4_port_chan(pdev);
 	}
 	neigh_release(neigh);
