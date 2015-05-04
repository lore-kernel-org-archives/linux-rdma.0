From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon,  4 May 2015 02:14:55 -0400
Message-ID: <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430720099-32512-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add Core capability flags to each port attribute and read those into ib_device
upon registration for each port.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/device.c |   41 ++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h          |   22 ++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b360350..6a37255 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -262,6 +262,37 @@ out:
 	return ret;
 }
 
+static int read_core_cap_flags(struct ib_device *device)
+{
+	struct ib_port_attr tprops;
+	int num_ports, ret = -ENOMEM;
+	u8 port_index;
+
+	num_ports = device->phys_port_cnt;
+
+	device->core_cap_flags = kzalloc(sizeof(*device->core_cap_flags)
+						* (num_ports+1),
+					 GFP_KERNEL);
+	if (!device->core_cap_flags)
+		return -ENOMEM;
+
+	for (port_index = 0; port_index <= num_ports; ++port_index) {
+		if ((port_index == 0 && device->node_type != RDMA_NODE_IB_SWITCH))
+			continue;
+
+		ret = ib_query_port(device, port_index, &tprops);
+		if (ret)
+			goto err;
+
+		device->core_cap_flags[port_index] = tprops.core_cap_flags;
+	}
+
+	return 0;
+err:
+	kfree(device->core_cap_flags);
+	return ret;
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -302,12 +333,21 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = read_core_cap_flags(device);
+	if (ret) {
+		dev_err(&device->dev, "Couldn't create Core Capability flags\n");
+		kfree(device->gid_tbl_len);
+		kfree(device->pkey_tbl_len);
+		goto out;
+	}
+
 	ret = ib_device_register_sysfs(device, port_callback);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
 		kfree(device->gid_tbl_len);
 		kfree(device->pkey_tbl_len);
+		kfree(device->core_cap_flags);
 		goto out;
 	}
 
@@ -351,6 +391,7 @@ void ib_unregister_device(struct ib_device *device)
 
 	kfree(device->gid_tbl_len);
 	kfree(device->pkey_tbl_len);
+	kfree(device->core_cap_flags);
 
 	mutex_unlock(&device_mutex);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c724114..4de2758 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -353,11 +353,32 @@ union rdma_protocol_stats {
 	struct iw_protocol_stats	iw;
 };
 
+/* Define bits for the various functionality this port needs to be supported by
+ * the core.
+ */
+/* Management                           0x00000000FFFFFFFF */
+#define RDMA_CORE_CAP_IB_MAD		0x0000000000000001ULL
+#define RDMA_CORE_CAP_IB_SMI		0x0000000000000002ULL
+#define RDMA_CORE_CAP_IB_CM		0x0000000000000004ULL
+#define RDMA_CORE_CAP_IW_CM		0x0000000000000008ULL
+#define RDMA_CORE_CAP_IB_SA		0x0000000000000010ULL
+
+/* Address format                       0x0000FFFF00000000 */
+#define RDMA_CORE_CAP_AF_IB		0x0000000100000000ULL
+#define RDMA_CORE_CAP_ETH_AH		0x0000000200000000ULL
+
+/* Protocol                             0xFFFF000000000000 */
+#define RDMA_CORE_CAP_PROT_IB		0x0001000000000000ULL
+#define RDMA_CORE_CAP_PROT_IBOE		0x0002000000000000ULL
+#define RDMA_CORE_CAP_PROT_IWARP	0x0004000000000000ULL
+#define RDMA_CORE_CAP_PROT_USNIC_UDP	0x0008000000000000ULL
+
 struct ib_port_attr {
 	enum ib_port_state	state;
 	enum ib_mtu		max_mtu;
 	enum ib_mtu		active_mtu;
 	int			gid_tbl_len;
+	u64                     core_cap_flags;
 	u32			port_cap_flags;
 	u32			max_msg_sz;
 	u32			bad_pkey_cntr;
@@ -1684,6 +1705,7 @@ struct ib_device {
 	u32			     local_dma_lkey;
 	u8                           node_type;
 	u8                           phys_port_cnt;
+	u64                         *core_cap_flags; /* Per port core capability flags */
 };
 
 struct ib_client {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
