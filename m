From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for
	RDMA CM
Date: Tue, 27 Oct 2009 23:42:53 -0600
Message-ID: <20091028054253.GA22882@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

**COMPILE TESTED ONLY**

Convert the address resolution process for outgoing connections
to be very similar to the way the TCP stack does the same operations.
This fixes many corner case bugs that can crop up.

- Process link local scope IPv6 addreses and use sin6_scope_id
  to choose the binding device
- Use routing lookups to choose the device and the source address
- Use ipv6_addr_copy
- Make the interaction of rdma_bind_addr and rdma_resolve_addr smoother
  when both specify a source address
- Replace the unlocked struct net_device pointer in rdma_dev_addr with
  an ifindex value. This is easier to work with when processing
  sin6_scope_id.
- Make addr4_resolve and addr6_resolve have the same flow, for easier
  review.
- Fixup error checking in the v6 routing lookup, dst is never 0, errno
  is returned via dst.error. Corrects cases where routing would return
  ENETUNREACH, etc
- Fold addr_send_arp into addr_resolve so that it uses the correct
  dst structure.

Based on work from "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reported-by: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Reported-by: leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/addr.c |  242 ++++++++++++++--------------------------
 drivers/infiniband/core/cma.c  |   51 +++++++--
 include/rdma/ib_addr.h         |    2 +-
 3 files changed, 127 insertions(+), 168 deletions(-)

So.. I suddenly had a notion how to fit this all together when I was
writing about that SO_BINDTODEVICE stuff.

Here is how I think this should all go. I can't steal some machines to
test it right now (prolly can't till after SC|09), but David/Sean maybe
you can have a look at it?

This should be split up into probably 3-4 patches, but I've included it
as one to make discussions as to the whole flow simpler..

There are still a few areas I'm not certain about. There is something
wonky about how the old code was handling neighbours, I'm not sure if 
addr_send_arp was correct to assume dst->neighbour is always non zero,
or if addrX_resolve_remote is correct to check that it could be
zero. I'm also not certain the neigh_lookup is necessary, if the
dst->neighbour is already correct and non-zero. Hmm.

I left the network namespace stuff alone and kept with the init_net
situation..

The approach to solve the niggly problem Sean pointed out WRT to
rdma_bind_addr was to treat rdma_bind_addr as the combination of
SO_BINDTODEVICE and bind() in the normal inet case, and copy that
algorithm exactly. If rdma_bind_addr() is called with non-any IP
then the cm_id is bound to that device via the new bound_dev_if
index. All other checks then refer to that, and bound_dev_if is
fed into the route lookup to set the source device, and if the source
device is set then it is copied into the route output by the route
routines and everything works the way you'd expect. For the loopback
case, if no source device is bound then the destination IP is used
as the RDMA device, if one is bound then it is used instead.

There is also now checking for IPv6 link local addresses, and like in
the real stack specifying link local is basically the same flow as
SO_BINDTODEVICE, stick the scope_id into bound_dev_if and let the
routing sort it out.

I think the change for the arps should be done, but I'd definately
split it out into a new patch. Doing the neigh_event with the dst from
the single route lookup is really necessary for correct operation in
all cases - the old code could jump to another net_device in certain
situations due to the incomplete second lookup (Leo noticed this). It
may also be a good idea to set bound_dev_if when the neigh_event_send
is called so that if the timers run through addrX_resolve again we are
guarenteed to be bound on the right device.

This also fixes rdma_bind_addr with a v6 link local address, and v6
source address selection cases when unbound.

I'm guessing there are probably more problems with the v6 support,
like how is the port space being shared between v6/v4 and do incoming
v4 connections get mapped to v6 listeners? But that has nothing to do
with the routing... :)

AH, there is still another oopsie I just noticed, rdma_resolve_addr
does not check that dst_addr and src_addr are the same AF, and does
not check if src_addr == 0 that the bind_addr value is the same
AF. Not fixed in this version, just noting it here..

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index bd07803..1b6d419 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -107,7 +107,7 @@ int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
 	memcpy(dev_addr->broadcast, dev->broadcast, MAX_ADDR_LEN);
 	if (dst_dev_addr)
 		memcpy(dev_addr->dst_dev_addr, dst_dev_addr, MAX_ADDR_LEN);
-	dev_addr->src_dev = dev;
+	dev_addr->bound_dev_if = dev->ifindex;
 	return 0;
 }
 EXPORT_SYMBOL(rdma_copy_addr);
@@ -117,6 +117,16 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 	struct net_device *dev;
 	int ret = -EADDRNOTAVAIL;
 
+	/* Someone has specified we must bind to a specific interface.. */
+	if (dev_addr->bound_dev_if) {
+		dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+		if (!dev)
+			return -ENODEV;
+		ret = rdma_copy_addr(dev_addr, dev, NULL);
+		dev_put(dev);
+		return ret;
+	}
+
 	switch (addr->sa_family) {
 	case AF_INET:
 		dev = ip_dev_find(&init_net,
@@ -176,48 +186,9 @@ static void queue_req(struct addr_req *req)
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
-	case AF_INET:
-		fl.nl_u.ip4_u.daddr =
-			((struct sockaddr_in *) dst_in)->sin_addr.s_addr;
-
-		if (ip_route_output_key(&init_net, &rt, &fl))
-			return;
-
-		neigh_event_send(rt->u.dst.neighbour, NULL);
-		ip_rt_put(rt);
-		break;
-
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
-static int addr4_resolve_remote(struct sockaddr_in *src_in,
-			       struct sockaddr_in *dst_in,
-			       struct rdma_dev_addr *addr)
+static int addr4_resolve(struct sockaddr_in *src_in,
+			 struct sockaddr_in *dst_in,
+			 struct rdma_dev_addr *addr)
 {
 	__be32 src_ip = src_in->sin_addr.s_addr;
 	__be32 dst_ip = dst_in->sin_addr.s_addr;
@@ -229,10 +200,22 @@ static int addr4_resolve_remote(struct sockaddr_in *src_in,
 	memset(&fl, 0, sizeof fl);
 	fl.nl_u.ip4_u.daddr = dst_ip;
 	fl.nl_u.ip4_u.saddr = src_ip;
+	fl.oif = addr->bound_dev_if;
 	ret = ip_route_output_key(&init_net, &rt, &fl);
 	if (ret)
 		goto out;
 
+	src_in->sin_family = AF_INET;
+	src_in->sin_addr.s_addr = rt->rt_src;
+
+	if (rt->idev->dev == init_net.loopback_dev) {
+		ret = rdma_translate_ip((struct sockaddr *)dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
+			       MAX_ADDR_LEN);
+		goto put;
+	}
+
 	/* If the device does ARP internally, return 'done' */
 	if (rt->idev->dev->flags & IFF_NOARP) {
 		rdma_copy_addr(addr, rt->idev->dev, NULL);
@@ -240,24 +223,16 @@ static int addr4_resolve_remote(struct sockaddr_in *src_in,
 	}
 
 	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, rt->idev->dev);
-	if (!neigh) {
+	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
+		neigh_event_send(rt->u.dst.neighbour, NULL);
 		ret = -ENODATA;
+		if (neigh)
+			neigh_release(neigh);
 		goto put;
 	}
-
-	if (!(neigh->nud_state & NUD_VALID)) {
-		ret = -ENODATA;
-		goto release;
-	}
-
-	if (!src_ip) {
-		src_in->sin_family = dst_in->sin_family;
-		src_in->sin_addr.s_addr = rt->rt_src;
-	}
+	neigh_release(neigh);
 
 	ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
-release:
-	neigh_release(neigh);
 put:
 	ip_rt_put(rt);
 out:
@@ -265,36 +240,64 @@ out:
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
+	fl.oif = addr->bound_dev_if;
 
 	dst = ip6_route_output(&init_net, NULL, &fl);
-	if (!dst)
-		return ret;
+	if ((ret = dst->error))
+		goto put;
+
+	if (ipv6_addr_any(&fl.fl6_src)) {
+		ret = ipv6_dev_get_saddr(&init_net, ip6_dst_idev(dst)->dev,
+					 &fl.fl6_dst, 0,
+					 &fl.fl6_src);
+		if (!ret)
+			goto put;
+		src_in->sin6_family = AF_INET6;
+		ipv6_addr_copy(&src_in->sin6_addr, &fl.fl6_src);
+	}
+
+	if (ip6_dst_idev(dst)->dev == init_net.loopback_dev) {
+		ret = rdma_translate_ip((struct sockaddr *)dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
+			       MAX_ADDR_LEN);
+		goto put;
+	}
 
-	if (dst->dev->flags & IFF_NOARP) {
-		ret = rdma_copy_addr(addr, dst->dev, NULL);
-	} else {
-		neigh = dst->neighbour;
-		if (neigh && (neigh->nud_state & NUD_VALID))
-			ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
+	/* If the device does ARP internally, return 'done' */
+	if (ip6_dst_idev(dst)->dev->flags & IFF_NOARP) {
+		ret = rdma_copy_addr(addr, ip6_dst_idev(dst)->dev, NULL);
+		goto put;
 	}
 
+	/* XXX why is this different from the addr4_resolve case?
+	 Is the neigh_lookup redundant? */
+	neigh = dst->neighbour;
+	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
+		neigh_event_send(dst->neighbour, NULL);
+		ret = -ENODATA;
+		goto put;
+	}
+
+	ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
+put:
 	dst_release(dst);
 	return ret;
 }
 #else
-static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
+static int addr6_resolve(struct sockaddr_in6 *src_in,
 			       struct sockaddr_in6 *dst_in,
 			       struct rdma_dev_addr *addr)
 {
@@ -302,15 +305,15 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 }
 #endif
 
-static int addr_resolve_remote(struct sockaddr *src_in,
-				struct sockaddr *dst_in,
-				struct rdma_dev_addr *addr)
+static int addr_resolve(struct sockaddr *src_in,
+			struct sockaddr *dst_in,
+			struct rdma_dev_addr *addr)
 {
 	if (src_in->sa_family == AF_INET) {
-		return addr4_resolve_remote((struct sockaddr_in *) src_in,
+		return addr4_resolve((struct sockaddr_in *) src_in,
 			(struct sockaddr_in *) dst_in, addr);
 	} else
-		return addr6_resolve_remote((struct sockaddr_in6 *) src_in,
+		return addr6_resolve((struct sockaddr_in6 *) src_in,
 			(struct sockaddr_in6 *) dst_in, addr);
 }
 
@@ -327,8 +330,7 @@ static void process_req(struct work_struct *work)
 		if (req->status == -ENODATA) {
 			src_in = (struct sockaddr *) &req->src_addr;
 			dst_in = (struct sockaddr *) &req->dst_addr;
-			req->status = addr_resolve_remote(src_in, dst_in,
-							  req->addr);
+			req->status = addr_resolve(src_in, dst_in, req->addr);
 			if (req->status && time_after_eq(jiffies, req->timeout))
 				req->status = -ETIMEDOUT;
 			else if (req->status == -ENODATA)
@@ -352,82 +354,6 @@ static void process_req(struct work_struct *work)
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
-	case AF_INET:
-	{
-		__be32 src_ip = ((struct sockaddr_in *) src_in)->sin_addr.s_addr;
-		__be32 dst_ip = ((struct sockaddr_in *) dst_in)->sin_addr.s_addr;
-
-		dev = ip_dev_find(&init_net, dst_ip);
-		if (!dev)
-			return -EADDRNOTAVAIL;
-
-		if (ipv4_is_zeronet(src_ip)) {
-			src_in->sa_family = dst_in->sa_family;
-			((struct sockaddr_in *) src_in)->sin_addr.s_addr = dst_ip;
-			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
-		} else if (ipv4_is_loopback(src_ip)) {
-			ret = rdma_translate_ip(dst_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		} else {
-			ret = rdma_translate_ip(src_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		}
-		dev_put(dev);
-		break;
-	}
-
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	case AF_INET6:
-	{
-		struct in6_addr *a;
-
-		for_each_netdev(&init_net, dev)
-			if (ipv6_chk_addr(&init_net,
-					  &((struct sockaddr_in6 *) dst_in)->sin6_addr,
-					  dev, 1))
-				break;
-
-		if (!dev)
-			return -EADDRNOTAVAIL;
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
@@ -455,10 +381,11 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	src_in = (struct sockaddr *) &req->src_addr;
 	dst_in = (struct sockaddr *) &req->dst_addr;
 
-	req->status = addr_resolve_local(src_in, dst_in, addr);
-	if (req->status == -EADDRNOTAVAIL)
-		req->status = addr_resolve_remote(src_in, dst_in, addr);
+	req->status = addr_resolve(src_in, dst_in, addr);
 
+	/* XXX this scares me, ENODATA is not special, there is no guarentee
+	   that any of the functions in the IP stack called by addr_resolve
+	   don't return ENODATA in some cases.. */
 	switch (req->status) {
 	case 0:
 		req->timeout = jiffies;
@@ -467,7 +394,6 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	case -ENODATA:
 		req->timeout = msecs_to_jiffies(timeout_ms) + jiffies;
 		queue_req(req);
-		addr_send_arp(dst_in);
 		break;
 	default:
 		ret = req->status;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0753178..a0fa241 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1875,13 +1875,25 @@ err:
 	return ret;
 }
 
-static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
-			 struct sockaddr *dst_addr)
+/* IPv6 link local addresses must specify a consistent set of devices
+   to bind to. */
+static int check_ip6_ll(struct rdma_dev_addr *dev_addr,
+			const struct sockaddr *addr)
 {
-	if (src_addr && src_addr->sa_family)
-		return rdma_bind_addr(id, src_addr);
-	else
-		return cma_bind_any(id, dst_addr->sa_family);
+	const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)addr;
+
+	if (addr->sa_family != AF_INET6)
+		return 0;
+
+	if (ipv6_addr_type(&addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
+		if (dev_addr->bound_dev_if &&
+		    dev_addr->bound_dev_if != addr6->sin6_scope_id)
+			return -EINVAL;
+		dev_addr->bound_dev_if = addr6->sin6_scope_id;
+		if (!dev_addr->bound_dev_if)
+			return -EINVAL;
+	}
+	return 0;
 }
 
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
@@ -1891,8 +1903,16 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+
+	if (src_addr) {
+		if ((ret = check_ip6_ll(&id->route.addr.dev_addr, src_addr)))
+			return ret;
+	}
+	if ((ret = check_ip6_ll(&id->route.addr.dev_addr, dst_addr)))
+		return ret;
+
 	if (id_priv->state == CMA_IDLE) {
-		ret = cma_bind_addr(id, src_addr, dst_addr);
+		ret = cma_bind_any(id, dst_addr->sa_family);
 		if (ret)
 			return ret;
 	}
@@ -1900,12 +1920,18 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	if (!cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_ADDR_QUERY))
 		return -EINVAL;
 
+	/* NOTE: If the user has called rdma_bind_addr() and then passes
+	   a src_addr value here the interpretation is that they wished
+	   to use whatever address they gave to bind to choose a device,
+	   and this address as the source IP for the connection. */
+
 	atomic_inc(&id_priv->refcount);
 	memcpy(&id->route.addr.dst_addr, dst_addr, ip_addr_size(dst_addr));
 	if (cma_any_addr(dst_addr))
 		ret = cma_resolve_loopback(id_priv);
 	else
-		ret = rdma_resolve_ip(&addr_client, (struct sockaddr *) &id->route.addr.src_addr,
+		ret = rdma_resolve_ip(&addr_client,
+				      src_addr ? src_addr : (struct sockaddr *) &id->route.addr.src_addr,
 				      dst_addr, &id->route.addr.dev_addr,
 				      timeout_ms, addr_handler, id_priv);
 	if (ret)
@@ -2077,6 +2103,8 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	return ret;
 }
 
+/* rdma_bind_addr does a combination of what socket bind() and
+   SO_BINDTODEVICE would do. */
 int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 {
 	struct rdma_id_private *id_priv;
@@ -2085,10 +2113,14 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (addr->sa_family != AF_INET && addr->sa_family != AF_INET6)
 		return -EAFNOSUPPORT;
 
+	if ((ret = check_ip6_ll(&id->route.addr.dev_addr, addr)))
+		return ret;
+
 	id_priv = container_of(id, struct rdma_id_private, id);
 	if (!cma_comp_exch(id_priv, CMA_IDLE, CMA_ADDR_BOUND))
 		return -EINVAL;
 
+	/* Do socket SO_BINDTODEVICE like behavior */
 	if (!cma_any_addr(addr)) {
 		ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
 		if (ret)
@@ -2101,6 +2133,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 			goto err1;
 	}
 
+	/* Do socket bind() like behavior */
 	memcpy(&id->route.addr.src_addr, addr, ip_addr_size(addr));
 	ret = cma_get_port(id_priv);
 	if (ret)
@@ -2815,7 +2848,7 @@ static int cma_netdev_change(struct net_device *ndev, struct rdma_id_private *id
 
 	dev_addr = &id_priv->id.route.addr.dev_addr;
 
-	if ((dev_addr->src_dev == ndev) &&
+	if ((dev_addr->bound_dev_if == ndev->ifindex) &&
 	    memcmp(dev_addr->src_dev_addr, ndev->dev_addr, ndev->addr_len)) {
 		printk(KERN_INFO "RDMA CM addr change for ndev %s used by id %p\n",
 		       ndev->name, &id_priv->id);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 483057b..27f17cc 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -61,7 +61,7 @@ struct rdma_dev_addr {
 	unsigned char dst_dev_addr[MAX_ADDR_LEN];
 	unsigned char broadcast[MAX_ADDR_LEN];
 	enum rdma_node_type dev_type;
-	struct net_device *src_dev;
+	int bound_dev_if;
 };
 
 /**
-- 
1.5.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
