From: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: fix hazard of sending ibevent for unregistered
	device
Date: Tue, 25 Jan 2011 14:49:16 +0100
Message-ID: <20110125134916.6532.63603.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

nes_port_ibevent() should not be called when nes IB device
is not registered with IB core.
Add missing checks of of_device_registered flag.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes_hw.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 8b606fd..08c1948 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2610,9 +2610,11 @@ static void nes_process_mac_intr(struct 
 					netif_carrier_on(nesvnic->netdev);
 
 					spin_lock(&nesvnic->port_ibevent_lock);
-					if (nesdev->iw_status == 0) {
-						nesdev->iw_status = 1;
-						nes_port_ibevent(nesvnic);
+					if (nesvnic->of_device_registered) {
+						if (nesdev->iw_status == 0) {
+							nesdev->iw_status = 1;
+							nes_port_ibevent(nesvnic);
+						}
 					}
 					spin_unlock(&nesvnic->port_ibevent_lock);
 				}
@@ -2642,9 +2644,11 @@ static void nes_process_mac_intr(struct 
 					netif_carrier_off(nesvnic->netdev);
 
 					spin_lock(&nesvnic->port_ibevent_lock);
-					if (nesdev->iw_status == 1) {
-						nesdev->iw_status = 0;
-						nes_port_ibevent(nesvnic);
+					if (nesvnic->of_device_registered) {
+						if (nesdev->iw_status == 1) {
+							nesdev->iw_status = 0;
+							nes_port_ibevent(nesvnic);
+						}
 					}
 					spin_unlock(&nesvnic->port_ibevent_lock);
 				}
@@ -2703,9 +2707,11 @@ void nes_recheck_link_status(struct work
 				netif_carrier_on(nesvnic->netdev);
 
 				spin_lock(&nesvnic->port_ibevent_lock);
-				if (nesdev->iw_status == 0) {
-					nesdev->iw_status = 1;
-					nes_port_ibevent(nesvnic);
+				if (nesvnic->of_device_registered) {
+					if (nesdev->iw_status == 0) {
+						nesdev->iw_status = 1;
+						nes_port_ibevent(nesvnic);
+					}
 				}
 				spin_unlock(&nesvnic->port_ibevent_lock);
 			}
@@ -2723,9 +2729,11 @@ void nes_recheck_link_status(struct work
 				netif_carrier_off(nesvnic->netdev);
 
 				spin_lock(&nesvnic->port_ibevent_lock);
-				if (nesdev->iw_status == 1) {
-					nesdev->iw_status = 0;
-					nes_port_ibevent(nesvnic);
+				if (nesvnic->of_device_registered) {
+					if (nesdev->iw_status == 1) {
+						nesdev->iw_status = 0;
+						nes_port_ibevent(nesvnic);
+					}
 				}
 				spin_unlock(&nesvnic->port_ibevent_lock);
 			}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
