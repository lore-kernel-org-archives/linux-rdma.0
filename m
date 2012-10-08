From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [librdmacm] librdmacm: Disable ACM support if ibacm.port is
 not found
Date: Mon, 8 Oct 2012 17:47:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AA3A96@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The librdmacm will try to connect port 6125 if ibacm.port is
not found.  The problem is that some other service or application
could be using that port and respond with garbage.  Rather
than falling back to a hard coded port number, if ibacm.port
is not found, simply disable ACM support.

This has the effect of removing support for older versions
of ibacm, unless the port file is created manually.

Patch created based on feedback from Doug Ledford and Florian
Weimer from RedHat.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 3d8c912..c9ca5b5 100755
--- a/src/acm.c
+++ b/src/acm.c
@@ -62,7 +62,7 @@ typedef struct acm_msg cma_acm_msg_t;
 
 static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
 static int sock = -1;
-static short server_port = 6125;
+static short server_port;
 
 struct ib_connect_hdr {
 	uint8_t  cma_version;
@@ -76,7 +76,7 @@ struct ib_connect_hdr {
 #define cma_dst_ip6 dst_addr[0]
 };
 
-static void ucma_set_server_port(void)
+static int ucma_set_server_port(void)
 {
 	FILE *f;
 
@@ -84,6 +84,7 @@ static void ucma_set_server_port(void)
 		fscanf(f, "%hu", (unsigned short *) &server_port);
 		fclose(f);
 	}
+	return server_port;
 }
 
 void ucma_ib_init(void)
@@ -96,7 +97,9 @@ void ucma_ib_init(void)
 		return;
 
 	pthread_mutex_lock(&acm_lock);
-	ucma_set_server_port();
+	if (!ucma_set_server_port())
+		goto out;
+
 	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 	if (sock < 0)
 		goto out;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
