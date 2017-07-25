From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 7/7] IB/rxe: Avoid ICRC errors by copying into the skb first
Date: Tue, 25 Jul 2017 09:39:28 -0400
Message-ID: <1500989968-30889-8-git-send-email-andrew.boyer@dell.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the buffer contents are changing, the current code can generate a packet
with a bogus CRC. This can be seen with qperf's ud_bi_bw test.

No matter what behavior the client is expecting in this case, it shouldn't
result in a malformed packet.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index e37cc89..5c2684b 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -367,11 +367,11 @@ int rxe_mem_copy(struct rxe_mem *mem, u64 iova, void *addr, int length,
 		dest = (dir == to_mem_obj) ?
 			((void *)(uintptr_t)iova) : addr;
 
+		memcpy(dest, src, length);
+
 		if (crcp)
 			*crcp = rxe_crc32(to_rdev(mem->pd->ibpd.device),
-					*crcp, src, length);
-
-		memcpy(dest, src, length);
+					*crcp, dest, length);
 
 		return 0;
 	}
@@ -401,11 +401,11 @@ int rxe_mem_copy(struct rxe_mem *mem, u64 iova, void *addr, int length,
 		if (bytes > length)
 			bytes = length;
 
+		memcpy(dest, src, bytes);
+
 		if (crcp)
 			crc = rxe_crc32(to_rdev(mem->pd->ibpd.device),
-					crc, src, bytes);
-
-		memcpy(dest, src, bytes);
+					crc, dest, bytes);
 
 		length	-= bytes;
 		addr	+= bytes;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
