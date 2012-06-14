From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm/rsocket: Support IPV6_V6ONLY socket option
Date: Thu, 14 Jun 2012 20:31:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A31781@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Patch is dependent on proposed kernel changes.

 include/rdma/rdma_cma.h |    1 +
 src/rsocket.c           |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index c0f83b1..1487f8f 100755
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -650,6 +650,7 @@ enum {
 enum {
 	RDMA_OPTION_ID_TOS	 = 0,	/* uint8_t: RFC 2474 */
 	RDMA_OPTION_ID_REUSEADDR = 1,   /* int: ~SO_REUSEADDR */
+	RDMA_OPTION_ID_AFONLY	 = 2,   /* int: ~IPV6_V6ONLY */
 	RDMA_OPTION_IB_PATH	 = 1	/* struct ibv_path_data[] */
 };
 
diff --git a/src/rsocket.c b/src/rsocket.c
index a3c2c6a..860c63e 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -161,6 +161,7 @@ struct rsocket {
 	long		  fd_flags;
 	uint64_t	  so_opts;
 	uint64_t	  tcp_opts;
+	uint64_t	  ipv6_opts;
 	enum rs_state	  state;
 	int		  cq_armed;
 	int		  retries;
@@ -1817,6 +1818,18 @@ int rsetsockopt(int socket, int level, int optname,
 			break;
 		}
 		break;
+	case IPPROTO_IPV6:
+		opts = &rs->ipv6_opts;
+		switch (optname) {
+		case IPV6_V6ONLY:
+			ret = rdma_set_option(rs->cm_id, RDMA_OPTION_ID,
+					      RDMA_OPTION_ID_AFONLY,
+					      (void *) optval, optlen);
+			opt_on = *(int *) optval;
+			break;
+		default:
+			break;
+		}
 	case SOL_RDMA:
 		if (rs->state > rs_listening) {
 			ret = ERR(EINVAL);
@@ -1910,6 +1923,16 @@ int rgetsockopt(int socket, int level, int optname,
 			break;
 		}
 		break;
+	case IPPROTO_IPV6:
+		switch (optname) {
+		case IPV6_V6ONLY:
+			*((int *) optval) = !!(rs->ipv6_opts & (1 << optname));
+			*optlen = sizeof(int);
+			break;
+		default:
+			ret = ENOTSUP;
+			break;
+		}
 	case SOL_RDMA:
 		switch (optname) {
 		case RDMA_SQSIZE:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
