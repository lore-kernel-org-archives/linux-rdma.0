From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next v4 5/8] IB/core: Add functions to convert 32 bit lids to 16 bits
Date: Thu, 10 Aug 2017 14:04:25 -0400
Message-ID: <1502388268-20687-6-git-send-email-don.hiatt@intel.com>
References: <1502388268-20687-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502388268-20687-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add two helper functions (ib_lid_cpu16(), ib_lid_be16()) to
convert 32 bit lids to 16 bits.

Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a7d6990..3875ea5d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3710,4 +3710,16 @@ static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
 	else
 		return RDMA_AH_ATTR_TYPE_IB;
 }
+
+/* Return lid in 16bit CPU encoding */
+static inline u16 ib_lid_cpu16(u32 lid)
+{
+	return (u16)lid;
+}
+
+/* Return lid in 16bit BE encoding */
+static inline u16 ib_lid_be16(u32 lid)
+{
+	return cpu_to_be16((u16)lid);
+}
 #endif /* IB_VERBS_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
