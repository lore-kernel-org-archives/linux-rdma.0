From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 1/8] libacm.c: Remove unneeded structures
Date: Tue, 06 Aug 2013 07:45:14 -0400
Message-ID: <5200E1CA.509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


acm_port and acm_device are not used/needed

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/libacm.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/src/libacm.c b/src/libacm.c
index 1bf7030..4e42233 100644
--- a/src/libacm.c
+++ b/src/libacm.c
@@ -40,21 +40,6 @@
 #include <netdb.h>
 #include <arpa/inet.h>
 
-struct acm_port {
-	uint8_t           port_num;
-	uint16_t          lid;
-	union ibv_gid     gid;
-	int               pkey_cnt;
-	uint16_t          pkey[4];
-};
-
-struct acm_device {
-	struct ibv_context *verbs;
-	uint64_t           guid;
-	int                port_cnt;
-	struct acm_port    *ports;
-};
-
 extern lock_t lock;
 static SOCKET sock = INVALID_SOCKET;
 static short server_port = 6125;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
