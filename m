From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/9 v3] ib/addr: fix ipv6 routing lookup
Date: Thu, 19 Nov 2009 08:46:26 -0800
Message-ID: <3A9CA5981C45449C9F6DABBFA97C6090@amr.corp.intel.com>
References: <2449CF17D7E94FCBA643A743473246A5@amr.corp.intel.com> <B596269C5991406FA7EA473D383667F8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B596269C5991406FA7EA473D383667F8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Include link scope as part of address resolution.  Combine local
and remote address resolution into a single, simpler code path.
Fix error checking in the IPv6 routing lookups.

Based on work from:
David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
change from v2:
modified lines are the same, only updated because of changes to patch 5 in series

change from v1:
update from 2.6.31 to 2.6.32-rc7
remove end of line white space

 drivers/infiniband/core/addr.c |  144 +++++++++++-----------------------------
 drivers/infiniband/core/cma.c  |   45 +++++++++----
 2 files changed, 72 insertions(+), 117 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 38a7184..abbb069 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -176,34 +176,6 @@ static void queue_req(struct addr_req *req)
 	mutex_unlock(&lock);
 }
 
-static void addr_send_arp(struct sockaddr *dst_in)
-{
-	struct rtable *rt;
-	struct flowi fl;
-
-	memset(&fl, 0, sizeof fl);
-
-	switch (dst_in->sa_family) {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	case AF_INET6:
-	{
-		struct dst_entry *dst;
-
-		fl.nl_u.ip6_u.daddr =
-			((struct sockaddr_in6 *) dst_in)->sin6_addr;
-
-		dst = ip6_route_output(&init_net, NULL, &fl);
-		if (!dst)
-			return;
-
-		neigh_event_send(dst->neighbour, NULL);
-		dst_release(dst);
-		break;
-	}
-#endif
-	}
-}
-
 static int addr4_resolve(struct sockaddr_in *src_in,
 			 struct sockaddr_in *dst_in,
 			 struct rdma_dev_addr *addr)
@@ -259,39 +231,63 @@ out:
 }
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
-			       struct sockaddr_in6 *dst_in,
-			       struct rdma_dev_addr *addr)
+static int addr6_resolve(struct sockaddr_in6 *src_in,
+			 struct sockaddr_in6 *dst_in,
+			 struct rdma_dev_addr *addr)
 {
 	struct flowi fl;
 	struct neighbour *neigh;
 	struct dst_entry *dst;
-	int ret = -ENODATA;
+	int ret;
 
 	memset(&fl, 0, sizeof fl);
-	fl.nl_u.ip6_u.daddr = dst_in->sin6_addr;
-	fl.nl_u.ip6_u.saddr = src_in->sin6_addr;
+	ipv6_addr_copy(&fl.fl6_dst, &dst_in->sin6_addr);
+	ipv6_addr_copy(&fl.fl6_src, &src_in->sin6_addr);
 	fl.oif = addr->bound_dev_if;
 
 	dst = ip6_route_output(&init_net, NULL, &fl);
-	if (!dst)
-		return ret;
+	if ((ret = dst->error))
+		goto put;
+
+	if (ipv6_addr_any(&fl.fl6_src)) {
+		ret = ipv6_dev_get_saddr(&init_net, ip6_dst_idev(dst)->dev,
+					 &fl.fl6_dst, 0, &fl.fl6_src);
+		if (ret)
+			goto put;
 
+		src_in->sin6_family = AF_INET6;
+		ipv6_addr_copy(&src_in->sin6_addr, &fl.fl6_src);
+	}
+
+	if (dst->dev->flags & IFF_LOOPBACK) {
+		ret = rdma_translate_ip((struct sockaddr *) dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr, MAX_ADDR_LEN);
+		goto put;
+	}
+
+	/* If the device does ARP internally, return 'done' */
 	if (dst->dev->flags & IFF_NOARP) {
 		ret = rdma_copy_addr(addr, dst->dev, NULL);
-	} else {
-		neigh = dst->neighbour;
-		if (neigh && (neigh->nud_state & NUD_VALID))
-			ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
+		goto put;
 	}
 
+	neigh = dst->neighbour;
+	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
+		neigh_event_send(dst->neighbour, NULL);
+		ret = -ENODATA;
+		goto put;
+	}
+
+	ret = rdma_copy_addr(addr, dst->dev, neigh->ha);
+put:
 	dst_release(dst);
 	return ret;
 }
 #else
-static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
-			       struct sockaddr_in6 *dst_in,
-			       struct rdma_dev_addr *addr)
+static int addr6_resolve(struct sockaddr_in6 *src_in,
+			 struct sockaddr_in6 *dst_in,
+			 struct rdma_dev_addr *addr)
 {
 	return -EADDRNOTAVAIL;
 }
@@ -305,7 +301,7 @@ static int addr_resolve(struct sockaddr *src_in,
 		return addr4_resolve((struct sockaddr_in *) src_in,
 			(struct sockaddr_in *) dst_in, addr);
 	} else
-		return addr6_resolve_remote((struct sockaddr_in6 *) src_in,
+		return addr6_resolve((struct sockaddr_in6 *) src_in,
 			(struct sockaddr_in6 *) dst_in, addr);
 }
 
@@ -346,60 +342,6 @@ static void process_req(struct work_struct *work)
 	}
 }
 
-static int addr_resolve_local(struct sockaddr *src_in,
-			      struct sockaddr *dst_in,
-			      struct rdma_dev_addr *addr)
-{
-	struct net_device *dev;
-	int ret;
-
-	switch (dst_in->sa_family) {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	case AF_INET6:
-	{
-		struct in6_addr *a;
-
-		read_lock(&dev_base_lock);
-		for_each_netdev(&init_net, dev)
-			if (ipv6_chk_addr(&init_net,
-					  &((struct sockaddr_in6 *) dst_in)->sin6_addr,
-					  dev, 1))
-				break;
-
-		if (!dev) {
-			read_unlock(&dev_base_lock);
-			return -EADDRNOTAVAIL;
-		}
-
-		a = &((struct sockaddr_in6 *) src_in)->sin6_addr;
-
-		if (ipv6_addr_any(a)) {
-			src_in->sa_family = dst_in->sa_family;
-			((struct sockaddr_in6 *) src_in)->sin6_addr =
-				((struct sockaddr_in6 *) dst_in)->sin6_addr;
-			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
-		} else if (ipv6_addr_loopback(a)) {
-			ret = rdma_translate_ip(dst_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		} else  {
-			ret = rdma_translate_ip(src_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		}
-		read_unlock(&dev_base_lock);
-		break;
-	}
-#endif
-
-	default:
-		ret = -EADDRNOTAVAIL;
-		break;
-	}
-
-	return ret;
-}
-
 int rdma_resolve_ip(struct rdma_addr_client *client,
 		    struct sockaddr *src_addr, struct sockaddr *dst_addr,
 		    struct rdma_dev_addr *addr, int timeout_ms,
@@ -436,10 +378,7 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	req->client = client;
 	atomic_inc(&client->refcount);
 
-	req->status = addr_resolve_local(src_in, dst_in, addr);
-	if (req->status == -EADDRNOTAVAIL)
-		req->status = addr_resolve(src_in, dst_in, addr);
-
+	req->status = addr_resolve(src_in, dst_in, addr);
 	switch (req->status) {
 	case 0:
 		req->timeout = jiffies;
@@ -448,7 +387,6 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	case -ENODATA:
 		req->timeout = msecs_to_jiffies(timeout_ms) + jiffies;
 		queue_req(req);
-		addr_send_arp(dst_in);
 		break;
 	default:
 		ret = req->status;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 38867a4..71e616a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1472,15 +1472,6 @@ static void cma_listen_on_all(struct rdma_id_private *id_priv)
 	mutex_unlock(&lock);
 }
 
-static int cma_bind_any(struct rdma_cm_id *id, sa_family_t af)
-{
-	struct sockaddr_storage addr_in;
-
-	memset(&addr_in, 0, sizeof addr_in);
-	addr_in.ss_family = af;
-	return rdma_bind_addr(id, (struct sockaddr *) &addr_in);
-}
-
 int rdma_listen(struct rdma_cm_id *id, int backlog)
 {
 	struct rdma_id_private *id_priv;
@@ -1488,7 +1479,8 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 
 	id_priv = container_of(id, struct rdma_id_private, id);
 	if (id_priv->state == CMA_IDLE) {
-		ret = cma_bind_any(id, AF_INET);
+		((struct sockaddr *) &id->route.addr.src_addr)->sa_family = AF_INET;
+		ret = rdma_bind_addr(id, (struct sockaddr *) &id->route.addr.src_addr);
 		if (ret)
 			return ret;
 	}
@@ -1885,10 +1877,14 @@ err:
 static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			 struct sockaddr *dst_addr)
 {
-	if (src_addr && src_addr->sa_family)
-		return rdma_bind_addr(id, src_addr);
-	else
-		return cma_bind_any(id, dst_addr->sa_family);
+	if (!src_addr || !src_addr->sa_family) {
+		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
+		if ((src_addr->sa_family = dst_addr->sa_family) == AF_INET6) {
+			((struct sockaddr_in6 *) src_addr)->sin6_scope_id =
+				((struct sockaddr_in6 *) dst_addr)->sin6_scope_id;
+		}
+	}
+	return rdma_bind_addr(id, src_addr);
 }
 
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
@@ -2084,6 +2080,23 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	return ret;
 }
 
+static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
+			       struct sockaddr *addr)
+{
+	struct sockaddr_in6 *sin6;
+
+	if (addr->sa_family != AF_INET6)
+		return 0;
+
+	sin6 = (struct sockaddr_in6 *) addr;
+	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
+	    !sin6->sin6_scope_id)
+			return -EINVAL;
+
+	dev_addr->bound_dev_if = sin6->sin6_scope_id;
+	return 0;
+}
+
 int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 {
 	struct rdma_id_private *id_priv;
@@ -2096,6 +2109,10 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (!cma_comp_exch(id_priv, CMA_IDLE, CMA_ADDR_BOUND))
 		return -EINVAL;
 
+	ret = cma_check_linklocal(&id->route.addr.dev_addr, addr);
+	if (ret)
+		goto err1;
+
 	if (cma_loopback_addr(addr)) {
 		ret = cma_bind_loopback(id_priv);
 	} else if (!cma_zero_addr(addr)) {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
