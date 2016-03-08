From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V2 05/10] IB/core: Add interfaces to control VF attributes
Date: Tue,  8 Mar 2016 18:36:53 +0200
Message-ID: <1457455018-17638-6-git-send-email-eli@mellanox.com>
References: <1457455018-17638-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457455018-17638-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Following the practice exercised for network devices which allow the PF
net device to configure attributes of its virtual functions, we
introduce the following functions to be used by IPoIB which is the
network driver implementation for IB devices.

ib_set_vf_link_state - set the policy for a VF link. More below.
ib_get_vf_config - read configuration information of a VF
ib_get_vf_stats - read VF statistics
ib_set_vf_guid - set the node or port GUID of a VF

Also add an indication in the device cap flags that indicates that this
IB devices is based on a virtual function.

A VF shares the physical port with the PF and other VFs. When setting
the link state we have three options:

1. Auto - in this mode, the virtual port follows the state of the
   physical port and becomes active only if the physical port's state is
   active. In all other cases it remains in a Down state.
2. Down - sets the state of the virtual port to Down
3. Up - causes the virtual port to transition into Initialize state if
   it was not already in this state. A virtualization aware subnet manager
   can then bring the state of the port into the Active state.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 40 ++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         | 19 +++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 16f3fb1b9d75..b928c71cda87 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1551,6 +1551,46 @@ int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 }
 EXPORT_SYMBOL(ib_check_mr_status);
 
+int ib_set_vf_link_state(struct ib_device *device, int vf, u8 port,
+			 int state)
+{
+	if (!device->set_vf_link_state)
+		return -ENOSYS;
+
+	return device->set_vf_link_state(device, vf, port, state);
+}
+EXPORT_SYMBOL(ib_set_vf_link_state);
+
+int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
+		     struct ifla_vf_info *info)
+{
+	if (!device->get_vf_config)
+		return -ENOSYS;
+
+	return device->get_vf_config(device, vf, port, info);
+}
+EXPORT_SYMBOL(ib_get_vf_config);
+
+int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
+		    struct ifla_vf_stats *stats)
+{
+	if (!device->get_vf_stats)
+		return -ENOSYS;
+
+	return device->get_vf_stats(device, vf, port, stats);
+}
+EXPORT_SYMBOL(ib_get_vf_stats);
+
+int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
+		   int type)
+{
+	if (!device->set_vf_guid)
+		return -ENOSYS;
+
+	return device->set_vf_guid(device, vf, port, guid, type);
+}
+EXPORT_SYMBOL(ib_set_vf_guid);
+
 /**
  * ib_map_mr_sg() - Map the largest prefix of a dma mapped SG list
  *     and set it the memory region.
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8add3db9a244..694d6d4e0dce 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -56,6 +56,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 
+#include <linux/if_link.h>
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
@@ -217,6 +218,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
 	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
 	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
+	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
 };
 
 enum ib_signature_prot_cap {
@@ -1859,6 +1861,14 @@ struct ib_device {
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
 	void			   (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
+	int			   (*set_vf_link_state)(struct ib_device *device, int vf, u8 port,
+							int state);
+	int			   (*get_vf_config)(struct ib_device *device, int vf, u8 port,
+						    struct ifla_vf_info *ivf);
+	int			   (*get_vf_stats)(struct ib_device *device, int vf, u8 port,
+						   struct ifla_vf_stats *stats);
+	int			   (*set_vf_guid)(struct ib_device *device, int vf, u8 port, u64 guid,
+						  int type);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2302,6 +2312,15 @@ int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid,
 		 struct ib_gid_attr *attr);
 
+int ib_set_vf_link_state(struct ib_device *device, int vf, u8 port,
+			 int state);
+int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
+		     struct ifla_vf_info *info);
+int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
+		    struct ifla_vf_stats *stats);
+int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
+		   int type);
+
 int ib_query_pkey(struct ib_device *device,
 		  u8 port_num, u16 index, u16 *pkey);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
