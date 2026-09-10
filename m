Received: from mail-wm2-f8.google.com (mail-wm2-f8.google.com [74.125.225.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C3F4582E8
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037374; cv=none; b=kjnTMD7sZWGIhRqYIubgu5Pvm1Mkqb0IchrIyOzkjO4HBMMkHD35vbo1qEdFwswiNdar6vOaR1A/y9+Ikluhqs2Cq9bjrcSIW48VGhf3+J/tIDsVcNdMmN9BATNhK/5mN1Q1DKfFTVyne1De449AJbIqDafoEa4SIsER6EVV4Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037374; c=relaxed/simple;
	bh=YcqveSVRqqRU5HOL31SzMtQT2Jp8obnX0ebPfH5vpBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j5r39NagkbqMWSpPbdiJ+K+QbFAd/KLte8eeWUmXz516UhYQ7yVfllvqC4y1sou7WsRvKnRWXPMj/yPBxx43N5mqSzcqO/E/SSq/zloqI2q5sCHfO7L8gL+A3VAovCECEzqa+xZ4LA00tODnd6wGglz1uV2zA9dEydbyg09FWsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzuNZ0zd; arc=none smtp.client-ip=74.125.225.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzuNZ0zd"
Received: by mail-wm2-f8.google.com with SMTP id 5b1f17b1804b1-49cd3d0f150so31746815e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 03:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789037366; x=1789642166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8HrwhY4DasNbxFapRyvEf80WOr9MkCHIOinv5ZDHyRs=;
        b=MzuNZ0zdd6PtpLY7BUPCpnQh8DMGbYgjcLPpLGdMez0w6x6Dale0/mIZsKPfr+lrHf
         6FAk/5hcs5MnrwvI5C/dSv5ussgXKEmds0rQrW2CE0XmOigh5eqB9vv9tyMBm9pgfuKQ
         g3lRz8zhiF6VFrsNRwW7D21gYuuZyCIueY6VfJL50rook3cqSvSx9Sk8DuQWan99x2sJ
         PUyBcPl8VNlkmmPwFyd0uaCJEb1JJ03X6A54Bnjd4P0DhZmWGJx3gsmjzjozolTWBWpA
         0tBbXgzw2eZuOtHFP4kS2TGRSTXqPJcgsKRXOz/ucZej55UI9HmnOinNO2nOfwYL+fW/
         mEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789037366; x=1789642166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8HrwhY4DasNbxFapRyvEf80WOr9MkCHIOinv5ZDHyRs=;
        b=HinbKYAZe8Cr43WQ9yxZ/r1rWxdAJew3RER8rYJSLlQmUIZbOIAiRSwu93RvyEoALj
         nPI0yg+VFLZ/OW04hS4WrS11Ws8RDxnG6jfv1KZ0MOJU6DivFihIXLBEY/V4laQoPiSu
         Vs1bva/oXttAVwKKn/7YIky9VP0U5+k+AeJnjeoR6Asm99lvda/Qk6wyxbmujN5IZQaM
         Yl5hmC4MPXnSDODjca7cimWxt+eFt9QQ6S6iGN12Jh8kr/yWXyrnyAxnGxZxoqaMdS3T
         IsM8J+epRs8wEcQUZw/xO52TYZQlIDEAURYNwChJQyxrPtz/F5mwDJKqaDvZr8GssWdz
         wiUg==
X-Forwarded-Encrypted: i=1; AKwUvByVPXjvwh0G/eQeyFch8WtlqPXyNR6N/CQNy11f1vjhtNCkb+rM7UpEzEomLf5Vk77Vr6QejyN/ED4u@vger.kernel.org
X-Gm-Message-State: AFuF++ku2R58RaClU5WtHAhvifpf3G1f8OLKBd1wdgJQEmwnH4UX7OTb
	ug/I0yr4zTGNyKT+1TYx9lac+tetNtLeKBuspAfdhMXmQ2FFQV0nU12D
X-Gm-Gg: AYBFou0G57nuhP+47CFSctzozQ2VRFCjI3ILCyWnqmywCYvYPDIYH9dlFHlT8mQX7Cp
	Jl/9QQ/gLlJpIDHgYzvSVqMfTdublbjNpFHuz2XyzlVI/+J063pUQabaxTDW5kuoW8k/Un+GcL/
	OnA86IEj97nnGs+BOiNneNSDICA5UgdI9zp4jij1m6rnjCJfdcAZ92mZfnyPEUxIzK7ddSYitNX
	HolnsSr8IWK0VqUM/GMQRZ11cIT2bEaXVn9sE9pt4UQviYSIJf22Xfk6LL4mW/VRA2OkCXkekzC
	FEGV9x4senAslpdpJqDuniByuYMM7+zCNjTNuIEIzgBC2XZg+iGaVHZ/j3qGTa6m4fF2Nl++bFb
	T3SslIgtYDtbh9AgjC1HDsv8ich3uwurjEFfhpj4z7dJWoKSrHNtu2sWZp2rYxH/nOi5AFcGgWe
	QrPVEGIB61qByGvWQaU1MnGUUAd1l0d7mcv2ijBpOZpEqW72rJreag3YqYuEMRb5UNSOwoAI2G6
	O++fSz3OhGUilJ9fAhvvMfymw==
X-Received: by 2002:a05:600c:5247:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-49cf81dadcamr372142095e9.2.1789037364919;
        Thu, 10 Sep 2026 03:49:24 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26be3e0asm67419465e9.1.2026.09.10.03.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 03:49:24 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH v2 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Thu, 10 Sep 2026 13:49:05 +0300
Message-ID: <20260910104906.19681-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rxe creates the shared per-netns UDP tunnel sockets in rxe_newlink() and
releases them from dellink, the NETDEV_UNREGISTER notifier and a pernet
exit hook, with driver side bookkeeping deciding when the last user is
gone. Keeping that in sync with the core GID table has been a recurring
source of lifetime bugs, most recently a refcount underflow /
use-after-free reported by syzkaller when those paths raced.

Implement add_gid/del_gid and key the sockets off the GID entries
instead: the first RoCEv2 entry of an address family in a netns creates
the wildcard socket, the last one releases it. The core pairs every
installed GID entry with one del_gid, so the counts have a single owner
and cannot underflow.

The per-netns state is a small global list keyed by netns; no pernet
storage and no pernet hook are needed. rxe_ns.[ch], the sk_refcnt magic
in rxe_net_del() and the .dellink hook are gone.

One behavior change: the core does not propagate add_gid errors, so a
busy port 4791 or a failed allocation no longer fails "rdma link add",
it leaves the GID entry missing.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Fixes: f1327abd6abe ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
Reported-by: syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8c9eede336e3a843750e
Assisted-by: Claude:claude-fable-5
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
v2:
- Dropped backstop. 

v1:https://lore.kernel.org/linux-rdma/20260718142642.102924-1-serhatkumral1@gmail.com/

 drivers/infiniband/sw/rxe/Makefile    |   3 +-
 drivers/infiniband/sw/rxe/rxe.c       |  26 +--
 drivers/infiniband/sw/rxe/rxe_net.c   | 289 +++++++++++++++-----------
 drivers/infiniband/sw/rxe/rxe_net.h   |   5 +-
 drivers/infiniband/sw/rxe/rxe_ns.c    | 124 -----------
 drivers/infiniband/sw/rxe/rxe_ns.h    |  26 ---
 drivers/infiniband/sw/rxe/rxe_verbs.c |   2 +
 7 files changed, 171 insertions(+), 304 deletions(-)
 delete mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
 delete mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h

diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
index e097c1ca1874..18ff60542744 100644
--- a/drivers/infiniband/sw/rxe/Makefile
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -23,7 +23,6 @@ rdma_rxe-y := \
 	rxe_task.o \
 	rxe_net.o \
 	rxe_hw_counters.o \
-	rxe_mad.o \
-	rxe_ns.o
+	rxe_mad.o
 
 rdma_rxe-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += rxe_odp.o
diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index af39209d0fcf..66d5986dac99 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -9,7 +9,6 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_net.h"
-#include "rxe_ns.h"
 
 MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
 MODULE_DESCRIPTION("Soft RDMA transport");
@@ -202,8 +201,6 @@ void rxe_set_mtu(struct rxe_dev *rxe, unsigned int ndev_mtu)
 	port->mtu_cap = ib_mtu_enum_to_int(mtu);
 }
 
-static struct rdma_link_ops rxe_link_ops;
-
 /* called by ifc layer to create new rxe device.
  * The caller should allocate memory for rxe by calling ib_alloc_device.
  */
@@ -212,7 +209,6 @@ int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name,
 {
 	rxe_init(rxe, ndev);
 	rxe_set_mtu(rxe, mtu);
-	rxe->ib_dev.link_ops = &rxe_link_ops;
 
 	return rxe_register_device(rxe, ibdev_name, ndev);
 }
@@ -236,10 +232,6 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 		goto err;
 	}
 
-	err = rxe_net_init(ndev);
-	if (err)
-		return err;
-
 	err = rxe_net_add(ibdev_name, ndev);
 	if (err) {
 		rxe_err("failed to add %s\n", ndev->name);
@@ -249,17 +241,9 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 	return err;
 }
 
-static int rxe_dellink(struct ib_device *dev)
-{
-	rxe_net_del(dev);
-
-	return 0;
-}
-
 static struct rdma_link_ops rxe_link_ops = {
 	.type = "rxe",
 	.newlink = rxe_newlink,
-	.dellink = rxe_dellink,
 };
 
 static int __init rxe_module_init(void)
@@ -270,21 +254,15 @@ static int __init rxe_module_init(void)
 	if (err)
 		return err;
 
-	err = rxe_namespace_init();
-	if (err)
-		goto err_destroy_wq;
-
 	err = rxe_register_notifier();
 	if (err)
-		goto err_namespace_exit;
+		goto err_destroy_wq;
 
 	rdma_link_register(&rxe_link_ops);
 
 	pr_info("loaded\n");
 	return 0;
 
-err_namespace_exit:
-	rxe_namespace_exit();
 err_destroy_wq:
 	rxe_destroy_wq();
 	return err;
@@ -297,8 +275,6 @@ static void __exit rxe_module_exit(void)
 	rxe_net_exit();
 	rxe_destroy_wq();
 
-	rxe_namespace_exit();
-
 	pr_info("unloaded\n");
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2..fa1cf49c13e3 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -17,11 +17,6 @@
 #include "rxe.h"
 #include "rxe_net.h"
 #include "rxe_loc.h"
-#include "rxe_ns.h"
-
-#ifndef SK_REF_FOR_TUNNEL
-#define SK_REF_FOR_TUNNEL	2
-#endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
@@ -81,9 +76,9 @@ static inline void rxe_reclassify_recv_socket(struct socket *sock)
 	 * from being called and 'rmmod rdma_rxe'
 	 * is refused because of the references.
 	 *
-	 * For the global sockets in recv_sockets,
-	 * we are sure that rxe_net_exit() will call
-	 * rxe_release_udp_tunnel -> udp_tunnel_sock_release.
+	 * For the shared tunnel sockets, the last
+	 * rxe_del_gid() calls udp_tunnel_sock_release().
+	 * All GID entries are removed before module exit.
 	 *
 	 * So we don't need the additional reference to
 	 * our own (THIS_MODULE).
@@ -141,7 +136,7 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	ndst = ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);
+	ndst = ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
 	if (IS_ERR(ndst)) {
 		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
 		return NULL;
@@ -288,10 +283,165 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 	return sock;
 }
 
-static void rxe_release_udp_tunnel(struct sock *sk)
+/*
+ * The wildcard tunnel sockets are shared by every RoCEv2 GID entry in
+ * a netns. The first entry of an address family creates its socket and
+ * the last del_gid releases it. The GID table pairs each successful
+ * add_gid with one del_gid, so only these callbacks own the counts.
+ *
+ * GID removal can outlive netns teardown. Keep the state in a global
+ * list instead of pernet storage; the sockets' passive net references
+ * keep the net pointer valid as a list key until the sockets are released.
+ */
+struct rxe_ns_sock {
+	struct list_head node;
+	struct net *net;
+	struct socket *sk4;
+	struct socket *sk6;
+	int nr4;
+	int nr6;
+};
+
+static DEFINE_MUTEX(rxe_ns_lock);
+static LIST_HEAD(rxe_ns_list);
+
+static struct rxe_ns_sock *rxe_ns_find(struct net *net)
+{
+	struct rxe_ns_sock *ns;
+
+	lockdep_assert_held(&rxe_ns_lock);
+
+	list_for_each_entry(ns, &rxe_ns_list, node)
+		if (ns->net == net)
+			return ns;
+
+	return NULL;
+}
+
+int rxe_add_gid(const struct ib_gid_attr *attr, void **context)
+{
+	bool ipv6 = rdma_gid_attr_network_type(attr) == RDMA_NETWORK_IPV6;
+	__be16 port = htons(ROCE_V2_UDP_DPORT);
+	struct net_device *ndev;
+	struct rxe_ns_sock *ns;
+	struct socket *sock;
+	struct net *net;
+	int err = 0;
+
+	*context = NULL;
+
+	/* Only RoCEv2 GIDs use a UDP tunnel socket. */
+	if (attr->gid_type != IB_GID_TYPE_ROCE_UDP_ENCAP)
+		return 0;
+
+	/*
+	 * Hold the netns across the socket setup; this also fails
+	 * instead of binding a new socket in a netns that is already
+	 * being dismantled.
+	 */
+	rcu_read_lock();
+	ndev = rcu_dereference(attr->ndev);
+	net = ndev ? maybe_get_net(dev_net_rcu(ndev)) : NULL;
+	rcu_read_unlock();
+	if (!net)
+		return -ENODEV;
+
+	mutex_lock(&rxe_ns_lock);
+	ns = rxe_ns_find(net);
+	if (!ns) {
+		ns = kzalloc_obj(*ns);
+		if (!ns) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+		ns->net = net;
+		list_add(&ns->node, &rxe_ns_list);
+	}
+
+	if (ipv6) {
+		if (!ns->nr6) {
+			sock = rxe_setup_udp_tunnel(net, port, true);
+			if (IS_ERR(sock)) {
+				err = PTR_ERR(sock);
+				/*
+				 * No IPv6 support: leave this GID entry
+				 * without a socket and without a count;
+				 * rxe_del_gid() skips a NULL context.
+				 */
+				if (err == -EAFNOSUPPORT ||
+				    err == -EPFNOSUPPORT)
+					err = 0;
+				goto out_free;
+			}
+			ns->sk6 = sock;
+		}
+		ns->nr6++;
+	} else {
+		if (!ns->nr4) {
+			sock = rxe_setup_udp_tunnel(net, port, false);
+			if (IS_ERR(sock)) {
+				err = PTR_ERR(sock);
+				goto out_free;
+			}
+			ns->sk4 = sock;
+		}
+		ns->nr4++;
+	}
+	mutex_unlock(&rxe_ns_lock);
+
+	put_net(net);
+	*context = ns;
+	return 0;
+
+out_free:
+	if (!ns->nr4 && !ns->nr6) {
+		list_del(&ns->node);
+		kfree(ns);
+	}
+out_unlock:
+	mutex_unlock(&rxe_ns_lock);
+	put_net(net);
+	return err;
+}
+
+int rxe_del_gid(const struct ib_gid_attr *attr, void **context)
 {
-	if (sk)
-		udp_tunnel_sock_release(sk);
+	bool ipv6 = rdma_gid_attr_network_type(attr) == RDMA_NETWORK_IPV6;
+	struct rxe_ns_sock *ns = *context;
+	struct socket *sock = NULL;
+
+	if (!ns)
+		return 0;
+
+	*context = NULL;
+
+	mutex_lock(&rxe_ns_lock);
+	if (ipv6) {
+		if (!WARN_ON_ONCE(!ns->nr6) && !--ns->nr6) {
+			sock = ns->sk6;
+			ns->sk6 = NULL;
+		}
+	} else {
+		if (!WARN_ON_ONCE(!ns->nr4) && !--ns->nr4) {
+			sock = ns->sk4;
+			ns->sk4 = NULL;
+		}
+	}
+	/*
+	 * Release under the lock: a concurrent rxe_add_gid() must not
+	 * see a zero count while the old socket still holds the port,
+	 * or its bind() fails with -EADDRINUSE.
+	 */
+	if (sock)
+		udp_tunnel_sock_release(sock->sk);
+
+	if (!ns->nr4 && !ns->nr6) {
+		list_del(&ns->node);
+		kfree(ns);
+	}
+	mutex_unlock(&rxe_ns_lock);
+
+	return 0;
 }
 
 static void prepare_udp_hdr(struct sk_buff *skb, __be16 src_port,
@@ -631,42 +781,6 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 	return 0;
 }
 
-static void rxe_sock_put(struct sock *sk,
-					void (*set_sk)(struct net *, struct sock *),
-					struct net *net)
-{
-	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
-		__sock_put(sk);
-	} else {
-		rxe_release_udp_tunnel(sk);
-		sk = NULL;
-		set_sk(net, sk);
-	}
-}
-
-void rxe_net_del(struct ib_device *dev)
-{
-	struct net_device *ndev;
-	struct sock *sk;
-	struct net *net;
-
-	ndev = ib_device_get_netdev(dev, 1);
-	if (!ndev)
-		return;
-
-	net = dev_net(ndev);
-
-	sk = rxe_ns_pernet_sk4(net);
-	if (sk)
-		rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);
-
-	sk = rxe_ns_pernet_sk6(net);
-	if (sk)
-		rxe_sock_put(sk, rxe_ns_pernet_set_sk6, net);
-
-	dev_put(ndev);
-}
-
 static void rxe_port_event(struct rxe_dev *rxe,
 			   enum ib_event_type event)
 {
@@ -723,7 +837,6 @@ static int rxe_notify(struct notifier_block *not_blk,
 	switch (event) {
 	case NETDEV_UNREGISTER:
 		ib_unregister_device_queued(&rxe->ib_dev);
-		rxe_net_del(&rxe->ib_dev);
 		break;
 	case NETDEV_CHANGEMTU:
 		rxe_dbg_dev(rxe, "%s changed mtu to %d\n", ndev->name, ndev->mtu);
@@ -753,56 +866,6 @@ static struct notifier_block rxe_net_notifier = {
 	.notifier_call = rxe_notify,
 };
 
-static int rxe_net_ipv4_init(struct net *net)
-{
-	struct sock *sk;
-	struct socket *sock;
-
-	sk = rxe_ns_pernet_sk4(net);
-	if (sk) {
-		sock_hold(sk);
-		return 0;
-	}
-
-	sock = rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), false);
-	if (IS_ERR(sock)) {
-		pr_err("Failed to create IPv4 UDP tunnel\n");
-		return -1;
-	}
-	rxe_ns_pernet_set_sk4(net, sock->sk);
-
-	return 0;
-}
-
-static int rxe_net_ipv6_init(struct net *net)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-	struct sock *sk;
-	struct socket *sock;
-
-	sk = rxe_ns_pernet_sk6(net);
-	if (sk) {
-		sock_hold(sk);
-		return 0;
-	}
-
-	sock = rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), true);
-	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
-		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
-		return 0;
-	}
-
-	if (IS_ERR(sock)) {
-		pr_err("Failed to create IPv6 UDP tunnel\n");
-		return -1;
-	}
-
-	rxe_ns_pernet_set_sk6(net, sock->sk);
-
-#endif
-	return 0;
-}
-
 int rxe_register_notifier(void)
 {
 	int err;
@@ -819,31 +882,7 @@ int rxe_register_notifier(void)
 void rxe_net_exit(void)
 {
 	unregister_netdevice_notifier(&rxe_net_notifier);
-}
-
-int rxe_net_init(struct net_device *ndev)
-{
-	struct net *net;
-	struct sock *sk;
-	int err;
-
-	net = dev_net(ndev);
 
-	err = rxe_net_ipv4_init(net);
-	if (err)
-		return err;
-
-	err = rxe_net_ipv6_init(net);
-	if (err)
-		goto err_out;
-
-	return 0;
-
-err_out:
-	/* If ipv6 error, release ipv4 resource */
-	sk = rxe_ns_pernet_sk4(net);
-	if (sk)
-		rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);
-
-	return err;
+	/* All devices and thus all GID entries are gone by now. */
+	WARN_ON(!list_empty(&rxe_ns_list));
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index 56249677d692..b564ff5c83f3 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -12,10 +12,11 @@
 #include <linux/module.h>
 
 int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
-void rxe_net_del(struct ib_device *dev);
+
+int rxe_add_gid(const struct ib_gid_attr *attr, void **context);
+int rxe_del_gid(const struct ib_gid_attr *attr, void **context);
 
 int rxe_register_notifier(void);
-int rxe_net_init(struct net_device *ndev);
 void rxe_net_exit(void);
 
 #endif /* RXE_NET_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
deleted file mode 100644
index 64621c89f8bf..000000000000
--- a/drivers/infiniband/sw/rxe/rxe_ns.c
+++ /dev/null
@@ -1,124 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-
-#include <net/sock.h>
-#include <net/netns/generic.h>
-#include <net/net_namespace.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/pid_namespace.h>
-#include <net/udp_tunnel.h>
-
-#include "rxe_ns.h"
-
-/*
- * Per network namespace data
- */
-struct rxe_ns_sock {
-	struct sock __rcu *rxe_sk4;
-	struct sock __rcu *rxe_sk6;
-};
-
-/*
- * Index to store custom data for each network namespace.
- */
-static unsigned int rxe_pernet_id;
-
-/*
- * Called for every existing and added network namespaces
- */
-static int rxe_ns_init(struct net *net)
-{
-	/* defer socket create in the namespace to the first
-	 * device create.
-	 */
-
-	return 0;
-}
-
-static void rxe_ns_exit(struct net *net)
-{
-	/* called when the network namespace is removed
-	 */
-	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-	struct sock *sk;
-
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk4);
-	rcu_read_unlock();
-	if (sk) {
-		rcu_assign_pointer(ns_sk->rxe_sk4, NULL);
-		udp_tunnel_sock_release(sk);
-	}
-
-#if IS_ENABLED(CONFIG_IPV6)
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk6);
-	rcu_read_unlock();
-	if (sk) {
-		rcu_assign_pointer(ns_sk->rxe_sk6, NULL);
-		udp_tunnel_sock_release(sk);
-	}
-#endif
-}
-
-/*
- * callback to make the module network namespace aware
- */
-static struct pernet_operations rxe_net_ops = {
-	.init = rxe_ns_init,
-	.exit = rxe_ns_exit,
-	.id = &rxe_pernet_id,
-	.size = sizeof(struct rxe_ns_sock),
-};
-
-struct sock *rxe_ns_pernet_sk4(struct net *net)
-{
-	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-	struct sock *sk;
-
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk4);
-	rcu_read_unlock();
-
-	return sk;
-}
-
-void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk)
-{
-	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-
-	rcu_assign_pointer(ns_sk->rxe_sk4, sk);
-	synchronize_rcu();
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-struct sock *rxe_ns_pernet_sk6(struct net *net)
-{
-	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-	struct sock *sk;
-
-	rcu_read_lock();
-	sk = rcu_dereference(ns_sk->rxe_sk6);
-	rcu_read_unlock();
-
-	return sk;
-}
-
-void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk)
-{
-	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-
-	rcu_assign_pointer(ns_sk->rxe_sk6, sk);
-	synchronize_rcu();
-}
-#endif /* IPV6 */
-
-int rxe_namespace_init(void)
-{
-	return register_pernet_subsys(&rxe_net_ops);
-}
-
-void rxe_namespace_exit(void)
-{
-	unregister_pernet_subsys(&rxe_net_ops);
-}
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.h b/drivers/infiniband/sw/rxe/rxe_ns.h
deleted file mode 100644
index 4da2709e6b71..000000000000
--- a/drivers/infiniband/sw/rxe/rxe_ns.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-
-#ifndef RXE_NS_H
-#define RXE_NS_H
-
-struct sock *rxe_ns_pernet_sk4(struct net *net);
-void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk);
-
-#if IS_ENABLED(CONFIG_IPV6)
-void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk);
-struct sock *rxe_ns_pernet_sk6(struct net *net);
-#else /* IPv6 */
-static inline struct sock *rxe_ns_pernet_sk6(struct net *net)
-{
-	return NULL;
-}
-
-static inline void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk)
-{
-}
-#endif /* IPv6 */
-
-int rxe_namespace_init(void);
-void rxe_namespace_exit(void);
-
-#endif /* RXE_NS_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 96c7716057fe..278da342ca1e 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1460,6 +1460,7 @@ static const struct ib_device_ops rxe_dev_ops = {
 	.driver_id = RDMA_DRIVER_RXE,
 	.uverbs_abi_ver = RXE_UVERBS_ABI_VERSION,
 
+	.add_gid = rxe_add_gid,
 	.alloc_hw_port_stats = rxe_ib_alloc_hw_port_stats,
 	.alloc_mr = rxe_alloc_mr,
 	.alloc_mw = rxe_alloc_mw,
@@ -1475,6 +1476,7 @@ static const struct ib_device_ops rxe_dev_ops = {
 	.dealloc_mw = rxe_dealloc_mw,
 	.dealloc_pd = rxe_dealloc_pd,
 	.dealloc_ucontext = rxe_dealloc_ucontext,
+	.del_gid = rxe_del_gid,
 	.dereg_mr = rxe_dereg_mr,
 	.destroy_ah = rxe_destroy_ah,
 	.destroy_cq = rxe_destroy_cq,

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.53.0

