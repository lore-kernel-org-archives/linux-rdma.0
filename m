From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-3.9 1/3] IB/ipoib: Fix ipoib_neigh hashing to use the correct daddr octets
Date: Tue, 19 Feb 2013 17:40:22 +0200
Message-ID: <1361288424-8376-2-git-send-email-ogerlitz@mellanox.com>
References: <1361288424-8376-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361288424-8376-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The hash function introduced in commit b63b70d877 "IPoIB: Use a private hash
table for path lookup in xmit path" was designd to use the 3 octets of the
IPoIB HW address that holds the remote QPN. However, this currently isn't
the case under little endian machines as the code there uses the flags part
(octet[0]) and not the last octet of the QPN (octet[3]), fix that.

The fix caused a checkpatch warning on line over 80 characters, to
solve that changed the name of the temp variable that holds the daddr.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    2 ++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 07ca6fd..a7ac097 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -117,6 +117,8 @@ enum {
 #define	IPOIB_OP_CM     (0)
 #endif
 
+#define IPOIB_QPN_MASK ((__force u32) cpu_to_be32(0xFFFFFF))
+
 /* structs */
 
 struct ipoib_header {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 6fdc9e7..3c2498f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -844,10 +844,10 @@ static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl, u8 *daddr)
 	 * different subnets.
 	 */
 	 /* qpn octets[1:4) & port GUID octets[12:20) */
-	u32 *daddr_32 = (u32 *) daddr;
+	u32 *d32 = (u32 *)daddr;
 	u32 hv;
 
-	hv = jhash_3words(daddr_32[3], daddr_32[4], 0xFFFFFF & daddr_32[0], 0);
+	hv = jhash_3words(d32[3], d32[4], IPOIB_QPN_MASK & d32[0], 0);
 	return hv & htbl->mask;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
