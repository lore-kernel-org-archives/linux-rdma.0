From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] [TRIVIAL] rsocket.c: In rsetsockopt, for RDMA_ROUTE
 option, use malloc rather than calloc
Date: Wed, 18 Jun 2014 10:30:38 -0400
Message-ID: <53A1A28E.7000408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


No need to clear allocated memory as immediately followed by
memcpy which covers the allocated memory.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/rsocket.c b/src/rsocket.c
index 3a9ff7d..a3c5385 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3473,7 +3473,7 @@ int rsetsockopt(int socket, int level, int optname,
 			ret = 0;
 			break;
 		case RDMA_ROUTE:
-			if ((rs->optval = calloc(optlen, 1))) {
+			if ((rs->optval = malloc(optlen))) {
 				memcpy(rs->optval, optval, optlen);
 				rs->optlen = optlen;
 				ret = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
