From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 05/16] IB/core: Introduce counter set object and its create/destroy verbs
Date: Thu, 19 Oct 2017 17:41:47 +0300
Message-ID: <1508424118-27205-6-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Counter set instance is allocated on an IB context and belongs to
that context.
Upon successful creation the counter set hardware resources are
allocated and are ready to be bound to its counted type IB object.
Post the bind operation the hardware related counters could be queried.

Downstream patches in this series will introduce the bind and the
query functionality.

Counter set instance can be de-allocated, upon successful
destruction the related hardware resources are released.

Prior to calling the destroy verb the user must first make sure that
the counter set is not being used by its IB object, in other words not
bound to any of its counted objects.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 42 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         | 15 +++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index eda389a..ea71393 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2310,3 +2310,45 @@ int ib_describe_counter_set(struct ib_device *device,
 					NULL);
 }
 EXPORT_SYMBOL(ib_describe_counter_set);
+
+/**
+ * ib_create_counter_set - Creates a Counter Set
+ * @device: The device on which to create the counter set.
+ * @cs_id: counter set id required to
+ * create the counter set.
+ */
+struct ib_counter_set *ib_create_counter_set(struct ib_device *device,
+					     u16 cs_id)
+{
+	struct ib_counter_set *cs;
+
+	if (!device->create_counter_set)
+		return ERR_PTR(-ENOSYS);
+
+	cs = device->create_counter_set(device, cs_id, NULL);
+	if (!IS_ERR(cs)) {
+		cs->device = device;
+		cs->uobject = NULL;
+		cs->cs_id = cs_id;
+		atomic_set(&cs->usecnt, 0);
+	}
+
+	return cs;
+}
+EXPORT_SYMBOL(ib_create_counter_set);
+
+/**
+ * ib_destroy_counter_set - Destroys the specified counter set.
+ * @cs: The counter set to destroy.
+ **/
+int ib_destroy_counter_set(struct ib_counter_set *cs)
+{
+	if (!cs->device->destroy_counter_set)
+		return -ENOSYS;
+
+	if (atomic_read(&cs->usecnt))
+		return -EBUSY;
+
+	return cs->device->destroy_counter_set(cs);
+}
+EXPORT_SYMBOL(ib_destroy_counter_set);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 44f92c3..1c78db7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2077,6 +2077,14 @@ struct ib_counter_set_describe_attr {
 	char *counters_names_buff;
 };
 
+struct ib_counter_set {
+	struct ib_device	*device;
+	struct ib_uobject	*uobject;
+	u16	cs_id;
+	/* num of objects attached */
+	atomic_t	usecnt;
+};
+
 struct ib_device {
 	/* Do not access @dma_device directly from ULP nor from HW drivers. */
 	struct device                *dma_device;
@@ -2336,6 +2344,10 @@ struct ib_device {
 					u16	cs_id,
 					struct ib_counter_set_describe_attr *cs_describe_attr,
 					struct ib_udata *udata);
+	struct ib_counter_set *	(*create_counter_set)(struct ib_device *device,
+						      u16 cs_id,
+						      struct ib_udata *udata);
+	int	(*destroy_counter_set)(struct ib_counter_set *cs);
 
 	/**
 	 * rdma netdev operation
@@ -3647,6 +3659,9 @@ struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
 int ib_describe_counter_set(struct ib_device *device,
 			    u16 cs_id,
 			    struct ib_counter_set_describe_attr *cs_describe_attr);
+struct ib_counter_set *ib_create_counter_set(struct ib_device *device,
+					     u16 cs_id);
+int ib_destroy_counter_set(struct ib_counter_set *cs);
 
 int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 		 unsigned int *sg_offset, unsigned int page_size);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
