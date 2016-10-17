From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 09/13] ibacm: remove e stricmp and strnicmp
Date: Mon, 17 Oct 2016 21:11:18 +0200
Message-ID: <1476731482-26491-10-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h          |  3 ---
 ibacm/prov/acmp/src/acmp.c | 50 +++++++++++++++++++++++-----------------------
 ibacm/src/acm.c            | 30 ++++++++++++++--------------
 ibacm/src/acme.c           |  4 ++--
 4 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index ee582bb..6e408f7 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -87,9 +87,6 @@ typedef struct { volatile int val; } atomic_t;
 #define atomic_get(v) ((v)->val)
 #define atomic_set(v, s) ((v)->val = s)
 
-#define stricmp strcasecmp
-#define strnicmp strncasecmp
-
 typedef struct { pthread_cond_t cond; pthread_mutex_t mutex; } event_t;
 static inline void event_init(event_t *e)
 {
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 4cda359..1cb14e1 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -1057,7 +1057,7 @@ acmp_addr_lookup(struct acmp_ep *ep, uint8_t *addr, uint16_t type)
 			continue;
 
 		if ((type == ACM_ADDRESS_NAME &&
-		    !strnicmp((char *) ep->addr_info[i].info.name,
+		    !strncasecmp((char *) ep->addr_info[i].info.name,
 			      (char *) addr, ACM_MAX_ADDRESS)) ||
 		    !memcmp(ep->addr_info[i].info.addr, addr, 
 			    ACM_MAX_ADDRESS)) {
@@ -1993,7 +1993,7 @@ static void acmp_query_perf(void *ep_context, uint64_t *values, uint8_t *cnt)
 
 static enum acmp_addr_prot acmp_convert_addr_prot(char *param)
 {
-	if (!stricmp("acm", param))
+	if (!strcasecmp("acm", param))
 		return ACMP_ADDR_PROT_ACM;
 
 	return addr_prot;
@@ -2001,9 +2001,9 @@ static enum acmp_addr_prot acmp_convert_addr_prot(char *param)
 
 static enum acmp_route_prot acmp_convert_route_prot(char *param)
 {
-	if (!stricmp("acm", param))
+	if (!strcasecmp("acm", param))
 		return ACMP_ROUTE_PROT_ACM;
-	else if (!stricmp("sa", param))
+	else if (!strcasecmp("sa", param))
 		return ACMP_ROUTE_PROT_SA;
 
 	return route_prot;
@@ -2011,9 +2011,9 @@ static enum acmp_route_prot acmp_convert_route_prot(char *param)
 
 static enum acmp_loopback_prot acmp_convert_loopback_prot(char *param)
 {
-	if (!stricmp("none", param))
+	if (!strcasecmp("none", param))
 		return ACMP_LOOPBACK_PROT_NONE;
-	else if (!stricmp("local", param))
+	else if (!strcasecmp("local", param))
 		return ACMP_LOOPBACK_PROT_LOCAL;
 
 	return loopback_prot;
@@ -2021,9 +2021,9 @@ static enum acmp_loopback_prot acmp_convert_loopback_prot(char *param)
 
 static enum acmp_route_preload acmp_convert_route_preload(char *param)
 {
-	if (!stricmp("none", param) || !stricmp("no", param))
+	if (!strcasecmp("none", param) || !strcasecmp("no", param))
 		return ACMP_ROUTE_PRELOAD_NONE;
-	else if (!stricmp("opensm_full_v1", param))
+	else if (!strcasecmp("opensm_full_v1", param))
 		return ACMP_ROUTE_PRELOAD_OSM_FULL_V1;
 
 	return route_preload;
@@ -2031,9 +2031,9 @@ static enum acmp_route_preload acmp_convert_route_preload(char *param)
 
 static enum acmp_addr_preload acmp_convert_addr_preload(char *param)
 {
-	if (!stricmp("none", param) || !stricmp("no", param))
+	if (!strcasecmp("none", param) || !strcasecmp("no", param))
 		return ACMP_ADDR_PRELOAD_NONE;
-	else if (!stricmp("acm_hosts", param))
+	else if (!strcasecmp("acm_hosts", param))
 		return ACMP_ADDR_PRELOAD_HOSTS;
 
 	return addr_preload;
@@ -2882,37 +2882,37 @@ static void acmp_set_options(void)
 		if (sscanf(s, "%31s%255s", opt, value) != 2)
 			continue;
 
-		if (!stricmp("addr_prot", opt))
+		if (!strcasecmp("addr_prot", opt))
 			addr_prot = acmp_convert_addr_prot(value);
-		else if (!stricmp("addr_timeout", opt))
+		else if (!strcasecmp("addr_timeout", opt))
 			addr_timeout = atoi(value);
-		else if (!stricmp("route_prot", opt))
+		else if (!strcasecmp("route_prot", opt))
 			route_prot = acmp_convert_route_prot(value);
 		else if (!strcmp("route_timeout", opt))
 			route_timeout = atoi(value);
-		else if (!stricmp("loopback_prot", opt))
+		else if (!strcasecmp("loopback_prot", opt))
 			loopback_prot = acmp_convert_loopback_prot(value);
-		else if (!stricmp("timeout", opt))
+		else if (!strcasecmp("timeout", opt))
 			timeout = atoi(value);
-		else if (!stricmp("retries", opt))
+		else if (!strcasecmp("retries", opt))
 			retries = atoi(value);
-		else if (!stricmp("resolve_depth", opt))
+		else if (!strcasecmp("resolve_depth", opt))
 			resolve_depth = atoi(value);
-		else if (!stricmp("send_depth", opt))
+		else if (!strcasecmp("send_depth", opt))
 			send_depth = atoi(value);
-		else if (!stricmp("recv_depth", opt))
+		else if (!strcasecmp("recv_depth", opt))
 			recv_depth = atoi(value);
-		else if (!stricmp("min_mtu", opt))
+		else if (!strcasecmp("min_mtu", opt))
 			min_mtu = acm_convert_mtu(atoi(value));
-		else if (!stricmp("min_rate", opt))
+		else if (!strcasecmp("min_rate", opt))
 			min_rate = acm_convert_rate(atoi(value));
-		else if (!stricmp("route_preload", opt))
+		else if (!strcasecmp("route_preload", opt))
 			route_preload = acmp_convert_route_preload(value);
-		else if (!stricmp("route_data_file", opt))
+		else if (!strcasecmp("route_data_file", opt))
 			strcpy(route_data_file, value);
-		else if (!stricmp("addr_preload", opt))
+		else if (!strcasecmp("addr_preload", opt))
 			addr_preload = acmp_convert_addr_preload(value);
-		else if (!stricmp("addr_data_file", opt))
+		else if (!strcasecmp("addr_data_file", opt))
 			strcpy(addr_data_file, value);
 	}
 
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 912d563..37bbbe7 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -388,7 +388,7 @@ static void acm_mark_addr_invalid(struct acmc_ep *ep,
 			continue;
 
 		if ((data->type == ACM_ADDRESS_NAME &&
-		    !strnicmp((char *) ep->addr_info[i].addr.info.name,
+		    !strncasecmp((char *) ep->addr_info[i].addr.info.name,
 			      (char *) data->info.addr, ACM_MAX_ADDRESS)) ||
 		     !memcmp(ep->addr_info[i].addr.info.addr, data->info.addr,
 			     ACM_MAX_ADDRESS)) {
@@ -410,7 +410,7 @@ acm_addr_lookup(const struct acm_endpoint *endpoint, uint8_t *addr, uint8_t addr
 			continue;
 
 		if ((addr_type == ACM_ADDRESS_NAME &&
-			!strnicmp((char *) ep->addr_info[i].addr.info.name,
+			!strncasecmp((char *) ep->addr_info[i].addr.info.name,
 				(char *) addr, ACM_MAX_ADDRESS)) ||
 			!memcmp(ep->addr_info[i].addr.info.addr, addr, ACM_MAX_ADDRESS))
 			return &ep->addr_info[i].addr;
@@ -2004,7 +2004,7 @@ static int acm_assign_ep_names(struct acmc_ep *ep)
 			memcpy(addr, name, addr_len);
 		}
 
-		if (stricmp(pkey_str, "default")) {
+		if (strcasecmp(pkey_str, "default")) {
 			if (sscanf(pkey_str, "%hx", &pkey) != 1) {
 				acm_log(0, "ERROR - bad pkey format %s\n", pkey_str);
 				continue;
@@ -2013,7 +2013,7 @@ static int acm_assign_ep_names(struct acmc_ep *ep)
 			pkey = ep->port->def_acm_pkey;
 		}
 
-		if (!stricmp(dev_name, dev) &&
+		if (!strcasecmp(dev_name, dev) &&
 		    (ep->port->port.port_num == (uint8_t) port) &&
 		    (ep->endpoint.pkey == pkey)) {
 			acm_log(1, "assigning %s\n", name);
@@ -2939,23 +2939,23 @@ static void acm_set_options(void)
 		if (sscanf(s, "%32s%256s", opt, value) != 2)
 			continue;
 
-		if (!stricmp("log_file", opt))
+		if (!strcasecmp("log_file", opt))
 			strcpy(log_file, value);
-		else if (!stricmp("log_level", opt))
+		else if (!strcasecmp("log_level", opt))
 			log_level = atoi(value);
-		else if (!stricmp("lock_file", opt))
+		else if (!strcasecmp("lock_file", opt))
 			strcpy(lock_file, value);
-		else if (!stricmp("server_port", opt))
+		else if (!strcasecmp("server_port", opt))
 			server_port = (short) atoi(value);
-		else if (!stricmp("provider_lib_path", opt))
+		else if (!strcasecmp("provider_lib_path", opt))
 			strcpy(prov_lib_path, value);
-		else if (!stricmp("support_ips_in_addr_cfg", opt))
+		else if (!strcasecmp("support_ips_in_addr_cfg", opt))
 			support_ips_in_addr_cfg = atoi(value);
-		else if (!stricmp("timeout", opt))
+		else if (!strcasecmp("timeout", opt))
 			sa.timeout = atoi(value);
-		else if (!stricmp("retries", opt))
+		else if (!strcasecmp("retries", opt))
 			sa.retries = atoi(value);
-		else if (!stricmp("sa_depth", opt))
+		else if (!strcasecmp("sa_depth", opt))
 			sa.depth = atoi(value);
 	}
 
@@ -2981,10 +2981,10 @@ static FILE *acm_open_log(void)
 {
 	FILE *f;
 
-	if (!stricmp(log_file, "stdout"))
+	if (!strcasecmp(log_file, "stdout"))
 		return stdout;
 
-	if (!stricmp(log_file, "stderr"))
+	if (!strcasecmp(log_file, "stderr"))
 		return stderr;
 
 	if (!(f = fopen(log_file, "w")))
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index f2c9348..5a571cf 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -968,9 +968,9 @@ static char *opt_arg(int argc, char **argv)
 
 static void parse_perf_arg(char *arg)
 {
-	if (!strnicmp("col", arg, 3)) {
+	if (!strncasecmp("col", arg, 3)) {
 		perf_query = PERF_QUERY_COL;
-	} else if (!strnicmp("all", arg, 3)) {
+	} else if (!strncasecmp("all", arg, 3)) {
 		perf_query = PERF_QUERY_EP_ALL;
 	} else if (!strcmp("s", arg)) {
 		perf_query = PERF_QUERY_EP_ADDR;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
