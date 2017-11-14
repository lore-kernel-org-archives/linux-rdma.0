From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 04/31] IB/core: Avoid exporting module internal function
Date: Tue, 14 Nov 2017 14:51:51 +0200
Message-ID: <20171114125218.20477-5-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ib_security_modify_qp and ib_security_pkey_access are core internal
function. So avoid exporting them.
ib_security_pkey_access is used only when secuirty hooks are enabled so
avoid defining it otherwise.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h | 13 -------------
 drivers/infiniband/core/security.c  | 10 ++++------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a1d687a664f8..6c4541af54bb 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -213,11 +213,6 @@ int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u64              *sn_pfx);
 
 #ifdef CONFIG_SECURITY_INFINIBAND
-int ib_security_pkey_access(struct ib_device *dev,
-			    u8 port_num,
-			    u16 pkey_index,
-			    void *sec);
-
 void ib_security_destroy_port_pkey_list(struct ib_device *device);
 
 void ib_security_cache_change(struct ib_device *device,
@@ -240,14 +235,6 @@ int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
 void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent);
 int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index);
 #else
-static inline int ib_security_pkey_access(struct ib_device *dev,
-					  u8 port_num,
-					  u16 pkey_index,
-					  void *sec)
-{
-	return 0;
-}
-
 static inline void ib_security_destroy_port_pkey_list(struct ib_device *device)
 {
 }
diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 23278ed5be45..209d0574fc1f 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -620,12 +620,11 @@ int ib_security_modify_qp(struct ib_qp *qp,
 	}
 	return ret;
 }
-EXPORT_SYMBOL(ib_security_modify_qp);
 
-int ib_security_pkey_access(struct ib_device *dev,
-			    u8 port_num,
-			    u16 pkey_index,
-			    void *sec)
+static int ib_security_pkey_access(struct ib_device *dev,
+				   u8 port_num,
+				   u16 pkey_index,
+				   void *sec)
 {
 	u64 subnet_prefix;
 	u16 pkey;
@@ -642,7 +641,6 @@ int ib_security_pkey_access(struct ib_device *dev,
 
 	return security_ib_pkey_access(sec, subnet_prefix, pkey);
 }
-EXPORT_SYMBOL(ib_security_pkey_access);
 
 static int ib_mad_agent_security_change(struct notifier_block *nb,
 					unsigned long event,
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
