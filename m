From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] librdmacm: Renumber RDMA_PS_IB to match kernel patch
Date: Wed, 15 Jun 2011 17:35:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730212B3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RDMA_PS_IB is only a placeholder and not usable yet.  Update
the assigned value to match that specified for the kernel.

Update rdma_getaddrinfo to use port space hints when formatting
responses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_cma.h |    2 +-
 src/addrinfo.c          |   29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 3648c97..ab6016e 100755
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -68,9 +68,9 @@ enum rdma_cm_event_type {
 
 enum rdma_port_space {
 	RDMA_PS_IPOIB = 0x0002,
-	RDMA_PS_IB    = 0x0003,
 	RDMA_PS_TCP   = 0x0106,
 	RDMA_PS_UDP   = 0x0111,
+	RDMA_PS_IB    = 0x013F,
 };
 
 #define RDMA_IB_IP_PS_MASK   0xFFFFFFFFFFFF0000ULL
diff --git a/src/addrinfo.c b/src/addrinfo.c
index 021f7c4..428baf6 100755
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -69,6 +69,12 @@ static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 	case RDMA_PS_UDP:
 		ai->ai_protocol = IPPROTO_UDP;
 		break;
+	case RDMA_PS_IB:
+		if (ai->ai_socktype == SOCK_STREAM)
+			ai->ai_protocol = IPPROTO_TCP;
+		else if (ai->ai_socktype == SOCK_DGRAM)
+			ai->ai_protocol = IPPROTO_UDP;
+		break;
 	}
 
 	if (rai->ai_flags & RAI_PASSIVE) {
@@ -82,7 +88,8 @@ static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 	ai->ai_next = NULL;
 }
 
-static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai)
+static int ucma_convert_to_rai(struct rdma_addrinfo *rai,
+			       struct rdma_addrinfo *hints, struct addrinfo *ai)
 {
 	struct sockaddr *addr;
 	char *canonname;
@@ -98,13 +105,17 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai)
 		break;
 	}
 
-	switch (ai->ai_protocol) {
-	case IPPROTO_TCP:
-		rai->ai_port_space = RDMA_PS_TCP;
-		break;
-	case IPPROTO_UDP:
-		rai->ai_port_space = RDMA_PS_UDP;
-		break;
+	if (hints && hints->ai_port_space) {
+		rai->ai_port_space = hints->ai_port_space;
+	} else {
+		switch (ai->ai_protocol) {
+		case IPPROTO_TCP:
+			rai->ai_port_space = RDMA_PS_TCP;
+			break;
+		case IPPROTO_UDP:
+			rai->ai_port_space = RDMA_PS_UDP;
+			break;
+		}
 	}
 
 	addr = malloc(ai->ai_addrlen);
@@ -149,7 +160,7 @@ static int ucma_convert_gai(char *node, char *service,
 	if (ret)
 		return ret;
 
-	ret = ucma_convert_to_rai(rai, ai);
+	ret = ucma_convert_to_rai(rai, hints, ai);
 	freeaddrinfo(ai);
 	return ret;
 }


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
