From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 4/7] rxe: Do not use _sockaddr in struct rxe_av
Date: Thu,  8 Feb 2018 20:09:01 -0700
Message-ID: <20180209030904.22370-5-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The kernel cannot export this type as a uAPI so don't use it.

Instead pass the union directly to the helper function and refer
to the in6/in members without casting.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/rxe/rxe.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index fcc8cfcb6fe49c..38140ba49c620a 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -761,17 +761,17 @@ static inline int ipv6_addr_v4mapped(const struct in6_addr *a)
 	return IN6_IS_ADDR_V4MAPPED(a);
 }
 
-static inline int rdma_gid2ip(struct sockaddr *out, union ibv_gid *gid)
+typedef typeof(((struct rxe_av *)0)->sgid_addr) sockaddr_union_t;
+
+static inline int rdma_gid2ip(sockaddr_union_t *out, union ibv_gid *gid)
 {
 	if (ipv6_addr_v4mapped((struct in6_addr *)gid)) {
-		struct sockaddr_in *out_in = (struct sockaddr_in *)out;
-		memset(out_in, 0, sizeof(*out_in));
-		memcpy(&out_in->sin_addr.s_addr, gid->raw + 12, 4);
+		memset(&out->_sockaddr_in, 0, sizeof(out->_sockaddr_in));
+		memcpy(&out->_sockaddr_in.sin_addr.s_addr, gid->raw + 12, 4);
 	} else {
-		struct sockaddr_in6 *out_in = (struct sockaddr_in6 *)out;
-		memset(out_in, 0, sizeof(*out_in));
-		out_in->sin6_family = AF_INET6;
-		memcpy(&out_in->sin6_addr.s6_addr, gid->raw, 16);
+		memset(&out->_sockaddr_in6, 0, sizeof(out->_sockaddr_in6));
+		out->_sockaddr_in6.sin6_family = AF_INET6;
+		memcpy(&out->_sockaddr_in6.sin6_addr.s6_addr, gid->raw, 16);
 	}
 	return 0;
 }
@@ -802,8 +802,8 @@ static struct ibv_ah *rxe_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		ipv6_addr_v4mapped((struct in6_addr *)attr->grh.dgid.raw) ?
 		RDMA_NETWORK_IPV4 : RDMA_NETWORK_IPV6;
 
-	rdma_gid2ip(&av->sgid_addr._sockaddr, &sgid);
-	rdma_gid2ip(&av->dgid_addr._sockaddr, &attr->grh.dgid);
+	rdma_gid2ip(&av->sgid_addr, &sgid);
+	rdma_gid2ip(&av->dgid_addr, &attr->grh.dgid);
 
 	memset(&resp, 0, sizeof(resp));
 	if (ibv_cmd_create_ah(pd, &ah->ibv_ah, attr, &resp, sizeof(resp))) {
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
