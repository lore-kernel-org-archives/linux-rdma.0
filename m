From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 07/11] ib_core: Add API to support IBoE from userspace
Date: Thu, 18 Feb 2010 19:24:25 +0200
Message-ID: <20100218172425.GH12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add ib_uverbs_get_eth_l2_addr() to allow ibv_create_ah() to resolve <sgid,
dgid> to <vlan, dmac> for any gid type.  Although user-space might bypass this
call for link-local gids, it is better not to replicate the kernel resolution
policy.  Port link layer is also returned by ibv_query_port().

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---

Changes from v7:

1. ib_uverbs_get_mac() was renamed to ib_uverbs_get_eth_l2_addr() and it now
   returns both MAC, VLAN ID and a tagged indication to indicate if packets
   should go out tagged..

 drivers/infiniband/core/uverbs.h      |    1 +
 drivers/infiniband/core/uverbs_cmd.c  |   33 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |    1 +
 drivers/infiniband/core/verbs.c       |   10 ++++++++++
 include/rdma/ib_user_verbs.h          |   22 ++++++++++++++++++++--
 include/rdma/ib_verbs.h               |   17 +++++++++++++++++
 6 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b3ea958..79359f6 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -194,5 +194,6 @@ IB_UVERBS_DECLARE_CMD(create_srq);
 IB_UVERBS_DECLARE_CMD(modify_srq);
 IB_UVERBS_DECLARE_CMD(query_srq);
 IB_UVERBS_DECLARE_CMD(destroy_srq);
+IB_UVERBS_DECLARE_CMD(get_eth_l2_addr);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 112d397..19b4827 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -452,6 +452,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.active_width    = attr.active_width;
 	resp.active_speed    = attr.active_speed;
 	resp.phys_state      = attr.phys_state;
+	resp.link_layer	     = attr.link_layer;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -1824,6 +1825,38 @@ err:
 	return ret;
 }
 
+ssize_t ib_uverbs_get_eth_l2_addr(struct ib_uverbs_file *file, const char __user *buf,
+				  int in_len, int out_len)
+{
+	struct ib_uverbs_get_eth_l2_addr       cmd;
+	struct ib_uverbs_get_eth_l2_addr_resp  resp;
+	int              ret;
+	struct ib_pd    *pd;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	if (!pd)
+		return -EINVAL;
+
+	ret = ib_get_eth_l2_addr(pd->device, cmd.port, (union ib_gid *)cmd.gid,
+				 cmd.sgid_idx, resp.mac, &resp.vlan_id, &resp.tagged);
+	put_pd_read(pd);
+	if (!ret) {
+		if (copy_to_user((void __user *) (unsigned long) cmd.response,
+				 &resp, sizeof resp))
+			return -EFAULT;
+
+		return in_len;
+	}
+
+	return ret;
+}
+
 ssize_t ib_uverbs_destroy_ah(struct ib_uverbs_file *file,
 			     const char __user *buf, int in_len, int out_len)
 {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5f284ff..ef9eaa5 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -109,6 +109,7 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_MODIFY_SRQ]    	= ib_uverbs_modify_srq,
 	[IB_USER_VERBS_CMD_QUERY_SRQ]     	= ib_uverbs_query_srq,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]   	= ib_uverbs_destroy_srq,
+	[IB_USER_VERBS_CMD_GET_ETH_L2_ADDR]	= ib_uverbs_get_eth_l2_addr,
 };
 
 static struct vfsmount *uverbs_event_mnt;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f9cbdb6..f586702 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -920,3 +920,13 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	return qp->device->detach_mcast(qp, gid, lid);
 }
 EXPORT_SYMBOL(ib_detach_mcast);
+
+int ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
+		       int sgid_idx, u8 *mac, __u16 *vlan_id, u8 *tagged)
+{
+	if (!device->get_eth_l2_addr)
+		return -ENOSYS;
+
+	return device->get_eth_l2_addr(device, port, gid, sgid_idx, mac, vlan_id, tagged);
+}
+EXPORT_SYMBOL(ib_get_eth_l2_addr);
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index a17f771..09f38df 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -81,7 +81,8 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_GET_ETH_L2_ADDR
 };
 
 /*
@@ -205,7 +206,8 @@ struct ib_uverbs_query_port_resp {
 	__u8  active_width;
 	__u8  active_speed;
 	__u8  phys_state;
-	__u8  reserved[3];
+	__u8  link_layer;
+	__u8  reserved[2];
 };
 
 struct ib_uverbs_alloc_pd {
@@ -621,6 +623,22 @@ struct ib_uverbs_destroy_ah {
 	__u32 ah_handle;
 };
 
+struct ib_uverbs_get_eth_l2_addr {
+	__u64	response;
+	__u32	pd_handle;
+	__u8	port;
+	__u8    sgid_idx;
+	__u8    reserved[2];
+	__u8	gid[16];
+};
+
+struct ib_uverbs_get_eth_l2_addr_resp {
+	__u8	mac[6];
+	__u16	vlan_id;
+	__u8	tagged;
+	__u8	reserved[3];
+};
+
 struct ib_uverbs_attach_mcast {
 	__u8  gid[16];
 	__u32 qp_handle;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bbfe315..764de74 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1139,6 +1139,10 @@ struct ib_device {
 						  struct ib_grh *in_grh,
 						  struct ib_mad *in_mad,
 						  struct ib_mad *out_mad);
+	int			   (*get_eth_l2_addr)(struct ib_device *device, u8 port,
+						      union ib_gid *dgid, int sgid_idx,
+						      u8 *mac, u16 *vlan_id, u8 *tagged);
+
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2048,4 +2052,17 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid);
  */
 int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 
+/**
+  * ib_get_eth_l2_addr - get the mac and vlan id for the specified gid
+  * @device: IB device used for traffic
+  * @port: port number used.
+  * @gid: gid to be resolved into mac
+  * @sgid_idx: index to port's gid table for the corresponding address vector
+  * @mac: mac of the port bearing this gid
+  * @vlan_id: vlan to be used to reach this gid
+  * @tagged: set if 802.1q tag should be used. Cleared otherwise.
+  */
+int ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
+		       int sgid_idx, u8 *mac, u16 *vlan_id, u8 *tagged);
+
 #endif /* IB_VERBS_H */
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
