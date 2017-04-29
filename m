From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 18/18] IB/core: Define 'opa' rdma_ah_attr type
Date: Sat, 29 Apr 2017 14:41:30 -0400
Message-ID: <1493491290-31621-19-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OPA ah_attr types allows core components to specify
attributes that may be specific to opa devices.
For instance, opa type ah_attr provides 32 bit lids
enabling larger OPA fabric sizes.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 803927b..f0cb490 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -843,6 +843,7 @@ struct ib_mr_status {
 enum rdma_ah_attr_type {
 	RDMA_AH_ATTR_TYPE_IB,
 	RDMA_AH_ATTR_TYPE_ROCE,
+	RDMA_AH_ATTR_TYPE_OPA,
 };
 
 struct ib_ah_attr {
@@ -854,6 +855,11 @@ struct roce_ah_attr {
 	u8			dmac[ETH_ALEN];
 };
 
+struct opa_ah_attr {
+	u32			dlid;
+	u8			src_path_bits;
+};
+
 struct rdma_ah_attr {
 	struct ib_global_route	grh;
 	u8			sl;
@@ -864,6 +870,7 @@ struct rdma_ah_attr {
 	union {
 		struct ib_ah_attr ib;
 		struct roce_ah_attr roce;
+		struct opa_ah_attr opa;
 	};
 };
 
@@ -3490,16 +3497,20 @@ static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)
 	return NULL;
 }
 
-static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u16 dlid)
+static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u32 dlid)
 {
 	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
-		attr->ib.dlid = dlid;
+		attr->ib.dlid = (u16)dlid;
+	else if (attr->type == RDMA_AH_ATTR_TYPE_OPA)
+		attr->opa.dlid = dlid;
 }
 
-static inline u16 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
+static inline u32 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
 {
 	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
 		return attr->ib.dlid;
+	else if (attr->type == RDMA_AH_ATTR_TYPE_OPA)
+		return attr->opa.dlid;
 	return 0;
 }
 
@@ -3518,12 +3529,16 @@ static inline void rdma_ah_set_path_bits(struct rdma_ah_attr *attr,
 {
 	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
 		attr->ib.src_path_bits = src_path_bits;
+	else if (attr->type == RDMA_AH_ATTR_TYPE_OPA)
+		attr->opa.src_path_bits = src_path_bits;
 }
 
 static inline u8 rdma_ah_get_path_bits(const struct rdma_ah_attr *attr)
 {
 	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
 		return attr->ib.src_path_bits;
+	else if (attr->type == RDMA_AH_ATTR_TYPE_OPA)
+		return attr->opa.src_path_bits;
 	return 0;
 }
 
@@ -3619,6 +3634,9 @@ static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
 	if ((rdma_protocol_roce(dev, port_num)) ||
 	    (rdma_protocol_iwarp(dev, port_num)))
 		return RDMA_AH_ATTR_TYPE_ROCE;
+	else if ((rdma_protocol_ib(dev, port_num)) &&
+		 (rdma_cap_opa_ah(dev, port_num)))
+		return RDMA_AH_ATTR_TYPE_OPA;
 	else
 		return RDMA_AH_ATTR_TYPE_IB;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
