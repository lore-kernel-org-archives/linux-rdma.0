From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/usnic: Remove unused functions
Date: Wed,  1 Mar 2017 22:09:09 +0200
Message-ID: <1488398949-30263-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_common_util.h | 29 -------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_common_util.h b/drivers/infiniband/hw/usnic/usnic_common_util.h
index b54986d..d757b82 100644
--- a/drivers/infiniband/hw/usnic/usnic_common_util.h
+++ b/drivers/infiniband/hw/usnic/usnic_common_util.h
@@ -35,22 +35,6 @@
 #define USNIC_CMN_UTIL_H
 
 static inline void
-usnic_mac_to_gid(const char *const mac, char *raw_gid)
-{
-	raw_gid[0] = 0xfe;
-	raw_gid[1] = 0x80;
-	memset(&raw_gid[2], 0, 6);
-	raw_gid[8] = mac[0]^2;
-	raw_gid[9] = mac[1];
-	raw_gid[10] = mac[2];
-	raw_gid[11] = 0xff;
-	raw_gid[12] = 0xfe;
-	raw_gid[13] = mac[3];
-	raw_gid[14] = mac[4];
-	raw_gid[15] = mac[5];
-}
-
-static inline void
 usnic_mac_ip_to_gid(const char *const mac, const __be32 inaddr, char *raw_gid)
 {
 	raw_gid[0] = 0xfe;
@@ -67,17 +51,4 @@
 	raw_gid[15] = mac[5];
 }
 
-static inline void
-usnic_write_gid_if_id_from_mac(char *mac, char *raw_gid)
-{
-	raw_gid[8] = mac[0]^2;
-	raw_gid[9] = mac[1];
-	raw_gid[10] = mac[2];
-	raw_gid[11] = 0xff;
-	raw_gid[12] = 0xfe;
-	raw_gid[13] = mac[3];
-	raw_gid[14] = mac[4];
-	raw_gid[15] = mac[5];
-}
-
 #endif /* USNIC_COMMON_UTIL_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
