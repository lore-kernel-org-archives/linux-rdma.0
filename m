Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116A23A8756;
	Mon, 19 Oct 2026 04:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792384356; cv=none; b=fiTr1hjlE3ps8H+ulnpP4fAXP+ylI+ukCABlO6ktB1IMmWFU6DvihnYd4I4/ldZ2tWuVF4PWznu3AzTYIl+jPd/VuhpRvh8r/xg+1zcTSzDS23vcGTQX8cFOTz0riQKxT5IymF4DTJu09+hhfW/smhWNVztnfy/iKBdZWWvYflY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792384356; c=relaxed/simple;
	bh=tCbT8qZv3KnB9a27lq/xJligLMw7fgL2mpBzU7PgkrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z/NAyv0szHiRdPwqfv1o2a8QhBRIsrpSGctUeAfuYBqbfQKMMi2xQDF4dubiDkOGBx0/8pwD212ZDs3/z13apAxJxNvutMcNetTeolKK69NviU34L0PfeRoPFnwm+sFkx0BM87z12vjit3C/8A+Whb42O28KR+/JVR5NYSQByhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=o+bRu9DI; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="o+bRu9DI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=5o
	h545sb/eMSgu56KNqxAk9hRVcUgeao4mc8tHKFbhw=; b=o+bRu9DIJK5SQCIBml
	DXbwF2qVNo9xgFzNTWiGnFxfHBP8aGkJdYcBoaSf3Jha+JgbzJFCULhvI+faWXI3
	JCWH5l0guFeBFM4FhYtMFopEaBv8bqbqMcW9CgW4243FYq/6r1qIOhIRSmMbPldX
	2gXwVhhx6i+to886I8BomFODs=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H19HndVqZpt1BA--.1993S2;
	Mon, 19 Oct 2026 12:32:07 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v3] RDMA/rxe: Fix use-after-free of the per-net tunnel socket
Date: Mon, 19 Oct 2026 12:32:04 +0800
Message-ID: <20261019043205.466134-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H19HndVqZpt1BA--.1993S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jw1xJF13CF1DZrWDKF1xXwb_yoW3Zr47pr
	WrKayYyrsrJr42vr43AF4jvr1Fv3Z3tFy3Gas7Kwnavan8uw43Xa47tryj9Fn5CrW8CF4U
	XF1kJF1vkw4rZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UwVysUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC+weIbGrVnUcUywAA3i

KASAN reported a slab-use-after-free in ip6_route_output_flags()
reached from rxe_find_route(): a user with CAP_NET_ADMIN can remove
an RXE device with "rdma link del rxe0" while RoCE v2 over IPv6
traffic keeps using the per-net tunnel socket for route lookups.

BUG: KASAN: slab-use-after-free in ip6_route_output_flags+0x300/0x360
Read of size 4 at addr ffff888115ddd794 by task kworker/u32:6/309
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 print_report+0xd0/0x630
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? ip6_route_output_flags+0x300/0x360
 kasan_report+0xce/0x100
 ? ip6_route_output_flags+0x300/0x360
 ip6_route_output_flags+0x300/0x360
 ip6_dst_lookup_tail.constprop.0+0x76c/0xcc0
 ? ct_nmi_exit+0xc3/0xf0
 ip6_dst_lookup_flow+0xf5/0x1e0
 ? __pfx_ip6_dst_lookup_flow+0x10/0x10
 rxe_find_route+0x426/0xa30
 ? __kasan_slab_alloc+0x6e/0x70
 ? __pfx_rxe_find_route+0x10/0x10
 ? kmem_cache_alloc_node_noprof+0x141/0x370
 ? kmalloc_reserve+0x103/0x2b0
 ? rxe_icrc_generate+0x229/0x330
 ? __pfx___alloc_skb+0x10/0x10
 rxe_prepare+0x9e8/0x18b0
 ? rxe_init_packet+0x3c7/0x4f0
 rxe_requester+0x1a0f/0x51f0
 ? rxe_completer+0x1de9/0x38c0
 ? __pfx_rxe_completer+0x10/0x10
 ? __queue_work+0x43e/0x11f0
 ? __pfx_rxe_requester+0x10/0x10
 ? irqentry_exit+0xd2/0x640
 ? _raw_spin_lock_irqsave+0x85/0xe0
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? __pfx_rxe_sender+0x10/0x10
 rxe_sender+0xe/0x30
 do_work+0x144/0x470
 process_one_work+0x633/0x1030
 ? assign_work+0x11d/0x370
 worker_thread+0x45b/0xd10
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2c6/0x3b0
 ? recalc_sigpending+0x15c/0x1e0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x36e/0x5a0
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x572/0xdd0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 146020:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x6e/0x70
 kmem_cache_alloc_noprof+0x130/0x360
 sk_prot_alloc+0x56/0x210

rxe_net_del() releases the tunnel socket before the device is torn
down: nldev_dellink() calls .dellink before unregistering the
device, and the NETDEV_UNREGISTER notifier calls rxe_net_del() right
after queueing the unregistration, so the rxe_sender() workqueue can
still perform route lookups while the socket is released.

Two gaps in the tunnel socket lifetime allow the use-after-free:

1. rxe_sock_put() released the socket with rxe_release_udp_tunnel()
   before the per-net pointer was cleared, so route lookups could
   fetch a socket that was already freed.

2. rxe_ns_pernet_sk4/6() return the raw socket pointer after
   rcu_read_unlock(), without taking a reference.  Readers like
   rxe_find_route6() dereference the pointer outside the RCU
   read-side critical section, so the synchronize_rcu() in
   rxe_ns_pernet_set_sk4/6() cannot protect a reader that already
   fetched the pointer, and ip6_route_output_flags() or
   xfrm_lookup_with_ifid() can still be using the socket while it
   is freed.

Fix both gaps:

- rxe_sock_put() clears the per-net pointer before it releases the
  socket, so no new lookup can fetch a socket that is being
  released;

- rxe_ns_pernet_sk4/6() take a reference on the socket with
  refcount_inc_not_zero() under rcu_read_lock(), and the callers
  sock_put() it after use.  The reference that rxe_net_ipv4/6_init()
  keeps now comes from the getter instead of an open-coded
  sock_hold() on the raw pointer, and rxe_sock_put() drops the
  getter's reference after the tunnel is released.  Since the
  reference is taken inside the RCU read-side critical section, the
  synchronize_rcu() after the pointer is cleared guarantees that
  every reader has finished taking its reference before the last
  reference is dropped, so the count never reaches zero while a
  reader still holds the pointer.

The remaining races on the tunnel socket lifetime (serialization of
rxe_net_init() against rxe_net_del(), a second rxe_net_del() of one
device from the NETDEV_UNREGISTER notifier, and the per-device
reference accounting of shared sockets) already exist in the code
this fixes and are left for a follow-up series.

Fixes: f1327abd6abe ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 29 ++++++++++++++++++++---------
 drivers/infiniband/sw/rxe/rxe_ns.c  | 10 ++++++++++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2..ec98133a6005 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -135,13 +135,20 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 {
 	struct dst_entry *ndst;
 	struct flowi6 fl6 = {};
+	struct sock *sk;
 
 	fl6.flowi6_oif = ndev->ifindex;
 	memcpy(&fl6.saddr, saddr, sizeof(*saddr));
 	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	ndst = ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);
+	/* keep the socket pinned while it is passed to the IPv6 routing
+	 * code which dereferences it outside of rcu_read_lock()
+	 */
+	sk = rxe_ns_pernet_sk6(net);
+	ndst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);
+	if (sk)
+		sock_put(sk);
 	if (IS_ERR(ndst)) {
 		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
 		return NULL;
@@ -638,9 +645,15 @@ static void rxe_sock_put(struct sock *sk,
 	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
 		__sock_put(sk);
 	} else {
+		/*
+		 * Clear the per-net pointer before the socket is released:
+		 * rxe_ns_pernet_sk4/6() take a reference on the socket, but
+		 * new lookups must not find it once it is being released.
+		 */
+		set_sk(net, NULL);
 		rxe_release_udp_tunnel(sk);
-		sk = NULL;
-		set_sk(net, sk);
+		/* drop the reference from rxe_ns_pernet_sk4/6() */
+		sock_put(sk);
 	}
 }
 
@@ -758,11 +771,10 @@ static int rxe_net_ipv4_init(struct net *net)
 	struct sock *sk;
 	struct socket *sock;
 
+	/* returns with a reference held for this device */
 	sk = rxe_ns_pernet_sk4(net);
-	if (sk) {
-		sock_hold(sk);
+	if (sk)
 		return 0;
-	}
 
 	sock = rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(sock)) {
@@ -780,11 +792,10 @@ static int rxe_net_ipv6_init(struct net *net)
 	struct sock *sk;
 	struct socket *sock;
 
+	/* returns with a reference held for this device */
 	sk = rxe_ns_pernet_sk6(net);
-	if (sk) {
-		sock_hold(sk);
+	if (sk)
 		return 0;
-	}
 
 	sock = rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), true);
 	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
index 64621c89f8bf..0a7d409c0f98 100644
--- a/drivers/infiniband/sw/rxe/rxe_ns.c
+++ b/drivers/infiniband/sw/rxe/rxe_ns.c
@@ -71,6 +71,12 @@ static struct pernet_operations rxe_net_ops = {
 	.size = sizeof(struct rxe_ns_sock),
 };
 
+/*
+ * Return the per-net tunnel socket with a reference taken, or NULL if
+ * the namespace has no tunnel socket.  The reference is taken under
+ * rcu_read_lock() so the socket cannot be freed while the pointer is
+ * still published; the caller must sock_put() it.
+ */
 struct sock *rxe_ns_pernet_sk4(struct net *net)
 {
 	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
@@ -78,6 +84,8 @@ struct sock *rxe_ns_pernet_sk4(struct net *net)
 
 	rcu_read_lock();
 	sk = rcu_dereference(ns_sk->rxe_sk4);
+	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
+		sk = NULL;
 	rcu_read_unlock();
 
 	return sk;
@@ -99,6 +107,8 @@ struct sock *rxe_ns_pernet_sk6(struct net *net)
 
 	rcu_read_lock();
 	sk = rcu_dereference(ns_sk->rxe_sk6);
+	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
+		sk = NULL;
 	rcu_read_unlock();
 
 	return sk;

