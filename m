From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/16] librdmacm: Delay ACM connection until resolving an
 address
Date: Wed, 30 May 2012 17:21:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24BEF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid creating a connection to the ACM service when
it's not needed.  For example, if the user of the librdmacm
is a server application, it will not use ACM services.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   22 +++++++++++++---------
 src/cma.c |    2 --
 src/cma.h |    2 --
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 9c65919..5bdeb88 100755
--- a/src/acm.c
+++ b/src/acm.c
@@ -89,26 +89,30 @@ static void ucma_set_server_port(void)
 void ucma_ib_init(void)
 {
 	struct sockaddr_in addr;
+	static int init;
 	int ret;
 
+	if (init)
+		return;
+
+	pthread_mutex_lock(&acm_lock);
 	ucma_set_server_port();
 	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 	if (sock < 0)
-		return;
+		goto out;
 
 	memset(&addr, 0, sizeof addr);
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
 	addr.sin_port = htons(server_port);
 	ret = connect(sock, (struct sockaddr *) &addr, sizeof(addr));
-	if (ret)
-		goto err;
-
-	return;
-
-err:
-	close(sock);
-	sock = -1;
+	if (ret) {
+		close(sock);
+		sock = -1;
+	}
+out:
+	init = 1;
+	pthread_mutex_unlock(&acm_lock);
 }
 
 void ucma_ib_cleanup(void)
diff --git a/src/cma.c b/src/cma.c
index 9cd34cf..2121d06 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -272,8 +272,6 @@ int ucma_init(void)
 		ib += (cma_dev->verbs->device->transport_type == IBV_TRANSPORT_IB);
 	}
 
-	if (ib)
-		ucma_ib_init();
 	cma_dev_cnt = dev_cnt;
 	ucma_set_af_ib_support();
 	pthread_mutex_unlock(&mut);
diff --git a/src/cma.h b/src/cma.h
index 7703fe8..0d94e8b 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -117,11 +117,9 @@ extern int af_ib_support;
 #define RAI_ROUTEONLY		0x01000000
 
 #ifdef USE_IB_ACM
-void ucma_ib_init();
 void ucma_ib_cleanup();
 void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints);
 #else
-#define ucma_ib_init()
 #define ucma_ib_cleanup()
 #define ucma_ib_resolve(x, y)
 #endif


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
