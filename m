From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v5 for-4.13 4/7] RDMA/core: expose affinity mappings per completion vector
Date: Thu, 15 Jun 2017 16:33:11 +0300
Message-ID: <1497533594-11579-5-git-send-email-sagi@grimberg.me>
References: <1497533594-11579-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497533594-11579-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This will allow ULPs to intelligently locate threads based
on completion vector cpu affinity mappings. In case the
driver does not expose a get_vector_affinity callout, return
NULL so the caller can maintain a fallback logic.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 include/rdma/ib_verbs.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314ec5768..2349143297c9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2245,6 +2245,8 @@ struct ib_device {
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
+	const struct cpumask *(*get_vector_affinity)(struct ib_device *ibdev,
+						     int comp_vector);
 };
 
 struct ib_client {
@@ -3609,7 +3611,6 @@ static inline void rdma_ah_set_interface_id(struct rdma_ah_attr *attr,
 
 	grh->dgid.global.interface_id = if_id;
 }
-
 static inline void rdma_ah_set_grh(struct rdma_ah_attr *attr,
 				   union ib_gid *dgid, u32 flow_label,
 				   u8 sgid_index, u8 hop_limit,
@@ -3639,4 +3640,26 @@ static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
 	else
 		return RDMA_AH_ATTR_TYPE_IB;
 }
+
+/**
+ * ib_get_vector_affinity - Get the affinity mappings of a given completion
+ *   vector
+ * @device:         the rdma device
+ * @comp_vector:    index of completion vector
+ *
+ * Returns NULL on failure, otherwise a corresponding cpu map of the
+ * completion vector (returns all-cpus map if the device driver doesn't
+ * implement get_vector_affinity).
+ */
+static inline const struct cpumask *
+ib_get_vector_affinity(struct ib_device *device, int comp_vector)
+{
+	if (comp_vector < 0 || comp_vector >= device->num_comp_vectors ||
+	    !device->get_vector_affinity)
+		return NULL;
+
+	return device->get_vector_affinity(device, comp_vector);
+
+}
+
 #endif /* IB_VERBS_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
