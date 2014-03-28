From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 09/16] ibacm: read system IP's into endpoints at startup
Date: Thu, 27 Mar 2014 22:50:03 -0700
Message-ID: <1395985810-23822-10-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ibacm_addr.cfg is read after system is read which can add endpoints which are
not active at start up.

ibacm_addr.cfg can still specify names for end points

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am    |    2 +-
 src/acm.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/acm_util.c |   13 ++++++++++-
 3 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 703030d..cab1ca1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,7 @@ AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=\"$(sysconfdir)\" -DBINDIR=\"$(b
 
 bin_PROGRAMS = util/ib_acme
 sbin_PROGRAMS = svc/ibacm
-svc_ibacm_SOURCES = src/acm.c
+svc_ibacm_SOURCES = src/acm.c src/acm_util.c
 util_ib_acme_SOURCES = src/acme.c linux/acme_linux.c src/libacm.c linux/libacm_linux.c \
 			src/parse.c src/acm_util.c
 svc_ibacm_CFLAGS = $(AM_CFLAGS)
diff --git a/src/acm.c b/src/acm.c
index 6bbc1e5..c5da791 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -46,6 +46,9 @@
 #include <infiniband/verbs.h>
 #include <dlist.h>
 #include <search.h>
+#include <net/if.h>
+#include <sys/ioctl.h>
+#include <net/if_arp.h>
 #include "acm_mad.h"
 #include "acm_util.h"
 
@@ -2922,6 +2925,67 @@ acm_ep_insert_addr(struct acm_ep *ep, uint8_t *addr, size_t addr_len, uint8_t ad
 	return ret;
 }
 
+static struct acm_device *
+acm_get_device_from_gid(union ibv_gid *sgid, uint8_t *port)
+{
+	DLIST_ENTRY *dev_entry;
+	struct acm_device *dev;
+	struct ibv_device_attr dev_attr;
+	struct ibv_port_attr port_attr;
+	union ibv_gid gid;
+	int ret, i;
+
+	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
+		 dev_entry = dev_entry->Next) {
+
+		dev = container_of(dev_entry, struct acm_device, entry);
+
+		ret = ibv_query_device(dev->verbs, &dev_attr);
+		if (ret)
+			continue;
+
+		for (*port = 1; *port <= dev_attr.phys_port_cnt; (*port)++) {
+			ret = ibv_query_port(dev->verbs, *port, &port_attr);
+			if (ret)
+				continue;
+
+			for (i = 0; i < port_attr.gid_tbl_len; i++) {
+				ret = ibv_query_gid(dev->verbs, *port, i, &gid);
+				if (ret || !gid.global.interface_id)
+					break;
+
+				if (!memcmp(sgid->raw, gid.raw, sizeof gid))
+					return dev;
+			}
+		}
+	}
+	return NULL;
+}
+
+static void acm_ip_iter_cb(char *ifname, union ibv_gid *gid, uint16_t pkey,
+		uint8_t addr_type, uint8_t *addr, size_t addr_len,
+		char *addr_name, void *ctx)
+{
+	uint8_t port_num;
+	struct acm_device *dev;
+	struct acm_ep *ep = (struct acm_ep *)ctx;
+
+	dev = acm_get_device_from_gid(gid, &port_num);
+	if (dev && ep->port->dev == dev
+	    && ep->port->port_num == port_num && ep->pkey == pkey) {
+		if (!acm_ep_insert_addr(ep, addr, addr_len, addr_type)) {
+			acm_log(0, "Added %s %s %d 0x%x from %s\n", addr_name,
+				dev->verbs->device->name, port_num, pkey,
+				ifname);
+		}
+	}
+}
+
+static int acm_get_system_ips(struct acm_ep *ep)
+{
+	return acm_if_iter_sys(acm_ip_iter_cb, (void *)ep);
+}
+
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
 	FILE *faddr;
@@ -2938,6 +3002,8 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	acm_log(1, "device %s, port %d, pkey 0x%x\n",
 		dev_name, ep->port->port_num, ep->pkey);
 
+	acm_get_system_ips(ep);
+
 	if (!(faddr = acm_open_addr_file())) {
 		acm_log(0, "ERROR - address file not found\n");
 		return -1;
diff --git a/src/acm_util.c b/src/acm_util.c
index 7a84ac7..c3c5b69 100644
--- a/src/acm_util.c
+++ b/src/acm_util.c
@@ -40,6 +40,8 @@
 #include <sys/types.h>
 #include <errno.h>
 
+#include <infiniband/acm.h>
+#include "acm_mad.h"
 #include "acm_util.h"
 
 int acm_if_is_ib(char *ifname)
@@ -129,6 +131,9 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	int s, ret, i, len;
 	uint16_t pkey;
 	union ibv_gid sgid;
+	uint8_t addr_type;
+	uint8_t addr[ACM_MAX_ADDRESS];
+	size_t addr_len;
 
 	s = socket(AF_INET6, SOCK_DGRAM, 0);
 	if (!s)
@@ -155,10 +160,16 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	for (i = 0; i < ifc->ifc_len / sizeof(struct ifreq); i++) {
 		switch (ifr[i].ifr_addr.sa_family) {
 		case AF_INET:
+			addr_type = ACM_ADDRESS_IP;
+			memcpy(&addr, &((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, sizeof addr);
+			addr_len = 4;
 			inet_ntop(ifr[i].ifr_addr.sa_family,
 				&((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, ip, sizeof ip);
 			break;
 		case AF_INET6:
+			addr_type = ACM_ADDRESS_IP6;
+			memcpy(&addr, &((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, sizeof addr);
+			addr_len = ACM_MAX_ADDRESS;
 			inet_ntop(ifr[i].ifr_addr.sa_family,
 				&((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, ip, sizeof ip);
 			break;
@@ -177,7 +188,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 		if (ret)
 			continue;
 
-		cb(ifr[i].ifr_name, &sgid, pkey, 0, NULL, 0, ip, ctx);
+		cb(ifr[i].ifr_name, &sgid, pkey, addr_type, addr, addr_len, ip, ctx);
 	}
 	ret = 0;
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
