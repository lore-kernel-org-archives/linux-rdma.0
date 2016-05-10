From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 2/4] IB/SA Agent: Add support for SA agent get ClassPortInfo
Date: Tue, 10 May 2016 17:56:46 +0300
Message-ID: <1462892208-6140-3-git-send-email-erezsh@mellanox.com>
References: <1462892208-6140-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462892208-6140-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


New SA query function to return the ClassPortInfo struct from the SA.
If the SM supports FullMemberSendOnly mode for MCG's, it sets a
capability bit in the capability_mask2 field of the response.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 173 +++++++++++++++++++++++++++++++++++++
 include/rdma/ib_sa.h               |  12 +++
 2 files changed, 185 insertions(+)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8a09c0f..a97c571 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -119,6 +119,12 @@ struct ib_sa_guidinfo_query {
 	struct ib_sa_query sa_query;
 };
 
+struct ib_sa_classport_info_query {
+	void (*callback)(int, struct ib_class_port_info *, void *);
+	void *context;
+	struct ib_sa_query sa_query;
+};
+
 struct ib_sa_mcmember_query {
 	void (*callback)(int, struct ib_sa_mcmember_rec *, void *);
 	void *context;
@@ -392,6 +398,82 @@ static const struct ib_field service_rec_table[] = {
 	  .size_bits    = 2*64 },
 };
 
+#define CLASSPORTINFO_REC_FIELD(field) \
+	.struct_offset_bytes = offsetof(struct ib_class_port_info, field),	\
+	.struct_size_bytes   = sizeof((struct ib_class_port_info *)0)->field,	\
+	.field_name          = "ib_class_port_info:" #field
+
+static const struct ib_field classport_info_rec_table[] = {
+	{ CLASSPORTINFO_REC_FIELD(base_version),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ CLASSPORTINFO_REC_FIELD(class_version),
+	  .offset_words = 0,
+	  .offset_bits  = 8,
+	  .size_bits    = 8 },
+	{ CLASSPORTINFO_REC_FIELD(capability_mask),
+	  .offset_words = 0,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ CLASSPORTINFO_REC_FIELD(cap_mask2_resp_time),
+	  .offset_words = 1,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ CLASSPORTINFO_REC_FIELD(redirect_gid),
+	  .offset_words = 2,
+	  .offset_bits  = 0,
+	  .size_bits    = 128 },
+	{ CLASSPORTINFO_REC_FIELD(redirect_tcslfl),
+	  .offset_words = 6,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ CLASSPORTINFO_REC_FIELD(redirect_lid),
+	  .offset_words = 7,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ CLASSPORTINFO_REC_FIELD(redirect_pkey),
+	  .offset_words = 7,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+
+	{ CLASSPORTINFO_REC_FIELD(redirect_qp),
+	  .offset_words = 8,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ CLASSPORTINFO_REC_FIELD(redirect_qkey),
+	  .offset_words = 9,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+
+	{ CLASSPORTINFO_REC_FIELD(trap_gid),
+	  .offset_words = 10,
+	  .offset_bits  = 0,
+	  .size_bits    = 128 },
+	{ CLASSPORTINFO_REC_FIELD(trap_tcslfl),
+	  .offset_words = 14,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+
+	{ CLASSPORTINFO_REC_FIELD(trap_lid),
+	  .offset_words = 15,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ CLASSPORTINFO_REC_FIELD(trap_pkey),
+	  .offset_words = 15,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+
+	{ CLASSPORTINFO_REC_FIELD(trap_hlqp),
+	  .offset_words = 16,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ CLASSPORTINFO_REC_FIELD(trap_qkey),
+	  .offset_words = 17,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+};
+
 #define GUIDINFO_REC_FIELD(field) \
 	.struct_offset_bytes = offsetof(struct ib_sa_guidinfo_rec, field),	\
 	.struct_size_bytes   = sizeof((struct ib_sa_guidinfo_rec *) 0)->field,	\
@@ -1645,6 +1727,97 @@ err1:
 }
 EXPORT_SYMBOL(ib_sa_guid_info_rec_query);
 
+/* Support get SA ClassPortInfo */
+static void ib_sa_classport_info_rec_callback(struct ib_sa_query *sa_query,
+					      int status,
+					      struct ib_sa_mad *mad)
+{
+	struct ib_sa_classport_info_query *query =
+		container_of(sa_query, struct ib_sa_classport_info_query, sa_query);
+
+	if (mad) {
+		struct ib_class_port_info rec;
+
+		ib_unpack(classport_info_rec_table,
+			  ARRAY_SIZE(classport_info_rec_table),
+			  mad->data, &rec);
+		query->callback(status, &rec, query->context);
+	} else {
+		query->callback(status, NULL, query->context);
+	}
+}
+
+static void ib_sa_portclass_info_rec_release(struct ib_sa_query *sa_query)
+{
+	kfree(container_of(sa_query, struct ib_sa_classport_info_query,
+			   sa_query));
+}
+
+int ib_sa_classport_info_rec_query(struct ib_sa_client *client,
+				   struct ib_device *device, u8 port_num,
+				   int timeout_ms, gfp_t gfp_mask,
+				   void (*callback)(int status,
+						    struct ib_class_port_info *resp,
+						    void *context),
+				   void *context,
+				   struct ib_sa_query **sa_query)
+{
+	struct ib_sa_classport_info_query *query;
+	struct ib_sa_device *sa_dev = ib_get_client_data(device, &sa_client);
+	struct ib_sa_port *port;
+	struct ib_mad_agent *agent;
+	struct ib_sa_mad *mad;
+	int ret;
+
+	if (!sa_dev)
+		return -ENODEV;
+
+	port  = &sa_dev->port[port_num - sa_dev->start_port];
+	agent = port->agent;
+
+	query = kzalloc(sizeof(*query), gfp_mask);
+	if (!query)
+		return -ENOMEM;
+
+	query->sa_query.port = port;
+	ret = alloc_mad(&query->sa_query, gfp_mask);
+	if (ret)
+		goto err1;
+
+	ib_sa_client_get(client);
+	query->sa_query.client = client;
+	query->callback        = callback;
+	query->context         = context;
+
+	mad = query->sa_query.mad_buf->mad;
+	init_mad(mad, agent);
+
+	query->sa_query.callback = callback ? ib_sa_classport_info_rec_callback : NULL;
+
+	query->sa_query.release  = ib_sa_portclass_info_rec_release;
+	/* support GET only */
+	mad->mad_hdr.method	 = IB_MGMT_METHOD_GET;
+	mad->mad_hdr.attr_id	 = cpu_to_be16(IB_SA_ATTR_CLASS_PORTINFO);
+	mad->sa_hdr.comp_mask	 = 0;
+	*sa_query = &query->sa_query;
+
+	ret = send_mad(&query->sa_query, timeout_ms, gfp_mask);
+	if (ret < 0)
+		goto err2;
+
+	return ret;
+
+err2:
+	*sa_query = NULL;
+	ib_sa_client_put(query->sa_query.client);
+	free_mad(&query->sa_query);
+
+err1:
+	kfree(query);
+	return ret;
+}
+EXPORT_SYMBOL(ib_sa_classport_info_rec_query);
+
 static void send_handler(struct ib_mad_agent *agent,
 			 struct ib_mad_send_wc *mad_send_wc)
 {
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index cdc1c81..3840416 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -94,6 +94,8 @@ enum ib_sa_selector {
 	IB_SA_BEST = 3
 };
 
+#define IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT	BIT(12)
+
 /*
  * Structures for SA records are named "struct ib_sa_xxx_rec."  No
  * attempt is made to pack structures to match the physical layout of
@@ -439,4 +441,14 @@ int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
 			      void *context,
 			      struct ib_sa_query **sa_query);
 
+/* Support get SA ClassPortInfo */
+int ib_sa_classport_info_rec_query(struct ib_sa_client *client,
+				   struct ib_device *device, u8 port_num,
+				   int timeout_ms, gfp_t gfp_mask,
+				   void (*callback)(int status,
+						    struct ib_class_port_info *resp,
+						    void *context),
+				   void *context,
+				   struct ib_sa_query **sa_query);
+
 #endif /* IB_SA_H */
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
