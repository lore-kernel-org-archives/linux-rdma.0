From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] librdmacm: Use union with sockaddr structures
Date: Wed, 15 Jun 2011 17:45:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021311@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To avoid strict aliasing compiler warnings, use an unamed union
to store the src and dst addresses.  This eliminates the need
for padding and sockaddr casts.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This isn't related to XRC support; I just got tired of seeing a
bunch of warnings when compiling.  This removed most of the
warnings.

 examples/cmatose.c      |   12 ++++++------
 include/rdma/rdma_cma.h |   26 ++++++++++++++++----------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/examples/cmatose.c b/examples/cmatose.c
index 84831ec..82e0d7c 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -541,13 +541,13 @@ static int run_server(void)
 		if (ret)
 			goto out;
 		if (test.addr.src_addr.sa_family == AF_INET)
-			((struct sockaddr_in *) &test.addr.src_addr)->sin_port = port;
+			test.addr.src_sin.sin_port = port;
 		else
-			((struct sockaddr_in6 *) &test.addr.src_addr)->sin6_port = port;
+			test.addr.src_sin6.sin6_port = port;
 		
 	} else {
-		test.addr.src_addr.sa_family = PF_INET;
-		((struct sockaddr_in *) &test.addr.src_addr)->sin_port = port;
+		test.addr.src_addr.sa_family = AF_INET;
+		test.addr.src_sin.sin_port = port;
 	}
 
 	ret = rdma_bind_addr(listen_id, &test.addr.src_addr);
@@ -628,9 +628,9 @@ static int run_client(void)
 		return ret;
 
 	if (test.addr.dst_addr.sa_family == AF_INET)
-		((struct sockaddr_in *) &test.addr.dst_addr)->sin_port = port;
+		test.addr.dst_sin.sin_port = port;
 	else
-		((struct sockaddr_in6 *) &test.addr.dst_addr)->sin6_port = port;
+		test.addr.dst_sin6.sin6_port = port;
 
 	printf("cmatose: connecting\n");
 	for (i = 0; i < connections; i++) {
diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 3b40060..c0f83b1 100755
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -91,12 +91,18 @@ struct rdma_ib_addr {
 };
 
 struct rdma_addr {
-	struct sockaddr		src_addr;
-	uint8_t			src_pad[sizeof(struct sockaddr_storage) -
-					sizeof(struct sockaddr)];
-	struct sockaddr		dst_addr;
-	uint8_t			dst_pad[sizeof(struct sockaddr_storage) -
-					sizeof(struct sockaddr)];
+	union {
+		struct sockaddr		src_addr;
+		struct sockaddr_in	src_sin;
+		struct sockaddr_in6	src_sin6;
+		struct sockaddr_storage src_storage;
+	};
+	union {
+		struct sockaddr		dst_addr;
+		struct sockaddr_in	dst_sin;
+		struct sockaddr_in6	dst_sin6;
+		struct sockaddr_storage dst_storage;
+	};
 	union {
 		struct rdma_ib_addr	ibaddr;
 	} addr;
@@ -578,15 +584,15 @@ int rdma_ack_cm_event(struct rdma_cm_event *event);
 static inline uint16_t rdma_get_src_port(struct rdma_cm_id *id)
 {
 	return	id->route.addr.src_addr.sa_family == PF_INET6 ?
-		((struct sockaddr_in6 *) &id->route.addr.src_addr)->sin6_port :
-		((struct sockaddr_in *) &id->route.addr.src_addr)->sin_port;
+		id->route.addr.src_sin6.sin6_port :
+		id->route.addr.src_sin.sin_port;
 }
 
 static inline uint16_t rdma_get_dst_port(struct rdma_cm_id *id)
 {
 	return	id->route.addr.dst_addr.sa_family == PF_INET6 ?
-		((struct sockaddr_in6 *) &id->route.addr.dst_addr)->sin6_port :
-		((struct sockaddr_in *) &id->route.addr.dst_addr)->sin_port;
+		id->route.addr.dst_sin6.sin6_port :
+		id->route.addr.dst_sin.sin_port;
 }
 
 static inline struct sockaddr *rdma_get_local_addr(struct rdma_cm_id *id)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
