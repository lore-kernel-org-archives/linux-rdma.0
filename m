From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] IB/SA: Fix kernel panic in CMA request handler flow
Date: Sun, 21 May 2017 19:09:54 +0300
Message-ID: <20170521160954.20311-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit 9fdca4da4d8c ("IB/SA: Split struct sa_path_rec based on IB and
ROCE specific fields") moved the service_id to be specific attribute
for IB and OPA SA Path Record, and thus wasn't assigned for RoCE.

This caused to the following kernel panic in the CMA request handler flow:

[   27.074594] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   27.074731] IP: __radix_tree_lookup+0x1d/0xe0
[   27.074782] PGD 1dadcb067
[   27.074783] PUD 1dadc3067
[   27.074821] PMD 0
[   27.074855]
[   27.074916] Oops: 0000 [#1] SMP
[   27.074950] Modules linked in: netconsole nfsv3 nfs fscache rdma_ucm ib_ucm
rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx4_en mlx4_ib ib_core
mlx4_core sg crc32_pclmul crc32c_intel dm_mirror dm_region_hash dm_log dm_mod
acpi_cpufreq ppdev serio_raw parport_pc i2c_piix4 parport virtio_balloon pcspkr
ghash_clmulni_intel nfsd auth_rpcgss nfs_acl lockd grace sunrpc uinput
binfmt_misc ata_generic pata_acpi cirrus mlx5_core drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm drm ata_piix libata virtio_blk e1000
virtio_pci ptp virtio_ring pps_core floppy i2c_core virtio [last unloaded:
ipmi_msghandler]
[   27.075252] CPU: 4 PID: 205 Comm: kworker/4:1 Not tainted 4.11.0-rc6+ #71
[   27.075307] Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
[   27.075356] Workqueue: ib_cm cm_work_handler [ib_cm]
[   27.075401] task: ffff88022e3b8000 task.stack: ffffc90001298000
[   27.075449] RIP: 0010:__radix_tree_lookup+0x1d/0xe0
[   27.075495] RSP: 0018:ffffc9000129bb98 EFLAGS: 00010292
[   27.075546] RAX: ffff88022e990180 RBX: ffffc9000129bc10 RCX: 0000000000000000
[   27.075600] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   27.075650] RBP: ffffc9000129bbc8 R08: ffffc9000129bad0 R09: 0000000000000002
[   27.075700] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
[   27.075770] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   27.075823] FS:  0000000000000000(0000) GS:ffff880237300000(0000) knlGS:0000000000000000
[   27.075879] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.075924] CR2: 0000000000000008 CR3: 0000000227bcd000 CR4: 00000000001406e0
[   27.075979] Call Trace:
[   27.076015]  radix_tree_lookup+0xd/0x10
[   27.076055]  cma_ps_find+0x59/0x70 [rdma_cm]
[   27.076097]  cma_id_from_event+0xd2/0x470 [rdma_cm]
[   27.076144]  ? ib_init_ah_from_path+0x39a/0x590 [ib_core]
[   27.076193]  cma_req_handler+0x25/0x480 [rdma_cm]
[   27.076237]  cm_process_work+0x25/0x120 [ib_cm]
[   27.076280]  ? cm_get_bth_pkey.isra.62+0x3c/0xa0 [ib_cm]
[   27.076350]  cm_req_handler+0xb03/0xd40 [ib_cm]
[   27.076430]  ? sched_clock_cpu+0x11/0xb0
[   27.076478]  cm_work_handler+0x194/0x1588 [ib_cm]
[   27.076525]  process_one_work+0x160/0x410
[   27.076565]  worker_thread+0x137/0x4a0
[   27.076614]  kthread+0x112/0x150
[   27.076684]  ? max_active_store+0x60/0x60
[   27.077642]  ? kthread_park+0x90/0x90
[   27.078530]  ret_from_fork+0x2c/0x40

This patch moves it back to the common SA Path Record structure
and removes the redundant setter and getter.

Tested on Connect-IB and Connect-X4 in Infiniband and RoCE respectively.

Fixes: 9fdca4da4d8c ("IB/SA: Split struct sa_path_rec based on IB and ROCE specific fields")
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c        |  4 ++--
 drivers/infiniband/core/cma.c       | 13 ++++++-------
 drivers/infiniband/core/sa_query.c  |  6 +++---
 drivers/infiniband/ulp/srp/ib_srp.c |  2 +-
 include/rdma/ib_sa.h                | 25 +++----------------------
 5 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1844770f3ae8..2b4d613a3474 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1429,7 +1429,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	primary_path->packet_life_time =
 		cm_req_get_primary_local_ack_timeout(req_msg);
 	primary_path->packet_life_time -= (primary_path->packet_life_time > 0);
-	sa_path_set_service_id(primary_path, req_msg->service_id);
+	primary_path->service_id = req_msg->service_id;

 	if (req_msg->alt_local_lid) {
 		alt_path->dgid = req_msg->alt_local_gid;
@@ -1452,7 +1452,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 		alt_path->packet_life_time =
 			cm_req_get_alt_local_ack_timeout(req_msg);
 		alt_path->packet_life_time -= (alt_path->packet_life_time > 0);
-		sa_path_set_service_id(alt_path, req_msg->service_id);
+		alt_path->service_id = req_msg->service_id;
 	}
 }

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 91b7a2fe5a55..31bb82d8ecd7 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1140,7 +1140,7 @@ static void cma_save_ib_info(struct sockaddr *src_addr,
 			ib->sib_pkey = path->pkey;
 			ib->sib_flowinfo = path->flow_label;
 			memcpy(&ib->sib_addr, &path->sgid, 16);
-			ib->sib_sid = sa_path_get_service_id(path);
+			ib->sib_sid = path->service_id;
 			ib->sib_scope_id = 0;
 		} else {
 			ib->sib_pkey = listen_ib->sib_pkey;
@@ -1274,8 +1274,7 @@ static int cma_save_req_info(const struct ib_cm_event *ib_event,
 		memcpy(&req->local_gid, &req_param->primary_path->sgid,
 		       sizeof(req->local_gid));
 		req->has_gid	= true;
-		req->service_id	=
-			sa_path_get_service_id(req_param->primary_path);
+		req->service_id = req_param->primary_path->service_id;
 		req->pkey	= be16_to_cpu(req_param->primary_path->pkey);
 		if (req->pkey != req_param->bth_pkey)
 			pr_warn_ratelimited("RDMA CMA: got different BTH P_Key (0x%x) and primary path P_Key (0x%x)\n"
@@ -1827,7 +1826,8 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	struct rdma_route *rt;
 	const sa_family_t ss_family = listen_id->route.addr.src_addr.ss_family;
 	struct sa_path_rec *path = ib_event->param.req_rcvd.primary_path;
-	const __be64 service_id = sa_path_get_service_id(path);
+	const __be64 service_id =
+		ib_event->param.req_rcvd.primary_path->service_id;
 	int ret;

 	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
@@ -2345,9 +2345,8 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	path_rec.pkey = cpu_to_be16(ib_addr_get_pkey(dev_addr));
 	path_rec.numb_path = 1;
 	path_rec.reversible = 1;
-	sa_path_set_service_id(&path_rec,
-			       rdma_get_service_id(&id_priv->id,
-						   cma_dst_addr(id_priv)));
+	path_rec.service_id = rdma_get_service_id(&id_priv->id,
+						  cma_dst_addr(id_priv));

 	comp_mask = IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
 		    IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index e335b09c022e..fb7aec4047c8 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -194,7 +194,7 @@ static u32 tid;
 	.field_name          = "sa_path_rec:" #field

 static const struct ib_field path_rec_table[] = {
-	{ PATH_REC_FIELD(ib.service_id),
+	{ PATH_REC_FIELD(service_id),
 	  .offset_words = 0,
 	  .offset_bits  = 0,
 	  .size_bits    = 64 },
@@ -296,7 +296,7 @@ static const struct ib_field path_rec_table[] = {
 	.field_name          = "sa_path_rec:" #field

 static const struct ib_field opa_path_rec_table[] = {
-	{ OPA_PATH_REC_FIELD(opa.service_id),
+	{ OPA_PATH_REC_FIELD(service_id),
 	  .offset_words = 0,
 	  .offset_bits  = 0,
 	  .size_bits    = 64 },
@@ -774,7 +774,7 @@ static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,

 	/* Now build the attributes */
 	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
-		val64 = be64_to_cpu(sa_path_get_service_id(sa_rec));
+		val64 = be64_to_cpu(sa_rec->service_id);
 		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
 			sizeof(val64), &val64);
 	}
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index def723a5df29..cc6371abc465 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -320,7 +320,7 @@ static int srp_new_cm_id(struct srp_rdma_ch *ch)
 	ch->path.sgid = target->sgid;
 	ch->path.dgid = target->orig_dgid;
 	ch->path.pkey = target->pkey;
-	sa_path_set_service_id(&ch->path, target->service_id);
+	ch->path.service_id = target->service_id;

 	return 0;
 }
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index f5f70e345318..355b81f4242d 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -158,7 +158,6 @@ enum sa_path_rec_type {
 };

 struct sa_path_rec_ib {
-	__be64       service_id;
 	__be16       dlid;
 	__be16       slid;
 	u8           raw_traffic;
@@ -174,7 +173,6 @@ struct sa_path_rec_roce {
 };

 struct sa_path_rec_opa {
-	__be64       service_id;
 	__be32       dlid;
 	__be32       slid;
 	u8           raw_traffic;
@@ -189,6 +187,7 @@ struct sa_path_rec_opa {
 struct sa_path_rec {
 	union ib_gid dgid;
 	union ib_gid sgid;
+	__be64       service_id;
 	/* reserved */
 	__be32       flow_label;
 	u8           hop_limit;
@@ -262,7 +261,7 @@ static inline void path_conv_opa_to_ib(struct sa_path_rec *ib,
 		ib->ib.dlid	= htons(ntohl(opa->opa.dlid));
 		ib->ib.slid	= htons(ntohl(opa->opa.slid));
 	}
-	ib->ib.service_id	= opa->opa.service_id;
+	ib->service_id		= opa->service_id;
 	ib->ib.raw_traffic	= opa->opa.raw_traffic;
 }

@@ -281,7 +280,7 @@ static inline void path_conv_ib_to_opa(struct sa_path_rec *opa,
 	}
 	opa->opa.slid		= slid;
 	opa->opa.dlid		= dlid;
-	opa->opa.service_id	= ib->ib.service_id;
+	opa->service_id		= ib->service_id;
 	opa->opa.raw_traffic	= ib->ib.raw_traffic;
 }

@@ -591,15 +590,6 @@ static inline bool sa_path_is_roce(struct sa_path_rec *rec)
 		(rec->rec_type == SA_PATH_REC_TYPE_ROCE_V2));
 }

-static inline void sa_path_set_service_id(struct sa_path_rec *rec,
-					  __be64 service_id)
-{
-	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
-		rec->ib.service_id = service_id;
-	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
-		rec->opa.service_id = service_id;
-}
-
 static inline void sa_path_set_slid(struct sa_path_rec *rec, __be32 slid)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
@@ -625,15 +615,6 @@ static inline void sa_path_set_raw_traffic(struct sa_path_rec *rec,
 		rec->opa.raw_traffic = raw_traffic;
 }

-static inline __be64 sa_path_get_service_id(struct sa_path_rec *rec)
-{
-	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
-		return rec->ib.service_id;
-	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
-		return rec->opa.service_id;
-	return 0;
-}
-
 static inline __be32 sa_path_get_slid(struct sa_path_rec *rec)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
