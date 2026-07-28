Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C4736197D
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255340; cv=none; b=rL1YPtlJ1aNaBjYaLvNkc8mYHh/BZPVUgb9gWU81wKvf69lEJ6Rch4bb4wuLBiomdS9ejbAQ8dMfQBgCbuP3cpky/a1nMQ4CktTZp5tfbE3kNqaOr8QqHLutPqHOEC/dV7F8fsu8Gux41M5tYWu4tS3zL4FWtFk4Ay3lwArn0kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255340; c=relaxed/simple;
	bh=9kdHgSNMqCZ5zMgB6ekr8AYJ6kF89Kp+RNMbCK8A5lA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OJ00wdWkaunKqmrOR72T0MnWhBHLHGuvRmJrAdHuQXcy4q+utnpvU1T29apKO5yo5+lwSv3p6ZcJM85+DocD6sOcBjJn1WhJyBZBw5+newABlxqW8YWiIKK3VLnn/43Tx82uH4A+vQxG8J/xCp96sZPcIyzZz3oDP7r5qUDa7+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HGTgWXxH; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HGTgWXxH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=Gw5Kk1ctJSBL3LoteJSdI4mYYZ1lDNnXDuJ7nDDsChY=;
	b=HGTgWXxHjwyHNbG0i4zlwuEABVYKhkTqjcx80z6wBF64G0adqBBGqRKJPnx843
	P4gRAteJsA0oq2jUNWjZ1tnbMi9PSPkfhv/V31k5YTAvi9TMt8lpVl4RfzSZsty6
	dEefw2qLZxGpThgXvJBxGbAPBRY7tX5u/mpXnm6zLlcng=
Received: from [IPV6:2601:647:6300:a030:7959:7dea:e154:d7cf] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDXvwGB1WhqAUyGLw--.37939S2;
	Wed, 29 Jul 2026 00:15:00 +0800 (CST)
Message-ID: <c225c004-1fa9-4010-a843-8be033003e93@163.com>
Date: Tue, 28 Jul 2026 09:14:55 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
To: Serhat Kumral <serhatkumral1@gmail.com>, yanjun.zhu@linux.dev
Cc: zyjzyj2000@gmail.com, Jason Gunthorpe <jgg@ziepe.ca>,
 "leon@kernel.org" <leon@kernel.org>, David Ahern <dsahern@kernel.org>,
 RDMA mailing list <linux-rdma@vger.kernel.org>
References: <95b8e484-c0d1-4973-b752-c93fb4cae1f4@linux.dev>
 <20260727220531.36724-1-serhatkumral1@gmail.com>
From: Zhu Yanjun <mounter625@163.com>
In-Reply-To: <20260727220531.36724-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXvwGB1WhqAUyGLw--.37939S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfurWkGFWDurW5KF4UAFy8AFb_yoW8tw1Duo
	Z7Jrn3Jw10yryxX397Ka48JFyjv3ZrGwsxJr43Kws09ayrtay8CrySy3W5J3y3WF1rGFW8
	Zr17G3yjkF4kWFn3n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUefHjUUUUU
X-CM-SenderInfo: hprx03thuwjki6rwjhhfrp/xtbC7whMhGpo1Yi1WAAA3d


在 2026/7/27 15:05, Serhat Kumral 写道:
> Thanks, that helps.
>
>> c7b5816e800a (HEAD -> master) Merge branch 'master' of
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
>> 668b9a3b586c RDMA/rxe: Hold netdev reference for transmit skbs
> So the committed tree appears to be f2ec6312bf71 plus the netdev
> reference patch, which matches one of the four kernels I ran. The command
> line has no allocator or KASAN parameters. It does differ from mine in
> timing: there is no console= at all, while my runs write every printk to
> a serial console, so my kernel is the slower of the two. I repeated the
> run with a quiet console, and it still passes 100/100.
>
> This series does not appear in that log, so I assume it is applied to the
> working tree. That is the part I cannot match: a plain git apply fails in
> both orders, as described in the last mail, so however it was fitted in,
> the resulting rxe_notify() decides whether the tunnel sockets are
> released by del_gid alone or also through the old rxe_net_del() path.
>
> Could you send
>
>    git diff HEAD
diff --git a/drivers/infiniband/core/nldev.c 
b/drivers/infiniband/core/nldev.c
index 02a0a9c0a4a6..b65075c821d5 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -51,7 +51,6 @@
   * a controlled QKEY.
   */
  static bool privileged_qkey;
-static DEFINE_MUTEX(nldev_dellink_mutex);

  typedef int (*res_fill_func_t)(struct sk_buff*, bool,
                                struct rdma_restrack_entry*, uint32_t);
@@ -1843,20 +1842,6 @@ static int nldev_dellink(struct sk_buff *skb, 
struct nlmsghdr *nlh,
                 return -EINVAL;
         }

-       /*
-        * This path is triggered by the 'rdma link delete' 
administrative command.
-        * For Soft-RoCE (RXE), we ensure that transport sockets are 
closed here.
-        * Note: iWARP driver does not implement .dellink, so this logic is
-        * implicitly scoped to the driver supporting dynamic link 
deletion like RXE.
-        */
-       if (device->link_ops && device->link_ops->dellink) {
-               mutex_lock(&nldev_dellink_mutex);
-               err = device->link_ops->dellink(device);
-               mutex_unlock(&nldev_dellink_mutex);
-               if (err)
-                       return err;
-       }
-
         ib_unregister_device_and_put(device);
         return 0;
  }
diff --git a/drivers/infiniband/sw/rxe/Makefile 
b/drivers/infiniband/sw/rxe/Makefile
index e097c1ca1874..18ff60542744 100644
--- a/drivers/infiniband/sw/rxe/Makefile
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -23,7 +23,6 @@ rdma_rxe-y := \
         rxe_task.o \
         rxe_net.o \
         rxe_hw_counters.o \
-       rxe_mad.o \
-       rxe_ns.o
+       rxe_mad.o

  rdma_rxe-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += rxe_odp.o
diff --git a/drivers/infiniband/sw/rxe/rxe.c 
b/drivers/infiniband/sw/rxe/rxe.c
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
@@ -202,8 +201,6 @@ void rxe_set_mtu(struct rxe_dev *rxe, unsigned int 
ndev_mtu)
         port->mtu_cap = ib_mtu_enum_to_int(mtu);
  }

-static struct rdma_link_ops rxe_link_ops;
-
  /* called by ifc layer to create new rxe device.
   * The caller should allocate memory for rxe by calling ib_alloc_device.
   */
@@ -212,7 +209,6 @@ int rxe_add(struct rxe_dev *rxe, unsigned int mtu, 
const char *ibdev_name,
  {
         rxe_init(rxe, ndev);
         rxe_set_mtu(rxe, mtu);
-       rxe->ib_dev.link_ops = &rxe_link_ops;

         return rxe_register_device(rxe, ibdev_name, ndev);
  }
@@ -236,10 +232,6 @@ static int rxe_newlink(const char *ibdev_name, 
struct net_device *ndev)
                 goto err;
         }

-       err = rxe_net_init(ndev);
-       if (err)
-               return err;
-
         err = rxe_net_add(ibdev_name, ndev);
         if (err) {
                 rxe_err("failed to add %s\n", ndev->name);
@@ -249,17 +241,9 @@ static int rxe_newlink(const char *ibdev_name, 
struct net_device *ndev)
         return err;
  }

-static int rxe_dellink(struct ib_device *dev)
-{
-       rxe_net_del(dev);
-
-       return 0;
-}
-
  static struct rdma_link_ops rxe_link_ops = {
         .type = "rxe",
         .newlink = rxe_newlink,
-       .dellink = rxe_dellink,
  };

  static int __init rxe_module_init(void)
@@ -270,21 +254,15 @@ static int __init rxe_module_init(void)
         if (err)
                 return err;

-       err = rxe_namespace_init();
-       if (err)
-               goto err_destroy_wq;
-
         err = rxe_register_notifier();
         if (err)
-               goto err_namespace_exit;
+               goto err_destroy_wq;

         rdma_link_register(&rxe_link_ops);

         pr_info("loaded\n");
         return 0;

-err_namespace_exit:
-       rxe_namespace_exit();
  err_destroy_wq:
         rxe_destroy_wq();
         return err;
@@ -297,8 +275,6 @@ static void __exit rxe_module_exit(void)
         rxe_net_exit();
         rxe_destroy_wq();

-       rxe_namespace_exit();
-
         pr_info("unloaded\n");
  }

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c 
b/drivers/infiniband/sw/rxe/rxe_net.c
index 44a16cb1601a..3b8828316e25 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -17,11 +17,6 @@
  #include "rxe.h"
  #include "rxe_net.h"
  #include "rxe_loc.h"
-#include "rxe_ns.h"
-
-#ifndef SK_REF_FOR_TUNNEL
-#define SK_REF_FOR_TUNNEL      2
-#endif

  #ifdef CONFIG_DEBUG_LOCK_ALLOC
  /*
@@ -81,9 +76,10 @@ static inline void rxe_reclassify_recv_socket(struct 
socket *sock)
          * from being called and 'rmmod rdma_rxe'
          * is refused because of the references.
          *
-        * For the global sockets in recv_sockets,
-        * we are sure that rxe_net_exit() will call
-        * rxe_release_udp_tunnel -> udp_tunnel_sock_release.
+        * For the shared tunnel sockets, we are sure
+        * that udp_tunnel_sock_release is called,
+        * normally by the last rxe_del_gid() and at
+        * the latest by the pernet exit backstop.
          *
          * So we don't need the additional reference to
          * our own (THIS_MODULE).
@@ -141,7 +137,7 @@ static struct dst_entry *rxe_find_route6(struct 
rxe_qp *qp,
         memcpy(&fl6.daddr, daddr, sizeof(*daddr));
         fl6.flowi6_proto = IPPROTO_UDP;

-       ndst = ip6_dst_lookup_flow(net, rxe_ns_pernet_sk6(net), &fl6, NULL);
+       ndst = ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
         if (IS_ERR(ndst)) {
                 rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
                 return NULL;
@@ -288,10 +284,204 @@ static struct socket *rxe_setup_udp_tunnel(struct 
net *net, __be16 port,
         return sock;
  }

-static void rxe_release_udp_tunnel(struct sock *sk)
+/*
+ * The wildcard tunnel sockets are shared by every RoCEv2 GID entry in
+ * a netns. Their lifetime is driven by add_gid/del_gid: the first GID
+ * entry of an address family creates the socket and normally the last
+ * one releases it; the pernet exit hook below can get there first
+ * when the netns dies. The GID table guarantees one del_gid for
+ * every successfully installed GID entry, so the counts cannot
+ * underflow and nothing else needs to manage the sockets: when an
+ * address, a netdev or the whole netns goes away, the core removes
+ * the GID entries and the sockets follow.
+ *
+ * The per netns state lives in a small global list instead of pernet
+ * storage: an entry exists only while the netns has RoCEv2 GID
+ * entries. Event-triggered GID removal is asynchronous, so a netns
+ * can be torn down before the last del_gid has run; the pernet exit
+ * hook closes the sockets before the net is freed and invalidates
+ * the entry's key so it cannot match a recycled net pointer, and the
+ * remaining del_gid calls only drop the counts.
+ */
+struct rxe_ns_sock {
+       struct list_head node;
+       struct net *net;
+       struct socket *sk4;
+       struct socket *sk6;
+       int nr4;
+       int nr6;
+};
+
+static DEFINE_MUTEX(rxe_ns_lock);
+static LIST_HEAD(rxe_ns_list);
+
+static struct rxe_ns_sock *rxe_ns_find(struct net *net)
  {
-       if (sk)
-               udp_tunnel_sock_release(sk);
+       struct rxe_ns_sock *ns;
+
+       lockdep_assert_held(&rxe_ns_lock);
+
+       list_for_each_entry(ns, &rxe_ns_list, node)
+               if (ns->net == net)
+                       return ns;
+
+       return NULL;
+}
+
+/*
+ * Close the sockets of a dying netns before the net is freed. This
+ * only matters when GID entries still reference the netns at that
+ * point, e.g. after a netdev was moved to another netns and the
+ * queued removal of its GID entries has not run yet. Clearing
+ * ns->net keeps the entry from matching a recycled net pointer; the
+ * outstanding del_gid calls drop the counts and free it.
+ */
+static void __net_exit rxe_ns_exit(struct net *net)
+{
+       struct rxe_ns_sock *ns;
+
+       mutex_lock(&rxe_ns_lock);
+       ns = rxe_ns_find(net);
+       if (ns) {
+               if (ns->sk4)
+                       udp_tunnel_sock_release(ns->sk4->sk);
+               if (ns->sk6)
+                       udp_tunnel_sock_release(ns->sk6->sk);
+               ns->sk4 = NULL;
+               ns->sk6 = NULL;
+               ns->net = NULL;
+       }
+       mutex_unlock(&rxe_ns_lock);
+}
+
+static struct pernet_operations rxe_pernet_ops = {
+       .exit = rxe_ns_exit,
+};
+
+int rxe_add_gid(const struct ib_gid_attr *attr, void **context)
+{
+       bool ipv6 = rdma_gid_attr_network_type(attr) == RDMA_NETWORK_IPV6;
+       __be16 port = htons(ROCE_V2_UDP_DPORT);
+       struct net_device *ndev;
+       struct rxe_ns_sock *ns;
+       struct socket *sock;
+       struct net *net;
+       int err = 0;
+
+       *context = NULL;
+
+       /* Only RoCEv2 GIDs use a UDP tunnel socket. */
+       if (attr->gid_type != IB_GID_TYPE_ROCE_UDP_ENCAP)
+               return 0;
+
+       /*
+        * Hold the netns across the socket setup; this also fails
+        * instead of binding a new socket in a netns that is already
+        * being dismantled.
+        */
+       rcu_read_lock();
+       ndev = rcu_dereference(attr->ndev);
+       net = ndev ? maybe_get_net(dev_net_rcu(ndev)) : NULL;
+       rcu_read_unlock();
+       if (!net)
+               return -ENODEV;
+
+       mutex_lock(&rxe_ns_lock);
+       ns = rxe_ns_find(net);
+       if (!ns) {
+               ns = kzalloc_obj(*ns);
+               if (!ns) {
+                       err = -ENOMEM;
+                       goto out_unlock;
+               }
+               ns->net = net;
+               list_add(&ns->node, &rxe_ns_list);
+       }
+
+       if (ipv6) {
+               if (!ns->nr6) {
+                       sock = rxe_setup_udp_tunnel(net, port, true);
+                       if (IS_ERR(sock)) {
+                               err = PTR_ERR(sock);
+                               /*
+                                * No IPv6 support: leave this GID entry
+                                * without a socket and without a count;
+                                * rxe_del_gid() skips a NULL context.
+                                */
+                               if (err == -EAFNOSUPPORT ||
+                                   err == -EPFNOSUPPORT)
+                                       err = 0;
+                               goto out_free;
+                       }
+                       ns->sk6 = sock;
+               }
+               ns->nr6++;
+       } else {
+               if (!ns->nr4) {
+                       sock = rxe_setup_udp_tunnel(net, port, false);
+                       if (IS_ERR(sock)) {
+                               err = PTR_ERR(sock);
+                               goto out_free;
+                       }
+                       ns->sk4 = sock;
+               }
+               ns->nr4++;
+       }
+       mutex_unlock(&rxe_ns_lock);
+
+       put_net(net);
+       *context = ns;
+       return 0;
+
+out_free:
+       if (!ns->nr4 && !ns->nr6) {
+               list_del(&ns->node);
+               kfree(ns);
+       }
+out_unlock:
+       mutex_unlock(&rxe_ns_lock);
+       put_net(net);
+       return err;
+}
+
+int rxe_del_gid(const struct ib_gid_attr *attr, void **context)
+{
+       bool ipv6 = rdma_gid_attr_network_type(attr) == RDMA_NETWORK_IPV6;
+       struct rxe_ns_sock *ns = *context;
+       struct socket *sock = NULL;
+
+       if (!ns)
+               return 0;
+
+       *context = NULL;
+
+       mutex_lock(&rxe_ns_lock);
+       if (ipv6) {
+               if (!WARN_ON_ONCE(!ns->nr6) && !--ns->nr6) {
+                       sock = ns->sk6;
+                       ns->sk6 = NULL;
+               }
+       } else {
+               if (!WARN_ON_ONCE(!ns->nr4) && !--ns->nr4) {
+                       sock = ns->sk4;
+                       ns->sk4 = NULL;
+               }
+       }
+       /*
+        * Release under the lock: a concurrent rxe_add_gid() must not
+        * see a zero count while the old socket still holds the port,
+        * or its bind() fails with -EADDRINUSE.
+        */
+       if (sock)
+               udp_tunnel_sock_release(sock->sk);
+
+       if (!ns->nr4 && !ns->nr6) {
+               list_del(&ns->node);
+               kfree(ns);
+       }
+       mutex_unlock(&rxe_ns_lock);
+
+       return 0;
  }

  static void prepare_udp_hdr(struct sk_buff *skb, __be16 src_port,
@@ -647,42 +837,6 @@ int rxe_net_add(const char *ibdev_name, struct 
net_device *ndev)
         return 0;
  }

-static void rxe_sock_put(struct sock *sk,
-                                       void (*set_sk)(struct net *, 
struct sock *),
-                                       struct net *net)
-{
-       if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
-               __sock_put(sk);
-       } else {
-               rxe_release_udp_tunnel(sk);
-               sk = NULL;
-               set_sk(net, sk);
-       }
-}
-
-void rxe_net_del(struct ib_device *dev)
-{
-       struct net_device *ndev;
-       struct sock *sk;
-       struct net *net;
-
-       ndev = ib_device_get_netdev(dev, 1);
-       if (!ndev)
-               return;
-
-       net = dev_net(ndev);
-
-       sk = rxe_ns_pernet_sk4(net);
-       if (sk)
-               rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);
-
-       sk = rxe_ns_pernet_sk6(net);
-       if (sk)
-               rxe_sock_put(sk, rxe_ns_pernet_set_sk6, net);
-
-       dev_put(ndev);
-}
-
  static void rxe_port_event(struct rxe_dev *rxe,
                            enum ib_event_type event)
  {
@@ -766,7 +920,6 @@ static int rxe_notify(struct notifier_block *not_blk,
         case NETDEV_UNREGISTER:
                 rxe_flush_qps(rxe);
                 ib_unregister_device_queued(&rxe->ib_dev);
-               rxe_net_del(&rxe->ib_dev);
                 break;
         case NETDEV_CHANGEMTU:
                 rxe_dbg_dev(rxe, "%s changed mtu to %d\n", ndev->name, 
ndev->mtu);
@@ -795,63 +948,24 @@ static struct notifier_block rxe_net_notifier = {
         .notifier_call = rxe_notify,
  };

-static int rxe_net_ipv4_init(struct net *net)
-{
-       struct sock *sk;
-       struct socket *sock;
-
-       sk = rxe_ns_pernet_sk4(net);
-       if (sk) {
-               sock_hold(sk);
-               return 0;
-       }
-
-       sock = rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), false);
-       if (IS_ERR(sock)) {
-               pr_err("Failed to create IPv4 UDP tunnel\n");
-               return -1;
-       }
-       rxe_ns_pernet_set_sk4(net, sock->sk);
-
-       return 0;
-}
-
-static int rxe_net_ipv6_init(struct net *net)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-       struct sock *sk;
-       struct socket *sock;
-
-       sk = rxe_ns_pernet_sk6(net);
-       if (sk) {
-               sock_hold(sk);
-               return 0;
-       }
-
-       sock = rxe_setup_udp_tunnel(net, htons(ROCE_V2_UDP_DPORT), true);
-       if (PTR_ERR(sock) == -EAFNOSUPPORT) {
-               pr_warn("IPv6 is not supported, can not create a UDPv6 
socket\n");
-               return 0;
-       }
-
-       if (IS_ERR(sock)) {
-               pr_err("Failed to create IPv6 UDP tunnel\n");
-               return -1;
-       }
-
-       rxe_ns_pernet_set_sk6(net, sock->sk);
-
-#endif
-       return 0;
-}
-
  int rxe_register_notifier(void)
  {
         int err;

+       /*
+        * A pernet subsys, not a pernet device: its exit hook must run
+        * after the netdev cleanup of a dying netns, which waits for
+        * the GID entries' netdev references and thus for the del_gid
+        * calls that normally release the sockets.
+        */
+       err = register_pernet_subsys(&rxe_pernet_ops);
+       if (err)
+               return err;
+
         err = register_netdevice_notifier(&rxe_net_notifier);
         if (err) {
                 pr_err("Failed to register netdev notifier\n");
+               unregister_pernet_subsys(&rxe_pernet_ops);
                 return -1;
         }

@@ -861,31 +975,8 @@ int rxe_register_notifier(void)
  void rxe_net_exit(void)
  {
         unregister_netdevice_notifier(&rxe_net_notifier);
-}
-
-int rxe_net_init(struct net_device *ndev)
-{
-       struct net *net;
-       struct sock *sk;
-       int err;
-
-       net = dev_net(ndev);
-
-       err = rxe_net_ipv4_init(net);
-       if (err)
-               return err;
-
-       err = rxe_net_ipv6_init(net);
-       if (err)
-               goto err_out;
+       unregister_pernet_subsys(&rxe_pernet_ops);

-       return 0;
-
-err_out:
-       /* If ipv6 error, release ipv4 resource */
-       sk = rxe_ns_pernet_sk4(net);
-       if (sk)
-               rxe_sock_put(sk, rxe_ns_pernet_set_sk4, net);
-
-       return err;
+       /* all devices and thus all GID entries are gone by now */
+       WARN_ON(!list_empty(&rxe_ns_list));
  }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h 
b/drivers/infiniband/sw/rxe/rxe_net.h
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
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c 
b/drivers/infiniband/sw/rxe/rxe_ns.c
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
-       struct sock __rcu *rxe_sk4;
-       struct sock __rcu *rxe_sk6;
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
-       /* defer socket create in the namespace to the first
-        * device create.
-        */
-
-       return 0;
-}
-
-static void rxe_ns_exit(struct net *net)
-{
-       /* called when the network namespace is removed
-        */
-       struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-       struct sock *sk;
-
-       rcu_read_lock();
-       sk = rcu_dereference(ns_sk->rxe_sk4);
-       rcu_read_unlock();
-       if (sk) {
-               rcu_assign_pointer(ns_sk->rxe_sk4, NULL);
-               udp_tunnel_sock_release(sk);
-       }
-
-#if IS_ENABLED(CONFIG_IPV6)
-       rcu_read_lock();
-       sk = rcu_dereference(ns_sk->rxe_sk6);
-       rcu_read_unlock();
-       if (sk) {
-               rcu_assign_pointer(ns_sk->rxe_sk6, NULL);
-               udp_tunnel_sock_release(sk);
-       }
-#endif
-}
-
-/*
- * callback to make the module network namespace aware
- */
-static struct pernet_operations rxe_net_ops = {
-       .init = rxe_ns_init,
-       .exit = rxe_ns_exit,
-       .id = &rxe_pernet_id,
-       .size = sizeof(struct rxe_ns_sock),
-};
-
-struct sock *rxe_ns_pernet_sk4(struct net *net)
-{
-       struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-       struct sock *sk;
-
-       rcu_read_lock();
-       sk = rcu_dereference(ns_sk->rxe_sk4);
-       rcu_read_unlock();
-
-       return sk;
-}
-
-void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk)
-{
-       struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-
-       rcu_assign_pointer(ns_sk->rxe_sk4, sk);
-       synchronize_rcu();
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-struct sock *rxe_ns_pernet_sk6(struct net *net)
-{
-       struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-       struct sock *sk;
-
-       rcu_read_lock();
-       sk = rcu_dereference(ns_sk->rxe_sk6);
-       rcu_read_unlock();
-
-       return sk;
-}
-
-void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk)
-{
-       struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
-
-       rcu_assign_pointer(ns_sk->rxe_sk6, sk);
-       synchronize_rcu();
-}
-#endif /* IPV6 */
-
-int rxe_namespace_init(void)
-{
-       return register_pernet_subsys(&rxe_net_ops);
-}
-
-void rxe_namespace_exit(void)
-{
-       unregister_pernet_subsys(&rxe_net_ops);
-}
diff --git a/drivers/infiniband/sw/rxe/rxe_ns.h 
b/drivers/infiniband/sw/rxe/rxe_ns.h
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
-       return NULL;
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
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c 
b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 1ec130fee8ea..7954c2f2fd47 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1456,6 +1456,7 @@ static const struct ib_device_ops rxe_dev_ops = {
         .driver_id = RDMA_DRIVER_RXE,
         .uverbs_abi_ver = RXE_UVERBS_ABI_VERSION,

+       .add_gid = rxe_add_gid,
         .alloc_hw_port_stats = rxe_ib_alloc_hw_port_stats,
         .alloc_mr = rxe_alloc_mr,
         .alloc_mw = rxe_alloc_mw,
@@ -1471,6 +1472,7 @@ static const struct ib_device_ops rxe_dev_ops = {
         .dealloc_mw = rxe_dealloc_mw,
         .dealloc_pd = rxe_dealloc_pd,
         .dealloc_ucontext = rxe_dealloc_ucontext,
+       .del_gid = rxe_del_gid,
         .dereg_mr = rxe_dereg_mr,
         .destroy_ah = rxe_destroy_ah,
         .destroy_cq = rxe_destroy_cq,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 794746de8db0..620f00f5d026 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2984,8 +2984,6 @@ struct ib_device {
         struct completion unreg_completion;
         struct work_struct unregistration_work;

-       const struct rdma_link_ops *link_ops;
-
         /* Protects compat_devs xarray modifications */
         struct mutex compat_devs_mutex;
         /* Maintains compat devices for each net namespace */
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 2fd1358ea57d..d1a7186f7436 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -127,7 +127,6 @@ struct rdma_link_ops {
         struct list_head list;
         const char *type;
         int (*newlink)(const char *ibdev_name, struct net_device *ndev);
-       int (*dellink)(struct ib_device *dev);
  };

  void rdma_link_register(struct rdma_link_ops *ops);

>
> from that tree, or at least the resulting function:
>
>    sed -n '/^static int rxe_notify/,/^}/p' drivers/infiniband/sw/rxe/rxe_net.c
# sed -n '/^static int rxe_notify/,/^}/p' 
drivers/infiniband/sw/rxe/rxe_net.c
static int rxe_notify(struct notifier_block *not_blk,
                       unsigned long event,
                       void *arg)
{
         struct net_device *ndev = netdev_notifier_info_to_dev(arg);
         struct rxe_dev *rxe = rxe_get_dev_from_net(ndev);

         if (!rxe)
                 return NOTIFY_OK;

         switch (event) {
         case NETDEV_GOING_DOWN:
                 /* Start draining TX queues before the netdev 
disappears. */
                 rxe_flush_qps(rxe);
                 break;
         case NETDEV_UNREGISTER:
                 rxe_flush_qps(rxe);
                 ib_unregister_device_queued(&rxe->ib_dev);
                 break;
         case NETDEV_CHANGEMTU:
                 rxe_dbg_dev(rxe, "%s changed mtu to %d\n", ndev->name, 
ndev->mtu);
                 rxe_set_mtu(rxe, ndev->mtu);
                 break;
         case NETDEV_DOWN:
         case NETDEV_CHANGE:
                 if (ib_get_curr_port_state(ndev) == IB_PORT_DOWN)
                         rxe_counter_inc(rxe, RXE_CNT_LINK_DOWNED);
                 break;
         case NETDEV_REBOOT:
         case NETDEV_CHANGEADDR:
         case NETDEV_CHANGENAME:
         case NETDEV_FEAT_CHANGE:
         default:
                 rxe_dbg_dev(rxe, "ignoring netdev event = %ld for %s\n",
                         event, ndev->name);
                 break;
         }

         ib_device_put(&rxe->ib_dev);
         return NOTIFY_OK;
}

>
> ("git diff" alone would miss anything that ended up staged.) If it
> matches what I built, the difference is somewhere I have not looked yet.
> It would also help to know whether the crash still reproduces there
> today.
>
> thanks,
> serhat

