From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.14] IB: Avoid ib_modify_port() failure for RoCE devices
Date: Wed, 23 Aug 2017 01:08:07 -0700
Message-ID: <1503475687-5227-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IB CM calls ib_modify_port() irrespective of link layer. If the
failure is returned, the mad agent gets unregistered for those
devices. Recently, modify_port() hook was removed from some of the
low level drivers as it was always returning success. This breaks
rdma connection establishment over those devices.
For ethernet devices, Qkey violation and port capabilities are not
applicable. So returning success for RoCE when modify_port hook is
is not implemented.

Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index fc6be11..2466ffc 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1005,14 +1005,17 @@ int ib_modify_port(struct ib_device *device,
 		   u8 port_num, int port_modify_mask,
 		   struct ib_port_modify *port_modify)
 {
-	if (!device->modify_port)
-		return -ENOSYS;
+	int rc;
 
 	if (!rdma_is_port_valid(device, port_num))
 		return -EINVAL;
 
-	return device->modify_port(device, port_num, port_modify_mask,
-				   port_modify);
+	if (device->modify_port)
+		rc = device->modify_port(device, port_num, port_modify_mask,
+					   port_modify);
+	else
+		rc = rdma_protocol_roce(device, port_num) ? 0 : -ENOSYS;
+	return rc;
 }
 EXPORT_SYMBOL(ib_modify_port);
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
