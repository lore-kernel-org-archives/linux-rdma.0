From: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] RDMA/nes: enable bonds on iw_nes
Date: Wed, 24 Nov 2010 18:29:30 +0100
Message-ID: <20101124172930.14764.20947.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enable configuring bonds on nes devices by adding
missing support for master net_device to the driver

Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/nes/nes.c    |   24 +++++++++++++++++++-----
 drivers/infiniband/hw/nes/nes_cm.c |    8 +++++++-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 0c9f0aa..e17f52c 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -144,6 +144,7 @@ static int nes_inetaddr_event(struct not
 	struct nes_device *nesdev;
 	struct net_device *netdev;
 	struct nes_vnic *nesvnic;
+	unsigned int is_bonded;
 
 	nes_debug(NES_DBG_NETDEV, "nes_inetaddr_event: ip address %pI4, netmask %pI4.\n",
 		  &ifa->ifa_address, &ifa->ifa_mask);
@@ -152,7 +153,8 @@ static int nes_inetaddr_event(struct not
 				nesdev, nesdev->netdev[0]->name);
 		netdev = nesdev->netdev[0];
 		nesvnic = netdev_priv(netdev);
-		if (netdev == event_netdev) {
+		is_bonded = (netdev->master == event_netdev);
+		if ((netdev == event_netdev) || is_bonded) {
 			if (nesvnic->rdma_enabled == 0) {
 				nes_debug(NES_DBG_NETDEV, "Returning without processing event for %s since"
 						" RDMA is not enabled.\n",
@@ -169,7 +171,10 @@ static int nes_inetaddr_event(struct not
 					nes_manage_arp_cache(netdev, netdev->dev_addr,
 							ntohl(nesvnic->local_ipaddr), NES_ARP_DELETE);
 					nesvnic->local_ipaddr = 0;
-					return NOTIFY_OK;
+					if (is_bonded)
+						continue;
+					else
+						return NOTIFY_OK;
 					break;
 				case NETDEV_UP:
 					nes_debug(NES_DBG_NETDEV, "event:UP\n");
@@ -178,15 +183,24 @@ static int nes_inetaddr_event(struct not
 						nes_debug(NES_DBG_NETDEV, "Interface already has local_ipaddr\n");
 						return NOTIFY_OK;
 					}
+					/* fall through */
+				case NETDEV_CHANGEADDR:
 					/* Add the address to the IP table */
-					nesvnic->local_ipaddr = ifa->ifa_address;
+					if (netdev->master)
+						nesvnic->local_ipaddr =
+							((struct in_device *)netdev->master->ip_ptr)->ifa_list->ifa_address;
+					else
+						nesvnic->local_ipaddr = ifa->ifa_address;
 
 					nes_write_indexed(nesdev,
 							NES_IDX_DST_IP_ADDR+(0x10*PCI_FUNC(nesdev->pcidev->devfn)),
-							ntohl(ifa->ifa_address));
+							ntohl(nesvnic->local_ipaddr));
 					nes_manage_arp_cache(netdev, netdev->dev_addr,
 							ntohl(nesvnic->local_ipaddr), NES_ARP_ADD);
-					return NOTIFY_OK;
+					if (is_bonded)
+						continue;
+					else
+						return NOTIFY_OK;
 					break;
 				default:
 					break;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 25ad0f9..009ec81 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1107,6 +1107,7 @@ static int nes_addr_resolve_neigh(struct
 	struct flowi fl;
 	struct neighbour *neigh;
 	int rc = arpindex;
+	struct net_device *netdev;
 	struct nes_adapter *nesadapter = nesvnic->nesdev->nesadapter;
 
 	memset(&fl, 0, sizeof fl);
@@ -1117,7 +1118,12 @@ static int nes_addr_resolve_neigh(struct
 		return rc;
 	}
 
-	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, nesvnic->netdev);
+	if (nesvnic->netdev->master)
+		netdev = nesvnic->netdev->master;
+	else
+		netdev = nesvnic->netdev;
+
+	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, netdev);
 	if (neigh) {
 		if (neigh->nud_state & NUD_VALID) {
 			nes_debug(NES_DBG_CM, "Neighbor MAC address for 0x%08X"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
