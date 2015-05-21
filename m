From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/3] IB/core: Add const to agent_send_response
Date: Thu, 21 May 2015 16:40:24 -0400
Message-ID: <1432240824-3277-4-git-send-email-ira.weiny@intel.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432240824-3277-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to support constant callers of agent_send_response we add const
specifiers to the its pointer arguments.

Adjust the call tree accordingly.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/addr.c  | 4 ++--
 drivers/infiniband/core/agent.c | 8 ++++----
 drivers/infiniband/core/agent.h | 4 ++--
 drivers/infiniband/core/cache.c | 8 ++++----
 drivers/infiniband/core/verbs.c | 9 +++++----
 include/rdma/ib_addr.h          | 6 +++---
 include/rdma/ib_cache.h         | 8 ++++----
 include/rdma/ib_verbs.h         | 9 +++++----
 8 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 38339d220d7f..746cdf56bc76 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -457,8 +457,8 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
 	complete(&((struct resolve_cb_context *)context)->comp);
 }
 
-int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
-			       u16 *vlan_id)
+int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgid,
+			       u8 *dmac, u16 *vlan_id)
 {
 	int ret = 0;
 	struct rdma_dev_addr dev_addr;
diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index a6fc4d6dc7d7..e51ea76c2523 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -54,7 +54,7 @@ static DEFINE_SPINLOCK(ib_agent_port_list_lock);
 static LIST_HEAD(ib_agent_port_list);
 
 static struct ib_agent_port_private *
-__ib_get_agent_port(struct ib_device *device, int port_num)
+__ib_get_agent_port(const struct ib_device *device, int port_num)
 {
 	struct ib_agent_port_private *entry;
 
@@ -67,7 +67,7 @@ __ib_get_agent_port(struct ib_device *device, int port_num)
 }
 
 static struct ib_agent_port_private *
-ib_get_agent_port(struct ib_device *device, int port_num)
+ib_get_agent_port(const struct ib_device *device, int port_num)
 {
 	struct ib_agent_port_private *entry;
 	unsigned long flags;
@@ -78,8 +78,8 @@ ib_get_agent_port(struct ib_device *device, int port_num)
 	return entry;
 }
 
-void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
-			 struct ib_wc *wc, struct ib_device *device,
+void agent_send_response(const struct ib_mad *mad, const struct ib_grh *grh,
+			 const struct ib_wc *wc, const struct ib_device *device,
 			 int port_num, int qpn)
 {
 	struct ib_agent_port_private *port_priv;
diff --git a/drivers/infiniband/core/agent.h b/drivers/infiniband/core/agent.h
index 6669287009c2..94b5fb5b3eef 100644
--- a/drivers/infiniband/core/agent.h
+++ b/drivers/infiniband/core/agent.h
@@ -44,8 +44,8 @@ extern int ib_agent_port_open(struct ib_device *device, int port_num);
 
 extern int ib_agent_port_close(struct ib_device *device, int port_num);
 
-extern void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
-				struct ib_wc *wc, struct ib_device *device,
+extern void agent_send_response(const struct ib_mad *mad, const struct ib_grh *grh,
+				const struct ib_wc *wc, const struct ib_device *device,
 				int port_num, int qpn);
 
 #endif	/* __AGENT_H_ */
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 08921b34182c..871da832d016 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -85,10 +85,10 @@ int ib_get_cached_gid(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
 
-int ib_find_cached_gid(struct ib_device *device,
-		       union ib_gid	*gid,
-		       u8               *port_num,
-		       u16              *index)
+int ib_find_cached_gid(struct ib_device   *device,
+		       const union ib_gid *gid,
+		       u8                 *port_num,
+		       u16                *index)
 {
 	struct ib_gid_cache *cache;
 	unsigned long flags;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 685a362f6ed6..658c2835a11d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -257,8 +257,9 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(ib_create_ah);
 
-int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
-		       struct ib_grh *grh, struct ib_ah_attr *ah_attr)
+int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
+		       const struct ib_wc *wc, const struct ib_grh *grh,
+		       struct ib_ah_attr *ah_attr)
 {
 	u32 flow_class;
 	u16 gid_index;
@@ -307,8 +308,8 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 }
 EXPORT_SYMBOL(ib_init_ah_from_wc);
 
-struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, struct ib_wc *wc,
-				   struct ib_grh *grh, u8 port_num)
+struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
+				   const struct ib_grh *grh, u8 port_num)
 {
 	struct ib_ah_attr ah_attr;
 	int ret;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ac54c27a2bfd..fde33ac6b58a 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -111,8 +111,8 @@ int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
 int rdma_addr_size(struct sockaddr *addr);
 
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
-int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *smac,
-			       u16 *vlan_id);
+int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgid,
+			       u8 *smac, u16 *vlan_id);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
 {
@@ -160,7 +160,7 @@ static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
 }
 
 /* Important - sockaddr should be a union of sockaddr_in and sockaddr_in6 */
-static inline void rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
+static inline void rdma_gid2ip(struct sockaddr *out, const union ib_gid *gid)
 {
 	if (ipv6_addr_v4mapped((struct in6_addr *)gid)) {
 		struct sockaddr_in *out_in = (struct sockaddr_in *)out;
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index ad9a3c280944..bd92130f4ac5 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -64,10 +64,10 @@ int ib_get_cached_gid(struct ib_device    *device,
  * ib_find_cached_gid() searches for the specified GID value in
  * the local software cache.
  */
-int ib_find_cached_gid(struct ib_device *device,
-		       union ib_gid	*gid,
-		       u8               *port_num,
-		       u16              *index);
+int ib_find_cached_gid(struct ib_device   *device,
+		       const union ib_gid *gid,
+		       u8                 *port_num,
+		       u16                *index);
 
 /**
  * ib_get_cached_pkey - Returns a cached PKey table entry
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 48c9acbea53e..7d78794ed189 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2096,8 +2096,9 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
  * @ah_attr: Returned attributes that can be used when creating an address
  *   handle for replying to the message.
  */
-int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
-		       struct ib_grh *grh, struct ib_ah_attr *ah_attr);
+int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
+		       const struct ib_wc *wc, const struct ib_grh *grh,
+		       struct ib_ah_attr *ah_attr);
 
 /**
  * ib_create_ah_from_wc - Creates an address handle associated with the
@@ -2111,8 +2112,8 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
  * The address handle is used to reference a local or global destination
  * in all UD QP post sends.
  */
-struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, struct ib_wc *wc,
-				   struct ib_grh *grh, u8 port_num);
+struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
+				   const struct ib_grh *grh, u8 port_num);
 
 /**
  * ib_modify_ah - Modifies the address vector associated with an address
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
