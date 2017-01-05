From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/cma: Allow port reuse for rdma_id
Date: Thu,  5 Jan 2017 16:16:36 +0200
Message-ID: <20170105141636.23284-2-leon@kernel.org>
References: <20170105141636.23284-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105141636.23284-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When allocating a port number for binding to a rdma_id, assuming the
allocation is not for a specific port, the rule is to allow only ports
that were not in use before by any other rdma_id.

This condition is too strong to achieve the goal of a unique 5 tuple
rdma_id. Instead, we can compare current rdma_id with other rdma_id for
difference in one of destination port, source address and destination
address to allow port reuse.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 67 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 847c5ad..bd8d051 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2843,20 +2843,26 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	int ret;

 	id_priv = container_of(id, struct rdma_id_private, id);
+	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (id_priv->state == RDMA_CM_IDLE) {
 		ret = cma_bind_addr(id, src_addr, dst_addr);
-		if (ret)
+		if (ret) {
+			memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 			return ret;
+		}
 	}

-	if (cma_family(id_priv) != dst_addr->sa_family)
+	if (cma_family(id_priv) != dst_addr->sa_family) {
+		memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 		return -EINVAL;
+	}

-	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY)) {
+		memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 		return -EINVAL;
+	}

 	atomic_inc(&id_priv->refcount);
-	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (cma_any_addr(dst_addr)) {
 		ret = cma_resolve_loopback(id_priv);
 	} else {
@@ -2972,6 +2978,43 @@ static int cma_alloc_port(enum rdma_port_space ps,
 	return ret == -ENOSPC ? -EADDRNOTAVAIL : ret;
 }

+static int cma_port_is_unique(struct rdma_bind_list *bind_list,
+			      struct rdma_id_private *id_priv)
+{
+	struct rdma_id_private *cur_id;
+	struct sockaddr  *daddr = cma_dst_addr(id_priv);
+	struct sockaddr  *saddr = cma_src_addr(id_priv);
+	__be16 dport = cma_port(daddr);
+
+	hlist_for_each_entry(cur_id, &bind_list->owners, node) {
+		struct sockaddr  *cur_daddr = cma_dst_addr(cur_id);
+		struct sockaddr  *cur_saddr = cma_src_addr(cur_id);
+		__be16 cur_dport = cma_port(cur_daddr);
+
+		if (id_priv == cur_id)
+			continue;
+
+		/* different dest port -> unique */
+		if (!cma_any_port(cur_daddr) &&
+		    (dport != cur_dport))
+			continue;
+
+		/* different src address -> unique */
+		if (!cma_any_addr(saddr) &&
+		    !cma_any_addr(cur_saddr) &&
+		    cma_addr_cmp(saddr, cur_saddr))
+			continue;
+
+		/* different dst address -> unique */
+		if (!cma_any_addr(cur_daddr) &&
+		    cma_addr_cmp(daddr, cur_daddr))
+			continue;
+
+		return -EADDRNOTAVAIL;
+	}
+	return 0;
+}
+
 static int cma_alloc_any_port(enum rdma_port_space ps,
 			      struct rdma_id_private *id_priv)
 {
@@ -2984,9 +3027,19 @@ static int cma_alloc_any_port(enum rdma_port_space ps,
 	remaining = (high - low) + 1;
 	rover = prandom_u32() % remaining + low;
 retry:
-	if (last_used_port != rover &&
-	    !cma_ps_find(net, ps, (unsigned short)rover)) {
-		int ret = cma_alloc_port(ps, id_priv, rover);
+	if (last_used_port != rover) {
+		struct rdma_bind_list *bind_list;
+		int ret;
+
+		bind_list = cma_ps_find(net, ps, (unsigned short)rover);
+
+		if (!bind_list) {
+			ret = cma_alloc_port(ps, id_priv, rover);
+		} else {
+			ret = cma_port_is_unique(bind_list, id_priv);
+			if (!ret)
+				cma_bind_port(bind_list, id_priv);
+		}
 		/*
 		 * Remember previously used port number in order to avoid
 		 * re-using same port immediately after it is closed.
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
