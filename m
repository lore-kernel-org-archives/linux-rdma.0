From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/16] librdmacm/acm: Use -1 to indicate an invalid socket
 rather than 0
Date: Wed, 30 May 2012 17:21:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24BF3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

socket() can return 0 as a valid socket.  This can happen
when using a daemon that closes stdin/out/err.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index bcf11da..9c65919 100755
--- a/src/acm.c
+++ b/src/acm.c
@@ -61,7 +61,7 @@ typedef struct acm_msg cma_acm_msg_t;
 #endif
 
 static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
-static int sock;
+static int sock = -1;
 static short server_port = 6125;
 
 struct ib_connect_hdr {
@@ -108,12 +108,12 @@ void ucma_ib_init(void)
 
 err:
 	close(sock);
-	sock = 0;
+	sock = -1;
 }
 
 void ucma_ib_cleanup(void)
 {
-	if (sock > 0) {
+	if (sock >= 0) {
 		shutdown(sock, SHUT_RDWR);
 		close(sock);
 	}
@@ -322,7 +322,7 @@ void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints)
 	struct acm_ep_addr_data *data;
 	int ret;
 
-	if (sock <= 0)
+	if (sock < 0)
 		return;
 
 	memset(&msg, 0, sizeof msg);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
