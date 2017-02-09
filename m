From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 03/10] Remove uses of ntohll
Date: Thu,  9 Feb 2017 14:53:25 -0700
Message-ID: <1486677212-3188-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Done via

$ git ls-files | xargs sed -i -e 's/ntohll/be64toh/g'

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c |  2 +-
 providers/cxgb4/dev.c      |  4 ++--
 providers/cxgb4/t4.h       |  2 +-
 providers/mlx5/cq.c        |  2 +-
 providers/mlx5/qp.c        |  4 ++--
 providers/mlx5/srq.c       |  2 +-
 srp_daemon/srp_daemon.c    | 26 +++++++++++++-------------
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 6b7cbb8c203478..926ee367996127 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2126,7 +2126,7 @@ static int acmp_parse_osm_fullv1_paths(FILE *f, uint64_t *lid2guid, struct acmp_
 			continue;
 
 		guid = (uint64_t) strtoull(p_guid, NULL, 16);
-		if (guid != ntohll(sgid.global.interface_id))
+		if (guid != be64toh(sgid.global.interface_id))
 			continue;
 
 		ptr = strstr(ptr, "base LID");
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 3d903e85261652..b0233de0dd40c4 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -323,7 +323,7 @@ static void dump_qp(struct c4iw_qp *qhp)
 	for (i=0; i < qhp->wq.sq.size * T4_SQ_NUM_SLOTS; i++) {
 		for (j=0; j < T4_EQ_ENTRY_SIZE / 16; j++) {
 			fprintf(stderr, "%04u %016" PRIx64 " %016" PRIx64 " ",
-				i, ntohll(p[0]), ntohll(p[1]));
+				i, be64toh(p[0]), be64toh(p[1]));
 			if (j == 0 && i == qhp->wq.sq.wq_pidx)
 				fprintf(stderr, " <-- pidx");
 			fprintf(stderr, "\n");
@@ -348,7 +348,7 @@ static void dump_qp(struct c4iw_qp *qhp)
 	for (i=0; i < qhp->wq.rq.size * T4_RQ_NUM_SLOTS; i++) {
 		for (j=0; j < T4_EQ_ENTRY_SIZE / 16; j++) {
 			fprintf(stderr, "%04u %016" PRIx64 " %016" PRIx64 " ",
-				i, ntohll(p[0]), ntohll(p[1]));
+				i, be64toh(p[0]), be64toh(p[1]));
 			if (j == 0 && i == qhp->wq.rq.pidx)
 				fprintf(stderr, " <-- pidx");
 			if (j == 0 && i == qhp->wq.rq.cidx)
diff --git a/providers/cxgb4/t4.h b/providers/cxgb4/t4.h
index 59dbc65d4e164b..a457e2f2921727 100644
--- a/providers/cxgb4/t4.h
+++ b/providers/cxgb4/t4.h
@@ -58,7 +58,7 @@
 #define cpu_to_be64 htobe64
 #define be16_to_cpu ntohs
 #define be32_to_cpu ntohl
-#define be64_to_cpu ntohll
+#define be64_to_cpu be64toh
 #define BUG_ON(c) assert(!(c))
 #define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index b53fa663b01727..eab8abfdecaefe 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1267,7 +1267,7 @@ static inline uint64_t mlx5_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
-	return ntohll(cq->cqe64->timestamp);
+	return be64toh(cq->cqe64->timestamp);
 }
 
 #define BIT(i) (1UL << (i))
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index 7d034880f4caf6..bd3f8a83e508ee 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -81,7 +81,7 @@ static int copy_to_scat(struct mlx5_wqe_data_seg *scat, void *buf, int *size,
 
 	for (i = 0; i < max; ++i) {
 		copy = min_t(long, *size, ntohl(scat->byte_count));
-		memcpy((void *)(unsigned long)ntohll(scat->addr), buf, copy);
+		memcpy((void *)(unsigned long)be64toh(scat->addr), buf, copy);
 		*size -= copy;
 		if (*size == 0)
 			return IBV_WC_SUCCESS;
@@ -347,7 +347,7 @@ void *mlx5_get_atomic_laddr(struct mlx5_qp *qp, uint16_t idx, int *byte_count)
 	dpseg = mlx5_get_send_wqe(qp, idx) + sizeof(struct mlx5_wqe_ctrl_seg) +
 		sizeof(struct mlx5_wqe_raddr_seg) +
 		sizeof(struct mlx5_wqe_atomic_seg);
-	addr = (void *)(unsigned long)ntohll(dpseg->addr);
+	addr = (void *)(unsigned long)be64toh(dpseg->addr);
 
 	/*
 	 * Currently byte count is always 8 bytes. Fix this when
diff --git a/providers/mlx5/srq.c b/providers/mlx5/srq.c
index b362ec85724961..b6e1eaf26bbd0c 100644
--- a/providers/mlx5/srq.c
+++ b/providers/mlx5/srq.c
@@ -60,7 +60,7 @@ int mlx5_copy_to_recv_srq(struct mlx5_srq *srq, int idx, void *buf, int size)
 
 	for (i = 0; i < max; ++i) {
 		copy = min_t(long, size, ntohl(scat->byte_count));
-		memcpy((void *)(unsigned long)ntohll(scat->addr), buf, copy);
+		memcpy((void *)(unsigned long)be64toh(scat->addr), buf, copy);
 		size -= copy;
 		if (size <= 0)
 			return IBV_WC_SUCCESS;
diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index ff6118acf611ca..19a1bfaeb22c88 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -365,7 +365,7 @@ static int is_enabled_by_rules_file(struct target_details *target)
 			continue;
 
 		if (conf->rules[rule].ioc_guid[0] != '\0' &&
-		    ntohll(target->ioc_prof.guid) !=
+		    be64toh(target->ioc_prof.guid) !=
 		    strtoull(conf->rules[rule].ioc_guid, NULL, 16))
 			continue;
 
@@ -450,7 +450,7 @@ static int add_non_exist_target(struct target_details *target)
 					target->h_service_id))
 			continue;
 		if (!check_equal_uint64(scsi_host_dir, "ioc_guid",
-					ntohll(target->ioc_prof.guid)))
+					be64toh(target->ioc_prof.guid)))
 			continue;
 		if (srpd_sys_read_gid(scsi_host_dir, "orig_dgid", dgid_val)) {
 			/*
@@ -518,7 +518,7 @@ static int add_non_exist_target(struct target_details *target)
 		"pkey=%04x,"
 		"service_id=%016llx",
 		target->id_ext,
-		(unsigned long long) ntohll(target->ioc_prof.guid),
+		(unsigned long long) be64toh(target->ioc_prof.guid),
 		(unsigned long long) target->subnet_prefix,
 		(unsigned long long) target->h_guid,
 		target->pkey,
@@ -545,7 +545,7 @@ static int add_non_exist_target(struct target_details *target)
 		len += snprintf(target_config_str+len,
 				MAX_TARGET_CONFIG_STR_STRING - len,
 				",initiator_ext=%016llx",
-				(unsigned long long) ntohll(target->h_guid));
+				(unsigned long long) be64toh(target->h_guid));
 
 		if (len >= MAX_TARGET_CONFIG_STR_STRING) {
 			pr_err("Target config string is too long, ignoring target\n");
@@ -637,7 +637,7 @@ recv:
 				return -ret;
 			}
 
-			received_tid = ntohll(in_dm_mad->tid);
+			received_tid = be64toh(in_dm_mad->tid);
 			if (tid != received_tid)
 				pr_debug("umad_recv returned different transaction id sent %d got %d\n",
 					 tid, received_tid);
@@ -970,7 +970,7 @@ static int do_port(struct resources *res, uint16_t pkey, uint16_t dlid,
 			pr_human("    controller[%3d]\n", i + 1);
 
 			pr_human("        GUID:      %016llx\n",
-				 (unsigned long long) ntohll(target->ioc_prof.guid));
+				 (unsigned long long) be64toh(target->ioc_prof.guid));
 			pr_human("        vendor ID: %06x\n", ntohl(target->ioc_prof.vendor_id) >> 8);
 			pr_human("        device ID: %06x\n", ntohl(target->ioc_prof.device_id));
 			pr_human("        IO class : %04hx\n", ntohs(target->ioc_prof.io_class));
@@ -997,10 +997,10 @@ static int do_port(struct resources *res, uint16_t pkey, uint16_t dlid,
 
 					pr_human("            service[%3d]: %016llx / %s\n",
 						 j + k,
-						 (unsigned long long) ntohll(svc_entries.service[k].id),
+						 (unsigned long long) be64toh(svc_entries.service[k].id),
 						 svc_entries.service[k].name);
 
-					target->h_service_id = ntohll(svc_entries.service[k].id);
+					target->h_service_id = be64toh(svc_entries.service[k].id);
 					target->pkey = pkey;
 					if (is_enabled_by_rules_file(target)) {
 						if (!add_non_exist_target(target) && !config->once) {
@@ -1041,7 +1041,7 @@ int get_node(struct umad_resources *umad_res, uint16_t dlid, uint64_t *guid)
 		return -1;
 
 	node  = (void *) in_sa_mad->data;
-	*guid = ntohll(node->port_guid);
+	*guid = be64toh(node->port_guid);
 
 	return 0;
 }
@@ -1067,7 +1067,7 @@ static int get_port_info(struct umad_resources *umad_res, uint16_t dlid,
 		return -1;
 
 	port_info = (void *) in_sa_mad->data;
-	*subnet_prefix = ntohll(port_info->subnet_prefix);
+	*subnet_prefix = be64toh(port_info->subnet_prefix);
 	*isdm          = !!(ntohl(port_info->capability_mask) & SRP_IS_DM);
 
 	return 0;
@@ -1233,7 +1233,7 @@ static int do_dm_port_list(struct resources *res)
 
 		for (j = 0; j < num_pkeys; ++j)
 			do_port(res, pkeys[j], ntohs(port_info->endport_lid),
-				ntohll(port_info->subnet_prefix), guid);
+				be64toh(port_info->subnet_prefix), guid);
 	}
 
 	free(in_mad_buf);
@@ -1311,7 +1311,7 @@ static int do_full_port_list(struct resources *res)
 
 		for (j = 0; j < num_pkeys; ++j)
 			(void) handle_port(res, pkeys[j], ntohs(node->lid),
-					   ntohll(node->port_guid));
+					   be64toh(node->port_guid));
 	}
 
 	free(in_mad_buf);
@@ -2195,7 +2195,7 @@ catas_start:
 
 					srp_sleep(0, 100);
 					handle_port(res, pkey, lid,
-						    ntohll(ib_gid_get_guid(&gid)));
+						    be64toh(ib_gid_get_guid(&gid)));
 				}
 			}
 		} else {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
