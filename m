From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V3 03/10] IB/core: Add subnet prefix to port info
Date: Fri, 11 Mar 2016 22:58:36 +0200
Message-ID: <1457729923-4526-4-git-send-email-eli@mellanox.com>
References: <1457729923-4526-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457729923-4526-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The subnet prefix is a part of the port_info MAD returned and should be
available at the ib_port_attr struct. We define it here and provide a
default implementation in case the hardware driver does not provide one.
The subnet prefix is required when creating the address vector to access
the SA in networks where GRH must be used.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes from V2:
Move subnet_prefix to the beginning of the struct for better alignment

 drivers/infiniband/core/device.c | 15 ++++++++++++++-
 include/rdma/ib_verbs.h          |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 00da80e02154..7ba72799fc78 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -649,10 +649,23 @@ int ib_query_port(struct ib_device *device,
 		  u8 port_num,
 		  struct ib_port_attr *port_attr)
 {
+	union ib_gid gid;
+	int err;
+
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
-	return device->query_port(device, port_num, port_attr);
+	memset(port_attr, 0, sizeof(*port_attr));
+	err = device->query_port(device, port_num, port_attr);
+	if (err || port_attr->subnet_prefix)
+		return err;
+
+	err = ib_query_gid(device, port_num, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	port_attr->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
+	return 0;
 }
 EXPORT_SYMBOL(ib_query_port);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d83bc300c2b3..da4af77f6add 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -490,6 +490,7 @@ union rdma_protocol_stats {
 					| RDMA_CORE_CAP_OPA_MAD)
 
 struct ib_port_attr {
+	u64			subnet_prefix;
 	enum ib_port_state	state;
 	enum ib_mtu		max_mtu;
 	enum ib_mtu		active_mtu;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
