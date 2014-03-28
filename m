From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/16] ibacm: add separate acm_ep_insert_addr function
Date: Thu, 27 Mar 2014 22:50:02 -0700
Message-ID: <1395985810-23822-9-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This is in preparation for netlink support which will do this dynamically.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 5dc2684..6bbc1e5 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2875,6 +2875,53 @@ static void acm_parse_hosts_file(struct acm_ep *ep)
 	fclose(f);
 }
 
+static int
+acm_ep_insert_addr(struct acm_ep *ep, uint8_t *addr, size_t addr_len, uint8_t addr_type)
+{
+	int i;
+	int ret = ENOMEM;
+	uint8_t tmp[ACM_MAX_ADDRESS];
+	char name_str[INET6_ADDRSTRLEN];
+
+	if (addr_len > ACM_MAX_ADDRESS)
+		return EINVAL;
+
+	memset(tmp, 0, sizeof tmp);
+	memcpy(tmp, addr, addr_len);
+
+	lock_acquire(&ep->lock);
+	if (acm_addr_index(ep, tmp, addr_type) < 0) {
+		for (i = 0; i < MAX_EP_ADDR; i++) {
+			if (ep->addr_type[i] == ACM_ADDRESS_INVALID) {
+
+				ep->addr_type[i] = addr_type;
+				memcpy(ep->addr[i].addr, tmp, ACM_MAX_ADDRESS);
+
+				switch (addr_type) {
+				case ACM_ADDRESS_IP:
+					inet_ntop(AF_INET, addr, name_str, sizeof name_str);
+					strncpy(ep->name[i], name_str, ACM_MAX_ADDRESS);
+					break;
+				case ACM_ADDRESS_IP6:
+					inet_ntop(AF_INET6, addr, name_str, sizeof name_str);
+					strncpy(ep->name[i], name_str, ACM_MAX_ADDRESS);
+					break;
+				case ACM_ADDRESS_NAME:
+					strncpy(ep->name[i], (const char *)addr, ACM_MAX_ADDRESS);
+					break;
+				}
+
+				ret = 0;
+				break;
+			}
+		}
+	} else {
+		ret = 0;
+	}
+	lock_release(&ep->lock);
+	return ret;
+}
+
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
 	FILE *faddr;
@@ -2883,8 +2930,9 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	char dev[32], addr[INET6_ADDRSTRLEN], pkey_str[8];
 	uint16_t pkey;
 	uint8_t type;
-	int port, index = 0;
+	int port, ret = 0;
 	struct in6_addr ip_addr;
+	size_t addr_len;
 
 	dev_name = ep->port->dev->verbs->device->name;
 	acm_log(1, "device %s, port %d, pkey 0x%x\n",
@@ -2903,12 +2951,16 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 			continue;
 
 		acm_log(2, "%s", s);
-		if (inet_pton(AF_INET, addr, &ip_addr) > 0)
+		if (inet_pton(AF_INET, addr, &ip_addr) > 0) {
 			type = ACM_ADDRESS_IP;
-		else if (inet_pton(AF_INET6, addr, &ip_addr) > 0)
+			addr_len = 4;
+		} else if (inet_pton(AF_INET6, addr, &ip_addr) > 0) {
 			type = ACM_ADDRESS_IP6;
-		else
+			addr_len = ACM_MAX_ADDRESS;
+		} else {
 			type = ACM_ADDRESS_NAME;
+			addr_len = strlen(addr);
+		}
 
 		if (stricmp(pkey_str, "default")) {
 			if (sscanf(pkey_str, "%hx", &pkey) != 1) {
@@ -2922,17 +2974,8 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 		if (!stricmp(dev_name, dev) && (ep->port->port_num == (uint8_t) port) &&
 			(ep->pkey == pkey)) {
 
-			ep->addr_type[index] = type;
 			acm_log(1, "assigning %s\n", addr);
-			strncpy(ep->name[index], addr, ACM_MAX_ADDRESS);
-			if (type == ACM_ADDRESS_IP)
-				memcpy(ep->addr[index].addr, &ip_addr, 4);
-			else if (type == ACM_ADDRESS_IP6)
-				memcpy(ep->addr[index].addr, &ip_addr, sizeof ip_addr);
-			else
-				strncpy((char *) ep->addr[index].addr, addr, ACM_MAX_ADDRESS);
-
-			if (++index == MAX_EP_ADDR) {
+			if ((ret = acm_ep_insert_addr(ep, (uint8_t *)&ip_addr, addr_len, type)) != 0) {
 				acm_log(1, "maximum number of names assigned to EP\n");
 				break;
 			}
@@ -2940,7 +2983,7 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	}
 	fclose(faddr);
 
-	return !index;
+	return ret;
 }
 
 /*
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
