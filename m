From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibacm/libacm.c: Use IPv4 rather than IPv6 for ACM server
 communication
Date: Thu, 05 Apr 2012 16:05:24 -0400
Message-ID: <4F7DFB04.2030803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When both IPv4 and IPv6 are running, getaddrinfo indicates IPv6
rather than IPv4 and that currently causes a failure to connect to
the ACM server. Fix is to set the address family in the hint to
getaddrinfo to IPv4.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/libacm.c b/src/libacm.c
index 727741f..5ca1abc 100644
--- a/src/libacm.c
+++ b/src/libacm.c
@@ -75,6 +75,7 @@ int ib_acm_connect(char *dest)
 
 	acm_set_server_port();
 	memset(&hint, 0, sizeof hint);
+	hint.ai_family = AF_INET;
 	hint.ai_protocol = IPPROTO_TCP;
 	ret = getaddrinfo(dest, NULL, &hint, &res);
 	if (ret)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
