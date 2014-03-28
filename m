From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 15/16] ibacm: remove acm_if_iter_sys function
Date: Thu, 27 Mar 2014 22:50:09 -0700
Message-ID: <1395985810-23822-16-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The use of this function and the callback mechanism it used is now unnecessary
since ib_acme does not scan for IP's

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c      |  102 +++++++++++++++++++++++++++++++++++++++++++++++---------
 src/acm_util.c |   84 ----------------------------------------------
 src/acm_util.h |    5 ---
 3 files changed, 86 insertions(+), 105 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index a83dc22..651ccdd 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2990,28 +2990,98 @@ acm_get_device_from_gid(union ibv_gid *sgid, uint8_t *port)
 	return NULL;
 }
 
-static void acm_ip_iter_cb(char *ifname, union ibv_gid *gid, uint16_t pkey,
-		uint8_t addr_type, uint8_t *addr, size_t addr_len,
-		char *addr_name, void *ctx)
+static int acm_get_system_ips(struct acm_ep *ep)
 {
+	struct ifconf *ifc;
+	struct ifreq *ifr;
+	char ip[INET6_ADDRSTRLEN];
+	int s, ret, i, len;
+	uint16_t pkey;
+	union ibv_gid sgid;
+	uint8_t addr_type;
+	uint8_t addr[ACM_MAX_ADDRESS];
+	size_t addr_len;
+	char *alias_sep;
 	uint8_t port_num;
 	struct acm_device *dev;
-	struct acm_ep *ep = (struct acm_ep *)ctx;
-
-	dev = acm_get_device_from_gid(gid, &port_num);
-	if (dev && ep->port->dev == dev
-	    && ep->port->port_num == port_num && ep->pkey == pkey) {
-		if (!acm_ep_insert_addr(ep, addr, addr_len, addr_type)) {
-			acm_log(0, "Added %s %s %d 0x%x from %s\n", addr_name,
-				dev->verbs->device->name, port_num, pkey,
-				ifname);
+
+	s = socket(AF_INET6, SOCK_DGRAM, 0);
+	if (!s)
+		return -1;
+
+	len = sizeof(*ifc) + sizeof(*ifr) * 64;
+	ifc = malloc(len);
+	if (!ifc) {
+		ret = -1;
+		goto out1;
+	}
+
+	memset(ifc, 0, len);
+	ifc->ifc_len = len;
+	ifc->ifc_req = (struct ifreq *) (ifc + 1);
+
+	ret = ioctl(s, SIOCGIFCONF, ifc);
+	if (ret < 0) {
+		acm_log(0, "ioctl ifconf error %d\n", ret);
+		goto out2;
+	}
+
+	ifr = ifc->ifc_req;
+	for (i = 0; i < ifc->ifc_len / sizeof(struct ifreq); i++) {
+		switch (ifr[i].ifr_addr.sa_family) {
+		case AF_INET:
+			addr_type = ACM_ADDRESS_IP;
+			memcpy(&addr, &((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, sizeof addr);
+			addr_len = 4;
+			inet_ntop(ifr[i].ifr_addr.sa_family,
+				&((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, ip, sizeof ip);
+			break;
+		case AF_INET6:
+			addr_type = ACM_ADDRESS_IP6;
+			memcpy(&addr, &((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, sizeof addr);
+			addr_len = ACM_MAX_ADDRESS;
+			inet_ntop(ifr[i].ifr_addr.sa_family,
+				&((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, ip, sizeof ip);
+			break;
+		default:
+			continue;
+		}
+
+		acm_log(2, "%s\n", ifr[i].ifr_name);
+
+		alias_sep = strchr(ifr[i].ifr_name, ':');
+		if (alias_sep)
+			*alias_sep = '\0';
+
+		if (!acm_if_is_ib(ifr[i].ifr_name))
+			continue;
+
+		ret = acm_if_get_sgid(ifr[i].ifr_name, &sgid);
+		if (ret)
+			continue;
+
+		ret = acm_if_get_pkey(ifr[i].ifr_name, &pkey);
+		if (ret)
+			continue;
+
+		dev = acm_get_device_from_gid(&sgid, &port_num);
+		if (dev && ep->port->dev == dev
+		    && ep->port->port_num == port_num && ep->pkey == pkey) {
+			if (!acm_ep_insert_addr(ep, addr, addr_len, addr_type)) {
+				acm_log(0, "Added %s %s %d 0x%x from %s\n", ip,
+					dev->verbs->device->name, port_num, pkey,
+					ifr[i].ifr_name);
+			}
 		}
 	}
-}
+	ret = 0;
+
+out2:
+	free(ifc);
+out1:
+	close(s);
+	return ret;
 
-static int acm_get_system_ips(struct acm_ep *ep)
-{
-	return acm_if_iter_sys(acm_ip_iter_cb, (void *)ep);
 }
 
 static int acm_assign_ep_names(struct acm_ep *ep)
diff --git a/src/acm_util.c b/src/acm_util.c
index da6d058..581e999 100644
--- a/src/acm_util.c
+++ b/src/acm_util.c
@@ -122,87 +122,3 @@ int acm_if_get_sgid(char *ifname, union ibv_gid *sgid)
 	fclose(f);
 	return ret;
 }
-
-int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
-{
-	struct ifconf *ifc;
-	struct ifreq *ifr;
-	char ip[INET6_ADDRSTRLEN];
-	int s, ret, i, len;
-	uint16_t pkey;
-	union ibv_gid sgid;
-	uint8_t addr_type;
-	uint8_t addr[ACM_MAX_ADDRESS];
-	size_t addr_len;
-	char *alias_sep;
-
-	s = socket(AF_INET6, SOCK_DGRAM, 0);
-	if (!s)
-		return -1;
-
-	len = sizeof(*ifc) + sizeof(*ifr) * 64;
-	ifc = malloc(len);
-	if (!ifc) {
-		ret = -1;
-		goto out1;
-	}
-
-	memset(ifc, 0, len);
-	ifc->ifc_len = len;
-	ifc->ifc_req = (struct ifreq *) (ifc + 1);
-
-	ret = ioctl(s, SIOCGIFCONF, ifc);
-	if (ret < 0) {
-		acm_log(0, "ioctl ifconf error %d\n", ret);
-		goto out2;
-	}
-
-	ifr = ifc->ifc_req;
-	for (i = 0; i < ifc->ifc_len / sizeof(struct ifreq); i++) {
-		switch (ifr[i].ifr_addr.sa_family) {
-		case AF_INET:
-			addr_type = ACM_ADDRESS_IP;
-			memcpy(&addr, &((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, sizeof addr);
-			addr_len = 4;
-			inet_ntop(ifr[i].ifr_addr.sa_family,
-				&((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, ip, sizeof ip);
-			break;
-		case AF_INET6:
-			addr_type = ACM_ADDRESS_IP6;
-			memcpy(&addr, &((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, sizeof addr);
-			addr_len = ACM_MAX_ADDRESS;
-			inet_ntop(ifr[i].ifr_addr.sa_family,
-				&((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, ip, sizeof ip);
-			break;
-		default:
-			continue;
-		}
-
-		acm_log(2, "%s\n", ifr[i].ifr_name);
-
-		alias_sep = strchr(ifr[i].ifr_name, ':');
-		if (alias_sep)
-			*alias_sep = '\0';
-
-		if (!acm_if_is_ib(ifr[i].ifr_name))
-			continue;
-
-		ret = acm_if_get_sgid(ifr[i].ifr_name, &sgid);
-		if (ret)
-			continue;
-
-		ret = acm_if_get_pkey(ifr[i].ifr_name, &pkey);
-		if (ret)
-			continue;
-
-		cb(ifr[i].ifr_name, &sgid, pkey, addr_type, addr, addr_len, ip, ctx);
-	}
-	ret = 0;
-
-out2:
-	free(ifc);
-out1:
-	close(s);
-	return ret;
-
-}
diff --git a/src/acm_util.h b/src/acm_util.h
index 4f111b6..871b93a 100644
--- a/src/acm_util.h
+++ b/src/acm_util.h
@@ -48,9 +48,4 @@ int acm_if_is_ib(char *ifname);
 int acm_if_get_pkey(char *ifname, uint16_t *pkey);
 int acm_if_get_sgid(char *ifname, union ibv_gid *sgid);
 
-typedef void (*acm_if_iter_cb)(char *ifname, union ibv_gid *gid, uint16_t pkey,
-				uint8_t addr_type, uint8_t *addr, size_t addr_len,
-				char *addr_name, void *ctx);
-int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx);
-
 #endif /* ACM_IF_H */
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
