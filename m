From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 03/10] IB/core: Support accessing SA in virtualized environment
Date: Tue,  1 Mar 2016 18:52:16 +0200
Message-ID: <1456851143-138332-4-git-send-email-eli@mellanox.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456851143-138332-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Per the ongoing standardisation process, when virtual HCAs are present
in a network, traffic is routed based on a destination GID. In order to
access the SA we use the well known SA GID.

We also add a GRH required boolean field to the port attributes which is
used to report to the verbs consumer whether this port is connected to a
virtual network. We use this field to realize whether we need to create
an address vector with GRH to access the subnet administrator. We clear
the port attributes struct before calling the hardware driver to make
sure the default remains that GRH is not required.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c   | 1 +
 drivers/infiniband/core/sa_query.c | 5 +++++
 include/rdma/ib_verbs.h            | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 00da80e02154..24926acd4bcd 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -652,6 +652,7 @@ int ib_query_port(struct ib_device *device,
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
+	memset(port_attr, 0, sizeof(*port_attr));
 	return device->query_port(device, port_num, port_attr);
 }
 EXPORT_SYMBOL(ib_query_port);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index f334090bb612..833d2a99a311 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -886,6 +886,11 @@ static void update_sm_ah(struct work_struct *work)
 	ah_attr.dlid     = port_attr.sm_lid;
 	ah_attr.sl       = port_attr.sm_sl;
 	ah_attr.port_num = port->port_num;
+	if (port_attr.grh_required) {
+		ah_attr.ah_flags = IB_AH_GRH;
+		ah_attr.grh.dgid.global.subnet_prefix = cpu_to_be64(IB_SA_WELL_KNOWN_GID_PREFIX);
+		ah_attr.grh.dgid.global.interface_id = cpu_to_be64(IB_SA_WELL_KNOWN_GUID);
+	}
 
 	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
 	if (IS_ERR(new_ah->ah)) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c8fea4..5c1f11742c65 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -97,6 +97,11 @@ enum rdma_node_type {
 	RDMA_NODE_USNIC_UDP,
 };
 
+enum {
+	IB_SA_WELL_KNOWN_GID_PREFIX	= 0xfe80000000000000ull,
+	IB_SA_WELL_KNOWN_GUID		= 2,
+};
+
 enum rdma_transport_type {
 	RDMA_TRANSPORT_IB,
 	RDMA_TRANSPORT_IWARP,
@@ -508,6 +513,7 @@ struct ib_port_attr {
 	u8			active_width;
 	u8			active_speed;
 	u8                      phys_state;
+	bool			grh_required;
 };
 
 enum ib_device_modify_flags {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
