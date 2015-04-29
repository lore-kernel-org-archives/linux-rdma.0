From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: Fix unaligned accesses
Date: Wed, 29 Apr 2015 16:56:23 -0400
Message-ID: <1430340983-12538-1-git-send-email-david.ahern@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Addresses the following kernel logs seen during boot of sparc systems:

Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]

Signed-off-by: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cm.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..5102cfe 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -439,11 +439,23 @@ static struct cm_id_private * cm_acquire_id(__be32 local_id, __be32 remote_id)
 
 static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
 {
+	unsigned long *plsrc, *plmask, *pldst;
 	int i;
 
-	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
-		((unsigned long *) dst)[i] = ((unsigned long *) src)[i] &
-					     ((unsigned long *) mask)[i];
+	/* unsigned longs can use extended load operations which
+	 * can require 8-byte alignments. dst, src and mask are
+	 * not guaranteed to be aligned.
+	 */
+	pldst = (unsigned long *) dst;
+	plsrc = (unsigned long *) src;
+	plmask = (unsigned long *) mask;
+	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++) {
+		unsigned long lsrc, lmask;
+
+		lsrc = get_unaligned(&plsrc[i]);
+		lmask = get_unaligned(&plmask[i]);
+		put_unaligned(lsrc & lmask, &pldst[i]);
+	}
 }
 
 static int cm_compare_data(struct ib_cm_compare_data *src_data,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
