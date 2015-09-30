From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] examples/r[io]stream.c: Better handling of rpoll
 errors during client async rconnect
Date: Wed, 30 Sep 2015 09:06:06 -0400
Message-ID: <560BDE3E.9070806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Rather than silently exiting when connection is refused by server,
print error message (Connection refused) during async rconnect at client.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/riostream.c b/examples/riostream.c
index c12dd0d..b6c9f86 100644
--- a/examples/riostream.c
+++ b/examples/riostream.c
@@ -470,8 +470,10 @@ static int client_connect(void)
 		fds.fd = rs;
 		fds.events = POLLOUT;
 		ret = do_poll(&fds, poll_timeout);
-		if (ret)
+		if (ret) {
+			perror("rpoll");
 			goto close;
+		}
 
 		len = sizeof err;
 		ret = rgetsockopt(rs, SOL_SOCKET, SO_ERROR, &err, &len);
diff --git a/examples/rstream.c b/examples/rstream.c
index d93e9aa..4b76bbc 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -469,8 +469,10 @@ static int client_connect(void)
 		fds.fd = rs;
 		fds.events = POLLOUT;
 		ret = do_poll(&fds, poll_timeout);
-		if (ret)
+		if (ret) {
+			perror("rpoll");
 			goto close;
+		}
 
 		len = sizeof err;
 		ret = rs_getsockopt(rs, SOL_SOCKET, SO_ERROR, &err, &len);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
