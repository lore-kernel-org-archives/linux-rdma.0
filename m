From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Receive netdev events post INET_NOTIFIER state
Date: Fri, 17 Mar 2017 18:30:07 -0500
Message-ID: <20170317233007.16768-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Netdev notification events are de-registered only when all
client iwdev instances are removed. If a single client is closed
and re-opened, netdev events could arrive even before the Control
Queue-Pair (CQP) is created, causing a NULL pointer dereference crash
in i40iw_get_cqp_request. Fix this by allowing netdev event
notification only after we have reached the INET_NOTIFIER state with
respect to device initialization.

Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index d5f5de2..23df3ab 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -159,6 +159,9 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 		return NOTIFY_DONE;
 
 	iwdev = &hdl->device;
+	if (iwdev->init_state < INET_NOTIFIER)
+		return NOTIFY_DONE;
+
 	netdev = iwdev->ldev->netdev;
 	upper_dev = netdev_master_upper_dev_get(netdev);
 	if (netdev != event_netdev)
@@ -231,6 +234,9 @@ int i40iw_inet6addr_event(struct notifier_block *notifier,
 		return NOTIFY_DONE;
 
 	iwdev = &hdl->device;
+	if (iwdev->init_state < INET_NOTIFIER)
+		return NOTIFY_DONE;
+
 	netdev = iwdev->ldev->netdev;
 	if (netdev != event_netdev)
 		return NOTIFY_DONE;
@@ -280,6 +286,8 @@ int i40iw_net_event(struct notifier_block *notifier, unsigned long event, void *
 		if (!iwhdl)
 			return NOTIFY_DONE;
 		iwdev = &iwhdl->device;
+		if (iwdev->init_state < INET_NOTIFIER)
+			return NOTIFY_DONE;
 		p = (__be32 *)neigh->primary_key;
 		i40iw_copy_ip_ntohl(local_ipaddr, p);
 		if (neigh->nud_state & NUD_VALID) {
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
