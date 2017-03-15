From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/6] INADDR_* needs to be byteswapped before being used
Date: Wed, 15 Mar 2017 16:12:03 -0600
Message-ID: <1489615927-12117-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The constants are in host order. INADDR_ANY is 0 so the swap has no change,
but the INADDR_LOOPBACK test in rsocket never worked.

Found by sparse

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/iwarp_pm_common.c | 2 +-
 iwpmd/iwarp_pm_helper.c | 2 +-
 librdmacm/rsocket.c     | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iwpmd/iwarp_pm_common.c b/iwpmd/iwarp_pm_common.c
index e73f1714d1312d..8b4432042329c1 100644
--- a/iwpmd/iwarp_pm_common.c
+++ b/iwpmd/iwarp_pm_common.c
@@ -110,7 +110,7 @@ int create_iwpm_socket_v4(__u16 bind_port)
 	memset(&bind_addr, 0, sizeof(bind_addr));
 	bind_in4 = &bind_addr.v4_sockaddr;
 	bind_in4->sin_family = AF_INET;
-	bind_in4->sin_addr.s_addr = INADDR_ANY;
+	bind_in4->sin_addr.s_addr = htobe32(INADDR_ANY);
 	bind_in4->sin_port = htobe16(bind_port);
 
 	if (bind(pm_sock, &bind_addr.sock_addr, sizeof(struct sockaddr_in))) {
diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index ddc1deb48215a6..fe69f5f166904a 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -279,7 +279,7 @@ static int get_iwpm_tcp_port(__u16 addr_family, __be16 requested_port,
 		mapped_port = &((struct sockaddr_in *)mapped_addr)->sin_port;
 		bind_in4 = &bind_addr.v4_sockaddr;
 		bind_in4->sin_family = addr_family;
-		bind_in4->sin_addr.s_addr = INADDR_ANY;
+		bind_in4->sin_addr.s_addr = htobe32(INADDR_ANY);
 		if (requested_port)
 			requested_port = *mapped_port;
 		bind_in4->sin_port = requested_port;
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 04b91a57b9a42e..69ceab6de745d0 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -1402,8 +1402,8 @@ connected:
 static int rs_any_addr(const union socket_addr *addr)
 {
 	if (addr->sa.sa_family == AF_INET) {
-		return (addr->sin.sin_addr.s_addr == INADDR_ANY ||
-			addr->sin.sin_addr.s_addr == INADDR_LOOPBACK);
+		return (addr->sin.sin_addr.s_addr == htobe32(INADDR_ANY) ||
+			addr->sin.sin_addr.s_addr == htobe32(INADDR_LOOPBACK));
 	} else {
 		return (!memcmp(&addr->sin6.sin6_addr, &in6addr_any, 16) ||
 			!memcmp(&addr->sin6.sin6_addr, &in6addr_loopback, 16));
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
