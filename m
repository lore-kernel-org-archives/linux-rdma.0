From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 13/15] IB/usnic: Handle NETDEV_CHANGE
Date: Fri, 20 Dec 2013 12:26:44 -0800
Message-ID: <1387571206-8043-14-git-send-email-umalhi@cisco.com>
References: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571206-8043-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC netdev notifier handler does not correctly handle the
NETDEV_CHANGE event.  This patch adds handling for NETDEV_CHANGE.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 1cf22d5..ae4e544 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -148,20 +148,16 @@ static void usnic_ib_handle_usdev_event(struct usnic_ib_dev *us_ibdev,
 		ib_dispatch_event(&ib_event);
 		break;
 	case NETDEV_UP:
-		if (!us_ibdev->link_up) {
+	case NETDEV_DOWN:
+	case NETDEV_CHANGE:
+		if (!us_ibdev->link_up && netif_carrier_ok(netdev)) {
 			us_ibdev->link_up = true;
 			usnic_info("Link UP on %s\n", us_ibdev->ib_dev.name);
 			ib_event.event = IB_EVENT_PORT_ACTIVE;
 			ib_event.device = &us_ibdev->ib_dev;
 			ib_event.element.port_num = 1;
 			ib_dispatch_event(&ib_event);
-		} else {
-			usnic_dbg("Ignorning Link UP on %s\n",
-					us_ibdev->ib_dev.name);
-		}
-		break;
-	case NETDEV_DOWN:
-		if (us_ibdev->link_up) {
+		} else if (us_ibdev->link_up && !netif_carrier_ok(netdev)) {
 			us_ibdev->link_up = false;
 			usnic_info("Link DOWN on %s\n", us_ibdev->ib_dev.name);
 			usnic_ib_qp_grp_modify_active_to_err(us_ibdev);
@@ -170,7 +166,8 @@ static void usnic_ib_handle_usdev_event(struct usnic_ib_dev *us_ibdev,
 			ib_event.element.port_num = 1;
 			ib_dispatch_event(&ib_event);
 		} else {
-			usnic_dbg("Ignorning Link DOWN on %s\n",
+			usnic_dbg("Ignorning %s on %s\n",
+					usnic_ib_netdev_event_to_string(event),
 					us_ibdev->ib_dev.name);
 		}
 		break;
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
