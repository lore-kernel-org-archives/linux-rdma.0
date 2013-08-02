From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 3/5] rsockets: Add ability to set the IB route directly
Date: Fri,  2 Aug 2013 15:20:20 -0700
Message-ID: <1375482022-5953-4-git-send-email-sean.hefty@intel.com>
References: <1375482022-5953-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375482022-5953-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add an RDMA specific rsocket option that allows the user
to program the RDMA route directly.  This is useful
for apps that have path record data available, e.g. from
ibacm.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rsocket.h |    3 ++-
 src/rsocket.c          |   30 +++++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/rdma/rsocket.h b/include/rdma/rsocket.h
index f220c13..efd0db5 100644
--- a/include/rdma/rsocket.h
+++ b/include/rdma/rsocket.h
@@ -78,7 +78,8 @@ enum {
 	RDMA_SQSIZE,
 	RDMA_RQSIZE,
 	RDMA_INLINE,
-	RDMA_IOMAPSIZE
+	RDMA_IOMAPSIZE,
+	RDMA_ROUTE
 };
 
 int rsetsockopt(int socket, int level, int optname,
diff --git a/src/rsocket.c b/src/rsocket.c
index e2b1cc7..57df290 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -329,6 +329,8 @@ struct rsocket {
 	long		  fd_flags;
 	uint64_t	  so_opts;
 	uint64_t	  ipv6_opts;
+	void		  *optval;
+	size_t		  optlen;
 	int		  state;
 	int		  cq_armed;
 	int		  retries;
@@ -1243,13 +1245,26 @@ resolve_addr:
 		rs->retries = 0;
 resolve_route:
 		to = 1000 << rs->retries++;
-		ret = rdma_resolve_route(rs->cm_id, to);
-		if (!ret)
-			goto do_connect;
+		if (rs->optval) {
+			ret = rdma_set_option(rs->cm_id,  RDMA_OPTION_IB,
+					      RDMA_OPTION_IB_PATH, rs->optval,
+					      rs->optlen);
+			free(rs->optval);
+			rs->optval = NULL;
+			if (!ret) {
+				rs->state = rs_resolving_route;
+				goto resolving_route;
+			}
+		} else {
+			ret = rdma_resolve_route(rs->cm_id, to);
+			if (!ret)
+				goto do_connect;
+		}
 		if (errno == EAGAIN || errno == EWOULDBLOCK)
 			rs->state = rs_resolving_route;
 		break;
 	case rs_resolving_route:
+resolving_route:
 		ret = ucma_complete(rs->cm_id);
 		if (ret) {
 			if (errno == ETIMEDOUT && rs->retries <= RS_CONN_RETRIES)
@@ -3312,6 +3327,15 @@ int rsetsockopt(int socket, int level, int optname,
 			rs->target_iomap_size = (uint16_t) rs_scale_to_value(
 				(uint8_t) rs_value_to_scale(*(int *) optval, 8), 8);
 			break;
+		case RDMA_ROUTE:
+			if ((rs->optval = calloc(optlen, 1))) {
+				memcpy(rs->optval, optval, optlen);
+				rs->optlen = optlen;
+				ret = 0;
+			} else {
+				ret = ERR(ENOMEM);
+			}
+			break;
 		default:
 			break;
 		}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
