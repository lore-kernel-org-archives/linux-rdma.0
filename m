From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 default GID when IPv6 is disabled
Date: Tue, 14 Nov 2017 14:51:48 +0200
Message-ID: <20171114125218.20477-2-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently two RoCE default GIDs are added whenever HCA supports RoCEv1
and RoCEv2. Default GIDs are created using unique GUID and well known
prefix as defined by the IB spec 1.3 section 4.1.1 and 3.5.10.

For few HCAs GUID is derived from the MAC address of the netdev. Due to
this scheme, default RoCEv2 GID resemebles link-local IPv6 based GID.
Even when IPv6 is disabled at compile time in kernel, default RoCEv2 GID
can get added. When such RoCEv2 GID is used, offload HCA starts using
IPv6 packets for QP.
This leads to sending IPv6 packets in network from a host which has IPv6
disabled kernel.

This can be seen with below simple test.
ib_send_bw -x 1 -d mlx5_1
ib_send_bw -x 1 -d mlx5_1 <ip_v4_addr>

It may not be a good idea to send/receive IPv6 packets on kernel which
has IPv6 disabled.

Therefore lets honor networking stack's IPv6 disabled setting.
This patch avoids adding RoCEv2 based default GID when IPv6 is
disabled in kernel.

ibv_devinfo -v output can be seen as below on IPv6 disabled kernel as
below with one IPv4 address assign to netdevice.

GID[  0]: fe80:0000:0000:0000:268a:07ff:fe55:4661
GID[  2]: 0000:0000:0000:0000:0000:ffff:c3a8:0124
GID[  3]: 0000:0000:0000:0000:0000:ffff:c3a8:0124

This also ensures that any RoCE specific legacy application who has
assumed GID indexes for IP addresses start from 2, still continue to
have such IP based GIDs assigned from start index of 2.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 77515638c55c..e5bba898741d 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -670,6 +670,15 @@ void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
 	memset(&gid_attr, 0, sizeof(gid_attr));
 	gid_attr.ndev = ndev;
 
+	/* Default GID is created using unique GUID and local subnet prefix,
+	 * as described in section 4.1.1 and 3.5.10 in IB spec 1.3.
+	 * Therefore don't create RoCEv2 default GID based on it that
+	 * resembles as IPv6 GID based on link local address when IPv6 is
+	 * disabled in kernel.
+	 */
+	if (!IS_ENABLED(CONFIG_IPV6))
+		gid_type_mask &= ~BIT(IB_GID_TYPE_ROCE_UDP_ENCAP);
+
 	for (gid_type = 0; gid_type < IB_GID_TYPE_SIZE; ++gid_type) {
 		int ix;
 		union ib_gid current_gid;
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
