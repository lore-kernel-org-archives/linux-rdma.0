From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/core: Map iWarp AH type to undefined in
 rdma_ah_find_type
Date: Thu, 01 Feb 2018 10:57:03 -0800
Message-ID: <20180201185700.9503.25176.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

iWarp devices do not support the creation of address handles
so return AH_ATTR_TYPE_UNDEFINED for all iWarp devices.

While we are here reduce the size of port_num to u8 and add
a comment.

Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes since v1: Add Shiraz RB tag, move undefined to be 0 not 3
---
 include/rdma/ib_verbs.h |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5263c86..73b2387 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -874,6 +874,7 @@ struct ib_mr_status {
 __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
 
 enum rdma_ah_attr_type {
+	RDMA_AH_ATTR_TYPE_UNDEFINED,
 	RDMA_AH_ATTR_TYPE_IB,
 	RDMA_AH_ATTR_TYPE_ROCE,
 	RDMA_AH_ATTR_TYPE_OPA,
@@ -3810,17 +3811,24 @@ static inline void rdma_ah_set_grh(struct rdma_ah_attr *attr,
 	grh->traffic_class = traffic_class;
 }
 
-/*Get AH type */
+/**
+ * rdma_ah_find_type - Return address handle type.
+ *
+ * @dev: Device to be checked
+ * @port_num: Port number
+ */
 static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
-						       u32 port_num)
+						       u8 port_num)
 {
 	if (rdma_protocol_roce(dev, port_num))
 		return RDMA_AH_ATTR_TYPE_ROCE;
-	else if ((rdma_protocol_ib(dev, port_num)) &&
-		 (rdma_cap_opa_ah(dev, port_num)))
-		return RDMA_AH_ATTR_TYPE_OPA;
-	else
+	if (rdma_protocol_ib(dev, port_num)) {
+		if (rdma_cap_opa_ah(dev, port_num))
+			return RDMA_AH_ATTR_TYPE_OPA;
 		return RDMA_AH_ATTR_TYPE_IB;
+	}
+
+	return RDMA_AH_ATTR_TYPE_UNDEFINED;
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
