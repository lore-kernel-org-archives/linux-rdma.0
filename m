From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 05/14] ibacm: Move calling of helper functions out of get_devaddr
Date: Thu,  3 Apr 2014 20:51:45 -0400
Message-ID: <1396572714-16498-6-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Again this is in prep for sharing this code with ibacm and ib_acme

get_devaddr uses globals which are specific to ib_acme.  Move toward this
function being ib_acme specific while the code in get_addr_ip becomes generic.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/acme_linux.c |   64 ++++++++++++++++++++++++++++++++++------------------
 src/acm_util.h     |    5 ++++
 2 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index b246a9c..187507d 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -47,25 +47,13 @@ extern int dev_cnt;
 extern int verbose;
 
 static int
-get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
+get_devaddr(union ibv_gid *sgid, int *dev_index, uint8_t *port)
 {
 	struct ibv_device_attr dev_attr;
 	struct ibv_port_attr port_attr;
-	union ibv_gid sgid, gid;
+	union ibv_gid gid;
 	int ret, i;
 
-	ret = acm_if_get_sgid(ifname, &sgid);
-	if (ret) {
-		printf("unable to get sgid\n");
-		return ret;
-	}
-
-	ret = acm_if_get_pkey(ifname, pkey);
-	if (ret) {
-		printf("unable to get pkey\n");
-		return ret;
-	}
-
 	for (*dev_index = 0; *dev_index < dev_cnt; (*dev_index)++) {
 		ret = ibv_query_device(verbs[*dev_index], &dev_attr);
 		if (ret)
@@ -81,7 +69,7 @@ get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
 				if (ret || !gid.global.interface_id)
 					break;
 
-				if (!memcmp(sgid.raw, gid.raw, sizeof gid))
+				if (!memcmp(sgid->raw, gid.raw, sizeof gid))
 					return 0;
 			}
 		}
@@ -89,14 +77,39 @@ get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
 	return -1;
 }
 
+static void iter_cb(char *ifname, union ibv_gid *gid, uint16_t pkey,
+		uint8_t addr_type, uint8_t *addr, size_t addr_len,
+		char *addr_name, void *ctx)
+{
+	FILE *f = (FILE *)ctx;
+	int ret;
+	int dev_index;
+	uint8_t port;
+
+	ret = get_devaddr(gid, &dev_index, &port);
+	if (ret) {
+		printf("Failed to find verbs device for %s\n", ifname);
+		return;
+	}
+
+	if (verbose)
+		printf("%s %s %d 0x%x\n", addr_name, verbs[dev_index]->device->name, port, pkey);
+	fprintf(f, "%s %s %d 0x%x\n", addr_name, verbs[dev_index]->device->name, port, pkey);
+}
+
 int gen_addr_ip(FILE *f)
 {
+	return acm_if_iter_sys(iter_cb, (void *)f);
+}
+
+int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
+{
 	struct ifconf *ifc;
 	struct ifreq *ifr;
 	char ip[INET6_ADDRSTRLEN];
-	int s, ret, dev_index, i, len;
+	int s, ret, i, len;
 	uint16_t pkey;
-	uint8_t port;
+	union ibv_gid sgid;
 
 	s = socket(AF_INET6, SOCK_DGRAM, 0);
 	if (!s)
@@ -137,13 +150,19 @@ int gen_addr_ip(FILE *f)
 		if (!acm_if_is_ib(ifr[i].ifr_name))
 			continue;
 
-		ret = get_devaddr(ifr[i].ifr_name, &dev_index, &port, &pkey);
-		if (ret)
+		ret = acm_if_get_sgid(ifr[i].ifr_name, &sgid);
+		if (ret) {
+			printf("unable to get sgid\n");
+			continue;
+		}
+
+		ret = acm_if_get_pkey(ifr[i].ifr_name, &pkey);
+		if (ret) {
+			printf("unable to get pkey\n");
 			continue;
+		}
 
-		if (verbose)
-			printf("%s %s %d 0x%x\n", ip, verbs[dev_index]->device->name, port, pkey);
-		fprintf(f, "%s %s %d 0x%x\n", ip, verbs[dev_index]->device->name, port, pkey);
+		cb(ifr[i].ifr_name, &sgid, pkey, 0, NULL, 0, ip, ctx);
 	}
 	ret = 0;
 
@@ -152,4 +171,5 @@ out2:
 out1:
 	close(s);
 	return ret;
+
 }
diff --git a/src/acm_util.h b/src/acm_util.h
index 94aac9d..ea86133 100644
--- a/src/acm_util.h
+++ b/src/acm_util.h
@@ -36,4 +36,9 @@ int acm_if_is_ib(char *ifname);
 int acm_if_get_pkey(char *ifname, uint16_t *pkey);
 int acm_if_get_sgid(char *ifname, union ibv_gid *sgid);
 
+typedef void (*acm_if_iter_cb)(char *ifname, union ibv_gid *gid, uint16_t pkey,
+				uint8_t addr_type, uint8_t *addr, size_t addr_len,
+				char *addr_name, void *ctx);
+int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx);
+
 #endif /* ACM_IF_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
