From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 11/14] ibacm: add/remove addr's in EP's when added/removed from the system.
Date: Thu,  3 Apr 2014 20:51:51 -0400
Message-ID: <1396572714-16498-12-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This builds on the previous patch by reacting to the IP address changes
monitored there.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |  188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 184 insertions(+), 4 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 45f3ed9..a6e24a9 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -796,6 +796,27 @@ out:
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
@@ -2393,6 +2414,85 @@ out:
 		acm_disconnect_client(client);
 }
 
+static struct acm_device *
+acm_get_device_from_gid(union ibv_gid *sgid, uint8_t *port);
+static struct acm_ep *acm_find_ep(struct acm_port *port, uint16_t pkey);
+static int
+acm_ep_insert_addr(struct acm_ep *ep, uint8_t *addr, size_t addr_len, uint8_t addr_type);
+
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
+		if (acm_ep_insert_addr(ep, data->info.addr, sizeof data->info.addr, data->type))
+			acm_log(0, "Failed to add '%s' to EP\n", log_data);
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
 static int acm_ipnl_create(void)
 {
 	struct sockaddr_nl addr;
@@ -2414,6 +2514,72 @@ static int acm_ipnl_create(void)
 	return 0;
 }
 
+static void acm_ip_iter_cb(char *ifname, union ibv_gid *gid, uint16_t pkey,
+		uint8_t addr_type, uint8_t *addr, size_t addr_len,
+		char *addr_name, void *ctx)
+{
+	int ret = EINVAL;
+	struct acm_device *dev = NULL;
+	struct acm_ep *ep = NULL;
+	uint8_t port_num;
+	char gid_str[INET6_ADDRSTRLEN];
+
+	dev = acm_get_device_from_gid(gid, &port_num);
+	if (dev)
+		ep = acm_find_ep(&dev->port[port_num-1], pkey);
+
+	if (ep)
+		ret = acm_ep_insert_addr(ep, addr, addr_len, addr_type);
+
+	if (ret) {
+		acm_format_name(2, log_data, sizeof log_data,
+			addr_type, addr, addr_len);
+		inet_ntop(AF_INET6, gid->raw, gid_str, sizeof(gid_str));
+		acm_log(0, "Failed to add '%s' (gid %s; pkey 0x%x)\n",
+			log_data, gid_str, pkey);
+	}
+}
+
+/* Netlink updates have indicated a failure which means we are no longer in
+ * sync.  This should be a rare condition so we handle this with a "big
+ * hammer" by clearing and re-reading all the system IP's.
+ */
+static int resync_system_ips(void)
+{
+	DLIST_ENTRY *dev_entry;
+	struct acm_device *dev;
+	int cnt;
+
+	acm_log(0, "Resyncing all IP's\n");
+
+	/* mark all IP's invalid */
+	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
+	     dev_entry = dev_entry->Next) {
+		struct acm_ep *ep = NULL;
+		DLIST_ENTRY *entry;
+
+		dev = container_of(dev_entry, struct acm_device, entry);
+
+		for (cnt = 0; cnt < dev->port_cnt; cnt++) {
+			struct acm_port *port = &dev->port[cnt];
+
+			for (entry = port->ep_list.Next; entry != &port->ep_list;
+			     entry = entry->Next) {
+				int i;
+
+				ep = container_of(entry, struct acm_ep, entry);
+				for (i = 0; i < MAX_EP_ADDR; i++) {
+					if (ep->addr_type[i] == ACM_ADDRESS_IP
+					    || ep->addr_type[i] == ACM_ADDRESS_IP6)
+						ep->addr_type[i] = ACM_ADDRESS_INVALID;
+				}
+			}
+		}
+	}
+
+	return acm_if_iter_sys(acm_ip_iter_cb, NULL);
+}
+
 #define NL_MSG_BUF_SIZE 4096
 static void acm_ipnl_handler(void)
 {
@@ -2422,6 +2588,7 @@ static void acm_ipnl_handler(void)
 	struct nlmsghdr *nlh;
 	char name[IFNAMSIZ];
 	char ip_str[INET6_ADDRSTRLEN];
+	struct acm_ep_addr_data ad;
 
 	while ((len = recv(ip_mon_socket, buffer, NL_MSG_BUF_SIZE, 0)) > 0) {
 		nlh = (struct nlmsghdr *)buffer;
@@ -2437,9 +2604,14 @@ static void acm_ipnl_handler(void)
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
@@ -2450,9 +2622,14 @@ static void acm_ipnl_handler(void)
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
@@ -2475,8 +2652,11 @@ static void acm_ipnl_handler(void)
 			nlh = NLMSG_NEXT(nlh, len);
 		}
 	}
-	if (len < 0 && errno == ENOBUFS)
-		acm_log(0, "ENOBUFS returned from netlink... Resyncing all IP's\n");
+
+	if (len < 0 && errno == ENOBUFS) {
+		acm_log(0, "ENOBUFS returned from netlink...\n");
+		resync_system_ips();
+	}
 }
 
 static void acm_server(void)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
