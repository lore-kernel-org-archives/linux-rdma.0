From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 4/6] IB/SA: Split struct sa_path_rec based on IB and ROCE specific fields
Date: Mon, 17 Apr 2017 16:56:28 -0400
Message-ID: <1492462590-64866-5-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sa_path_rec now contains a union of sa_path_rec_ib and sa_path_rec_roce
based on the type of the path record. Note that fields applicable to
path record type ROCE v1 and ROCE v2 fall under sa_path_rec_roce.
Accessor functions are added to these fields so the caller doesn't have
to know the type.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c              |  62 +++++++------
 drivers/infiniband/core/cma.c             |  22 +++--
 drivers/infiniband/core/sa_query.c        |  32 ++++---
 drivers/infiniband/core/uverbs_marshall.c |  20 ++--
 drivers/infiniband/ulp/ipoib/ipoib_fs.c   |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  11 ++-
 drivers/infiniband/ulp/srp/ib_srp.c       |   7 +-
 include/rdma/ib_sa.h                      | 147 +++++++++++++++++++++++++++---
 8 files changed, 224 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 39e306a..ca742e8 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1203,8 +1203,8 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 	}
 
 	if (pri_path->hop_limit <= 1) {
-		req_msg->primary_local_lid = pri_path->slid;
-		req_msg->primary_remote_lid = pri_path->dlid;
+		req_msg->primary_local_lid = sa_path_get_slid(pri_path);
+		req_msg->primary_remote_lid = sa_path_get_dlid(pri_path);
 	} else {
 		/* Work-around until there's a way to obtain remote LID info */
 		req_msg->primary_local_lid = IB_LID_PERMISSIVE;
@@ -1224,8 +1224,8 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 
 	if (alt_path) {
 		if (alt_path->hop_limit <= 1) {
-			req_msg->alt_local_lid = alt_path->slid;
-			req_msg->alt_remote_lid = alt_path->dlid;
+			req_msg->alt_local_lid = sa_path_get_slid(alt_path);
+			req_msg->alt_remote_lid = sa_path_get_dlid(alt_path);
 		} else {
 			req_msg->alt_local_lid = IB_LID_PERMISSIVE;
 			req_msg->alt_remote_lid = IB_LID_PERMISSIVE;
@@ -1405,11 +1405,10 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 				     struct sa_path_rec *primary_path,
 				     struct sa_path_rec *alt_path)
 {
-	memset(primary_path, 0, sizeof(*primary_path));
 	primary_path->dgid = req_msg->primary_local_gid;
 	primary_path->sgid = req_msg->primary_remote_gid;
-	primary_path->dlid = req_msg->primary_local_lid;
-	primary_path->slid = req_msg->primary_remote_lid;
+	sa_path_set_dlid(primary_path, req_msg->primary_local_lid);
+	sa_path_set_slid(primary_path, req_msg->primary_remote_lid);
 	primary_path->flow_label = cm_req_get_primary_flow_label(req_msg);
 	primary_path->hop_limit = req_msg->primary_hop_limit;
 	primary_path->traffic_class = req_msg->primary_traffic_class;
@@ -1424,14 +1423,13 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 	primary_path->packet_life_time =
 		cm_req_get_primary_local_ack_timeout(req_msg);
 	primary_path->packet_life_time -= (primary_path->packet_life_time > 0);
-	primary_path->service_id = req_msg->service_id;
+	sa_path_set_service_id(primary_path, req_msg->service_id);
 
 	if (req_msg->alt_local_lid) {
-		memset(alt_path, 0, sizeof(*alt_path));
 		alt_path->dgid = req_msg->alt_local_gid;
 		alt_path->sgid = req_msg->alt_remote_gid;
-		alt_path->dlid = req_msg->alt_local_lid;
-		alt_path->slid = req_msg->alt_remote_lid;
+		sa_path_set_dlid(alt_path, req_msg->alt_local_lid);
+		sa_path_set_slid(alt_path, req_msg->alt_remote_lid);
 		alt_path->flow_label = cm_req_get_alt_flow_label(req_msg);
 		alt_path->hop_limit = req_msg->alt_hop_limit;
 		alt_path->traffic_class = req_msg->alt_traffic_class;
@@ -1446,7 +1444,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 		alt_path->packet_life_time =
 			cm_req_get_alt_local_ack_timeout(req_msg);
 		alt_path->packet_life_time -= (alt_path->packet_life_time > 0);
-		alt_path->service_id = req_msg->service_id;
+		sa_path_set_service_id(alt_path, req_msg->service_id);
 	}
 }
 
@@ -1760,27 +1758,34 @@ static int cm_req_handler(struct cm_work *work)
 	cm_id_priv->id.service_mask = ~cpu_to_be64(0);
 
 	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
-	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 
-	if (cm_id_priv->av.ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE)
-		memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.roce.dmac,
-		       ETH_ALEN);
+	memset(&work->path[0], 0, sizeof(work->path[0]));
+	memset(&work->path[1], 0, sizeof(work->path[1]));
 	grh = rdma_ah_read_grh(&cm_id_priv->av.ah_attr);
-	work->path[0].hop_limit = grh->hop_limit;
 	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
 				work->port->port_num,
 				grh->sgid_index,
 				&gid, &gid_attr);
 	if (!ret) {
 		if (gid_attr.ndev) {
-			work->path[0].ifindex = gid_attr.ndev->ifindex;
-			work->path[0].net = dev_net(gid_attr.ndev);
-			dev_put(gid_attr.ndev);
 			work->path[0].rec_type =
 				sa_conv_gid_to_pathrec_type(gid_attr.gid_type);
+			sa_path_set_ifindex(&work->path[0],
+					    gid_attr.ndev->ifindex);
+			sa_path_set_ndev(&work->path[0],
+					 dev_net(gid_attr.ndev));
+			dev_put(gid_attr.ndev);
 		} else {
 			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
 		}
+		if (req_msg->alt_local_lid)
+			work->path[1].rec_type = work->path[0].rec_type;
+		cm_format_paths_from_req(req_msg, &work->path[0],
+					 &work->path[1]);
+		if (cm_id_priv->av.ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE)
+			sa_path_set_dmac(&work->path[0],
+					 cm_id_priv->av.ah_attr.roce.dmac);
+		work->path[0].hop_limit = grh->hop_limit;
 		ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av,
 					 cm_id_priv);
 	}
@@ -1790,11 +1795,13 @@ static int cm_req_handler(struct cm_work *work)
 					    &work->path[0].sgid,
 					    &gid_attr);
 		if (!err && gid_attr.ndev) {
-			work->path[0].ifindex = gid_attr.ndev->ifindex;
-			work->path[0].net = dev_net(gid_attr.ndev);
-			dev_put(gid_attr.ndev);
 			work->path[0].rec_type =
 				sa_conv_gid_to_pathrec_type(gid_attr.gid_type);
+			sa_path_set_ifindex(&work->path[0],
+					    gid_attr.ndev->ifindex);
+			sa_path_set_ndev(&work->path[0],
+					 dev_net(gid_attr.ndev));
+			dev_put(gid_attr.ndev);
 		} else {
 			work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
 		}
@@ -2835,8 +2842,8 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 	cm_lap_set_remote_qpn(lap_msg, cm_id_priv->remote_qpn);
 	/* todo: need remote CM response timeout */
 	cm_lap_set_remote_resp_timeout(lap_msg, 0x1F);
-	lap_msg->alt_local_lid = alternate_path->slid;
-	lap_msg->alt_remote_lid = alternate_path->dlid;
+	lap_msg->alt_local_lid = sa_path_get_slid(alternate_path);
+	lap_msg->alt_remote_lid = sa_path_get_dlid(alternate_path);
 	lap_msg->alt_local_gid = alternate_path->sgid;
 	lap_msg->alt_remote_gid = alternate_path->dgid;
 	cm_lap_set_flow_label(lap_msg, alternate_path->flow_label);
@@ -2912,10 +2919,11 @@ static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
 				    struct cm_lap_msg *lap_msg)
 {
 	memset(path, 0, sizeof *path);
+	path->rec_type = SA_PATH_REC_TYPE_IB;
 	path->dgid = lap_msg->alt_local_gid;
 	path->sgid = lap_msg->alt_remote_gid;
-	path->dlid = lap_msg->alt_local_lid;
-	path->slid = lap_msg->alt_remote_lid;
+	sa_path_set_dlid(path, lap_msg->alt_local_lid);
+	sa_path_set_slid(path, lap_msg->alt_remote_lid);
 	path->flow_label = cm_lap_get_flow_label(lap_msg);
 	path->hop_limit = lap_msg->alt_hop_limit;
 	path->traffic_class = cm_lap_get_traffic_class(lap_msg);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a6195d5..83ed2ac 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1140,7 +1140,7 @@ static void cma_save_ib_info(struct sockaddr *src_addr,
 			ib->sib_pkey = path->pkey;
 			ib->sib_flowinfo = path->flow_label;
 			memcpy(&ib->sib_addr, &path->sgid, 16);
-			ib->sib_sid = path->service_id;
+			ib->sib_sid = sa_path_get_service_id(path);
 			ib->sib_scope_id = 0;
 		} else {
 			ib->sib_pkey = listen_ib->sib_pkey;
@@ -1274,7 +1274,8 @@ static int cma_save_req_info(const struct ib_cm_event *ib_event,
 		memcpy(&req->local_gid, &req_param->primary_path->sgid,
 		       sizeof(req->local_gid));
 		req->has_gid	= true;
-		req->service_id	= req_param->primary_path->service_id;
+		req->service_id	=
+			sa_path_get_service_id(req_param->primary_path);
 		req->pkey	= be16_to_cpu(req_param->primary_path->pkey);
 		if (req->pkey != req_param->bth_pkey)
 			pr_warn_ratelimited("RDMA CMA: got different BTH P_Key (0x%x) and primary path P_Key (0x%x)\n"
@@ -1822,8 +1823,8 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	struct rdma_cm_id *id;
 	struct rdma_route *rt;
 	const sa_family_t ss_family = listen_id->route.addr.src_addr.ss_family;
-	const __be64 service_id =
-		      ib_event->param.req_rcvd.primary_path->service_id;
+	struct sa_path_rec *path = ib_event->param.req_rcvd.primary_path;
+	const __be64 service_id = sa_path_get_service_id(path);
 	int ret;
 
 	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
@@ -1845,7 +1846,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	if (!rt->path_rec)
 		goto err;
 
-	rt->path_rec[0] = *ib_event->param.req_rcvd.primary_path;
+	rt->path_rec[0] = *path;
 	if (rt->num_paths == 2)
 		rt->path_rec[1] = *ib_event->param.req_rcvd.alternate_path;
 
@@ -2331,12 +2332,15 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	struct sockaddr_ib *sib;
 
 	memset(&path_rec, 0, sizeof path_rec);
+	path_rec.rec_type = SA_PATH_REC_TYPE_IB;
 	rdma_addr_get_sgid(dev_addr, &path_rec.sgid);
 	rdma_addr_get_dgid(dev_addr, &path_rec.dgid);
 	path_rec.pkey = cpu_to_be16(ib_addr_get_pkey(dev_addr));
 	path_rec.numb_path = 1;
 	path_rec.reversible = 1;
-	path_rec.service_id = rdma_get_service_id(&id_priv->id, cma_dst_addr(id_priv));
+	sa_path_set_service_id(&path_rec,
+			       rdma_get_service_id(&id_priv->id,
+						   cma_dst_addr(id_priv)));
 
 	comp_mask = IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
 		    IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
@@ -2574,8 +2578,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 			}
 		}
 
-		route->path_rec->net = &init_net;
-		route->path_rec->ifindex = ndev->ifindex;
 		supported_gids = roce_gid_type_mask_support(id_priv->id.device,
 							    id_priv->id.port_num);
 		gid_type = cma_route_gid_type(addr->dev_addr.network,
@@ -2583,13 +2585,15 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 					      id_priv->gid_type);
 		route->path_rec->rec_type =
 			sa_conv_gid_to_pathrec_type(gid_type);
+		sa_path_set_ndev(route->path_rec, &init_net);
+		sa_path_set_ifindex(route->path_rec, ndev->ifindex);
 	}
 	if (!ndev) {
 		ret = -ENODEV;
 		goto err2;
 	}
 
-	memcpy(route->path_rec->dmac, addr->dev_addr.dst_dev_addr, ETH_ALEN);
+	sa_path_set_dmac(route->path_rec, addr->dev_addr.dst_dev_addr);
 
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
 		    &route->path_rec->sgid);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 050a8e6..12614c9 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -193,7 +193,7 @@ struct ib_sa_mcmember_query {
 	.field_name          = "sa_path_rec:" #field
 
 static const struct ib_field path_rec_table[] = {
-	{ PATH_REC_FIELD(service_id),
+	{ PATH_REC_FIELD(ib.service_id),
 	  .offset_words = 0,
 	  .offset_bits  = 0,
 	  .size_bits    = 64 },
@@ -205,15 +205,15 @@ struct ib_sa_mcmember_query {
 	  .offset_words = 6,
 	  .offset_bits  = 0,
 	  .size_bits    = 128 },
-	{ PATH_REC_FIELD(dlid),
+	{ PATH_REC_FIELD(ib.dlid),
 	  .offset_words = 10,
 	  .offset_bits  = 0,
 	  .size_bits    = 16 },
-	{ PATH_REC_FIELD(slid),
+	{ PATH_REC_FIELD(ib.slid),
 	  .offset_words = 10,
 	  .offset_bits  = 16,
 	  .size_bits    = 16 },
-	{ PATH_REC_FIELD(raw_traffic),
+	{ PATH_REC_FIELD(ib.raw_traffic),
 	  .offset_words = 11,
 	  .offset_bits  = 0,
 	  .size_bits    = 1 },
@@ -643,7 +643,7 @@ static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
 
 	/* Now build the attributes */
 	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
-		val64 = be64_to_cpu(sa_rec->service_id);
+		val64 = be64_to_cpu(sa_path_get_service_id(sa_rec));
 		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
 			sizeof(val64), &val64);
 	}
@@ -1110,9 +1110,9 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	memset(ah_attr, 0, sizeof *ah_attr);
 	ah_attr->type = rdma_ah_find_type(device, port_num);
 
-	rdma_ah_set_dlid(ah_attr, be16_to_cpu(rec->dlid));
+	rdma_ah_set_dlid(ah_attr, be16_to_cpu(sa_path_get_dlid(rec)));
 	rdma_ah_set_sl(ah_attr, rec->sl);
-	rdma_ah_set_path_bits(ah_attr, be16_to_cpu(rec->slid) &
+	rdma_ah_set_path_bits(ah_attr, be16_to_cpu(sa_path_get_slid(rec)) &
 			      get_src_path_mask(device, port_num));
 	rdma_ah_set_port_num(ah_attr, port_num);
 	rdma_ah_set_static_rate(ah_attr, rec->rate);
@@ -1121,9 +1121,13 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	if (use_roce) {
 		struct net_device *idev;
 		struct net_device *resolved_dev;
-		struct rdma_dev_addr dev_addr = {.bound_dev_if = rec->ifindex,
-						 .net = rec->net ? rec->net :
-							 &init_net};
+		struct rdma_dev_addr dev_addr = {
+			.bound_dev_if = ((sa_path_get_ifindex(rec) >= 0) ?
+					 sa_path_get_ifindex(rec) : 0),
+			.net = sa_path_get_ndev(rec) ?
+				sa_path_get_ndev(rec) :
+				&init_net
+		};
 		union {
 			struct sockaddr     _sockaddr;
 			struct sockaddr_in  _sockaddr_in;
@@ -1194,7 +1198,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	}
 
 	if (use_roce)
-		memcpy(ah_attr->roce.dmac, rec->dmac, ETH_ALEN);
+		memcpy(ah_attr->roce.dmac, sa_path_get_dmac(rec), ETH_ALEN);
 
 	return 0;
 }
@@ -1326,10 +1330,10 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 
 		ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table),
 			  mad->data, &rec);
-		rec.net = NULL;
-		rec.ifindex = 0;
 		rec.rec_type = SA_PATH_REC_TYPE_IB;
-		eth_zero_addr(rec.dmac);
+		sa_path_set_ndev(&rec, NULL);
+		sa_path_set_ifindex(&rec, 0);
+		sa_path_set_dmac_zero(&rec);
 		query->callback(status, &rec, query->context);
 	} else
 		query->callback(status, NULL, query->context);
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index b4e9ce8..50575b6 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -102,9 +102,9 @@ void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 	memcpy(dst->dgid, src->dgid.raw, sizeof src->dgid);
 	memcpy(dst->sgid, src->sgid.raw, sizeof src->sgid);
 
-	dst->dlid		= src->dlid;
-	dst->slid		= src->slid;
-	dst->raw_traffic	= src->raw_traffic;
+	dst->dlid		= sa_path_get_dlid(src);
+	dst->slid		= sa_path_get_slid(src);
+	dst->raw_traffic	= sa_path_get_raw_traffic(src);
 	dst->flow_label		= src->flow_label;
 	dst->hop_limit		= src->hop_limit;
 	dst->traffic_class	= src->traffic_class;
@@ -128,9 +128,10 @@ void ib_copy_path_rec_from_user(struct sa_path_rec *dst,
 	memcpy(dst->dgid.raw, src->dgid, sizeof dst->dgid);
 	memcpy(dst->sgid.raw, src->sgid, sizeof dst->sgid);
 
-	dst->dlid		= src->dlid;
-	dst->slid		= src->slid;
-	dst->raw_traffic	= src->raw_traffic;
+	dst->rec_type = SA_PATH_REC_TYPE_IB;
+	sa_path_set_dlid(dst, src->dlid);
+	sa_path_set_slid(dst, src->slid);
+	sa_path_set_raw_traffic(dst, src->raw_traffic);
 	dst->flow_label		= src->flow_label;
 	dst->hop_limit		= src->hop_limit;
 	dst->traffic_class	= src->traffic_class;
@@ -146,9 +147,8 @@ void ib_copy_path_rec_from_user(struct sa_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 
-	memset(dst->dmac, 0, sizeof(dst->dmac));
-	dst->net = NULL;
-	dst->ifindex = 0;
-	dst->rec_type = SA_PATH_REC_TYPE_IB;
+	sa_path_set_dmac_zero(dst);
+	sa_path_set_ndev(dst, NULL);
+	sa_path_set_ifindex(dst, 0);
 }
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 09396bd..aa9083f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -210,16 +210,16 @@ static int ipoib_path_seq_show(struct seq_file *file, void *iter_ptr)
 	seq_printf(file,
 		   "GID: %s\n"
 		   "  complete: %6s\n",
-		   gid_buf, path.pathrec.dlid ? "yes" : "no");
+		   gid_buf, sa_path_get_dlid(&path.pathrec) ? "yes" : "no");
 
-	if (path.pathrec.dlid) {
+	if (sa_path_get_dlid(&path.pathrec)) {
 		rate = ib_rate_to_mbps(path.pathrec.rate);
 
 		seq_printf(file,
 			   "  DLID:     0x%04x\n"
 			   "  SL: %12d\n"
 			   "  rate: %8d.%d Gb/sec\n",
-			   be16_to_cpu(path.pathrec.dlid),
+			   be16_to_cpu(sa_path_get_dlid(&path.pathrec)),
 			   path.pathrec.sl,
 			   rate / 1000, rate % 1000);
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5e7939f..cc88d85 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -669,7 +669,7 @@ void ipoib_mark_paths_invalid(struct net_device *dev)
 
 	list_for_each_entry_safe(path, tp, &priv->path_list, list) {
 		ipoib_dbg(priv, "mark path LID 0x%04x GID %pI6 invalid\n",
-			be16_to_cpu(path->pathrec.dlid),
+			be16_to_cpu(sa_path_get_dlid(&path->pathrec)),
 			path->pathrec.dgid.raw);
 		path->valid =  0;
 	}
@@ -731,7 +731,8 @@ static void path_rec_completion(int status,
 
 	if (!status)
 		ipoib_dbg(priv, "PathRec LID 0x%04x for GID %pI6\n",
-			  be16_to_cpu(pathrec->dlid), pathrec->dgid.raw);
+			  be16_to_cpu(sa_path_get_dlid(pathrec)),
+			  pathrec->dgid.raw);
 	else
 		ipoib_dbg(priv, "PathRec status %d for GID %pI6\n",
 			  status, path->pathrec.dgid.raw);
@@ -754,7 +755,8 @@ static void path_rec_completion(int status,
 		path->ah = ah;
 
 		ipoib_dbg(priv, "created address handle %p for LID 0x%04x, SL %d\n",
-			  ah, be16_to_cpu(pathrec->dlid), pathrec->sl);
+			  ah, be16_to_cpu(sa_path_get_dlid(pathrec)),
+			  pathrec->sl);
 
 		while ((skb = __skb_dequeue(&path->queue)))
 			__skb_queue_tail(&skqueue, skb);
@@ -830,6 +832,7 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 
 	INIT_LIST_HEAD(&path->neigh_list);
 
+	path->pathrec.rec_type	    = SA_PATH_REC_TYPE_IB;
 	memcpy(path->pathrec.dgid.raw, gid, sizeof (union ib_gid));
 	path->pathrec.sgid	    = priv->local_gid;
 	path->pathrec.pkey	    = cpu_to_be16(priv->pkey);
@@ -995,7 +998,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 
 	if (path->ah) {
 		ipoib_dbg(priv, "Send unicast ARP to %04x\n",
-			  be16_to_cpu(path->pathrec.dlid));
+			  be16_to_cpu(sa_path_get_dlid(&path->pathrec)));
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ipoib_send(dev, skb, path->ah, IPOIB_QPN(phdr->hwaddr));
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ded9b9a..89341dd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -312,10 +312,11 @@ static int srp_new_cm_id(struct srp_rdma_ch *ch)
 	if (ch->cm_id)
 		ib_destroy_cm_id(ch->cm_id);
 	ch->cm_id = new_cm_id;
+	ch->path.rec_type = SA_PATH_REC_TYPE_IB;
 	ch->path.sgid = target->sgid;
 	ch->path.dgid = target->orig_dgid;
 	ch->path.pkey = target->pkey;
-	ch->path.service_id = target->service_id;
+	sa_path_set_service_id(&ch->path, target->service_id);
 
 	return 0;
 }
@@ -2399,12 +2400,12 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 	switch (event->param.rej_rcvd.reason) {
 	case IB_CM_REJ_PORT_CM_REDIRECT:
 		cpi = event->param.rej_rcvd.ari;
-		ch->path.dlid = cpi->redirect_lid;
+		sa_path_set_dlid(&ch->path, cpi->redirect_lid);
 		ch->path.pkey = cpi->redirect_pkey;
 		cm_id->remote_cm_qpn = be32_to_cpu(cpi->redirect_qp) & 0x00ffffff;
 		memcpy(ch->path.dgid.raw, cpi->redirect_gid, 16);
 
-		ch->status = ch->path.dlid ?
+		ch->status = sa_path_get_dlid(&ch->path) ?
 			SRP_DLID_REDIRECT : SRP_PORT_REDIRECT;
 		break;
 
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index c009147..c72c949 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -43,6 +43,7 @@
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_mad.h>
+#include <rdma/ib_addr.h>
 
 enum {
 	IB_SA_CLASS_VERSION		= 2,	/* IB spec version 1.1/1.2 */
@@ -147,19 +148,32 @@ enum ib_sa_mc_join_states {
 #define IB_SA_PATH_REC_PACKET_LIFE_TIME_SELECTOR	IB_SA_COMP_MASK(20)
 #define IB_SA_PATH_REC_PACKET_LIFE_TIME			IB_SA_COMP_MASK(21)
 #define IB_SA_PATH_REC_PREFERENCE			IB_SA_COMP_MASK(22)
+
 enum sa_path_rec_type {
 	SA_PATH_REC_TYPE_IB,
 	SA_PATH_REC_TYPE_ROCE_V1,
 	SA_PATH_REC_TYPE_ROCE_V2
 };
 
-struct sa_path_rec {
+struct sa_path_rec_ib {
 	__be64       service_id;
-	union ib_gid dgid;
-	union ib_gid sgid;
 	__be16       dlid;
 	__be16       slid;
 	u8           raw_traffic;
+};
+
+struct sa_path_rec_roce {
+	u8           dmac[ETH_ALEN];
+	/* ignored in IB */
+	int	     ifindex;
+	/* ignored in IB */
+	struct net  *net;
+
+};
+
+struct sa_path_rec {
+	union ib_gid dgid;
+	union ib_gid sgid;
 	/* reserved */
 	__be32       flow_label;
 	u8           hop_limit;
@@ -176,19 +190,13 @@ struct sa_path_rec {
 	u8           packet_life_time_selector;
 	u8           packet_life_time;
 	u8           preference;
-	u8           dmac[ETH_ALEN];
-	/* ignored in IB */
-	int	     ifindex;
-	/* ignored in IB */
-	struct net  *net;
+	union {
+		struct sa_path_rec_ib ib;
+		struct sa_path_rec_roce roce;
+	};
 	enum sa_path_rec_type rec_type;
 };
 
-static inline struct net_device *ib_get_ndev_from_path(struct sa_path_rec *rec)
-{
-	return rec->net ? dev_get_by_index(rec->net, rec->ifindex) : NULL;
-}
-
 static inline enum ib_gid_type
 		sa_conv_pathrec_to_gid_type(struct sa_path_rec *rec)
 {
@@ -490,4 +498,117 @@ bool ib_sa_sendonly_fullmem_support(struct ib_sa_client *client,
 				    struct ib_device *device,
 				    u8 port_num);
 
+static inline bool sa_path_is_roce(struct sa_path_rec *rec)
+{
+	return ((rec->rec_type == SA_PATH_REC_TYPE_ROCE_V1) ||
+		(rec->rec_type == SA_PATH_REC_TYPE_ROCE_V2));
+}
+
+static inline void sa_path_set_service_id(struct sa_path_rec *rec,
+					  __be64 service_id)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		rec->ib.service_id = service_id;
+}
+
+static inline void sa_path_set_slid(struct sa_path_rec *rec, __be16 slid)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		rec->ib.slid = slid;
+}
+
+static inline void sa_path_set_dlid(struct sa_path_rec *rec, __be16 dlid)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		rec->ib.dlid = dlid;
+}
+
+static inline void sa_path_set_raw_traffic(struct sa_path_rec *rec,
+					   u8 raw_traffic)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		rec->ib.raw_traffic = raw_traffic;
+}
+
+static inline __be64 sa_path_get_service_id(struct sa_path_rec *rec)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		return rec->ib.service_id;
+	return 0;
+}
+
+static inline __be16 sa_path_get_slid(struct sa_path_rec *rec)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		return rec->ib.slid;
+	return 0;
+}
+
+static inline __be16 sa_path_get_dlid(struct sa_path_rec *rec)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		return rec->ib.dlid;
+	return 0;
+}
+
+static inline u8 sa_path_get_raw_traffic(struct sa_path_rec *rec)
+{
+	if (rec->rec_type == SA_PATH_REC_TYPE_IB)
+		return rec->ib.raw_traffic;
+	return 0;
+}
+
+static inline void sa_path_set_dmac(struct sa_path_rec *rec, u8 *dmac)
+{
+	if (sa_path_is_roce(rec))
+		memcpy(rec->roce.dmac, dmac, ETH_ALEN);
+}
+
+static inline void sa_path_set_dmac_zero(struct sa_path_rec *rec)
+{
+	if (sa_path_is_roce(rec))
+		eth_zero_addr(rec->roce.dmac);
+}
+
+static inline void sa_path_set_ifindex(struct sa_path_rec *rec, int ifindex)
+{
+	if (sa_path_is_roce(rec))
+		rec->roce.ifindex = ifindex;
+}
+
+static inline void sa_path_set_ndev(struct sa_path_rec *rec, struct net *net)
+{
+	if (sa_path_is_roce(rec))
+		rec->roce.net = net;
+}
+
+static inline u8 *sa_path_get_dmac(struct sa_path_rec *rec)
+{
+	if (sa_path_is_roce(rec))
+		return rec->roce.dmac;
+	return NULL;
+}
+
+static inline int sa_path_get_ifindex(struct sa_path_rec *rec)
+{
+	if (sa_path_is_roce(rec))
+		return rec->roce.ifindex;
+	return 0;
+}
+
+static inline struct net *sa_path_get_ndev(struct sa_path_rec *rec)
+{
+	if (sa_path_is_roce(rec))
+		return rec->roce.net;
+	return NULL;
+}
+
+static inline struct net_device *ib_get_ndev_from_path(struct sa_path_rec *rec)
+{
+	return sa_path_get_ndev(rec) ?
+		dev_get_by_index(sa_path_get_ndev(rec),
+				 sa_path_get_ifindex(rec))
+		: NULL;
+}
+
 #endif /* IB_SA_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
