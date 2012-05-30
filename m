From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/16] librdmacm/rsockets: Allow user to specify the QP sizes
Date: Wed, 30 May 2012 17:21:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24C09@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add setsockopt options that allow the user to specify the desired
size of the underlying QP.  The provided sizes are used as the
maximum size when creating the QP.  The actual sizes of the QP
are the smaller of the user provided maximum and the maximum
sizes supported by the underlying hardware.

A user may retrieve the actual sizes of the QP through the
getsockopt call.

The send and receive queue sizes are specified separately.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rsocket.h |    4 ++++
 src/cma.h              |    1 +
 src/rsocket.c          |   38 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/rdma/rsocket.h b/include/rdma/rsocket.h
index 87ee943..9fd9929 100644
--- a/include/rdma/rsocket.h
+++ b/include/rdma/rsocket.h
@@ -73,6 +73,10 @@ int rgetpeername(int socket, struct sockaddr *addr, socklen_t *addrlen);
 int rgetsockname(int socket, struct sockaddr *addr, socklen_t *addrlen);
 
 #define SOL_RDMA 0x10000
+enum {
+	RDMA_SQSIZE,
+	RDMA_RQSIZE
+};
 
 int rsetsockopt(int socket, int level, int optname,
 		const void *optval, socklen_t optlen);
diff --git a/src/cma.h b/src/cma.h
index ffbcbf2..2ee4767 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -67,6 +67,7 @@ static inline uint64_t htonll(uint64_t x) { return x; }
 static inline uint64_t ntohll(uint64_t x) { return x; }
 #endif
 
+#define max(a, b) ((a) > (b) ? a : b)
 #define min(a, b) ((a) < (b) ? a : b)
 
 /*
diff --git a/src/rsocket.c b/src/rsocket.c
index ee31e0c..f94e48a 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -265,8 +265,15 @@ static void rs_set_qp_size(struct rsocket *rs)
 
 	if (rs->sq_size > max_size)
 		rs->sq_size = max_size;
+	else if (rs->sq_size < 2)
+		rs->sq_size = 2;
+	if (rs->sq_size <= (RS_QP_CTRL_SIZE << 2))
+		rs->ctrl_avail = 1;
+
 	if (rs->rq_size > max_size)
 		rs->rq_size = max_size;
+	else if (rs->rq_size < 2)
+		rs->rq_size = 2;
 }
 
 static int rs_init_bufs(struct rsocket *rs)
@@ -1711,12 +1718,27 @@ int rsetsockopt(int socket, int level, int optname,
 		}
 		break;
 	case SOL_RDMA:
+		if (rs->state > rs_listening) {
+			ret = ERR(EINVAL);
+			break;
+		}
+
+		switch (optname) {
+		case RDMA_SQSIZE:
+			rs->sq_size = min((*(uint32_t *) optval), RS_QP_MAX_SIZE);
+			break;
+		case RDMA_RQSIZE:
+			rs->rq_size = min((*(uint32_t *) optval), RS_QP_MAX_SIZE);
+			break;
+		default:
+			break;
+		}
 		break;
 	default:
 		break;
 	}
 
-	if (!ret) {
+	if (!ret && opts) {
 		if (opt_on)
 			*opts |= (1 << optname);
 		else
@@ -1778,7 +1800,19 @@ int rgetsockopt(int socket, int level, int optname,
 		}
 		break;
 	case SOL_RDMA:
-		ret = ENOTSUP;
+		switch (optname) {
+		case RDMA_SQSIZE:
+			*((int *) optval) = rs->sq_size;
+			*optlen = sizeof(int);
+			break;
+		case RDMA_RQSIZE:
+			*((int *) optval) = rs->rq_size;
+			*optlen = sizeof(int);
+			break;
+		default:
+			ret = ENOTSUP;
+			break;
+		}
 		break;
 	default:
 		ret = ENOTSUP;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
