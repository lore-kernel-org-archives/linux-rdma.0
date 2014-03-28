From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/16] ibacm: add/remove addr's in EP's when added/removed from the system.
Date: Thu, 27 Mar 2014 22:50:06 -0700
Message-ID: <1395985810-23822-13-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This builds on the previous patch by reacting to the IP address changes
monitored there.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index a23e953..a83dc22 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -795,6 +795,27 @@ out:
 	lock_release(&ep->lock);
 }
 
+static void acm_mark_addr_invalid(struct acm_ep *ep,
+				  struct acm_ep_addr_data *data)
+{
+	int i;
+
+	lock_acquire(&ep->lock);
+	for (i = 0; i < MAX_EP_ADDR; i++) {
+		if (ep->addr_type[i] != data->type)
+			continue;
+
+		if ((data->type == ACM_ADDRESS_NAME &&
+		    !strnicmp((char *) ep->addr[i].name,
+			      (char *) data->info.addr, ACM_MAX_ADDRESS)) ||
+		     !memcmp(ep->addr[i].addr, data->info.addr, ACM_MAX_ADDRESS)) {
+			ep->addr_type[i] = ACM_ADDRESS_INVALID;
+			break;
+		}
+	}
+	lock_release(&ep->lock);
+}
+
 static int acm_addr_index(struct acm_ep *ep, uint8_t *addr, uint8_t addr_type)
 {
 	int i;
@@ -3371,6 +3392,82 @@ static void acm_port_down(struct acm_port *port)
 	acm_log(1, "%s %d is down\n", port->dev->verbs->device->name, port->port_num);
 }
 
+static int acm_nl_to_addr_data(struct acm_ep_addr_data *ad,
+				  int af_family, uint8_t *addr, size_t addr_len)
+{
+	if (addr_len > ACM_MAX_ADDRESS)
+		return EINVAL;
+
+	/* find the ep associated with this address "if any" */
+	switch (af_family) {
+	case AF_INET:
+		ad->type = ACM_ADDRESS_IP;
+		break;
+	case AF_INET6:
+		ad->type = ACM_ADDRESS_IP6;
+		break;
+	default:
+		return EINVAL;
+	}
+	memcpy(&ad->info.addr, addr, addr_len);
+	return 0;
+}
+
+static void acm_add_ep_ip(struct acm_ep_addr_data *data, char *ifname)
+{
+	struct acm_ep *ep;
+	struct acm_device *dev;
+	uint8_t port_num;
+	uint16_t pkey;
+	union ibv_gid sgid;
+
+	ep = acm_get_ep(data);
+	if (ep) {
+		acm_format_name(1, log_data, sizeof log_data,
+				data->type, data->info.addr, sizeof data->info.addr);
+		acm_log(1, "Address '%s' already available\n", log_data);
+		return;
+	}
+
+	if (acm_if_get_sgid(ifname, &sgid))
+		return;
+
+	dev = acm_get_device_from_gid(&sgid, &port_num);
+	if (!dev)
+		return;
+
+	if (acm_if_get_pkey(ifname, &pkey))
+		return;
+
+	acm_format_name(0, log_data, sizeof log_data,
+			data->type, data->info.addr, sizeof data->info.addr);
+	acm_log(0, " %s\n", log_data);
+
+	ep = acm_find_ep(&dev->port[port_num-1], pkey);
+	if (ep) {
+		if (acm_ep_insert_addr(ep, data->info.addr, sizeof data->info.addr, data->type)) {
+			acm_format_name(0, log_data, sizeof log_data,
+					data->type, data->info.addr, sizeof data->info.addr);
+			acm_log(0, "Failed to add '%s' to EP\n", log_data);
+		}
+	} else {
+		acm_log(0, "Failed to add '%s' no EP for pkey\n", log_data);
+	}
+}
+
+static void acm_rm_ep_ip(struct acm_ep_addr_data *data)
+{
+	struct acm_ep *ep;
+
+	ep = acm_get_ep(data);
+	if (ep) {
+		acm_format_name(0, log_data, sizeof log_data,
+				data->type, data->info.addr, sizeof data->info.addr);
+		acm_log(0, " %s\n", log_data);
+		acm_mark_addr_invalid(ep, data);
+	}
+}
+
 
 #define NL_MSG_BUF_SIZE 4096
 static void CDECL_FUNC acm_ipnl_handler(void *context)
@@ -3403,6 +3500,7 @@ static void CDECL_FUNC acm_ipnl_handler(void *context)
 			struct ifinfomsg *ifi = (struct ifinfomsg *) NLMSG_DATA(nlh);
 			struct rtattr *rth = IFA_RTA(ifa);
 			int rtl = IFA_PAYLOAD(nlh);
+			struct acm_ep_addr_data ad;
 
 			switch (nlh->nlmsg_type) {
 			case RTM_NEWADDR:
@@ -3410,9 +3508,14 @@ static void CDECL_FUNC acm_ipnl_handler(void *context)
 				if_indextoname(ifa->ifa_index, name);
 				while (rtl && RTA_OK(rth, rtl)) {
 					if (rth->rta_type == IFA_LOCAL) {
-						acm_log(0, "Address added %s : %s\n",
+						acm_log(1, "New system address available %s : %s\n",
 						        name, inet_ntop(ifa->ifa_family, RTA_DATA(rth),
 							ip_str, sizeof(ip_str)));
+						if (!acm_nl_to_addr_data(&ad, ifa->ifa_family,
+								      RTA_DATA(rth),
+								      RTA_PAYLOAD(rth))) {
+							acm_add_ep_ip(&ad, name);
+						}
 					}
 					rth = RTA_NEXT(rth, rtl);
 				}
@@ -3423,9 +3526,14 @@ static void CDECL_FUNC acm_ipnl_handler(void *context)
 				if_indextoname(ifa->ifa_index, name);
 				while (rtl && RTA_OK(rth, rtl)) {
 					if (rth->rta_type == IFA_LOCAL) {
-						acm_log(0, "Address deleted %s : %s\n",
+						acm_log(1, "System address removed %s : %s\n",
 						        name, inet_ntop(ifa->ifa_family, RTA_DATA(rth),
 							ip_str, sizeof(ip_str)));
+						if (!acm_nl_to_addr_data(&ad, ifa->ifa_family,
+								      RTA_DATA(rth),
+								      RTA_PAYLOAD(rth))) {
+							acm_rm_ep_ip(&ad);
+						}
 					}
 					rth = RTA_NEXT(rth, rtl);
 				}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
