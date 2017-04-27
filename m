From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 rdma-next 2/6] IB/SA: Rename ib_sa_path_rec to sa_path_rec
Date: Thu, 27 Apr 2017 19:05:58 -0400
Message-ID: <1493334362-24774-3-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493334362-24774-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493334362-24774-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename ib_sa_path_rec to a more generic sa_path_rec.
This is part of extending ib_sa to also support OPA
path records in addition to the IB defined path records.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c              | 20 ++++++++++----------
 drivers/infiniband/core/cma.c             |  8 ++++----
 drivers/infiniband/core/sa_query.c        | 20 ++++++++++----------
 drivers/infiniband/core/ucm.c             |  6 +++---
 drivers/infiniband/core/ucma.c            |  2 +-
 drivers/infiniband/core/uverbs_marshall.c |  4 ++--
 drivers/infiniband/ulp/ipoib/ipoib.h      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.h       |  2 +-
 include/rdma/ib_cm.h                      | 14 +++++++-------
 include/rdma/ib_marshall.h                |  4 ++--
 include/rdma/ib_sa.h                      | 14 +++++++-------
 include/rdma/rdma_cm.h                    |  2 +-
 include/rdma/rdma_cm_ib.h                 |  2 +-
 16 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 53661f34..fe83823 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -241,7 +241,7 @@ struct cm_work {
 	__be32 local_id;			/* Established / timewait */
 	__be32 remote_id;
 	struct ib_cm_event cm_event;
-	struct ib_sa_path_rec path[0];
+	struct sa_path_rec path[0];
 };
 
 struct cm_timewait_info {
@@ -440,7 +440,7 @@ static void cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
 			   grh, &av->ah_attr);
 }
 
-static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av,
+static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
 			      struct cm_id_private *cm_id_priv)
 {
 	struct cm_device *cm_dev;
@@ -1172,8 +1172,8 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 			  struct cm_id_private *cm_id_priv,
 			  struct ib_cm_req_param *param)
 {
-	struct ib_sa_path_rec *pri_path = param->primary_path;
-	struct ib_sa_path_rec *alt_path = param->alternate_path;
+	struct sa_path_rec *pri_path = param->primary_path;
+	struct sa_path_rec *alt_path = param->alternate_path;
 
 	cm_format_mad_hdr(&req_msg->hdr, CM_REQ_ATTR_ID,
 			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_REQ));
@@ -1401,8 +1401,8 @@ static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
 }
 
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
-					    struct ib_sa_path_rec *primary_path,
-					    struct ib_sa_path_rec *alt_path)
+				     struct sa_path_rec *primary_path,
+				     struct sa_path_rec *alt_path)
 {
 	memset(primary_path, 0, sizeof(*primary_path));
 	primary_path->dgid = req_msg->primary_local_gid;
@@ -2815,7 +2815,7 @@ static int cm_mra_handler(struct cm_work *work)
 
 static void cm_format_lap(struct cm_lap_msg *lap_msg,
 			  struct cm_id_private *cm_id_priv,
-			  struct ib_sa_path_rec *alternate_path,
+			  struct sa_path_rec *alternate_path,
 			  const void *private_data,
 			  u8 private_data_len)
 {
@@ -2845,7 +2845,7 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 }
 
 int ib_send_cm_lap(struct ib_cm_id *cm_id,
-		   struct ib_sa_path_rec *alternate_path,
+		   struct sa_path_rec *alternate_path,
 		   const void *private_data,
 		   u8 private_data_len)
 {
@@ -2899,7 +2899,7 @@ int ib_send_cm_lap(struct ib_cm_id *cm_id,
 EXPORT_SYMBOL(ib_send_cm_lap);
 
 static void cm_format_path_from_lap(struct cm_id_private *cm_id_priv,
-				    struct ib_sa_path_rec *path,
+				    struct sa_path_rec *path,
 				    struct cm_lap_msg *lap_msg)
 {
 	memset(path, 0, sizeof *path);
@@ -3712,7 +3712,7 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	atomic_long_inc(&port->counter_group[CM_RECV].
 			counter[attr_id - CM_ATTR_ID_OFFSET]);
 
-	work = kmalloc(sizeof(*work) + sizeof(struct ib_sa_path_rec) * paths,
+	work = kmalloc(sizeof(*work) + sizeof(struct sa_path_rec) * paths,
 		       GFP_KERNEL);
 	if (!work) {
 		ib_free_recv_mad(mad_recv_wc);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 21244f7..1185d58 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1128,7 +1128,7 @@ static inline int cma_any_port(struct sockaddr *addr)
 static void cma_save_ib_info(struct sockaddr *src_addr,
 			     struct sockaddr *dst_addr,
 			     struct rdma_cm_id *listen_id,
-			     struct ib_sa_path_rec *path)
+			     struct sa_path_rec *path)
 {
 	struct sockaddr_ib *listen_ib, *ib;
 
@@ -2298,7 +2298,7 @@ void rdma_set_service_type(struct rdma_cm_id *id, int tos)
 }
 EXPORT_SYMBOL(rdma_set_service_type);
 
-static void cma_query_handler(int status, struct ib_sa_path_rec *path_rec,
+static void cma_query_handler(int status, struct sa_path_rec *path_rec,
 			      void *context)
 {
 	struct cma_work *work = context;
@@ -2325,7 +2325,7 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 			      struct cma_work *work)
 {
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
-	struct ib_sa_path_rec path_rec;
+	struct sa_path_rec path_rec;
 	ib_sa_comp_mask comp_mask;
 	struct sockaddr_in6 *sin6;
 	struct sockaddr_ib *sib;
@@ -2450,7 +2450,7 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 }
 
 int rdma_set_ib_paths(struct rdma_cm_id *id,
-		      struct ib_sa_path_rec *path_rec, int num_paths)
+		      struct sa_path_rec *path_rec, int num_paths)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c04ac94..87ffc82 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -129,7 +129,7 @@ struct ib_sa_service_query {
 };
 
 struct ib_sa_path_query {
-	void (*callback)(int, struct ib_sa_path_rec *, void *);
+	void (*callback)(int, struct sa_path_rec *, void *);
 	void *context;
 	struct ib_sa_query sa_query;
 };
@@ -188,8 +188,8 @@ struct ib_sa_mcmember_query {
 static u32 tid;
 
 #define PATH_REC_FIELD(field) \
-	.struct_offset_bytes = offsetof(struct ib_sa_path_rec, field),		\
-	.struct_size_bytes   = sizeof ((struct ib_sa_path_rec *) 0)->field,	\
+	.struct_offset_bytes = offsetof(struct sa_path_rec, field),	\
+	.struct_size_bytes   = sizeof((struct sa_path_rec *)0)->field,	\
 	.field_name          = "sa_path_rec:" #field
 
 static const struct ib_field path_rec_table[] = {
@@ -618,7 +618,7 @@ static inline int ib_sa_query_cancelled(struct ib_sa_query *query)
 static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
 				     struct ib_sa_query *query)
 {
-	struct ib_sa_path_rec *sa_rec = query->mad_buf->context[1];
+	struct sa_path_rec *sa_rec = query->mad_buf->context[1];
 	struct ib_sa_mad *mad = query->mad_buf->mad;
 	ib_sa_comp_mask comp_mask = mad->sa_hdr.comp_mask;
 	u16 val16;
@@ -1099,7 +1099,7 @@ static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
 }
 
 int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
-			 struct ib_sa_path_rec *rec,
+			 struct sa_path_rec *rec,
 			 struct rdma_ah_attr *ah_attr)
 {
 	int ret;
@@ -1301,13 +1301,13 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	return ret ? ret : id;
 }
 
-void ib_sa_unpack_path(void *attribute, struct ib_sa_path_rec *rec)
+void ib_sa_unpack_path(void *attribute, struct sa_path_rec *rec)
 {
 	ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table), attribute, rec);
 }
 EXPORT_SYMBOL(ib_sa_unpack_path);
 
-void ib_sa_pack_path(struct ib_sa_path_rec *rec, void *attribute)
+void ib_sa_pack_path(struct sa_path_rec *rec, void *attribute)
 {
 	ib_pack(path_rec_table, ARRAY_SIZE(path_rec_table), rec, attribute);
 }
@@ -1321,7 +1321,7 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 		container_of(sa_query, struct ib_sa_path_query, sa_query);
 
 	if (mad) {
-		struct ib_sa_path_rec rec;
+		struct sa_path_rec rec;
 
 		ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table),
 			  mad->data, &rec);
@@ -1366,11 +1366,11 @@ static void ib_sa_path_rec_release(struct ib_sa_query *sa_query)
  */
 int ib_sa_path_rec_get(struct ib_sa_client *client,
 		       struct ib_device *device, u8 port_num,
-		       struct ib_sa_path_rec *rec,
+		       struct sa_path_rec *rec,
 		       ib_sa_comp_mask comp_mask,
 		       int timeout_ms, gfp_t gfp_mask,
 		       void (*callback)(int status,
-					struct ib_sa_path_rec *resp,
+					struct sa_path_rec *resp,
 					void *context),
 		       void *context,
 		       struct ib_sa_query **sa_query)
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index cc0d51f..80d0fca 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -702,10 +702,10 @@ static int ib_ucm_alloc_data(const void **dest, u64 src, u32 len)
 	return 0;
 }
 
-static int ib_ucm_path_get(struct ib_sa_path_rec **path, u64 src)
+static int ib_ucm_path_get(struct sa_path_rec **path, u64 src)
 {
 	struct ib_user_path_rec upath;
-	struct ib_sa_path_rec  *sa_path;
+	struct sa_path_rec  *sa_path;
 
 	*path = NULL;
 
@@ -962,7 +962,7 @@ static ssize_t ib_ucm_send_lap(struct ib_ucm_file *file,
 			       int in_len, int out_len)
 {
 	struct ib_ucm_context *ctx;
-	struct ib_sa_path_rec *path = NULL;
+	struct sa_path_rec *path = NULL;
 	struct ib_ucm_lap cmd;
 	const void *data = NULL;
 	int result;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index e12f8fa..2beff90 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1197,7 +1197,7 @@ static int ucma_set_option_id(struct ucma_context *ctx, int optname,
 static int ucma_set_ib_path(struct ucma_context *ctx,
 			    struct ib_path_rec_data *path_data, size_t optlen)
 {
-	struct ib_sa_path_rec sa_path;
+	struct sa_path_rec sa_path;
 	struct rdma_cm_event event;
 	int ret;
 
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index cb4ba16..eda6f30 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -97,7 +97,7 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
 
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
-			      struct ib_sa_path_rec *src)
+			      struct sa_path_rec *src)
 {
 	memcpy(dst->dgid, src->dgid.raw, sizeof src->dgid);
 	memcpy(dst->sgid, src->sgid.raw, sizeof src->sgid);
@@ -122,7 +122,7 @@ void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 }
 EXPORT_SYMBOL(ib_copy_path_rec_to_user);
 
-void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
+void ib_copy_path_rec_from_user(struct sa_path_rec *dst,
 				struct ib_user_path_rec *src)
 {
 	memcpy(dst->dgid.raw, src->dgid, sizeof dst->dgid);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 866ecfa..8b657cb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -416,7 +416,7 @@ struct ipoib_ah {
 
 struct ipoib_path {
 	struct net_device    *dev;
-	struct ib_sa_path_rec pathrec;
+	struct sa_path_rec pathrec;
 	struct ipoib_ah      *ah;
 	struct sk_buff_head   queue;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 0cdf2b7..a13d3d6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1068,7 +1068,7 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 static int ipoib_cm_send_req(struct net_device *dev,
 			     struct ib_cm_id *id, struct ib_qp *qp,
 			     u32 qpn,
-			     struct ib_sa_path_rec *pathrec)
+			     struct sa_path_rec *pathrec)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_data data = {};
@@ -1128,7 +1128,7 @@ static int ipoib_cm_modify_tx_init(struct net_device *dev,
 }
 
 static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
-			    struct ib_sa_path_rec *pathrec)
+			    struct sa_path_rec *pathrec)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
 	int ret;
@@ -1332,7 +1332,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 	struct ipoib_path *path;
 	int ret;
 
-	struct ib_sa_path_rec pathrec;
+	struct sa_path_rec pathrec;
 	u32 qpn;
 
 	netif_tx_lock_bh(dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 63c8092..5e7939f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -716,7 +716,7 @@ void ipoib_flush_paths(struct net_device *dev)
 }
 
 static void path_rec_completion(int status,
-				struct ib_sa_path_rec *pathrec,
+				struct sa_path_rec *pathrec,
 				void *path_ptr)
 {
 	struct ipoib_path *path = path_ptr;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cee4626..ded9b9a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -643,7 +643,7 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 }
 
 static void srp_path_rec_completion(int status,
-				    struct ib_sa_path_rec *pathrec,
+				    struct sa_path_rec *pathrec,
 				    void *ch_ptr)
 {
 	struct srp_rdma_ch *ch = ch_ptr;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 32ed40d..ab9077b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -152,7 +152,7 @@ struct srp_rdma_ch {
 	struct completion	done;
 	int			status;
 
-	struct ib_sa_path_rec	path;
+	struct sa_path_rec	path;
 	struct ib_sa_query     *path_query;
 	int			path_query_id;
 
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index b49258b..7979cb0 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -117,8 +117,8 @@ struct ib_cm_req_event_param {
 
 	u8			port;
 
-	struct ib_sa_path_rec	*primary_path;
-	struct ib_sa_path_rec	*alternate_path;
+	struct sa_path_rec	*primary_path;
+	struct sa_path_rec	*alternate_path;
 
 	__be64			remote_ca_guid;
 	u32			remote_qkey;
@@ -197,7 +197,7 @@ struct ib_cm_mra_event_param {
 };
 
 struct ib_cm_lap_event_param {
-	struct ib_sa_path_rec	*alternate_path;
+	struct sa_path_rec	*alternate_path;
 };
 
 enum ib_cm_apr_status {
@@ -363,8 +363,8 @@ struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
 				     __be64 service_id);
 
 struct ib_cm_req_param {
-	struct ib_sa_path_rec	*primary_path;
-	struct ib_sa_path_rec	*alternate_path;
+	struct sa_path_rec	*primary_path;
+	struct sa_path_rec	*alternate_path;
 	__be64			service_id;
 	u32			qp_num;
 	enum ib_qp_type		qp_type;
@@ -521,7 +521,7 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
  * @private_data_len: Size of the private data buffer, in bytes.
  */
 int ib_send_cm_lap(struct ib_cm_id *cm_id,
-		   struct ib_sa_path_rec *alternate_path,
+		   struct sa_path_rec *alternate_path,
 		   const void *private_data,
 		   u8 private_data_len);
 
@@ -565,7 +565,7 @@ int ib_send_cm_apr(struct ib_cm_id *cm_id,
 		   u8 private_data_len);
 
 struct ib_cm_sidr_req_param {
-	struct ib_sa_path_rec	*path;
+	struct sa_path_rec	*path;
 	__be64			service_id;
 	int			timeout_ms;
 	const void		*private_data;
diff --git a/include/rdma/ib_marshall.h b/include/rdma/ib_marshall.h
index 42a0fc6..68cef3b 100644
--- a/include/rdma/ib_marshall.h
+++ b/include/rdma/ib_marshall.h
@@ -45,9 +45,9 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 			     struct rdma_ah_attr *src);
 
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
-			      struct ib_sa_path_rec *src);
+			      struct sa_path_rec *src);
 
-void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
+void ib_copy_path_rec_from_user(struct sa_path_rec *dst,
 				struct ib_user_path_rec *src);
 
 #endif /* IB_USER_MARSHALL_H */
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 3ff8e64..7efdfb1 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -148,7 +148,7 @@ enum ib_sa_mc_join_states {
 #define IB_SA_PATH_REC_PACKET_LIFE_TIME			IB_SA_COMP_MASK(21)
 #define IB_SA_PATH_REC_PREFERENCE			IB_SA_COMP_MASK(22)
 
-struct ib_sa_path_rec {
+struct sa_path_rec {
 	__be64       service_id;
 	union ib_gid dgid;
 	union ib_gid sgid;
@@ -179,7 +179,7 @@ struct ib_sa_path_rec {
 	enum ib_gid_type gid_type;
 };
 
-static inline struct net_device *ib_get_ndev_from_path(struct ib_sa_path_rec *rec)
+static inline struct net_device *ib_get_ndev_from_path(struct sa_path_rec *rec)
 {
 	return rec->net ? dev_get_by_index(rec->net, rec->ifindex) : NULL;
 }
@@ -323,11 +323,11 @@ struct ib_sa_client {
 
 int ib_sa_path_rec_get(struct ib_sa_client *client,
 		       struct ib_device *device, u8 port_num,
-		       struct ib_sa_path_rec *rec,
+		       struct sa_path_rec *rec,
 		       ib_sa_comp_mask comp_mask,
 		       int timeout_ms, gfp_t gfp_mask,
 		       void (*callback)(int status,
-					struct ib_sa_path_rec *resp,
+					struct sa_path_rec *resp,
 					void *context),
 		       void *context,
 		       struct ib_sa_query **query);
@@ -428,20 +428,20 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
  *   path record.
  */
 int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
-			 struct ib_sa_path_rec *rec,
+			 struct sa_path_rec *rec,
 			 struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_sa_pack_path - Conert a path record from struct ib_sa_path_rec
  * to IB MAD wire format.
  */
-void ib_sa_pack_path(struct ib_sa_path_rec *rec, void *attribute);
+void ib_sa_pack_path(struct sa_path_rec *rec, void *attribute);
 
 /**
  * ib_sa_unpack_path - Convert a path record from MAD format to struct
  * ib_sa_path_rec.
  */
-void ib_sa_unpack_path(void *attribute, struct ib_sa_path_rec *rec);
+void ib_sa_unpack_path(void *attribute, struct sa_path_rec *rec);
 
 /* Support GuidInfoRecord */
 int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c9ac1e1..3d2eed3 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -85,7 +85,7 @@ struct rdma_addr {
 
 struct rdma_route {
 	struct rdma_addr addr;
-	struct ib_sa_path_rec *path_rec;
+	struct sa_path_rec *path_rec;
 	int num_paths;
 };
 
diff --git a/include/rdma/rdma_cm_ib.h b/include/rdma/rdma_cm_ib.h
index 2389c3b..6947a6b 100644
--- a/include/rdma/rdma_cm_ib.h
+++ b/include/rdma/rdma_cm_ib.h
@@ -46,7 +46,7 @@
  * connection and replaces the call to rdma_resolve_route.
  */
 int rdma_set_ib_paths(struct rdma_cm_id *id,
-		      struct ib_sa_path_rec *path_rec, int num_paths);
+		      struct sa_path_rec *path_rec, int num_paths);
 
 /* Global qkey for UDP QPs and multicast groups. */
 #define RDMA_UDP_QKEY 0x01234567
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
