From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 5/6] IB/SA: Add OPA path record type
Date: Mon, 17 Apr 2017 16:56:29 -0400
Message-ID: <1492462590-64866-6-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add opa_sa_path_rec to sa_path_rec data structure.
The 'type' field in sa_path_rec identifies the
type of the path record.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c              |  34 ++++++---
 drivers/infiniband/core/sa_query.c        |   4 +-
 drivers/infiniband/core/ucma.c            |  22 +++++-
 drivers/infiniband/core/uverbs_marshall.c |  40 ++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_fs.c   |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  14 ++--
 drivers/infiniband/ulp/srp/ib_srp.c       |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c     |   3 +-
 include/rdma/ib_sa.h                      | 121 +++++++++++++++++++++++++++---
 include/rdma/opa_addr.h                   |  79 +++++++++++++++++++
 10 files changed, 278 insertions(+), 43 deletions(-)
 create mode 100644 include/rdma/opa_addr.h

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index ca742e8..1844770 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1203,8 +1203,10 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 	}
 
 	if (pri_path->hop_limit <= 1) {
-		req_msg->primary_local_lid = sa_path_get_slid(pri_path);
-		req_msg->primary_remote_lid = sa_path_get_dlid(pri_path);
+		req_msg->primary_local_lid =
+			htons(ntohl(sa_path_get_slid(pri_path)));
+		req_msg->primary_remote_lid =
+			htons(ntohl(sa_path_get_dlid(pri_path)));
 	} else {
 		/* Work-around until there's a way to obtain remote LID info */
 		req_msg->primary_local_lid = IB_LID_PERMISSIVE;
@@ -1224,8 +1226,10 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 
 	if (alt_path) {
 		if (alt_path->hop_limit <= 1) {
-			req_msg->alt_local_lid = sa_path_get_slid(alt_path);
-			req_msg->alt_remote_lid = sa_path_get_dlid(alt_path);
+			req_msg->alt_local_lid =
+				htons(ntohl(sa_path_get_slid(alt_path)));
+			req_msg->alt_remote_lid =
+				htons(ntohl(sa_path_get_dlid(alt_path)));
 		} else {
 			req_msg->alt_local_lid = IB_LID_PERMISSIVE;
 			req_msg->alt_remote_lid = IB_LID_PERMISSIVE;
@@ -1407,8 +1411,10 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 {
 	primary_path->dgid = req_msg->primary_local_gid;
 	primary_path->sgid = req_msg->primary_remote_gid;
-	sa_path_set_dlid(primary_path, req_msg->primary_local_lid);
-	sa_path_set_slid(primary_path, req_msg->primary_remote_lid);
+	sa_path_set_dlid(primary_path,
+			 htonl(ntohs(req_msg->primary_local_lid)));
+	sa_path_set_slid(primary_path,
+			 htonl(ntohs(req_msg->primary_remote_lid)));
 	primary_path->flow_label = cm_req_get_primary_flow_label(req_msg);
 	primary_path->hop_limit = req_msg->primary_hop_limit;
 	primary_path->traffic_class = req_msg->primary_traffic_class;
@@ -1428,8 +1434,10 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	if (req_msg->alt_local_lid) {
 		alt_path->dgid = req_msg->alt_local_gid;
 		alt_path->sgid = req_msg->alt_remote_gid;
-		sa_path_set_dlid(alt_path, req_msg->alt_local_lid);
-		sa_path_set_slid(alt_path, req_msg->alt_remote_lid);
+		sa_path_set_dlid(alt_path,
+				 htonl(ntohs(req_msg->alt_local_lid)));
+		sa_path_set_slid(alt_path,
+				 htonl(ntohs(req_msg->alt_remote_lid)));
 		alt_path->flow_label = cm_req_get_alt_flow_label(req_msg);
 		alt_path->hop_limit = req_msg->alt_hop_limit;
 		alt_path->traffic_class = req_msg->alt_traffic_class;
@@ -2842,8 +2850,10 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 	cm_lap_set_remote_qpn(lap_msg, cm_id_priv->remote_qpn);
 	/* todo: need remote CM response timeout */
 	cm_lap_set_remote_resp_timeout(lap_msg, 0x1F);
-	lap_msg->alt_local_lid = sa_path_get_slid(alternate_path);
-	lap_msg->alt_remote_lid = sa_path_get_dlid(alternate_path);
+	lap_msg->alt_local_lid =
+		htons(ntohl(sa_path_get_slid(alternate_path)));
+	lap_msg->alt_remote_lid =
+		htons(ntohl(sa_path_get_dlid(alternate_path)));
 	lap_msg->alt_local_gid = alternate_path->sgid;
 	lap_msg->alt_remote_gid = alternate_path->dgid;
 	cm_lap_set_flow_label(lap_msg, alternate_path->flow_label);
@@ -2922,8 +2932,8 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 	path->rec_type = SA_PATH_REC_TYPE_IB;
 	path->dgid = lap_msg->alt_local_gid;
 	path->sgid = lap_msg->alt_remote_gid;
-	sa_path_set_dlid(path, lap_msg->alt_local_lid);
-	sa_path_set_slid(path, lap_msg->alt_remote_lid);
+	sa_path_set_dlid(path, htonl(ntohs(lap_msg->alt_local_lid)));
+	sa_path_set_slid(path, htonl(ntohs(lap_msg->alt_remote_lid)));
 	path->flow_label = cm_lap_get_flow_label(lap_msg);
 	path->hop_limit = lap_msg->alt_hop_limit;
 	path->traffic_class = cm_lap_get_traffic_class(lap_msg);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 12614c9..745906e 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1110,9 +1110,9 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	memset(ah_attr, 0, sizeof *ah_attr);
 	ah_attr->type = rdma_ah_find_type(device, port_num);
 
-	rdma_ah_set_dlid(ah_attr, be16_to_cpu(sa_path_get_dlid(rec)));
+	rdma_ah_set_dlid(ah_attr, be32_to_cpu(sa_path_get_dlid(rec)));
 	rdma_ah_set_sl(ah_attr, rec->sl);
-	rdma_ah_set_path_bits(ah_attr, be16_to_cpu(sa_path_get_slid(rec)) &
+	rdma_ah_set_path_bits(ah_attr, be32_to_cpu(sa_path_get_slid(rec)) &
 			      get_src_path_mask(device, port_num));
 	rdma_ah_set_port_num(ah_attr, port_num);
 	rdma_ah_set_static_rate(ah_attr, rec->rate);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2beff90..276f0ef 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -898,11 +898,18 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 	for (i = 0, out_len -= sizeof(*resp);
 	     i < resp->num_paths && out_len > sizeof(struct ib_path_rec_data);
 	     i++, out_len -= sizeof(struct ib_path_rec_data)) {
+		struct sa_path_rec *rec = &ctx->cm_id->route.path_rec[i];
 
 		resp->path_data[i].flags = IB_PATH_GMP | IB_PATH_PRIMARY |
 					   IB_PATH_BIDIRECTIONAL;
-		ib_sa_pack_path(&ctx->cm_id->route.path_rec[i],
-				&resp->path_data[i].path_rec);
+		if (rec->rec_type == SA_PATH_REC_TYPE_IB) {
+			ib_sa_pack_path(rec, &resp->path_data[i].path_rec);
+		} else {
+			struct sa_path_rec ib;
+
+			sa_convert_path_opa_to_ib(&ib, rec);
+			ib_sa_pack_path(&ib, &resp->path_data[i].path_rec);
+		}
 	}
 
 	if (copy_to_user(response, resp,
@@ -1215,8 +1222,17 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
 
 	memset(&sa_path, 0, sizeof(sa_path));
 
+	sa_path.rec_type = SA_PATH_REC_TYPE_IB;
 	ib_sa_unpack_path(path_data->path_rec, &sa_path);
-	ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
+
+	if (rdma_cap_opa_ah(ctx->cm_id->device, ctx->cm_id->port_num)) {
+		struct sa_path_rec opa;
+
+		sa_convert_path_ib_to_opa(&opa, &sa_path);
+		ret = rdma_set_ib_paths(ctx->cm_id, &opa, 1);
+	} else {
+		ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
+	}
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 50575b6..8b9587f 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -96,14 +96,14 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 }
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
 
-void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
-			      struct sa_path_rec *src)
+void __ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
+				struct sa_path_rec *src)
 {
 	memcpy(dst->dgid, src->dgid.raw, sizeof src->dgid);
 	memcpy(dst->sgid, src->sgid.raw, sizeof src->sgid);
 
-	dst->dlid		= sa_path_get_dlid(src);
-	dst->slid		= sa_path_get_slid(src);
+	dst->dlid		= htons(ntohl(sa_path_get_dlid(src)));
+	dst->slid		= htons(ntohl(sa_path_get_slid(src)));
 	dst->raw_traffic	= sa_path_get_raw_traffic(src);
 	dst->flow_label		= src->flow_label;
 	dst->hop_limit		= src->hop_limit;
@@ -120,17 +120,42 @@ void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 }
+
+void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
+			      struct sa_path_rec *src)
+{
+	struct sa_path_rec rec;
+
+	if (src->rec_type == SA_PATH_REC_TYPE_OPA) {
+		sa_convert_path_opa_to_ib(&rec, src);
+		__ib_copy_path_rec_to_user(dst, &rec);
+		return;
+	}
+	__ib_copy_path_rec_to_user(dst, src);
+}
 EXPORT_SYMBOL(ib_copy_path_rec_to_user);
 
 void ib_copy_path_rec_from_user(struct sa_path_rec *dst,
 				struct ib_user_path_rec *src)
 {
+	__be32 slid, dlid;
+
+	memset(dst, 0, sizeof(*dst));
+	if ((ib_is_opa_gid((union ib_gid *)src->sgid)) ||
+	    (ib_is_opa_gid((union ib_gid *)src->dgid))) {
+		dst->rec_type = SA_PATH_REC_TYPE_OPA;
+		slid = htonl(opa_get_lid_from_gid((union ib_gid *)src->sgid));
+		dlid = htonl(opa_get_lid_from_gid((union ib_gid *)src->dgid));
+	} else {
+		dst->rec_type = SA_PATH_REC_TYPE_IB;
+		slid = htonl(ntohs(src->slid));
+		dlid = htonl(ntohs(src->dlid));
+	}
 	memcpy(dst->dgid.raw, src->dgid, sizeof dst->dgid);
 	memcpy(dst->sgid.raw, src->sgid, sizeof dst->sgid);
 
-	dst->rec_type = SA_PATH_REC_TYPE_IB;
-	sa_path_set_dlid(dst, src->dlid);
-	sa_path_set_slid(dst, src->slid);
+	sa_path_set_dlid(dst, dlid);
+	sa_path_set_slid(dst, slid);
 	sa_path_set_raw_traffic(dst, src->raw_traffic);
 	dst->flow_label		= src->flow_label;
 	dst->hop_limit		= src->hop_limit;
@@ -147,6 +172,7 @@ void ib_copy_path_rec_from_user(struct sa_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 
+	/* TODO: No need to set this */
 	sa_path_set_dmac_zero(dst);
 	sa_path_set_ndev(dst, NULL);
 	sa_path_set_ifindex(dst, 0);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index aa9083f..f7f2590 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -219,7 +219,7 @@ static int ipoib_path_seq_show(struct seq_file *file, void *iter_ptr)
 			   "  DLID:     0x%04x\n"
 			   "  SL: %12d\n"
 			   "  rate: %8d.%d Gb/sec\n",
-			   be16_to_cpu(sa_path_get_dlid(&path.pathrec)),
+			   be32_to_cpu(sa_path_get_dlid(&path.pathrec)),
 			   path.pathrec.sl,
 			   rate / 1000, rate % 1000);
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index cc88d85..4d3f146 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -668,9 +668,9 @@ void ipoib_mark_paths_invalid(struct net_device *dev)
 	spin_lock_irq(&priv->lock);
 
 	list_for_each_entry_safe(path, tp, &priv->path_list, list) {
-		ipoib_dbg(priv, "mark path LID 0x%04x GID %pI6 invalid\n",
-			be16_to_cpu(sa_path_get_dlid(&path->pathrec)),
-			path->pathrec.dgid.raw);
+		ipoib_dbg(priv, "mark path LID 0x%08x GID %pI6 invalid\n",
+			  be32_to_cpu(sa_path_get_dlid(&path->pathrec)),
+			  path->pathrec.dgid.raw);
 		path->valid =  0;
 	}
 
@@ -731,7 +731,7 @@ static void path_rec_completion(int status,
 
 	if (!status)
 		ipoib_dbg(priv, "PathRec LID 0x%04x for GID %pI6\n",
-			  be16_to_cpu(sa_path_get_dlid(pathrec)),
+			  be32_to_cpu(sa_path_get_dlid(pathrec)),
 			  pathrec->dgid.raw);
 	else
 		ipoib_dbg(priv, "PathRec status %d for GID %pI6\n",
@@ -755,7 +755,7 @@ static void path_rec_completion(int status,
 		path->ah = ah;
 
 		ipoib_dbg(priv, "created address handle %p for LID 0x%04x, SL %d\n",
-			  ah, be16_to_cpu(sa_path_get_dlid(pathrec)),
+			  ah, be32_to_cpu(sa_path_get_dlid(pathrec)),
 			  pathrec->sl);
 
 		while ((skb = __skb_dequeue(&path->queue)))
@@ -997,8 +997,8 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	if (path->ah) {
-		ipoib_dbg(priv, "Send unicast ARP to %04x\n",
-			  be16_to_cpu(sa_path_get_dlid(&path->pathrec)));
+		ipoib_dbg(priv, "Send unicast ARP to %08x\n",
+			  be32_to_cpu(sa_path_get_dlid(&path->pathrec)));
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ipoib_send(dev, skb, path->ah, IPOIB_QPN(phdr->hwaddr));
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 89341dd..07877a8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2400,7 +2400,7 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 	switch (event->param.rej_rcvd.reason) {
 	case IB_CM_REJ_PORT_CM_REDIRECT:
 		cpi = event->param.rej_rcvd.ari;
-		sa_path_set_dlid(&ch->path, cpi->redirect_lid);
+		sa_path_set_dlid(&ch->path, htonl(ntohs(cpi->redirect_lid)));
 		ch->path.pkey = cpi->redirect_pkey;
 		cm_id->remote_cm_qpn = be32_to_cpu(cpi->redirect_qp) & 0x00ffffff;
 		memcpy(ch->path.dgid.raw, cpi->redirect_gid, 16);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7d6c199..38df02f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1846,6 +1846,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srp_login_rej *rej;
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
+	union ib_gid *sgid = &param->primary_path->sgid;
 	__be16 *guid;
 	u32 it_iu_len;
 	int i, ret = 0;
@@ -1992,7 +1993,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 
-	guid = (__be16 *)&param->primary_path->sgid.global.interface_id;
+	guid = (__be16 *)&sgid->global.interface_id;
 	snprintf(ch->ini_guid, sizeof(ch->ini_guid), "%04x:%04x:%04x:%04x",
 		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
 		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index c72c949..0551cb4 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -44,6 +44,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_addr.h>
+#include <rdma/opa_addr.h>
 
 enum {
 	IB_SA_CLASS_VERSION		= 2,	/* IB spec version 1.1/1.2 */
@@ -152,7 +153,8 @@ enum ib_sa_mc_join_states {
 enum sa_path_rec_type {
 	SA_PATH_REC_TYPE_IB,
 	SA_PATH_REC_TYPE_ROCE_V1,
-	SA_PATH_REC_TYPE_ROCE_V2
+	SA_PATH_REC_TYPE_ROCE_V2,
+	SA_PATH_REC_TYPE_OPA
 };
 
 struct sa_path_rec_ib {
@@ -171,6 +173,19 @@ struct sa_path_rec_roce {
 
 };
 
+struct sa_path_rec_opa {
+	__be64       service_id;
+	__be32       dlid;
+	__be32       slid;
+	u8           raw_traffic;
+	u8	     l2_8B;
+	u8	     l2_10B;
+	u8	     l2_9B;
+	u8	     l2_16B;
+	u8	     qos_type;
+	u8	     qos_priority;
+};
+
 struct sa_path_rec {
 	union ib_gid dgid;
 	union ib_gid sgid;
@@ -193,6 +208,7 @@ struct sa_path_rec {
 	union {
 		struct sa_path_rec_ib ib;
 		struct sa_path_rec_roce roce;
+		struct sa_path_rec_opa opa;
 	};
 	enum sa_path_rec_type rec_type;
 };
@@ -223,6 +239,77 @@ struct sa_path_rec {
 	}
 }
 
+static inline void path_conv_opa_to_ib(struct sa_path_rec *ib,
+				       struct sa_path_rec *opa)
+{
+	if ((be32_to_cpu(opa->opa.dlid) >=
+	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
+	    (be32_to_cpu(opa->opa.slid) >=
+	     be16_to_cpu(IB_MULTICAST_LID_BASE))) {
+		/* Create OPA GID and zero out the LID */
+		ib->dgid.global.interface_id
+				= OPA_MAKE_ID(opa->opa.dlid);
+		ib->dgid.global.subnet_prefix
+				= opa->dgid.global.subnet_prefix;
+		ib->sgid.global.interface_id
+				= OPA_MAKE_ID(opa->opa.slid);
+		ib->dgid.global.subnet_prefix
+				= opa->dgid.global.subnet_prefix;
+		ib->ib.dlid	= 0;
+
+		ib->ib.slid	= 0;
+	} else {
+		ib->ib.dlid	= opa->opa.dlid;
+		ib->ib.slid	= opa->opa.slid;
+	}
+	ib->ib.service_id	= opa->opa.service_id;
+	ib->ib.raw_traffic	= opa->opa.raw_traffic;
+}
+
+static inline void path_conv_ib_to_opa(struct sa_path_rec *opa,
+				       struct sa_path_rec *ib)
+{
+	__be32 slid, dlid;
+
+	if ((ib_is_opa_gid(&ib->sgid)) ||
+	    (ib_is_opa_gid(&ib->dgid))) {
+		slid = htonl(opa_get_lid_from_gid(&ib->sgid));
+		dlid = htonl(opa_get_lid_from_gid(&ib->dgid));
+	} else {
+		slid = htonl(ntohs(ib->ib.slid));
+		dlid = htonl(ntohs(ib->ib.dlid));
+	}
+	opa->opa.slid		= slid;
+	opa->opa.dlid		= dlid;
+	opa->opa.service_id	= ib->ib.service_id;
+	opa->opa.raw_traffic	= ib->ib.raw_traffic;
+}
+
+/* Convert from OPA to IB path record */
+static inline void sa_convert_path_opa_to_ib(struct sa_path_rec *dest,
+					     struct sa_path_rec *src)
+{
+	if (src->rec_type != SA_PATH_REC_TYPE_OPA)
+		return;
+
+	*dest = *src;
+	dest->rec_type = SA_PATH_REC_TYPE_IB;
+	path_conv_opa_to_ib(dest, src);
+}
+
+/* Convert from IB to OPA path record */
+static inline void sa_convert_path_ib_to_opa(struct sa_path_rec *dest,
+					     struct sa_path_rec *src)
+{
+	if (src->rec_type != SA_PATH_REC_TYPE_IB)
+		return;
+
+	/* Do a structure copy and overwrite the relevant fields */
+	*dest = *src;
+	dest->rec_type = SA_PATH_REC_TYPE_OPA;
+	path_conv_ib_to_opa(dest, src);
+}
+
 #define IB_SA_MCMEMBER_REC_MGID				IB_SA_COMP_MASK( 0)
 #define IB_SA_MCMEMBER_REC_PORT_GID			IB_SA_COMP_MASK( 1)
 #define IB_SA_MCMEMBER_REC_QKEY				IB_SA_COMP_MASK( 2)
@@ -509,18 +596,24 @@ static inline void sa_path_set_service_id(struct sa_path_rec *rec,
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
 		rec->ib.service_id = service_id;
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		rec->opa.service_id = service_id;
 }
 
-static inline void sa_path_set_slid(struct sa_path_rec *rec, __be16 slid)
+static inline void sa_path_set_slid(struct sa_path_rec *rec, __be32 slid)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
-		rec->ib.slid = slid;
+		rec->ib.slid = htons(ntohl(slid));
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		rec->opa.slid = slid;
 }
 
-static inline void sa_path_set_dlid(struct sa_path_rec *rec, __be16 dlid)
+static inline void sa_path_set_dlid(struct sa_path_rec *rec, __be32 dlid)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
-		rec->ib.dlid = dlid;
+		rec->ib.dlid = htons(ntohl(dlid));
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		rec->opa.dlid = dlid;
 }
 
 static inline void sa_path_set_raw_traffic(struct sa_path_rec *rec,
@@ -528,26 +621,34 @@ static inline void sa_path_set_raw_traffic(struct sa_path_rec *rec,
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
 		rec->ib.raw_traffic = raw_traffic;
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		rec->opa.raw_traffic = raw_traffic;
 }
 
 static inline __be64 sa_path_get_service_id(struct sa_path_rec *rec)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
 		return rec->ib.service_id;
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		return rec->opa.service_id;
 	return 0;
 }
 
-static inline __be16 sa_path_get_slid(struct sa_path_rec *rec)
+static inline __be32 sa_path_get_slid(struct sa_path_rec *rec)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
-		return rec->ib.slid;
+		return htonl(ntohs(rec->ib.slid));
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		return rec->opa.dlid;
 	return 0;
 }
 
-static inline __be16 sa_path_get_dlid(struct sa_path_rec *rec)
+static inline __be32 sa_path_get_dlid(struct sa_path_rec *rec)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
-		return rec->ib.dlid;
+		return htonl(ntohs(rec->ib.dlid));
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		return rec->opa.dlid;
 	return 0;
 }
 
@@ -555,6 +656,8 @@ static inline u8 sa_path_get_raw_traffic(struct sa_path_rec *rec)
 {
 	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
 		return rec->ib.raw_traffic;
+	else if (rec->rec_type == SA_PATH_REC_TYPE_OPA)
+		return rec->opa.raw_traffic;
 	return 0;
 }
 
diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
new file mode 100644
index 0000000..eace28f
--- /dev/null
+++ b/include/rdma/opa_addr.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright(c) 2017 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef OPA_ADDR_H
+#define OPA_ADDR_H
+
+#define	OPA_SPECIAL_OUI		(0x00066AULL)
+#define OPA_MAKE_ID(x)          (cpu_to_be64(OPA_SPECIAL_OUI << 40 | (x)))
+
+/**
+ * ib_is_opa_gid: Returns true if the top 24 bits of the gid
+ * contains the OPA_STL_OUI identifier. This identifies that
+ * the provided gid is a special purpose GID meant to carry
+ * extended LID information.
+ *
+ * @gid: The Global identifier
+ */
+static inline bool ib_is_opa_gid(union ib_gid *gid)
+{
+	return ((be64_to_cpu(gid->global.interface_id) >> 40) ==
+		OPA_SPECIAL_OUI);
+}
+
+/**
+ * opa_get_lid_from_gid: Returns the last 32 bits of the gid.
+ * OPA devices use one of the gids in the gid table to also
+ * store the lid.
+ *
+ * @gid: The Global identifier
+ */
+static inline u32 opa_get_lid_from_gid(union ib_gid *gid)
+{
+	return be64_to_cpu(gid->global.interface_id) & 0xFFFFFFFF;
+}
+#endif /* OPA_ADDR_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
