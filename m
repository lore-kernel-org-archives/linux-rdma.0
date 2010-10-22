From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: cma: fix debug build issue
Date: Fri, 22 Oct 2010 13:17:37 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BA209EE@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 9338d55..1eb7aed 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -105,7 +105,6 @@ static void dapli_route_resolve(struct dapl_cm_id *conn)
 	int ret;
 #ifdef DAPL_DBG
 	struct rdma_addr *ipaddr = &conn->cm_id->route.addr;
-	struct ib_addr *ibaddr = &conn->cm_id->route.addr.addr.ibaddr;
 #endif
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
@@ -120,16 +119,16 @@ static void dapli_route_resolve(struct dapl_cm_id *conn)
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " route_resolve: SRC GID subnet %016llx id %016llx\n",
 		     (unsigned long long)
-		     ntohll(ibaddr->sgid.global.subnet_prefix),
+		     ntohll(ipaddr->addr.ibaddr.sgid.global.subnet_prefix),
 		     (unsigned long long)
-		     ntohll(ibaddr->sgid.global.interface_id));
+		     ntohll(ipaddr->addr.ibaddr.sgid.global.interface_id));
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " route_resolve: DST GID subnet %016llx id %016llx\n",
 		     (unsigned long long)
-		     ntohll(ibaddr->dgid.global.subnet_prefix),
+		     ntohll(ipaddr->addr.ibaddr.dgid.global.subnet_prefix),
 		     (unsigned long long)
-		     ntohll(ibaddr->dgid.global.interface_id));
+		     ntohll(ipaddr->addr.ibaddr.dgid.global.interface_id));
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " route_resolve: cm_id %p pdata %p plen %d rr %d ind %d\n",
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
