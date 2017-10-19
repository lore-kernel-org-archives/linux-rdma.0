From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 07/16] IB/core: Introduce counter set query verb
Date: Thu, 19 Oct 2017 17:41:49 +0300
Message-ID: <1508424118-27205-8-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds the query counter set verb, enabling the user to
read the hardware counters which are associated with the counter
set.

The user supplies counter set instance and an output address.
The hardware queries the counter set and writes statistics to the
output address as an array of uint64_t, each entry in the uint64_t
array represents a single counter.

Note:
A counter set must be first attached to an IB object in order to
be queried for its underlay counters, downstream patches will
present bind and query methods for flow counters.
The user has an option as part of the query verb to force reading
the up-to-date hardware values instead of reading some cached
values by using the IB_COUNTER_SET_FORCE_UPDATE flag.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 21 +++++++++++++++++++++
 include/rdma/ib_verbs.h         | 17 +++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ea71393..ffe51fd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2352,3 +2352,24 @@ int ib_destroy_counter_set(struct ib_counter_set *cs)
 	return cs->device->destroy_counter_set(cs);
 }
 EXPORT_SYMBOL(ib_destroy_counter_set);
+
+/**
+ * ib_query_counter_set - Queries a Counter Set
+ * @cs: The counter set to query.
+ * @cs_query_attr: A list of query attributes
+ * required to get the outcome.
+ */
+int ib_query_counter_set(struct ib_counter_set *cs,
+			 struct ib_counter_set_query_attr *cs_query_attr)
+{
+	if (!cs->device->query_counter_set)
+		return -ENOSYS;
+
+	if (!atomic_read(&cs->usecnt))
+		return -EINVAL;
+
+	return cs->device->query_counter_set(cs,
+				cs_query_attr,
+				NULL);
+}
+EXPORT_SYMBOL(ib_query_counter_set);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1c78db7..bc33bc2 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2085,6 +2085,18 @@ struct ib_counter_set {
 	atomic_t	usecnt;
 };
 
+enum ib_query_counter_set_flags {
+	/* force hardware query instead of cached value */
+	IB_COUNTER_SET_FORCE_UPDATE = 1 << 0,
+};
+
+struct ib_counter_set_query_attr {
+	u32	query_flags; /* Use enum ib_query_counter_set_flags */
+	u64	*out_buff;
+	u32	buff_len;
+	u32	outlen;
+};
+
 struct ib_device {
 	/* Do not access @dma_device directly from ULP nor from HW drivers. */
 	struct device                *dma_device;
@@ -2348,6 +2360,9 @@ struct ib_device {
 						      u16 cs_id,
 						      struct ib_udata *udata);
 	int	(*destroy_counter_set)(struct ib_counter_set *cs);
+	int	(*query_counter_set)(struct ib_counter_set *cs,
+				     struct ib_counter_set_query_attr *cs_query_attr,
+				     struct ib_udata *udata);
 
 	/**
 	 * rdma netdev operation
@@ -3662,6 +3677,8 @@ int ib_describe_counter_set(struct ib_device *device,
 struct ib_counter_set *ib_create_counter_set(struct ib_device *device,
 					     u16 cs_id);
 int ib_destroy_counter_set(struct ib_counter_set *cs);
+int ib_query_counter_set(struct ib_counter_set *cs,
+			 struct ib_counter_set_query_attr *cs_query_attr);
 
 int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 		 unsigned int *sg_offset, unsigned int page_size);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
