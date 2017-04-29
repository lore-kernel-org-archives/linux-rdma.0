From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 15/18] IB/core: Add accessor functions for rdma_ah_attr fields
Date: Sat, 29 Apr 2017 14:41:27 -0400
Message-ID: <1493491290-31621-16-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These accessor functions are supposed to be used to get
and set individual fields of struct rdma_ah_attr

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 121 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ecaf9d5..46a5be6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3465,4 +3465,125 @@ int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 
 int ib_resolve_eth_dmac(struct ib_device *device,
 			struct rdma_ah_attr *ah_attr);
+
+static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)
+{
+	return attr->dmac;
+}
+
+static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u32 dlid)
+{
+	attr->dlid = (u16)dlid;
+}
+
+static inline u32 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
+{
+	return attr->dlid;
+}
+
+static inline void rdma_ah_set_sl(struct rdma_ah_attr *attr, u8 sl)
+{
+	attr->sl = sl;
+}
+
+static inline u8 rdma_ah_get_sl(const struct rdma_ah_attr *attr)
+{
+	return attr->sl;
+}
+
+static inline void rdma_ah_set_path_bits(struct rdma_ah_attr *attr,
+					 u8 src_path_bits)
+{
+	attr->src_path_bits = src_path_bits;
+}
+
+static inline u8 rdma_ah_get_path_bits(const struct rdma_ah_attr *attr)
+{
+	return attr->src_path_bits;
+}
+
+static inline void rdma_ah_set_port_num(struct rdma_ah_attr *attr, u8 port_num)
+{
+	attr->port_num = port_num;
+}
+
+static inline u8 rdma_ah_get_port_num(const struct rdma_ah_attr *attr)
+{
+	return attr->port_num;
+}
+
+static inline void rdma_ah_set_static_rate(struct rdma_ah_attr *attr,
+					   u8 static_rate)
+{
+	attr->static_rate = static_rate;
+}
+
+static inline u8 rdma_ah_get_static_rate(const struct rdma_ah_attr *attr)
+{
+	return attr->static_rate;
+}
+
+static inline void rdma_ah_set_ah_flags(struct rdma_ah_attr *attr,
+					enum ib_ah_flags flag)
+{
+	attr->ah_flags = flag;
+}
+
+static inline enum ib_ah_flags
+		rdma_ah_get_ah_flags(const struct rdma_ah_attr *attr)
+{
+	return attr->ah_flags;
+}
+
+static inline const struct ib_global_route
+		*rdma_ah_read_grh(const struct rdma_ah_attr *attr)
+{
+	return &attr->grh;
+}
+
+/*To retrieve and modify the grh */
+static inline struct ib_global_route
+		*rdma_ah_retrieve_grh(struct rdma_ah_attr *attr)
+{
+	return &attr->grh;
+}
+
+static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr, void *dgid)
+{
+	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
+
+	memcpy(grh->dgid.raw, dgid, sizeof(grh->dgid));
+}
+
+static inline void rdma_ah_set_subnet_prefix(struct rdma_ah_attr *attr,
+					     __be64 prefix)
+{
+	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
+
+	grh->dgid.global.subnet_prefix = prefix;
+}
+
+static inline void rdma_ah_set_interface_id(struct rdma_ah_attr *attr,
+					    __be64 if_id)
+{
+	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
+
+	grh->dgid.global.interface_id = if_id;
+}
+
+static inline void rdma_ah_set_grh(struct rdma_ah_attr *attr,
+				   union ib_gid *dgid, u32 flow_label,
+				   u8 sgid_index, u8 hop_limit,
+				   u8 traffic_class)
+{
+	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
+
+	attr->ah_flags = IB_AH_GRH;
+	if (dgid)
+		grh->dgid = *dgid;
+	grh->flow_label = flow_label;
+	grh->sgid_index = sgid_index;
+	grh->hop_limit = hop_limit;
+	grh->traffic_class = traffic_class;
+}
 #endif /* IB_VERBS_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
