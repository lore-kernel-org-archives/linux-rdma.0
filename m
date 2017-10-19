From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 03/16] IB/core: Introduce counter set describe verb
Date: Thu, 19 Oct 2017 17:41:45 +0300
Message-ID: <1508424118-27205-4-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to work with a counter set object, first need to get various
information on the counter set, hence the describe verb is introduced.

The following info is exposed by the describe verb:
- Type of counter set:
  Which type of verb object this counter set
  could count, for example Flow.
- Number of instances of this counter-set that are available in the
  hardware (i.e. num_of_cs).
- Additional attributes about the counter set, for example is cache
  supported ? if yes, application can choose upon query to read the data from
  the cache.
- Number of counters in the counter set i.e. entries_count.
- An array of null terminated counters names strings within this counter set,
  each name is 64 bytes aligned.
  The user must allocate sufficient buffer size to get this data.
  In case buffer is NULL all other metadata is returned, except of
  the array.
  Based on the returned metadata, user can know the required buffer size
  needed to hold the counters names, which is 64 * entries_count.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 20 ++++++++++++++++++++
 include/rdma/ib_verbs.h         | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index d8f1a5d..eda389a 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2290,3 +2290,23 @@ void ib_drain_qp(struct ib_qp *qp)
 		ib_drain_rq(qp);
 }
 EXPORT_SYMBOL(ib_drain_qp);
+
+/**
+ * ib_describe_counter_set - Describes a Counter Set
+ * @device: The device on which to describe a counter set.
+ * @cs_id: the counter set id to be described
+ * @cs_describe_attr: A list of description attributes
+ * required to get the outcome.
+ */
+int ib_describe_counter_set(struct ib_device *device,
+			    u16 cs_id,
+			    struct ib_counter_set_describe_attr *cs_describe_attr)
+{
+	if (!device->describe_counter_set)
+		return -ENOSYS;
+
+	return device->describe_counter_set(device, cs_id,
+					cs_describe_attr,
+					NULL);
+}
+EXPORT_SYMBOL(ib_describe_counter_set);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0cc880d..44f92c3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2053,6 +2053,30 @@ struct ib_port_pkey_list {
 	struct list_head              pkey_list;
 };
 
+enum ib_counter_set_type {
+	IB_COUNTER_SET_FLOW,
+};
+
+enum ib_counter_set_attributes {
+	/* Is cache supported */
+	IB_COUNTER_SET_ATTR_CACHED = 1 << 0,
+};
+
+#define IB_COUNTER_NAME_LEN 64
+struct ib_counter_set_describe_attr {
+	/* Type that this set refers to, use enum ib_counter_set_type */
+	u8 counted_type;
+	/* Number of instances of this counter-set available in the hardware */
+	u64 num_of_cs;
+	/* Attributes of the set, use enum ib_counter_set_attributes */
+	u32 attributes;
+	/* Number of counters in this set */
+	u8 entries_count;
+	/* Counters_names_buff length */
+	u16 counters_names_len;
+	char *counters_names_buff;
+};
+
 struct ib_device {
 	/* Do not access @dma_device directly from ULP nor from HW drivers. */
 	struct device                *dma_device;
@@ -2308,6 +2332,11 @@ struct ib_device {
 							   struct ib_rwq_ind_table_init_attr *init_attr,
 							   struct ib_udata *udata);
 	int                        (*destroy_rwq_ind_table)(struct ib_rwq_ind_table *wq_ind_table);
+	int	(*describe_counter_set)(struct ib_device *device,
+					u16	cs_id,
+					struct ib_counter_set_describe_attr *cs_describe_attr,
+					struct ib_udata *udata);
+
 	/**
 	 * rdma netdev operation
 	 *
@@ -3615,6 +3644,10 @@ struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
 						 wq_ind_table_init_attr);
 int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 
+int ib_describe_counter_set(struct ib_device *device,
+			    u16 cs_id,
+			    struct ib_counter_set_describe_attr *cs_describe_attr);
+
 int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 		 unsigned int *sg_offset, unsigned int page_size);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
