From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/SA: Add support to query OPA path records
Date: Mon, 17 Apr 2017 16:56:30 -0400
Message-ID: <1492462590-64866-7-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the bit 26 of capmask2 field in OPA classport info
query is set, SA will query for OPA path records instead
of querying for IB path records. Note that OPA
path records can only be queried by kernel ULPs.
Userspace clients continue to query IB path records.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c             |   6 +-
 drivers/infiniband/core/sa_query.c        | 264 ++++++++++++++++++++++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   5 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |   6 +-
 include/rdma/ib_mad.h                     |  13 ++
 5 files changed, 279 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 83ed2ac..fc595b99 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2332,7 +2332,11 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	struct sockaddr_ib *sib;
 
 	memset(&path_rec, 0, sizeof path_rec);
-	path_rec.rec_type = SA_PATH_REC_TYPE_IB;
+
+	if (rdma_cap_opa_ah(id_priv->id.device, id_priv->id.port_num))
+		path_rec.rec_type = SA_PATH_REC_TYPE_OPA;
+	else
+		path_rec.rec_type = SA_PATH_REC_TYPE_IB;
 	rdma_addr_get_sgid(dev_addr, &path_rec.sgid);
 	rdma_addr_get_dgid(dev_addr, &path_rec.dgid);
 	path_rec.pkey = cpu_to_be16(ib_addr_get_pkey(dev_addr));
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 745906e..471fe9c 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -132,6 +132,7 @@ struct ib_sa_path_query {
 	void (*callback)(int, struct sa_path_rec *, void *);
 	void *context;
 	struct ib_sa_query sa_query;
+	struct sa_path_rec *conv_pr;
 };
 
 struct ib_sa_guidinfo_query {
@@ -287,6 +288,136 @@ struct ib_sa_mcmember_query {
 	  .size_bits    = 48 },
 };
 
+#define OPA_PATH_REC_FIELD(field) \
+	.struct_offset_bytes = \
+		offsetof(struct sa_path_rec, field), \
+	.struct_size_bytes   = \
+		sizeof((struct sa_path_rec *)0)->field,	\
+	.field_name          = "sa_path_rec:" #field
+
+static const struct ib_field opa_path_rec_table[] = {
+	{ OPA_PATH_REC_FIELD(opa.service_id),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 64 },
+	{ OPA_PATH_REC_FIELD(dgid),
+	  .offset_words = 2,
+	  .offset_bits  = 0,
+	  .size_bits    = 128 },
+	{ OPA_PATH_REC_FIELD(sgid),
+	  .offset_words = 6,
+	  .offset_bits  = 0,
+	  .size_bits    = 128 },
+	{ OPA_PATH_REC_FIELD(opa.dlid),
+	  .offset_words = 10,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_PATH_REC_FIELD(opa.slid),
+	  .offset_words = 11,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_PATH_REC_FIELD(opa.raw_traffic),
+	  .offset_words = 12,
+	  .offset_bits  = 0,
+	  .size_bits    = 1 },
+	{ RESERVED,
+	  .offset_words = 12,
+	  .offset_bits  = 1,
+	  .size_bits    = 3 },
+	{ OPA_PATH_REC_FIELD(flow_label),
+	  .offset_words = 12,
+	  .offset_bits  = 4,
+	  .size_bits    = 20 },
+	{ OPA_PATH_REC_FIELD(hop_limit),
+	  .offset_words = 12,
+	  .offset_bits  = 24,
+	  .size_bits    = 8 },
+	{ OPA_PATH_REC_FIELD(traffic_class),
+	  .offset_words = 13,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ OPA_PATH_REC_FIELD(reversible),
+	  .offset_words = 13,
+	  .offset_bits  = 8,
+	  .size_bits    = 1 },
+	{ OPA_PATH_REC_FIELD(numb_path),
+	  .offset_words = 13,
+	  .offset_bits  = 9,
+	  .size_bits    = 7 },
+	{ OPA_PATH_REC_FIELD(pkey),
+	  .offset_words = 13,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ OPA_PATH_REC_FIELD(opa.l2_8B),
+	  .offset_words = 14,
+	  .offset_bits  = 0,
+	  .size_bits    = 1 },
+	{ OPA_PATH_REC_FIELD(opa.l2_10B),
+	  .offset_words = 14,
+	  .offset_bits  = 1,
+	  .size_bits    = 1 },
+	{ OPA_PATH_REC_FIELD(opa.l2_9B),
+	  .offset_words = 14,
+	  .offset_bits  = 2,
+	  .size_bits    = 1 },
+	{ OPA_PATH_REC_FIELD(opa.l2_16B),
+	  .offset_words = 14,
+	  .offset_bits  = 3,
+	  .size_bits    = 1 },
+	{ RESERVED,
+	  .offset_words = 14,
+	  .offset_bits  = 4,
+	  .size_bits    = 2 },
+	{ OPA_PATH_REC_FIELD(opa.qos_type),
+	  .offset_words = 14,
+	  .offset_bits  = 6,
+	  .size_bits    = 2 },
+	{ OPA_PATH_REC_FIELD(opa.qos_priority),
+	  .offset_words = 14,
+	  .offset_bits  = 8,
+	  .size_bits    = 8 },
+	{ RESERVED,
+	  .offset_words = 14,
+	  .offset_bits  = 16,
+	  .size_bits    = 3 },
+	{ OPA_PATH_REC_FIELD(sl),
+	  .offset_words = 14,
+	  .offset_bits  = 19,
+	  .size_bits    = 5 },
+	{ RESERVED,
+	  .offset_words = 14,
+	  .offset_bits  = 24,
+	  .size_bits    = 8 },
+	{ OPA_PATH_REC_FIELD(mtu_selector),
+	  .offset_words = 15,
+	  .offset_bits  = 0,
+	  .size_bits    = 2 },
+	{ OPA_PATH_REC_FIELD(mtu),
+	  .offset_words = 15,
+	  .offset_bits  = 2,
+	  .size_bits    = 6 },
+	{ OPA_PATH_REC_FIELD(rate_selector),
+	  .offset_words = 15,
+	  .offset_bits  = 8,
+	  .size_bits    = 2 },
+	{ OPA_PATH_REC_FIELD(rate),
+	  .offset_words = 15,
+	  .offset_bits  = 10,
+	  .size_bits    = 6 },
+	{ OPA_PATH_REC_FIELD(packet_life_time_selector),
+	  .offset_words = 15,
+	  .offset_bits  = 16,
+	  .size_bits    = 2 },
+	{ OPA_PATH_REC_FIELD(packet_life_time),
+	  .offset_words = 15,
+	  .offset_bits  = 18,
+	  .size_bits    = 6 },
+	{ OPA_PATH_REC_FIELD(preference),
+	  .offset_words = 15,
+	  .offset_bits  = 24,
+	  .size_bits    = 8 },
+};
+
 #define MCMEMBER_REC_FIELD(field) \
 	.struct_offset_bytes = offsetof(struct ib_sa_mcmember_rec, field),	\
 	.struct_size_bytes   = sizeof ((struct ib_sa_mcmember_rec *) 0)->field,	\
@@ -1283,7 +1414,8 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	query->mad_buf->context[0] = query;
 	query->id = id;
 
-	if (query->flags & IB_SA_ENABLE_LOCAL_SERVICE) {
+	if ((query->flags & IB_SA_ENABLE_LOCAL_SERVICE) &&
+	    (!(query->flags & IB_SA_QUERY_OPA))) {
 		if (!ibnl_chk_listeners(RDMA_NL_GROUP_LS)) {
 			if (!ib_nl_make_request(query, gfp_mask))
 				return id;
@@ -1318,6 +1450,62 @@ void ib_sa_pack_path(struct sa_path_rec *rec, void *attribute)
 }
 EXPORT_SYMBOL(ib_sa_pack_path);
 
+static bool ib_sa_opa_pathrecord_support(struct ib_sa_client *client,
+					 struct ib_device *device,
+					 u8 port_num)
+{
+	struct ib_sa_device *sa_dev = ib_get_client_data(device, &sa_client);
+	struct ib_sa_port *port = &sa_dev->port[port_num - sa_dev->start_port];
+	unsigned long flags;
+	bool ret = false;
+
+	if (!sa_dev)
+		return ret;
+
+	spin_lock_irqsave(&port->classport_lock, flags);
+	if (!port->classport_info.valid)
+		goto ret;
+
+	if (port->classport_info.data.type == RDMA_CLASS_PORT_INFO_OPA)
+		ret = opa_get_cpi_capmask2(&port->classport_info.data.opa) &
+			OPA_CLASS_PORT_INFO_PR_SUPPORT;
+ret:
+	spin_unlock_irqrestore(&port->classport_lock, flags);
+	return ret;
+}
+
+enum opa_pr_supported {
+	PR_NOT_SUPPORTED,
+	PR_OPA_SUPPORTED,
+	PR_IB_SUPPORTED
+};
+
+/**
+ * Check if current PR query can be an OPA query.
+ * Retuns PR_NOT_SUPPORTED if a path record query is not
+ * possible, PR_OPA_SUPPORTED if an OPA path record query
+ * is possible and PR_IB_SUPPORTED if an IB path record
+ * query is possible.
+ */
+static int opa_pr_query_possible(struct ib_sa_client *client,
+				 struct ib_device *device,
+				 u8 port_num,
+				 struct sa_path_rec *rec)
+{
+	struct ib_port_attr port_attr;
+
+	if (ib_query_port(device, port_num, &port_attr))
+		return PR_NOT_SUPPORTED;
+
+	if (ib_sa_opa_pathrecord_support(client, device, port_num))
+		return PR_OPA_SUPPORTED;
+
+	if (port_attr.lid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
+		return PR_NOT_SUPPORTED;
+	else
+		return PR_IB_SUPPORTED;
+}
+
 static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 				    int status,
 				    struct ib_sa_mad *mad)
@@ -1328,20 +1516,42 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 	if (mad) {
 		struct sa_path_rec rec;
 
-		ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table),
-			  mad->data, &rec);
-		rec.rec_type = SA_PATH_REC_TYPE_IB;
-		sa_path_set_ndev(&rec, NULL);
-		sa_path_set_ifindex(&rec, 0);
-		sa_path_set_dmac_zero(&rec);
-		query->callback(status, &rec, query->context);
+		if (sa_query->flags & IB_SA_QUERY_OPA) {
+			ib_unpack(opa_path_rec_table,
+				  ARRAY_SIZE(opa_path_rec_table),
+				  mad->data, &rec);
+			rec.rec_type = SA_PATH_REC_TYPE_OPA;
+			query->callback(status, &rec, query->context);
+		} else {
+			ib_unpack(path_rec_table,
+				  ARRAY_SIZE(path_rec_table),
+				  mad->data, &rec);
+			rec.rec_type = SA_PATH_REC_TYPE_IB;
+			sa_path_set_ndev(&rec, NULL);
+			sa_path_set_ifindex(&rec, 0);
+			sa_path_set_dmac_zero(&rec);
+
+			if (query->conv_pr) {
+				struct sa_path_rec opa;
+
+				memset(&opa, 0, sizeof(struct sa_path_rec));
+				sa_convert_path_ib_to_opa(&opa, &rec);
+				query->callback(status, &opa, query->context);
+			} else {
+				query->callback(status, &rec, query->context);
+			}
+		}
 	} else
 		query->callback(status, NULL, query->context);
 }
 
 static void ib_sa_path_rec_release(struct ib_sa_query *sa_query)
 {
-	kfree(container_of(sa_query, struct ib_sa_path_query, sa_query));
+	struct ib_sa_path_query *query =
+		container_of(sa_query, struct ib_sa_path_query, sa_query);
+
+	kfree(query->conv_pr);
+	kfree(query);
 }
 
 /**
@@ -1385,12 +1595,14 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 	struct ib_sa_port   *port;
 	struct ib_mad_agent *agent;
 	struct ib_sa_mad *mad;
+	enum opa_pr_supported status;
 	int ret;
 
 	if (!sa_dev)
 		return -ENODEV;
 
-	if (rec->rec_type != SA_PATH_REC_TYPE_IB)
+	if ((rec->rec_type != SA_PATH_REC_TYPE_IB) &&
+	    (rec->rec_type != SA_PATH_REC_TYPE_OPA))
 		return -EINVAL;
 
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
@@ -1401,6 +1613,23 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 		return -ENOMEM;
 
 	query->sa_query.port     = port;
+	if (rec->rec_type == SA_PATH_REC_TYPE_OPA) {
+		status = opa_pr_query_possible(client, device, port_num, rec);
+		if (status == PR_NOT_SUPPORTED) {
+			return -EINVAL;
+			goto err1;
+		} else if (status == PR_OPA_SUPPORTED) {
+			query->sa_query.flags |= IB_SA_QUERY_OPA;
+		} else {
+			query->conv_pr =
+				kmalloc(sizeof(*query->conv_pr), gfp_mask);
+			if (!query->conv_pr) {
+				ret = -ENOMEM;
+				goto err1;
+			}
+		}
+	}
+
 	ret = alloc_mad(&query->sa_query, gfp_mask);
 	if (ret)
 		goto err1;
@@ -1419,12 +1648,23 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 	mad->mad_hdr.attr_id	 = cpu_to_be16(IB_SA_ATTR_PATH_REC);
 	mad->sa_hdr.comp_mask	 = comp_mask;
 
-	ib_pack(path_rec_table, ARRAY_SIZE(path_rec_table), rec, mad->data);
+	if (query->sa_query.flags & IB_SA_QUERY_OPA) {
+		ib_pack(opa_path_rec_table, ARRAY_SIZE(opa_path_rec_table),
+			rec, mad->data);
+	} else if (query->conv_pr) {
+		sa_convert_path_opa_to_ib(query->conv_pr, rec);
+		ib_pack(path_rec_table, ARRAY_SIZE(path_rec_table),
+			query->conv_pr, mad->data);
+	} else {
+		ib_pack(path_rec_table, ARRAY_SIZE(path_rec_table),
+			rec, mad->data);
+	}
 
 	*sa_query = &query->sa_query;
 
 	query->sa_query.flags |= IB_SA_ENABLE_LOCAL_SERVICE;
-	query->sa_query.mad_buf->context[1] = rec;
+	query->sa_query.mad_buf->context[1] = (query->conv_pr) ?
+						query->conv_pr : rec;
 
 	ret = send_mad(&query->sa_query, timeout_ms, gfp_mask);
 	if (ret < 0)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 4d3f146..7dfe424 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -832,7 +832,10 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 
 	INIT_LIST_HEAD(&path->neigh_list);
 
-	path->pathrec.rec_type	    = SA_PATH_REC_TYPE_IB;
+	if (rdma_cap_opa_ah(priv->ca, priv->port))
+		path->pathrec.rec_type = SA_PATH_REC_TYPE_OPA;
+	else
+		path->pathrec.rec_type = SA_PATH_REC_TYPE_IB;
 	memcpy(path->pathrec.dgid.raw, gid, sizeof (union ib_gid));
 	path->pathrec.sgid	    = priv->local_gid;
 	path->pathrec.pkey	    = cpu_to_be16(priv->pkey);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 07877a8..def723a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -312,7 +312,11 @@ static int srp_new_cm_id(struct srp_rdma_ch *ch)
 	if (ch->cm_id)
 		ib_destroy_cm_id(ch->cm_id);
 	ch->cm_id = new_cm_id;
-	ch->path.rec_type = SA_PATH_REC_TYPE_IB;
+	if (rdma_cap_opa_ah(target->srp_host->srp_dev->dev,
+			    target->srp_host->port))
+		ch->path.rec_type = SA_PATH_REC_TYPE_OPA;
+	else
+		ch->path.rec_type = SA_PATH_REC_TYPE_IB;
 	ch->path.sgid = target->sgid;
 	ch->path.dgid = target->orig_dgid;
 	ch->path.pkey = target->pkey;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 8e75f5d..2632516 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -262,6 +262,8 @@ struct ib_class_port_info {
 	__be32			trap_qkey;
 };
 
+#define OPA_CLASS_PORT_INFO_PR_SUPPORT BIT(26)
+
 struct opa_class_port_info {
 	u8 base_version;
 	u8 class_version;
@@ -340,6 +342,17 @@ static inline void ib_set_cpi_capmask2(struct ib_class_port_info *cpi,
 			    IB_CLASS_PORT_INFO_RESP_TIME_FIELD_SIZE);
 }
 
+/**
+ * opa_get_cpi_capmask2 - Returns the capmask2 value from
+ * cap_mask2_resp_time in ib_class_port_info.
+ * @cpi: A struct opa_class_port_info mad.
+ */
+static inline u32 opa_get_cpi_capmask2(struct opa_class_port_info *cpi)
+{
+	return (be32_to_cpu(cpi->cap_mask2_resp_time) >>
+		IB_CLASS_PORT_INFO_RESP_TIME_FIELD_SIZE);
+}
+
 struct ib_mad_notice_attr {
 	u8 generic_type;
 	u8 prod_type_msb;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
