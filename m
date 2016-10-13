From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 03/32] libibumad: use NULL instead of 0 for NULL pointers
Date: Thu, 13 Oct 2016 19:51:06 +0200
Message-ID: <1476381095-20041-4-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 libibumad/sysfs.c |  8 ++++----
 libibumad/umad.c  | 17 +++++++++--------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/libibumad/sysfs.c b/libibumad/sysfs.c
index 83f89b4..730374d 100644
--- a/libibumad/sysfs.c
+++ b/libibumad/sysfs.c
@@ -95,7 +95,7 @@ int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_gu
 	for (s = buf, i = 0; i < 4; i++) {
 		if (!(str = strsep(&s, ": \t\n")))
 			return -EINVAL;
-		guid = (guid << 16) | (strtoul(str, 0, 16) & 0xffff);
+		guid = (guid << 16) | (strtoul(str, NULL, 16) & 0xffff);
 	}
 
 	*net_guid = htonll(guid);
@@ -115,7 +115,7 @@ int sys_read_gid(const char *dir_name, const char *file_name, uint8_t * gid)
 	for (s = buf, i = 0; i < 8; i++) {
 		if (!(str = strsep(&s, ": \t\n")))
 			return -EINVAL;
-		ugid[i] = htons(strtoul(str, 0, 16) & 0xffff);
+		ugid[i] = htons(strtoul(str, NULL, 16) & 0xffff);
 	}
 
 	return 0;
@@ -129,7 +129,7 @@ int sys_read_uint64(const char *dir_name, const char *file_name, uint64_t * u)
 	if ((r = sys_read_string(dir_name, file_name, buf, sizeof(buf))) < 0)
 		return r;
 
-	*u = strtoull(buf, 0, 0);
+	*u = strtoull(buf, NULL, 0);
 
 	return 0;
 }
@@ -142,7 +142,7 @@ int sys_read_uint(const char *dir_name, const char *file_name, unsigned *u)
 	if ((r = sys_read_string(dir_name, file_name, buf, sizeof(buf))) < 0)
 		return r;
 
-	*u = strtoul(buf, 0, 0);
+	*u = strtoul(buf, NULL, 0);
 
 	return 0;
 }
diff --git a/libibumad/umad.c b/libibumad/umad.c
index 8860b99..c1b7338 100644
--- a/libibumad/umad.c
+++ b/libibumad/umad.c
@@ -215,7 +215,7 @@ static int release_ca(umad_ca_t * ca)
 			continue;
 		release_port(ca->ports[i]);
 		free(ca->ports[i]);
-		ca->ports[i] = 0;
+		ca->ports[i] = NULL;
 	}
 	return 0;
 }
@@ -320,13 +320,13 @@ static const char *resolve_ca_name(const char *ca_name, int *best_port)
 
 	if (ca_name) {
 		if (resolve_ca_port(ca_name, best_port) < 0)
-			return 0;
+			return NULL;
 		return ca_name;
 	}
 
 	/* Get the list of CA names */
 	if ((n = umad_get_cas_names((void *)names, UMAD_MAX_DEVICES)) < 0)
-		return 0;
+		return NULL;
 
 	/* Find the first existing CA with an active port */
 	for (caidx = 0; caidx < n; caidx++) {
@@ -354,7 +354,8 @@ static const char *resolve_ca_name(const char *ca_name, int *best_port)
 	}
 
 	DEBUG("phys found %d on %s port %d",
-	      phys_found, phys_found >= 0 ? names[phys_found] : 0, port_found);
+	      phys_found, phys_found >= 0 ? names[phys_found] : NULL,
+	      port_found);
 	if (phys_found >= 0) {
 		if (best_port)
 			*best_port = port_found;
@@ -404,7 +405,7 @@ static int get_ca(const char *ca_name, umad_ca_t * ca)
 	if (!(dir = opendir(dir_name)))
 		return -ENOENT;
 
-	if ((r = scandir(dir_name, &namelist, 0, alphasort)) < 0) {
+	if ((r = scandir(dir_name, &namelist, NULL, alphasort)) < 0) {
 		ret = errno < 0 ? errno : -EIO;
 		goto error;
 	}
@@ -544,7 +545,7 @@ int umad_get_cas_names(char cas[][UMAD_CA_NAME_LEN], int max)
 
 	TRACE("max %d", max);
 
-	n = scandir(SYS_INFINIBAND, &namelist, 0, alphasort);
+	n = scandir(SYS_INFINIBAND, &namelist, NULL, alphasort);
 	if (n > 0) {
 		for (i = 0; i < n; i++) {
 			if (strcmp(namelist[i]->d_name, ".") &&
@@ -573,7 +574,7 @@ int umad_get_ca_portguids(const char *ca_name, uint64_t * portguids, int max)
 	int ports = 0, i;
 
 	TRACE("ca name %s max port guids %d", ca_name, max);
-	if (!(ca_name = resolve_ca_name(ca_name, 0)))
+	if (!(ca_name = resolve_ca_name(ca_name, NULL)))
 		return -ENODEV;
 
 	if (umad_get_ca(ca_name, &ca) < 0)
@@ -650,7 +651,7 @@ int umad_get_ca(const char *ca_name, umad_ca_t * ca)
 	int r;
 
 	TRACE("ca_name %s", ca_name);
-	if (!(ca_name = resolve_ca_name(ca_name, 0)))
+	if (!(ca_name = resolve_ca_name(ca_name, NULL)))
 		return -ENODEV;
 
 	if (find_cached_ca(ca_name, ca) > 0)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
