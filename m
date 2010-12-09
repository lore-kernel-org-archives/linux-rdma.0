From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: support non-default ACM port number
Date: Wed, 8 Dec 2010 17:56:43 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1F13F@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

By default, ACM uses port 6125.  The actual port number
used is now published in /var/run/ibacm.port.  Attempt to
obtain the correct port number from here, and if that fails
revert to using the default port number of 6125.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 src/acm.c

diff --git a/src/acm.c b/src/acm.c
old mode 100644
new mode 100755
index 1867362..e2d02b4
--- a/src/acm.c
+++ b/src/acm.c
@@ -34,6 +34,7 @@
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
 
+#include <stdio.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netdb.h>
@@ -63,11 +64,22 @@ struct ib_connect_hdr {
 #define cma_dst_ip6 dst_addr[0]
 };
 
+static void ucma_set_server_port(void)
+{
+	FILE *f;
+
+	if ((f = fopen("/var/run/ibacm.port", "r"))) {
+		fscanf(f, "%hu", (unsigned short *) &server_port);
+		fclose(f);
+	}
+}
+
 void ucma_ib_init(void)
 {
 	struct sockaddr_in addr;
 	int ret;
 
+	ucma_set_server_port();
 	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 	if (sock < 0)
 		return;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
