From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/11] IB/core: Fix false search of the IB_SA_WELL_KNOWN_GUID
Date: Wed, 22 Jun 2016 17:27:24 +0300
Message-ID: <1466605652-24798-4-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When virtualziation is supported, VFs may send SA MADs to a GID formed
by the concatenation of the subnet prefix with the
IB_SA_WELL_KNOWN_GUID. When a response is required, the current code
will search the local HCA's port for the received GID to figure out the
GID index of the entry containing this GID. However, since this is not a
real GID it will not be found and error will be printed.

We change the logic to check if the destination GID is this special GID
and avoid lookup in this case and use GID index 0.

Fixes: a0c1b2a35087 ('IB/core: Support accessing SA in virtualized environment')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 1d7d4cf..6298f54 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -511,12 +511,16 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		ah_attr->grh.dgid = sgid;
 
 		if (!rdma_cap_eth_ah(device, port_num)) {
-			ret = ib_find_cached_gid_by_port(device, &dgid,
-							 IB_GID_TYPE_IB,
-							 port_num, NULL,
-							 &gid_index);
-			if (ret)
-				return ret;
+			if (dgid.global.interface_id != cpu_to_be64(IB_SA_WELL_KNOWN_GUID)) {
+				ret = ib_find_cached_gid_by_port(device, &dgid,
+								 IB_GID_TYPE_IB,
+								 port_num, NULL,
+								 &gid_index);
+				if (ret)
+					return ret;
+			} else {
+				gid_index = 0;
+			}
 		}
 
 		ah_attr->grh.sgid_index = (u8) gid_index;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
