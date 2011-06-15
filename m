From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] librdmacm: Add support for XRC qp types
Date: Wed, 15 Jun 2011 17:36:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730212C8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support XRC send/receive qp types.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/addrinfo.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/src/addrinfo.c b/src/addrinfo.c
index 428baf6..d659d43 100755
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -45,6 +45,14 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
+#ifdef IBV_XRC_OPS
+#define RDMA_QPT_XRC_SEND IBV_QPT_XRC_SEND
+#define RDMA_QPT_XRC_RECV IBV_QPT_XRC_RECV
+#else
+#define RDMA_QPT_XRC_SEND 0
+#define RDMA_QPT_XRC_RECV 0
+#endif
+
 static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 {
 	memset(ai, 0, sizeof *ai);
@@ -54,6 +62,9 @@ static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 
 	switch (rai->ai_qp_type) {
 	case IBV_QPT_RC:
+	case IBV_QPT_UC:
+	case RDMA_QPT_XRC_SEND:
+	case RDMA_QPT_XRC_RECV:
 		ai->ai_socktype = SOCK_STREAM;
 		break;
 	case IBV_QPT_UD:
@@ -96,13 +107,17 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai,
 
 	rai->ai_family = ai->ai_family;
 
-	switch (ai->ai_socktype) {
-	case SOCK_STREAM:
-		rai->ai_qp_type = IBV_QPT_RC;
-		break;
-	case SOCK_DGRAM:
-		rai->ai_qp_type = IBV_QPT_UD;
-		break;
+	if (hints && hints->ai_qp_type) {
+		rai->ai_qp_type = hints->ai_qp_type;
+	} else {
+		switch (ai->ai_socktype) {
+		case SOCK_STREAM:
+			rai->ai_qp_type = IBV_QPT_RC;
+			break;
+		case SOCK_DGRAM:
+			rai->ai_qp_type = IBV_QPT_UD;
+			break;
+		}
 	}
 
 	if (hints && hints->ai_port_space) {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
