From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/usnic: Fix endianness related warnings
Date: Wed, 15 Jan 2014 17:02:20 -0800
Message-ID: <1389834141-16587-2-git-send-email-umalhi@cisco.com>
References: <1389834141-16587-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389834141-16587-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix sparse endianness related warnings.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_common_util.h | 2 +-
 drivers/infiniband/hw/usnic/usnic_transport.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_common_util.h b/drivers/infiniband/hw/usnic/usnic_common_util.h
index afd8bfa..9d737ed 100644
--- a/drivers/infiniband/hw/usnic/usnic_common_util.h
+++ b/drivers/infiniband/hw/usnic/usnic_common_util.h
@@ -36,7 +36,7 @@ usnic_mac_to_gid(const char *const mac, char *raw_gid)
 }
 
 static inline void
-usnic_mac_ip_to_gid(const char *const mac, const uint32_t inaddr, char *raw_gid)
+usnic_mac_ip_to_gid(const char *const mac, const __be32 inaddr, char *raw_gid)
 {
 	raw_gid[0] = 0xfe;
 	raw_gid[1] = 0x80;
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index 9182cc8..ddef6f7 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -59,8 +59,7 @@ int usnic_transport_sock_to_str(char *buf, int buf_sz,
 	if (err)
 		return 0;
 
-	addr = htonl(addr);
-	return scnprintf(buf, buf_sz, "Proto:%u Addr:%pI4 Port:%hu",
+	return scnprintf(buf, buf_sz, "Proto:%u Addr:%pI4h Port:%hu",
 			proto, &addr, port);
 }
 
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
