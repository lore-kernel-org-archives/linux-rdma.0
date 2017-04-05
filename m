From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 1/6] IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs
Date: Wed,  5 Apr 2017 17:09:08 +0300
Message-ID: <20170405140913.2551-2-leon@kernel.org>
References: <20170405140913.2551-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405140913.2551-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add RDMA netdev interface to ib device structure allowing RDMA netdev
devices to be allocated by ib clients.

The idea is to allow to providers to optimize IPoIB data path.
New struct that includes functions and data member is exposed.
It exposes set of callback functions for handling data path flows
in IPoIB driver.

Each provider can support these set of functions in order to optimize its
specific data path, and let IPoIB to leverage its data path.

There is an assumption, that providers should give the full set of functions
and not only part of them, in order to work properly.

Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0f1813c13687..d3b104a96b58 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -55,6 +55,7 @@
 #include <net/ip.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/netdevice.h>
 
 #include <linux/if_link.h>
 #include <linux/atomic.h>
@@ -1862,7 +1863,38 @@ struct ib_port_immutable {
 	u32                           max_mad_size;
 };
 
+/* rdma netdev type - specifies protocol type */
+enum rdma_netdev_t {
+	RDMA_NETDEV_IPOIB,
+};
+
+/*
+ * struct rdma_netdev - rdma netdev
+ * For cases where netstack interfacing is required.
+ */
+struct rdma_netdev {
+	void *clnt_priv;
+
+	/* control functions */
+	void (*set_id)(struct net_device *netdev, int id);
+	/* send packet */
+	int (*send)(struct net_device *dev, struct sk_buff *skb,
+		    struct ib_ah *address, u32 dqpn);
+	/* multicast */
+	int (*attach_mcast)(struct net_device *dev, struct ib_device *hca,
+			    union ib_gid *gid, u16 mlid,
+			    int set_qkey, u32 qkey);
+	int (*detach_mcast)(struct net_device *dev, struct ib_device *hca,
+			    union ib_gid *gid, u16 mlid);
+
+	/* rdma-netdev private members */
+	struct ib_device *hca;
+};
+
 struct ib_device {
+	/* Do not access @dma_device directly from ULP nor from HW drivers. */
+	struct device                *dma_device;
+
 	char                          name[IB_DEVICE_NAME_MAX];
 
 	struct list_head              event_handler_list;
@@ -2112,6 +2144,15 @@ struct ib_device {
 							   struct ib_rwq_ind_table_init_attr *init_attr,
 							   struct ib_udata *udata);
 	int                        (*destroy_rwq_ind_table)(struct ib_rwq_ind_table *wq_ind_table);
+	/* rdma netdev operations */
+	struct net_device *(*alloc_rdma_netdev)(
+					struct ib_device *device,
+					u8 port_num,
+					enum rdma_netdev_t type,
+					const char *name,
+					unsigned char name_assign_type,
+					void (*setup)(struct net_device *));
+	void (*free_rdma_netdev)(struct net_device *netdev);
 
 	struct module               *owner;
 	struct device                dev;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
