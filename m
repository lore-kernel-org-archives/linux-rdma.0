From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v1 10/11] IB/rxe: Avoid ICRC errors by copying into the skb first
Date: Fri, 25 Aug 2017 15:05:55 -0400
Message-ID: <1503687956-7110-11-git-send-email-andrew.boyer@dell.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503687956-7110-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current process is to first calculate the CRC and then copy the client
data into the packet. This leaves a window in which the packet contents and
CRC can get out of sync, if the client changes the data after the CRC is
calculated but before the data is copied.

By copying the data into the packet and then calculating the CRC directly
from the packet contents we eliminate the window.

This can be seen with qperf's ud_bi_bw test. This seems like very
strange/reckless client behavior, but whether the client has mangled its
data or not RXE should be able to transfer it reliably.

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
