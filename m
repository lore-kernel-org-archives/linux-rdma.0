From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs V4 5/5] Optimize ibv_create_ah link query
Date: Sun, 18 May 2014 12:38:49 +0300
Message-ID: <1400405929-14313-6-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400405929-14313-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since creating AH depends on resolving the MAC address for
Ethernet link layer, ibv_query_port is used.
This verb gives some information that is irrelevant for creating
AH, but in some vendors it forces us to call kernel uverb.
Therefore, we prefer using the extended verb and query only the
relevant fields and by thus give the vendor more chance to optimizations.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/verbs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 6db79e8..e022cd8 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -552,7 +552,7 @@ struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	int err;
 	struct ibv_ah *ah = NULL;
 #ifndef NRESOLVE_NEIGH
-	struct ibv_port_attr port_attr;
+	struct ibv_port_attr_ex port_attr;
 	int dst_family;
 	int src_family;
 	int oif;
@@ -572,7 +572,9 @@ struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		goto return_ah;
 	}
 
-	err = ibv_query_port(pd->context, attr->port_num, &port_attr);
+	port_attr.comp_mask = IBV_QUERY_PORT_EX_LINK_LAYER |
+			      IBV_QUERY_PORT_EX_CAP_FLAGS;
+	err = ibv_query_port_ex(pd->context, attr->port_num, &port_attr);
 
 	if (err) {
 		fprintf(stderr, PFX "ibv_create_ah failed to query port.\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
