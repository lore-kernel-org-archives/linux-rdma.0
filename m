From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/core: Avoid unnecessary return value check
Date: Thu,  2 Nov 2017 15:22:27 +0200
Message-ID: <20171102132228.20985-5-leon@kernel.org>
References: <20171102132228.20985-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102132228.20985-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since there is nothing done with non zero return value, such check is
avoided.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/security.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 88bdafb297f5..455cba7f9640 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -692,20 +692,13 @@ void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)
 
 int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index)
 {
-	int ret;
-
 	if (map->agent.qp->qp_type == IB_QPT_SMI && !map->agent.smp_allowed)
 		return -EACCES;
 
-	ret = ib_security_pkey_access(map->agent.device,
-				      map->agent.port_num,
-				      pkey_index,
-				      map->agent.security);
-
-	if (ret)
-		return ret;
-
-	return 0;
+	return ib_security_pkey_access(map->agent.device,
+				       map->agent.port_num,
+				       pkey_index,
+				       map->agent.security);
 }
 
 #endif /* CONFIG_SECURITY_INFINIBAND */
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
