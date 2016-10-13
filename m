From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 13/32] librdmacm: mark symbols static where possible
Date: Thu, 13 Oct 2016 19:51:16 +0200
Message-ID: <1476381095-20041-14-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 librdmacm/addrinfo.c              |  2 +-
 librdmacm/examples/rcopy.c        |  4 ++--
 librdmacm/examples/rdma_client.c  | 10 +++++-----
 librdmacm/examples/rdma_server.c  | 10 +++++-----
 librdmacm/examples/rdma_xclient.c | 10 +++++-----
 librdmacm/examples/rdma_xserver.c | 10 +++++-----
 librdmacm/rsocket.c               |  2 +-
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/librdmacm/addrinfo.c b/librdmacm/addrinfo.c
index 2f4e674..2c515a2 100644
--- a/librdmacm/addrinfo.c
+++ b/librdmacm/addrinfo.c
@@ -43,7 +43,7 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
-struct rdma_addrinfo nohints;
+static struct rdma_addrinfo nohints;
 
 static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 {
diff --git a/librdmacm/examples/rcopy.c b/librdmacm/examples/rcopy.c
index 085b017..38f6929 100644
--- a/librdmacm/examples/rcopy.c
+++ b/librdmacm/examples/rcopy.c
@@ -59,8 +59,8 @@ static char *src_file;
 static struct timeval start, end;
 //static void buf[1024 * 1024];
 static uint64_t bytes;
-int fd;
-void *file_addr;
+static int fd;
+static void *file_addr;
 
 enum {
 	CMD_NOOP,
diff --git a/librdmacm/examples/rdma_client.c b/librdmacm/examples/rdma_client.c
index d7f65f5..fd7bbc2 100644
--- a/librdmacm/examples/rdma_client.c
+++ b/librdmacm/examples/rdma_client.c
@@ -39,11 +39,11 @@
 static char *server = "127.0.0.1";
 static char *port = "7471";
 
-struct rdma_cm_id *id;
-struct ibv_mr *mr, *send_mr;
-int send_flags;
-uint8_t send_msg[16];
-uint8_t recv_msg[16];
+static struct rdma_cm_id *id;
+static struct ibv_mr *mr, *send_mr;
+static int send_flags;
+static uint8_t send_msg[16];
+static uint8_t recv_msg[16];
 
 static int run(void)
 {
diff --git a/librdmacm/examples/rdma_server.c b/librdmacm/examples/rdma_server.c
index d98d11a..3c7c15e 100644
--- a/librdmacm/examples/rdma_server.c
+++ b/librdmacm/examples/rdma_server.c
@@ -38,11 +38,11 @@
 
 static char *port = "7471";
 
-struct rdma_cm_id *listen_id, *id;
-struct ibv_mr *mr, *send_mr;
-int send_flags;
-uint8_t send_msg[16];
-uint8_t recv_msg[16];
+static struct rdma_cm_id *listen_id, *id;
+static struct ibv_mr *mr, *send_mr;
+static int send_flags;
+static uint8_t send_msg[16];
+static uint8_t recv_msg[16];
 
 static int run(void)
 {
diff --git a/librdmacm/examples/rdma_xclient.c b/librdmacm/examples/rdma_xclient.c
index 8dba266..d86fee1 100644
--- a/librdmacm/examples/rdma_xclient.c
+++ b/librdmacm/examples/rdma_xclient.c
@@ -40,12 +40,12 @@
 static char *server = "127.0.0.1";
 static char port[6] = "7471";
 
-struct rdma_cm_id *id;
-struct ibv_mr *mr;
-struct rdma_addrinfo hints;
+static struct rdma_cm_id *id;
+static struct ibv_mr *mr;
+static struct rdma_addrinfo hints;
 
-uint8_t send_msg[16];
-uint32_t srqn;
+static uint8_t send_msg[16];
+static uint32_t srqn;
 
 static int post_send(void)
 {
diff --git a/librdmacm/examples/rdma_xserver.c b/librdmacm/examples/rdma_xserver.c
index 69f170b..f838e7d 100644
--- a/librdmacm/examples/rdma_xserver.c
+++ b/librdmacm/examples/rdma_xserver.c
@@ -40,12 +40,12 @@
 
 static char *port = "7471";
 
-struct rdma_cm_id *listen_id, *id;
-struct ibv_mr *mr;
-struct rdma_addrinfo hints;
+static struct rdma_cm_id *listen_id, *id;
+static struct ibv_mr *mr;
+static struct rdma_addrinfo hints;
 
-uint8_t recv_msg[16];
-uint32_t srqn;
+static uint8_t recv_msg[16];
+static uint32_t srqn;
 
 static int create_srq(void)
 {
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 7e7a38e..e0755dd 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -505,7 +505,7 @@ static int rs_scale_to_value(int value, int bits)
 		(void) rc;                                                     \
 	}
 
-void rs_configure(void)
+static void rs_configure(void)
 {
 	FILE *f;
 	static int init;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
