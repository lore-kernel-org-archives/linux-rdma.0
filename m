From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 14/14] ibacm: by default remove processing of IP's from ibacm_addr.cfg
Date: Thu,  3 Apr 2014 20:51:54 -0400
Message-ID: <1396572714-16498-15-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

support_ips_in_addr_cfg option in config file can turn this back on if wanted.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c  |   12 ++++++++++++
 src/acme.c |    4 ++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index a6e24a9..02272e3 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -252,6 +252,7 @@ static uint8_t min_mtu = IBV_MTU_2048;
 static uint8_t min_rate = IBV_RATE_10_GBPS;
 static enum acm_route_preload route_preload;
 static enum acm_addr_preload addr_preload;
+static int support_ips_in_addr_cfg = 0;
 
 void acm_write(int level, const char *format, ...)
 {
@@ -3294,9 +3295,17 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 
 		acm_log(2, "%s", s);
 		if (inet_pton(AF_INET, addr, &ip_addr) > 0) {
+			if (!support_ips_in_addr_cfg) {
+				acm_log(0, "ERROR - IP's are not configured to be read from ibacm_addr.cfg\n");
+				continue;
+			}
 			type = ACM_ADDRESS_IP;
 			addr_len = 4;
 		} else if (inet_pton(AF_INET6, addr, &ip_addr) > 0) {
+			if (!support_ips_in_addr_cfg) {
+				acm_log(0, "ERROR - IP's are not configured to be read from ibacm_addr.cfg\n");
+				continue;
+			}
 			type = ACM_ADDRESS_IP6;
 			addr_len = ACM_MAX_ADDRESS;
 		} else {
@@ -3873,6 +3882,8 @@ static void acm_set_options(void)
 			addr_preload = acm_convert_addr_preload(value);
 		else if (!stricmp("addr_data_file", opt))
 			strcpy(addr_data_file, value);
+		else if (!stricmp("support_ips_in_addr_cfg", opt))
+			support_ips_in_addr_cfg = atoi(value);
 	}
 
 	fclose(f);
@@ -3900,6 +3911,7 @@ static void acm_log_options(void)
 	acm_log(0, "route data file %s\n", route_data_file);
 	acm_log(0, "address preload %d\n", addr_preload);
 	acm_log(0, "address data file %s\n", addr_data_file);
+	acm_log(0, "support IP's in ibacm_addr.cfg %d\n", support_ips_in_addr_cfg);
 }
 
 static FILE *acm_open_log(void)
diff --git a/src/acme.c b/src/acme.c
index d83e56f..c93ee1b 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -280,6 +280,10 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# Default is ACM_CONF_DIR/ibacm_hosts.data\n");
 	fprintf(f, "# addr_data_file /etc/rdma/ibacm_hosts.data\n");
 	fprintf(f, "\n");
+	fprintf(f, "# support_ips_in_addr_cfg:\n");
+	fprintf(f, "# If 1 continue to read IP addresses from ibacm_addr.cfg\n");
+	fprintf(f, "# Default is 0 \"no\"\n");
+	fprintf(f, "# support_ips_in_addr_cfg 0\n");
 }
 
 static int open_dir(void)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
