From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 01/45] IB/core: Fix endianness annotation in rdma_is_multicast_addr()
Date: Wed, 11 Oct 2017 10:48:43 -0700
Message-ID: <20171011174927.25113-2-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since ipv4_addr is a big endian 32-bit number, annotate it as such.

Fixes: commit be1d325a3358 ("IB/core: Set RoCEv2 MGID according to spec")
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_addr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ec5008cf5d51..cfa82d16573d 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -305,12 +305,12 @@ static inline void rdma_get_ll_mac(struct in6_addr *addr, u8 *mac)
 
 static inline int rdma_is_multicast_addr(struct in6_addr *addr)
 {
-	u32 ipv4_addr;
+	__be32 ipv4_addr;
 
 	if (addr->s6_addr[0] == 0xff)
 		return 1;
 
-	memcpy(&ipv4_addr, addr->s6_addr + 12, 4);
+	ipv4_addr = addr->s6_addr32[3];
 	return (ipv6_addr_v4mapped(addr) && ipv4_is_multicast(ipv4_addr));
 }
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
