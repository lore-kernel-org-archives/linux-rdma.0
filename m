From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/core: Take into account optional UDR, XRC headers and mandatory ICRC for RoCE MTU
Date: Mon, 16 Oct 2017 08:28:11 +0300
Message-ID: <20171016052812.28802-5-leon@kernel.org>
References: <20171016052812.28802-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016052812.28802-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This fix considers optional UDP, XRC header sizes and mandatory ICRC 4 bytes in
calculation of path MTU, by considering additional 8 bytes, path MTU calculation
is more accurate.

Link: https://www.spinics.net/lists/linux-rdma/msg54558.html
Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_addr.h |  7 ++++---
 include/rdma/ib_pack.h | 19 +++++++++++--------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index cfa82d16573d..b2a10c762304 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -245,10 +245,11 @@ static inline void rdma_addr_set_dgid(struct rdma_dev_addr *dev_addr, union ib_g
 static inline enum ib_mtu iboe_get_mtu(int mtu)
 {
 	/*
-	 * reduce IB headers from effective IBoE MTU. 28 stands for
-	 * atomic header which is the biggest possible header after BTH
+	 * Reduce IB headers from effective IBoE MTU.
 	 */
-	mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
+	mtu = mtu - (IB_GRH_BYTES + IB_UDP_BYTES + IB_BTH_BYTES +
+		     IB_EXT_XRC_BYTES + IB_EXT_ATOMICETH_BYTES +
+		     IB_ICRC_BYTES);
 
 	if (mtu >= ib_mtu_enum_to_int(IB_MTU_4096))
 		return IB_MTU_4096;
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index 36655899ee02..7ea1382ad0e5 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -37,14 +37,17 @@
 #include <uapi/linux/if_ether.h>
 
 enum {
-	IB_LRH_BYTES  = 8,
-	IB_ETH_BYTES  = 14,
-	IB_VLAN_BYTES = 4,
-	IB_GRH_BYTES  = 40,
-	IB_IP4_BYTES  = 20,
-	IB_UDP_BYTES  = 8,
-	IB_BTH_BYTES  = 12,
-	IB_DETH_BYTES = 8
+	IB_LRH_BYTES		= 8,
+	IB_ETH_BYTES		= 14,
+	IB_VLAN_BYTES		= 4,
+	IB_GRH_BYTES		= 40,
+	IB_IP4_BYTES		= 20,
+	IB_UDP_BYTES		= 8,
+	IB_BTH_BYTES		= 12,
+	IB_DETH_BYTES		= 8,
+	IB_EXT_ATOMICETH_BYTES	= 28,
+	IB_EXT_XRC_BYTES	= 4,
+	IB_ICRC_BYTES		= 4
 };
 
 struct ib_field {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
