From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] ibacm/prov: export a function to return config file name
Date: Fri, 20 Jun 2014 07:52:45 -0400
Message-ID: <1403265166-32346-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Instead of exposing the ibacm configuration file name directly, this patch
exports a function to return the configuration file name. This provides better
encapsulation.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/acm_prov.h |    3 ++-
 prov/acmp/src/acmp.c          |    1 +
 src/acm.c                     |    7 ++++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/acm_prov.h b/include/infiniband/acm_prov.h
index dcfdf5f..9e299b9 100644
--- a/include/infiniband/acm_prov.h
+++ b/include/infiniband/acm_prov.h
@@ -82,7 +82,6 @@ struct acm_provider {
 
 /* Variables exported from core */
 extern atomic_t counter[ACM_MAX_COUNTER];
-extern char *opts_file;
 
 int provider_query(struct acm_provider **info, uint32_t *version);
 
@@ -117,4 +116,6 @@ acm_alloc_sa_mad(const struct acm_endpoint *endpoint, void *context,
 extern void acm_free_sa_mad(struct acm_sa_mad *mad);
 extern int acm_send_sa_mad(struct acm_sa_mad *mad);
 
+extern char * acm_get_opts_file(void);
+
 #endif /* ACM_PROV_H */
diff --git a/prov/acmp/src/acmp.c b/prov/acmp/src/acmp.c
index 45ad03b..5db62e2 100644
--- a/prov/acmp/src/acmp.c
+++ b/prov/acmp/src/acmp.c
@@ -2776,6 +2776,7 @@ static void acmp_set_options(void)
 	FILE *f;
 	char s[120];
 	char opt[32], value[256];
+	char *opts_file = acm_get_opts_file();
 
 	if (!(f = fopen(opts_file, "r")))
 		return;
diff --git a/src/acm.c b/src/acm.c
index 6d18ac5..97b773e 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -186,7 +186,7 @@ static struct sa_data {
  * Service options - may be set through ibacm_opts.cfg file.
  */
 static char *acme = IBACM_BIN_PATH "/ib_acme -A";
-char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
+static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
 static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
 static char log_file[128] = "/var/log/ibacm.log";
 static int log_level = 0;
@@ -256,6 +256,11 @@ int ib_any_gid(union ibv_gid *gid)
 	return ((gid->global.subnet_prefix | gid->global.interface_id) == 0);
 }
 
+char * acm_get_opts_file(void)
+{
+	return opts_file;
+}
+
 static struct acmc_prov_context *
 acm_alloc_prov_context(struct acm_provider *prov)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
