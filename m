From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next] IB/SA: Add support to query opa classport info.
Date: Fri, 28 Apr 2017 19:20:26 -0400
Message-ID: <1493421626-60796-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For OPA devices, SA will query the OPA classport info
instead of the IB defined classport info.
opa classport info exposes additional information and
capabilities that are specific to OPA devices.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 182 ++++++++++++++++++++++++++++++++-----
 include/rdma/ib_sa.h               |   1 +
 2 files changed, 158 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8a4b1f0..b57bdc2 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -67,10 +67,23 @@ struct ib_sa_sm_ah {
 	u8		     src_path_mask;
 };
 
+enum rdma_class_port_info_type {
+	RDMA_CLASS_PORT_INFO_IB,
+	RDMA_CLASS_PORT_INFO_OPA
+};
+
+struct rdma_class_port_info {
+	enum rdma_class_port_info_type type;
+	union {
+		struct ib_class_port_info ib;
+		struct opa_class_port_info opa;
+	};
+};
+
 struct ib_sa_classport_cache {
 	bool valid;
 	int retry_cnt;
-	struct ib_class_port_info data;
+	struct rdma_class_port_info data;
 };
 
 struct ib_sa_port {
@@ -107,6 +120,7 @@ struct ib_sa_query {
 
 #define IB_SA_ENABLE_LOCAL_SERVICE	0x00000001
 #define IB_SA_CANCEL			0x00000002
+#define IB_SA_QUERY_OPA			0x00000004
 
 struct ib_sa_service_query {
 	void (*callback)(int, struct ib_sa_service_rec *, void *);
@@ -410,7 +424,7 @@ struct ib_sa_mcmember_query {
 	.struct_size_bytes   = sizeof((struct ib_class_port_info *)0)->field,	\
 	.field_name          = "ib_class_port_info:" #field
 
-static const struct ib_field classport_info_rec_table[] = {
+static const struct ib_field ib_classport_info_rec_table[] = {
 	{ CLASSPORTINFO_REC_FIELD(base_version),
 	  .offset_words = 0,
 	  .offset_bits  = 0,
@@ -481,6 +495,88 @@ struct ib_sa_mcmember_query {
 	  .size_bits    = 32 },
 };
 
+#define OPA_CLASSPORTINFO_REC_FIELD(field) \
+	.struct_offset_bytes =\
+		offsetof(struct opa_class_port_info, field),	\
+	.struct_size_bytes   = \
+		sizeof((struct opa_class_port_info *)0)->field,	\
+	.field_name          = "opa_class_port_info:" #field
+
+static const struct ib_field opa_classport_info_rec_table[] = {
+	{ OPA_CLASSPORTINFO_REC_FIELD(base_version),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(class_version),
+	  .offset_words = 0,
+	  .offset_bits  = 8,
+	  .size_bits    = 8 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(cap_mask),
+	  .offset_words = 0,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(cap_mask2_resp_time),
+	  .offset_words = 1,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_gid),
+	  .offset_words = 2,
+	  .offset_bits  = 0,
+	  .size_bits    = 128 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_tc_fl),
+	  .offset_words = 6,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_lid),
+	  .offset_words = 7,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_sl_qp),
+	  .offset_words = 8,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_qkey),
+	  .offset_words = 9,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_gid),
+	  .offset_words = 10,
+	  .offset_bits  = 0,
+	  .size_bits    = 128 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_tc_fl),
+	  .offset_words = 14,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_lid),
+	  .offset_words = 15,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_hl_qp),
+	  .offset_words = 16,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_qkey),
+	  .offset_words = 17,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_pkey),
+	  .offset_words = 18,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_pkey),
+	  .offset_words = 18,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_sl_rsvd),
+	  .offset_words = 19,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ RESERVED,
+	  .offset_words = 19,
+	  .offset_bits  = 8,
+	  .size_bits    = 24 },
+};
+
 #define GUIDINFO_REC_FIELD(field) \
 	.struct_offset_bytes = offsetof(struct ib_sa_guidinfo_rec, field),	\
 	.struct_size_bytes   = sizeof((struct ib_sa_guidinfo_rec *) 0)->field,	\
@@ -1121,7 +1217,9 @@ static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
 					    query->sm_ah->pkey_index,
 					    0, IB_MGMT_SA_HDR, IB_MGMT_SA_DATA,
 					    gfp_mask,
-					    IB_MGMT_BASE_VERSION);
+					    ((query->flags & IB_SA_QUERY_OPA) ?
+					     OPA_MGMT_BASE_VERSION :
+					     IB_MGMT_BASE_VERSION));
 	if (IS_ERR(query->mad_buf)) {
 		kref_put(&query->sm_ah->ref, free_sm_ah);
 		return -ENOMEM;
@@ -1138,16 +1236,21 @@ static void free_mad(struct ib_sa_query *query)
 	kref_put(&query->sm_ah->ref, free_sm_ah);
 }
 
-static void init_mad(struct ib_sa_mad *mad, struct ib_mad_agent *agent)
+static void init_mad(struct ib_sa_query *query, struct ib_mad_agent *agent)
 {
+	struct ib_sa_mad *mad = query->mad_buf->mad;
 	unsigned long flags;
 
 	memset(mad, 0, sizeof *mad);
 
-	mad->mad_hdr.base_version  = IB_MGMT_BASE_VERSION;
+	if (query->flags & IB_SA_QUERY_OPA) {
+		mad->mad_hdr.base_version  = OPA_MGMT_BASE_VERSION;
+		mad->mad_hdr.class_version = OPA_SA_CLASS_VERSION;
+	} else {
+		mad->mad_hdr.base_version  = IB_MGMT_BASE_VERSION;
+		mad->mad_hdr.class_version = IB_SA_CLASS_VERSION;
+	}
 	mad->mad_hdr.mgmt_class    = IB_MGMT_CLASS_SUBN_ADM;
-	mad->mad_hdr.class_version = IB_SA_CLASS_VERSION;
-
 	spin_lock_irqsave(&tid_lock, flags);
 	mad->mad_hdr.tid           =
 		cpu_to_be64(((u64) agent->hi_tid) << 32 | tid++);
@@ -1301,7 +1404,7 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(&query->sa_query, agent);
 
 	query->sa_query.callback = callback ? ib_sa_path_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_path_rec_release;
@@ -1426,7 +1529,7 @@ int ib_sa_service_rec_query(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(&query->sa_query, agent);
 
 	query->sa_query.callback = callback ? ib_sa_service_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_service_rec_release;
@@ -1518,7 +1621,7 @@ int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(&query->sa_query, agent);
 
 	query->sa_query.callback = callback ? ib_sa_mcmember_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_mcmember_rec_release;
@@ -1615,7 +1718,7 @@ int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(&query->sa_query, agent);
 
 	query->sa_query.callback = callback ? ib_sa_guidinfo_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_guidinfo_rec_release;
@@ -1661,9 +1764,10 @@ bool ib_sa_sendonly_fullmem_support(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 
 	spin_lock_irqsave(&port->classport_lock, flags);
-	if (port->classport_info.valid)
-		ret = ib_get_cpi_capmask2(&port->classport_info.data) &
-			IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT;
+	if ((port->classport_info.valid) &&
+	    (port->classport_info.data.type == RDMA_CLASS_PORT_INFO_IB))
+		ret = ib_get_cpi_capmask2(&port->classport_info.data.ib)
+			& IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT;
 	spin_unlock_irqrestore(&port->classport_lock, flags);
 	return ret;
 }
@@ -1688,22 +1792,47 @@ static void ib_sa_classport_info_rec_callback(struct ib_sa_query *sa_query,
 	unsigned long flags;
 	struct ib_sa_classport_info_query *query =
 		container_of(sa_query, struct ib_sa_classport_info_query, sa_query);
+	struct ib_sa_classport_cache *info = &sa_query->port->classport_info;
 
 	if (mad) {
-		struct ib_class_port_info rec;
+		if (sa_query->flags & IB_SA_QUERY_OPA) {
+			struct opa_class_port_info rec;
 
-		ib_unpack(classport_info_rec_table,
-			  ARRAY_SIZE(classport_info_rec_table),
-			  mad->data, &rec);
+			ib_unpack(opa_classport_info_rec_table,
+				  ARRAY_SIZE(opa_classport_info_rec_table),
+				  mad->data, &rec);
+
+			spin_lock_irqsave(&sa_query->port->classport_lock,
+					  flags);
+			if (!status && !info->valid) {
+				memcpy(&info->data.opa, &rec,
+				       sizeof(info->data.opa));
+
+				info->valid = true;
+				info->data.type = RDMA_CLASS_PORT_INFO_OPA;
+			}
+			spin_unlock_irqrestore(&sa_query->port->classport_lock,
+					       flags);
+
+		} else {
+			struct ib_class_port_info rec;
 
-		spin_lock_irqsave(&sa_query->port->classport_lock, flags);
-		if (!status && !sa_query->port->classport_info.valid) {
-			memcpy(&sa_query->port->classport_info.data, &rec,
-			       sizeof(sa_query->port->classport_info.data));
+			ib_unpack(ib_classport_info_rec_table,
+				  ARRAY_SIZE(ib_classport_info_rec_table),
+				  mad->data, &rec);
 
-			sa_query->port->classport_info.valid = true;
+			spin_lock_irqsave(&sa_query->port->classport_lock,
+					  flags);
+			if (!status && !info->valid) {
+				memcpy(&info->data.ib, &rec,
+				       sizeof(info->data.ib));
+
+				info->valid = true;
+				info->data.type = RDMA_CLASS_PORT_INFO_IB;
+			}
+			spin_unlock_irqrestore(&sa_query->port->classport_lock,
+					       flags);
 		}
-		spin_unlock_irqrestore(&sa_query->port->classport_lock, flags);
 	}
 	query->callback(query->context);
 }
@@ -1733,6 +1862,9 @@ static int ib_sa_classport_info_rec_query(struct ib_sa_port *port,
 		return -ENOMEM;
 
 	query->sa_query.port = port;
+	query->sa_query.flags |= rdma_cap_opa_ah(port->agent->device,
+						 port->port_num) ?
+				 IB_SA_QUERY_OPA : 0;
 	ret = alloc_mad(&query->sa_query, gfp_mask);
 	if (ret)
 		goto err_free;
@@ -1741,7 +1873,7 @@ static int ib_sa_classport_info_rec_query(struct ib_sa_port *port,
 	query->context = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(&query->sa_query, agent);
 
 	query->sa_query.callback = ib_sa_classport_info_rec_callback;
 	query->sa_query.release  = ib_sa_classport_info_rec_release;
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 46838c8..843b562 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -56,6 +56,7 @@ enum {
 	IB_SA_METHOD_GET_TRACE_TBL	= 0x13
 };
 
+#define OPA_SA_CLASS_VERSION	0x80
 enum {
 	IB_SA_ATTR_CLASS_PORTINFO    = 0x01,
 	IB_SA_ATTR_NOTICE	     = 0x02,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
