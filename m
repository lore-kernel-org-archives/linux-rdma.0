From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 18/18] IB/core: Define 'opa' rdma_ah_attr type
Date: Tue, 11 Apr 2017 13:42:25 -0400
Message-ID: <1491932545-60894-19-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
 include/rdma/ib_verbs.h | 124 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 99 insertions(+), 25 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1d76438..81c8faa 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -840,6 +840,7 @@ struct ib_mr_status {
 enum rdma_ah_attr_type {
 	RDMA_AH_ATTR_TYPE_IB,
 	RDMA_AH_ATTR_TYPE_ETH,
+	RDMA_AH_ATTR_TYPE_OPA,
 };
 
 struct ib_ah_attr {
@@ -860,6 +861,16 @@ struct eth_ah_attr {
 	u8			dmac[ETH_ALEN];
 };
 
+struct opa_ah_attr {
+	struct ib_global_route	grh;
+	u32			dlid;
+	u8			sl;
+	u8			src_path_bits;
+	u8			static_rate;
+	u8			ah_flags;
+	u8			port_num;
+};
+
 struct rdma_ah_attr {
 	u8	port_num;
 	u8	ah_flags;
@@ -867,6 +878,7 @@ struct rdma_ah_attr {
 	union {
 		struct ib_ah_attr ib;
 		struct eth_ah_attr eth;
+		struct opa_ah_attr opa;
 	};
 };
 
@@ -3439,54 +3451,89 @@ static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)
 	return NULL;
 }
 
-static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u16 dlid)
+static inline void rdma_ah_set_dlid(struct rdma_ah_attr *attr, u32 dlid)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
-		attr->ib.dlid = dlid;
-	else
-		attr->eth.dlid = dlid;
-
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
+		attr->ib.dlid = (u16)dlid;
+		break;
+	case RDMA_AH_ATTR_TYPE_ETH:
+		attr->eth.dlid = (u16)dlid;
+		break;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		attr->opa.dlid = dlid;
+	}
 }
 
-static inline u16 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
+static inline u32 rdma_ah_get_dlid(const struct rdma_ah_attr *attr)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		return attr->ib.dlid;
-	else
+	case RDMA_AH_ATTR_TYPE_ETH:
 		return attr->eth.dlid;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		return attr->opa.dlid;
+	default:
+		return 0;
+	}
 }
 
 static inline void rdma_ah_set_sl(struct rdma_ah_attr *attr, u8 sl)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		attr->ib.sl = sl;
-	else
+		break;
+	case RDMA_AH_ATTR_TYPE_ETH:
 		attr->eth.sl = sl;
+		break;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		attr->opa.sl = sl;
+	}
 }
 
 static inline u8 rdma_ah_get_sl(const struct rdma_ah_attr *attr)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		return attr->ib.sl;
-	else
+	case RDMA_AH_ATTR_TYPE_ETH:
 		return attr->eth.sl;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		return attr->opa.sl;
+	default:
+		return 0;
+	}
 }
 
 static inline void rdma_ah_set_path_bits(struct rdma_ah_attr *attr,
 					 u8 src_path_bits)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		attr->ib.src_path_bits = src_path_bits;
-	else
+		break;
+	case RDMA_AH_ATTR_TYPE_ETH:
 		attr->eth.src_path_bits = src_path_bits;
+		break;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		attr->opa.src_path_bits = src_path_bits;
+	}
 }
 
 static inline u8 rdma_ah_get_path_bits(const struct rdma_ah_attr *attr)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		return attr->ib.src_path_bits;
-	else
+	case RDMA_AH_ATTR_TYPE_ETH:
 		return attr->eth.src_path_bits;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		return attr->opa.src_path_bits;
+	default:
+		return 0;
+	}
 }
 
 static inline void rdma_ah_set_port_num(struct rdma_ah_attr *attr, u8 port_num)
@@ -3502,18 +3549,30 @@ static inline u8 rdma_ah_get_port_num(const struct rdma_ah_attr *attr)
 static inline void rdma_ah_set_static_rate(struct rdma_ah_attr *attr,
 					   u8 static_rate)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		attr->ib.static_rate = static_rate;
-	else
+		break;
+	case RDMA_AH_ATTR_TYPE_ETH:
 		attr->eth.static_rate = static_rate;
+		break;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		attr->opa.static_rate = static_rate;
+	}
 }
 
 static inline u8 rdma_ah_get_static_rate(const struct rdma_ah_attr *attr)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		return attr->ib.static_rate;
-	else
+	case RDMA_AH_ATTR_TYPE_ETH:
 		return attr->eth.static_rate;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		return attr->opa.static_rate;
+	default:
+		return 0;
+	}
 }
 
 static inline void rdma_ah_set_ah_flags(struct rdma_ah_attr *attr,
@@ -3531,20 +3590,32 @@ static inline void rdma_ah_set_ah_flags(struct rdma_ah_attr *attr,
 static inline const struct ib_global_route
 		*rdma_ah_read_grh(const struct rdma_ah_attr *attr)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		return &attr->ib.grh;
-	else
+	case RDMA_AH_ATTR_TYPE_ETH:
 		return &attr->eth.grh;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		return &attr->opa.grh;
+	default:
+		return NULL;
+	}
 }
 
 /*To retrieve and modify the grh */
 static inline struct ib_global_route
 		*rdma_ah_retrieve_grh(struct rdma_ah_attr *attr)
 {
-	if (attr->type == RDMA_AH_ATTR_TYPE_IB)
+	switch (attr->type) {
+	case RDMA_AH_ATTR_TYPE_IB:
 		return &attr->ib.grh;
-	else
+	case RDMA_AH_ATTR_TYPE_ETH:
 		return &attr->eth.grh;
+	case RDMA_AH_ATTR_TYPE_OPA:
+		return &attr->opa.grh;
+	default:
+		return NULL;
+	}
 }
 
 static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr, void *dgid)
@@ -3593,6 +3664,9 @@ static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
 	if ((rdma_protocol_roce(dev, port_num)) ||
 	    (rdma_protocol_iwarp(dev, port_num)))
 		return RDMA_AH_ATTR_TYPE_ETH;
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
