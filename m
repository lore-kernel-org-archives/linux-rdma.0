From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Wed,  7 Sep 2016 14:04:04 +0300
Message-ID: <1473246247-16536-2-git-send-email-leon@kernel.org>
References: <1473246247-16536-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Disable creation of a UDP socket for ipv6 when
CONFIG_IPV6 is not enabeld. Since udp_sock_create6()
returns 0 when CONFIG_IPV6 is not set

[   46.888632] IP: [<c220705a>] setup_udp_tunnel_sock+0x6/0x4f
[   46.891355] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
[   46.893918] Oops: 0002 [#1] PREEMPT
[   46.896014] CPU: 0 PID: 1 Comm: swapper Not tainted 4.7.0-rc4-00001-g8700e3e #1
[   46.900280] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[   46.904905] task: cf06c040 ti: cf05e000 task.ti: cf05e000
[   46.907854] EIP: 0060:[<c220705a>] EFLAGS: 00210246 CPU: 0
[   46.911137] EIP is at setup_udp_tunnel_sock+0x6/0x4f
[   46.914070] EAX: 00000044 EBX: 00000001 ECX: cf05fef0 EDX: ca8142e0
[   46.917236] ESI: c2c4505b EDI: cf05fef0 EBP: cf05fed0 ESP: cf05fed0
[   46.919836]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[   46.922046] CR0: 80050033 CR2: 000001fc CR3: 02cec000 CR4: 000006b0
[   46.924550] Stack:
[   46.926014]  cf05ff10 c1fd4657 ca8142e0 0000000a 00000000 00000000 0000b712 00000008
[   46.931274]  00000000 6bb5bd01 c1fd48de 00000000 00000000 cf05ff1c 00000000 00000000
[   46.936122]  cf05ff1c c1fd4bdf 00000000 cf05ff28 c2c4507b ffffffff cf05ff88 c2bf1c74
[   46.942350] Call Trace:
[   46.944403]  [<c1fd4657>] rxe_setup_udp_tunnel+0x8f/0x99
[   46.947689]  [<c1fd48de>] ? net_to_rxe+0x4e/0x4e
[   46.950567]  [<c1fd4bdf>] rxe_net_init+0xe/0xa4
[   46.953147]  [<c2c4507b>] rxe_module_init+0x20/0x4c
[   46.955448]  [<c2bf1c74>] do_one_initcall+0x89/0x113
[   46.957797]  [<c2bf15eb>] ? set_debug_rodata+0xf/0xf
[   46.959966]  [<c2bf1dbc>] ? kernel_init_freeable+0xbe/0x15b
[   46.962262]  [<c2bf1ddc>] kernel_init_freeable+0xde/0x15b
[   46.964418]  [<c232eb54>] kernel_init+0x8/0xd0
[   46.966618]  [<c2333122>] ret_from_kernel_thread+0xe/0x24
[   46.969592]  [<c232eb4c>] ? rest_init+0x6f/0x6f

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.c     | 25 +++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_net.c | 55 +++++++++++++++++--------------------
 drivers/infiniband/sw/rxe/rxe_net.h |  5 +++-
 3 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 55f0e8f..ddd5927 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -362,15 +362,34 @@ static int __init rxe_module_init(void)
 		return err;
 	}

-	err = rxe_net_init();
+	err = rxe_net_ipv4_init();
 	if (err) {
-		pr_err("rxe: unable to init\n");
+		pr_err("rxe: unable to init ipv4 tunnel\n");
 		rxe_cache_exit();
-		return err;
+		goto exit;
+	}
+
+	err = rxe_net_ipv6_init();
+	if (err) {
+		pr_err("rxe: unable to init ipv6 tunnel\n");
+		rxe_cache_exit();
+		goto exit;
 	}
+
+	err = register_netdevice_notifier(&rxe_net_notifier);
+	if (err) {
+		pr_err("rxe: Failed to rigister netdev notifier\n");
+		goto exit;
+	}
+
 	pr_info("rxe: loaded\n");

 	return 0;
+
+exit:
+	rxe_release_udp_tunnel(recv_sockets.sk4);
+	rxe_release_udp_tunnel(recv_sockets.sk6);
+	return err;
 }

 static void __exit rxe_module_exit(void)
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 0b8d2ea..eedf2f1 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -275,9 +275,10 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 	return sock;
 }

-static void rxe_release_udp_tunnel(struct socket *sk)
+void rxe_release_udp_tunnel(struct socket *sk)
 {
-	udp_tunnel_sock_release(sk);
+	if (sk)
+		udp_tunnel_sock_release(sk);
 }

 static void prepare_udp_hdr(struct sk_buff *skb, __be16 src_port,
@@ -658,51 +659,45 @@ out:
 	return NOTIFY_OK;
 }

-static struct notifier_block rxe_net_notifier = {
+struct notifier_block rxe_net_notifier = {
 	.notifier_call = rxe_notify,
 };

-int rxe_net_init(void)
+int rxe_net_ipv4_init(void)
 {
-	int err;
-
 	spin_lock_init(&dev_list_lock);

-	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
-			htons(ROCE_V2_UDP_DPORT), true);
-	if (IS_ERR(recv_sockets.sk6)) {
-		recv_sockets.sk6 = NULL;
-		pr_err("rxe: Failed to create IPv6 UDP tunnel\n");
-		return -1;
-	}
-
 	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
-			htons(ROCE_V2_UDP_DPORT), false);
+				htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(recv_sockets.sk4)) {
-		rxe_release_udp_tunnel(recv_sockets.sk6);
 		recv_sockets.sk4 = NULL;
-		recv_sockets.sk6 = NULL;
 		pr_err("rxe: Failed to create IPv4 UDP tunnel\n");
 		return -1;
 	}

-	err = register_netdevice_notifier(&rxe_net_notifier);
-	if (err) {
-		rxe_release_udp_tunnel(recv_sockets.sk6);
-		rxe_release_udp_tunnel(recv_sockets.sk4);
-		pr_err("rxe: Failed to rigister netdev notifier\n");
-	}
-
-	return err;
+	return 0;
 }

-void rxe_net_exit(void)
+int rxe_net_ipv6_init(void)
 {
-	if (recv_sockets.sk6)
-		rxe_release_udp_tunnel(recv_sockets.sk6);
+#if IS_ENABLED(CONFIG_IPV6)

-	if (recv_sockets.sk4)
-		rxe_release_udp_tunnel(recv_sockets.sk4);
+	spin_lock_init(&dev_list_lock);

+	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
+						htons(ROCE_V2_UDP_DPORT), true);
+	if (IS_ERR(recv_sockets.sk6)) {
+		recv_sockets.sk6 = NULL;
+		pr_err("rxe: Failed to create IPv6 UDP tunnel\n");
+		return -1;
+	}
+#endif
+	return 0;
+}
+
+void rxe_net_exit(void)
+{
+	rxe_release_udp_tunnel(recv_sockets.sk6);
+	rxe_release_udp_tunnel(recv_sockets.sk4);
 	unregister_netdevice_notifier(&rxe_net_notifier);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index 7b06f76..0daf7f0 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -44,10 +44,13 @@ struct rxe_recv_sockets {
 };

 extern struct rxe_recv_sockets recv_sockets;
+extern struct notifier_block rxe_net_notifier;
+void rxe_release_udp_tunnel(struct socket *sk);

 struct rxe_dev *rxe_net_add(struct net_device *ndev);

-int rxe_net_init(void);
+int rxe_net_ipv4_init(void);
+int rxe_net_ipv6_init(void);
 void rxe_net_exit(void);

 #endif /* RXE_NET_H */
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
