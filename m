From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 7/7] IB/SA: Add support to query opa classport info.
Date: Wed, 15 Mar 2017 17:24:26 -0400
Message-ID: <1489613066-61684-8-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1489613066-61684-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489613066-61684-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For OPA devices, SA will query the OPA classport info
instead of the IB defined classport info.
opa classport info exposes additional information and
capabilities that are specific to OPA devices.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 229 +++++++++++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/mad.c   |  25 ----
 include/rdma/ib_mad.h              |  25 ++++
 include/rdma/ib_sa.h               |   1 +
 4 files changed, 206 insertions(+), 74 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index bc32989..b2b0c1f 100644
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
@@ -405,80 +419,162 @@ struct ib_sa_mcmember_query {
 	  .size_bits    = 2*64 },
 };
 
-#define CLASSPORTINFO_REC_FIELD(field) \
+#define IB_CLASSPORTINFO_REC_FIELD(field) \
 	.struct_offset_bytes = offsetof(struct ib_class_port_info, field),	\
 	.struct_size_bytes   = sizeof((struct ib_class_port_info *)0)->field,	\
 	.field_name          = "ib_class_port_info:" #field
 
-static const struct ib_field classport_info_rec_table[] = {
-	{ CLASSPORTINFO_REC_FIELD(base_version),
+static const struct ib_field ib_classport_info_rec_table[] = {
+	{ IB_CLASSPORTINFO_REC_FIELD(base_version),
 	  .offset_words = 0,
 	  .offset_bits  = 0,
 	  .size_bits    = 8 },
-	{ CLASSPORTINFO_REC_FIELD(class_version),
+	{ IB_CLASSPORTINFO_REC_FIELD(class_version),
 	  .offset_words = 0,
 	  .offset_bits  = 8,
 	  .size_bits    = 8 },
-	{ CLASSPORTINFO_REC_FIELD(capability_mask),
+	{ IB_CLASSPORTINFO_REC_FIELD(capability_mask),
 	  .offset_words = 0,
 	  .offset_bits  = 16,
 	  .size_bits    = 16 },
-	{ CLASSPORTINFO_REC_FIELD(cap_mask2_resp_time),
+	{ IB_CLASSPORTINFO_REC_FIELD(cap_mask2_resp_time),
 	  .offset_words = 1,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
-	{ CLASSPORTINFO_REC_FIELD(redirect_gid),
+	{ IB_CLASSPORTINFO_REC_FIELD(redirect_gid),
 	  .offset_words = 2,
 	  .offset_bits  = 0,
 	  .size_bits    = 128 },
-	{ CLASSPORTINFO_REC_FIELD(redirect_tcslfl),
+	{ IB_CLASSPORTINFO_REC_FIELD(redirect_tcslfl),
 	  .offset_words = 6,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
-	{ CLASSPORTINFO_REC_FIELD(redirect_lid),
+	{ IB_CLASSPORTINFO_REC_FIELD(redirect_lid),
 	  .offset_words = 7,
 	  .offset_bits  = 0,
 	  .size_bits    = 16 },
-	{ CLASSPORTINFO_REC_FIELD(redirect_pkey),
+	{ IB_CLASSPORTINFO_REC_FIELD(redirect_pkey),
 	  .offset_words = 7,
 	  .offset_bits  = 16,
 	  .size_bits    = 16 },
 
-	{ CLASSPORTINFO_REC_FIELD(redirect_qp),
+	{ IB_CLASSPORTINFO_REC_FIELD(redirect_qp),
 	  .offset_words = 8,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
-	{ CLASSPORTINFO_REC_FIELD(redirect_qkey),
+	{ IB_CLASSPORTINFO_REC_FIELD(redirect_qkey),
 	  .offset_words = 9,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
 
-	{ CLASSPORTINFO_REC_FIELD(trap_gid),
+	{ IB_CLASSPORTINFO_REC_FIELD(trap_gid),
 	  .offset_words = 10,
 	  .offset_bits  = 0,
 	  .size_bits    = 128 },
-	{ CLASSPORTINFO_REC_FIELD(trap_tcslfl),
+	{ IB_CLASSPORTINFO_REC_FIELD(trap_tcslfl),
 	  .offset_words = 14,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
 
-	{ CLASSPORTINFO_REC_FIELD(trap_lid),
+	{ IB_CLASSPORTINFO_REC_FIELD(trap_lid),
 	  .offset_words = 15,
 	  .offset_bits  = 0,
 	  .size_bits    = 16 },
-	{ CLASSPORTINFO_REC_FIELD(trap_pkey),
+	{ IB_CLASSPORTINFO_REC_FIELD(trap_pkey),
 	  .offset_words = 15,
 	  .offset_bits  = 16,
 	  .size_bits    = 16 },
 
-	{ CLASSPORTINFO_REC_FIELD(trap_hlqp),
+	{ IB_CLASSPORTINFO_REC_FIELD(trap_hlqp),
+	  .offset_words = 16,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ IB_CLASSPORTINFO_REC_FIELD(trap_qkey),
+	  .offset_words = 17,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+};
+
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
 	  .offset_words = 16,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
-	{ CLASSPORTINFO_REC_FIELD(trap_qkey),
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_qkey),
 	  .offset_words = 17,
 	  .offset_bits  = 0,
 	  .size_bits    = 32 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_pkey),
+	  .offset_words = 18,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(redirect_pkey),
+	  .offset_words = 18,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ OPA_CLASSPORTINFO_REC_FIELD(trap_sl),
+	  .offset_words = 19,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ RESERVED,
+	  .offset_words = 19,
+	  .offset_bits  = 8,
+	  .size_bits    = 24 },
 };
 
 #define GUIDINFO_REC_FIELD(field) \
@@ -1104,7 +1200,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 }
 EXPORT_SYMBOL(ib_init_ah_from_path);
 
-static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
+static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask, bool is_opa)
 {
 	unsigned long flags;
 
@@ -1116,12 +1212,12 @@ static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
 	kref_get(&query->port->sm_ah->ref);
 	query->sm_ah = query->port->sm_ah;
 	spin_unlock_irqrestore(&query->port->ah_lock, flags);
-
 	query->mad_buf = ib_create_send_mad(query->port->agent, 1,
 					    query->sm_ah->pkey_index,
 					    0, IB_MGMT_SA_HDR, IB_MGMT_SA_DATA,
 					    gfp_mask,
-					    IB_MGMT_BASE_VERSION);
+					    ((is_opa) ? OPA_MGMT_BASE_VERSION :
+					     IB_MGMT_BASE_VERSION));
 	if (IS_ERR(query->mad_buf)) {
 		kref_put(&query->sm_ah->ref, free_sm_ah);
 		return -ENOMEM;
@@ -1138,16 +1234,21 @@ static void free_mad(struct ib_sa_query *query)
 	kref_put(&query->sm_ah->ref, free_sm_ah);
 }
 
-static void init_mad(struct ib_sa_mad *mad, struct ib_mad_agent *agent)
+static void init_mad(struct ib_sa_mad *mad, struct ib_mad_agent *agent,
+		     bool is_opa)
 {
 	unsigned long flags;
 
 	memset(mad, 0, sizeof *mad);
 
-	mad->mad_hdr.base_version  = IB_MGMT_BASE_VERSION;
+	if (is_opa) {
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
@@ -1291,7 +1392,7 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 		return -ENOMEM;
 
 	query->sa_query.port     = port;
-	ret = alloc_mad(&query->sa_query, gfp_mask);
+	ret = alloc_mad(&query->sa_query, gfp_mask, false);
 	if (ret)
 		goto err1;
 
@@ -1301,7 +1402,7 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(mad, agent, false);
 
 	query->sa_query.callback = callback ? ib_sa_path_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_path_rec_release;
@@ -1416,7 +1517,7 @@ int ib_sa_service_rec_query(struct ib_sa_client *client,
 		return -ENOMEM;
 
 	query->sa_query.port     = port;
-	ret = alloc_mad(&query->sa_query, gfp_mask);
+	ret = alloc_mad(&query->sa_query, gfp_mask, false);
 	if (ret)
 		goto err1;
 
@@ -1426,7 +1527,7 @@ int ib_sa_service_rec_query(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(mad, agent, false);
 
 	query->sa_query.callback = callback ? ib_sa_service_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_service_rec_release;
@@ -1508,7 +1609,7 @@ int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
 		return -ENOMEM;
 
 	query->sa_query.port     = port;
-	ret = alloc_mad(&query->sa_query, gfp_mask);
+	ret = alloc_mad(&query->sa_query, gfp_mask, false);
 	if (ret)
 		goto err1;
 
@@ -1518,7 +1619,7 @@ int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(mad, agent, false);
 
 	query->sa_query.callback = callback ? ib_sa_mcmember_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_mcmember_rec_release;
@@ -1605,7 +1706,7 @@ int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
 		return -ENOMEM;
 
 	query->sa_query.port = port;
-	ret = alloc_mad(&query->sa_query, gfp_mask);
+	ret = alloc_mad(&query->sa_query, gfp_mask, false);
 	if (ret)
 		goto err1;
 
@@ -1615,7 +1716,7 @@ int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
 	query->context         = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(mad, agent, false);
 
 	query->sa_query.callback = callback ? ib_sa_guidinfo_rec_callback : NULL;
 	query->sa_query.release  = ib_sa_guidinfo_rec_release;
@@ -1661,9 +1762,11 @@ bool ib_sa_sendonly_fullmem_support(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 
 	spin_lock_irqsave(&port->classport_lock, flags);
-	if (port->classport_info.valid)
-		ret = ib_get_cpi_capmask2(&port->classport_info.data) &
-			IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT;
+	if (port->classport_info.valid) {
+		if (port->classport_info.data.type == RDMA_CLASS_PORT_INFO_IB)
+			ret = ib_get_cpi_capmask2(&port->classport_info.data.ib)
+				& IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT;
+	}
 	spin_unlock_irqrestore(&port->classport_lock, flags);
 	return ret;
 }
@@ -1688,22 +1791,47 @@ static void ib_sa_classport_info_rec_callback(struct ib_sa_query *sa_query,
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
@@ -1725,6 +1853,8 @@ static int ib_sa_classport_info_rec_query(struct ib_sa_port *port,
 	struct ib_sa_mad *mad;
 	gfp_t gfp_mask = GFP_KERNEL;
 	int ret;
+	bool is_opa = rdma_cap_opa_ah(port->agent->device,
+				      port->port_num);
 
 	agent = port->agent;
 
@@ -1733,7 +1863,8 @@ static int ib_sa_classport_info_rec_query(struct ib_sa_port *port,
 		return -ENOMEM;
 
 	query->sa_query.port = port;
-	ret = alloc_mad(&query->sa_query, gfp_mask);
+	query->sa_query.flags |= (is_opa) ? IB_SA_QUERY_OPA : 0;
+	ret = alloc_mad(&query->sa_query, gfp_mask, is_opa);
 	if (ret)
 		goto err_free;
 
@@ -1741,7 +1872,7 @@ static int ib_sa_classport_info_rec_query(struct ib_sa_port *port,
 	query->context = context;
 
 	mad = query->sa_query.mad_buf->mad;
-	init_mad(mad, agent);
+	init_mad(mad, agent, is_opa);
 
 	query->sa_query.callback = ib_sa_classport_info_rec_callback;
 	query->sa_query.release  = ib_sa_classport_info_rec_release;
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 6e595af..c3d0e48 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1986,31 +1986,6 @@ struct opa_pma_mad {
 	u8 data[2024];
 } __packed;
 
-struct opa_class_port_info {
-	u8 base_version;
-	u8 class_version;
-	__be16 cap_mask;
-	__be32 cap_mask2_resp_time;
-
-	u8 redirect_gid[16];
-	__be32 redirect_tc_fl;
-	__be32 redirect_lid;
-	__be32 redirect_sl_qp;
-	__be32 redirect_qkey;
-
-	u8 trap_gid[16];
-	__be32 trap_tc_fl;
-	__be32 trap_lid;
-	__be32 trap_hl_qp;
-	__be32 trap_qkey;
-
-	__be16 trap_pkey;
-	__be16 redirect_pkey;
-
-	u8 trap_sl_rsvd;
-	u8 reserved[3];
-} __packed;
-
 struct opa_port_status_req {
 	__u8 port_num;
 	__u8 reserved[3];
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 981214b..8e75f5d 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -262,6 +262,31 @@ struct ib_class_port_info {
 	__be32			trap_qkey;
 };
 
+struct opa_class_port_info {
+	u8 base_version;
+	u8 class_version;
+	__be16 cap_mask;
+	__be32 cap_mask2_resp_time;
+
+	u8 redirect_gid[16];
+	__be32 redirect_tc_fl;
+	__be32 redirect_lid;
+	__be32 redirect_sl_qp;
+	__be32 redirect_qkey;
+
+	u8 trap_gid[16];
+	__be32 trap_tc_fl;
+	__be32 trap_lid;
+	__be32 trap_hl_qp;
+	__be32 trap_qkey;
+
+	__be16 trap_pkey;
+	__be16 redirect_pkey;
+
+	u8 trap_sl;
+	u8 reserved[3];
+} __packed;
+
 /**
  * ib_get_cpi_resp_time - Returns the resp_time value from
  * cap_mask2_resp_time in ib_class_port_info.
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
