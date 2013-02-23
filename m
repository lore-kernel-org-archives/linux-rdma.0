From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] libibumad: Define well known QKEY
Date: Sat, 23 Feb 2013 15:02:20 -0800
Message-ID: <1361660540-503-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad_types.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
index 199edd1..113af16 100644
--- a/include/infiniband/umad_types.h
+++ b/include/infiniband/umad_types.h
@@ -51,6 +51,7 @@
 BEGIN_C_DECLS
 
 #define UMAD_BASE_VERSION		1
+#define UMAD_QKEY			0x80010000
 
 /* Management classes */
 enum {
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
