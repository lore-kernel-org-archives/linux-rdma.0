From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/16] ibacm: pass interface name rather than 'struct ifreq' to get_devaddr, get_sgid, and get_pkey
Date: Thu, 27 Mar 2014 22:49:56 -0700
Message-ID: <1395985810-23822-3-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/acme_linux.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index 6978db7..201ff19 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -47,13 +47,13 @@ extern int verbose;
 
 
 static int
-get_pkey(struct ifreq *ifreq, uint16_t *pkey)
+get_pkey(char *ifname, uint16_t *pkey)
 {
 	char buf[128], *end;
 	FILE *f;
 	int ret;
 
-	snprintf(buf, sizeof buf, "//sys//class//net//%s//pkey", ifreq->ifr_name);
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//pkey", ifname);
 	f = fopen(buf, "r");
 	if (!f) {
 		printf("failed to open %s\n", buf);
@@ -73,13 +73,13 @@ get_pkey(struct ifreq *ifreq, uint16_t *pkey)
 }
 
 static int
-get_sgid(struct ifreq *ifr, union ibv_gid *sgid)
+get_sgid(char *ifname, union ibv_gid *sgid)
 {
 	char buf[128], *end;
 	FILE *f;
 	int i, p, ret;
 
-	snprintf(buf, sizeof buf, "//sys//class//net//%s//address", ifr->ifr_name);
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//address", ifname);
 	f = fopen(buf, "r");
 	if (!f) {
 		printf("failed to open %s\n", buf);
@@ -102,21 +102,20 @@ get_sgid(struct ifreq *ifr, union ibv_gid *sgid)
 }
 
 static int
-get_devaddr(struct ifreq *ifr,
-	int *dev_index, uint8_t *port, uint16_t *pkey)
+get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
 {
 	struct ibv_device_attr dev_attr;
 	struct ibv_port_attr port_attr;
 	union ibv_gid sgid, gid;
 	int ret, i;
 
-	ret = get_sgid(ifr, &sgid);
+	ret = get_sgid(ifname, &sgid);
 	if (ret) {
 		printf("unable to get sgid\n");
 		return ret;
 	}
 
-	ret = get_pkey(ifr, pkey);
+	ret = get_pkey(ifname, pkey);
 	if (ret) {
 		printf("unable to get pkey\n");
 		return ret;
@@ -199,7 +198,7 @@ int gen_addr_ip(FILE *f)
 		if (ifr[i].ifr_hwaddr.sa_family != ARPHRD_INFINIBAND)
 			continue;
 
-		ret = get_devaddr(&ifr[i], &dev_index, &port, &pkey);
+		ret = get_devaddr(ifr[i].ifr_name, &dev_index, &port, &pkey);
 		if (ret)
 			continue;
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
