From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] ibacm/prov: export a function to increment performance counters
Date: Fri, 20 Jun 2014 07:52:46 -0400
Message-ID: <1403265166-32346-2-git-send-email-kaike.wan@intel.com>
References: <1403265166-32346-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403265166-32346-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Instead of exposing the combined counters directly, this patch exports a
function to providers to increment the combined counters. This offers better
encapsulation and avoids exposing the private type atomic_t.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/acm_prov.h |    4 +---
 prov/acmp/src/acmp.c          |   14 +++++++-------
 src/acm.c                     |    8 +++++++-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/infiniband/acm_prov.h b/include/infiniband/acm_prov.h
index 9e299b9..890e6ba 100644
--- a/include/infiniband/acm_prov.h
+++ b/include/infiniband/acm_prov.h
@@ -80,9 +80,6 @@ struct acm_provider {
 	void	(*query_perf)(void *ep_context, uint64_t *values, uint8_t *cnt);
 };
 
-/* Variables exported from core */
-extern atomic_t counter[ACM_MAX_COUNTER];
-
 int provider_query(struct acm_provider **info, uint32_t *version);
 
 /* Functions exported from core */
@@ -117,5 +114,6 @@ extern void acm_free_sa_mad(struct acm_sa_mad *mad);
 extern int acm_send_sa_mad(struct acm_sa_mad *mad);
 
 extern char * acm_get_opts_file(void);
+extern void acm_increment_counter(int type);
 
 #endif /* ACM_PROV_H */
diff --git a/prov/acmp/src/acmp.c b/prov/acmp/src/acmp.c
index 5db62e2..2dd356d 100644
--- a/prov/acmp/src/acmp.c
+++ b/prov/acmp/src/acmp.c
@@ -798,7 +798,7 @@ static uint8_t acmp_resolve_path_sa(struct acmp_ep *ep, struct acmp_dest *dest,
 	memcpy(mad->data, &dest->path, sizeof(dest->path));
 	mad->comp_mask = acm_path_comp_mask(&dest->path);
 
-	atomic_inc(&counter[ACM_CNTR_ROUTE_QUERY]);
+	acm_increment_counter(ACM_CNTR_ROUTE_QUERY);
 	atomic_inc(&ep->counters[ACM_CNTR_ROUTE_QUERY]);
 	dest->state = ACMP_QUERY_ROUTE;
 	if (acm_send_sa_mad(sa_mad)) {
@@ -1630,7 +1630,7 @@ acmp_query(void *addr_context, struct acm_msg *msg, uint64_t id)
 		sizeof(struct ibv_path_record));
 	mad->comp_mask = acm_path_comp_mask(&msg->resolve_data[0].info.path);
 
-	atomic_inc(&counter[ACM_CNTR_ROUTE_QUERY]);
+	acm_increment_counter(ACM_CNTR_ROUTE_QUERY);
 	atomic_inc(&ep->counters[ACM_CNTR_ROUTE_QUERY]);
 	if (acm_send_sa_mad(sa_mad)) {
 		acm_log(0, "Error - Failed to send sa mad\n");
@@ -1691,8 +1691,8 @@ acmp_send_resolve(struct acmp_ep *ep, struct acmp_dest *dest,
 	rec->gid_cnt = (uint8_t) ep->mc_cnt;
 	for (i = 0; i < ep->mc_cnt; i++)
 		memcpy(&rec->gid[i], ep->mc_dest[i].address, 16);
-	
-	atomic_inc(&counter[ACM_CNTR_ADDR_QUERY]);
+
+	acm_increment_counter(ACM_CNTR_ADDR_QUERY);
 	atomic_inc(&ep->counters[ACM_CNTR_ADDR_QUERY]);
 	acmp_post_send(&ep->resolve_queue, msg);
 	return 0;
@@ -1758,13 +1758,13 @@ test:
 		if (acmp_dest_timeout(dest))
 			goto test;
 		acm_log(2, "request satisfied from local cache\n");
-		atomic_inc(&counter[ACM_CNTR_ROUTE_CACHE]);
+		acm_increment_counter(ACM_CNTR_ROUTE_CACHE);
 		atomic_inc(&ep->counters[ACM_CNTR_ROUTE_CACHE]);
 		status = ACM_STATUS_SUCCESS;
 		break;
 	case ACMP_ADDR_RESOLVED:
 		acm_log(2, "have address, resolving route\n");
-		atomic_inc(&counter[ACM_CNTR_ADDR_CACHE]);
+		acm_increment_counter(ACM_CNTR_ADDR_CACHE);
 		atomic_inc(&ep->counters[ACM_CNTR_ADDR_CACHE]);
 		status = acmp_resolve_path_sa(ep, dest, acmp_dest_sa_resp);
 		if (status) {
@@ -1833,7 +1833,7 @@ test:
 		if (acmp_dest_timeout(dest))
 			goto test;
 		acm_log(2, "request satisfied from local cache\n");
-		atomic_inc(&counter[ACM_CNTR_ROUTE_CACHE]);
+		acm_increment_counter(ACM_CNTR_ROUTE_CACHE);
 		atomic_inc(&ep->counters[ACM_CNTR_ROUTE_CACHE]);
 		status = ACM_STATUS_SUCCESS;
 		break;
diff --git a/src/acm.c b/src/acm.c
index 97b773e..8f147ef 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -163,7 +163,7 @@ static struct acmc_client client_array[FD_SETSIZE - 1];
 static FILE *flog;
 static lock_t log_lock;
 PER_THREAD char log_data[ACM_MAX_ADDRESS];
-atomic_t counter[ACM_MAX_COUNTER];
+static atomic_t counter[ACM_MAX_COUNTER];
 
 static struct acmc_device *
 acm_get_device_from_gid(union ibv_gid *sgid, uint8_t *port);
@@ -261,6 +261,12 @@ char * acm_get_opts_file(void)
 	return opts_file;
 }
 
+void acm_increment_counter(int type)
+{
+	if (type >= 0 && type < ACM_MAX_COUNTER)
+		atomic_inc(&counter[type]);
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
