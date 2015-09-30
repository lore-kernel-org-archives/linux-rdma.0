From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] rstream.c: Use proper define for ai_flags before
 getaddrinfo call in client_connect
Date: Wed, 30 Sep 2015 09:03:08 -0400
Message-ID: <560BDD8C.1070803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


even though both have same value

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/rstream.c b/examples/rstream.c
index d93e9aa..ba5e449 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -421,7 +421,7 @@ static int client_connect(void)
 			rai_hints.ai_flags |= RAI_PASSIVE;
 			ret = rdma_getaddrinfo(src_addr, port, &rai_hints, &rai_src);
 		} else {
-			ai_hints.ai_flags |= RAI_PASSIVE;
+			ai_hints.ai_flags |= AI_PASSIVE;
 			ret = getaddrinfo(src_addr, port, &ai_hints, &ai_src);
 		}
 		if (ret) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
