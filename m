From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma_rxe: Fix kernel crash when IPV6 disabled.
Date: Sat, 24 Sep 2016 15:24:34 +0000
Message-ID: <1474730674-4017-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes below kernel crash when CONFIG_IPV6 is disabled by
avoiding ip6 socket initialization.

Additionally it has below minor related cleanup around recv_sockets elements.

1. Avoid extern for structure which is locally used in file
2. Define recv_sockets as static as its used by single file
3. Follow reverse deallocation order than allocation order for
recv_sockets elements

kernel: [  348.527616] general protection fault: 0000 [#1] SMP
kernel: [  348.528052] Modules linked in: rdma_rxe(+) udp_tunnel ib_core binfmt_misc dm_mirror dm_region_hash dm_log dm_mod mousedev psmouse sg pcspkr evdev floppy button acpi_cpufreq ext4(E) crc16(E) jbd2(E) mbcache(E) sd_mod(E) ata_piix(E) libata(E) scsi_mod(E)
kernel: [  348.528052] CPU: 0 PID: 2561 Comm: modprobe Tainted: G            E   4.8.0-rc6+ #8
kernel: [  348.528052] task: ffff880037af1d80 task.stack: ffff88003df50000
kernel: [  348.528052] RIP: 0010:[<ffffffffa03212bd>]  [<ffffffffa03212bd>] setup_udp_tunnel_sock+0xd/0x70 [udp_tunnel]
kernel: [  348.528052] RSP: 0018:ffff88003df53c38  EFLAGS: 00010202
kernel: [  348.528052] RAX: 840fc28949c08548 RBX: 0000000000000000 RCX: 00000000685eba97
kernel: [  348.528052] RDX: ffff88003df53c68 RSI: ffffffff81197185 RDI: ffffffff81acc800
kernel: [  348.528052] RBP: ffff88003df53c38 R08: 000000000001b1c0 R09: ffffffff812ef300
kernel: [  348.528052] R10: ffff88003e21b1c0 R11: ffffea0000f36000 R12: ffffffffa033e000
kernel: [  348.528052] R13: ffffffffa0339c10 R14: ffff88003d17b240 R15: ffffffffa0339bc0
kernel: [  348.528052] FS:  00007f910f913740(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
kernel: [  348.528052] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [  348.528052] CR2: 00007f910eac0000 CR3: 0000000037a07000 CR4: 00000000001406f0
kernel: [  348.528052] Stack:
kernel: [  348.528052]  ffff88003df53ca0 ffffffffa0331fbb ffffffff81197185 0000000a00000000
kernel: [  348.528052]  0000000000000000 000000080000b712 0000000000000000 ffffffffa0335701
kernel: [  348.528052]  ffffffffa0332320 0000000000000000 ffff88003d17b240 ffffffffa0339bc0
kernel: [  348.528052] Call Trace:
kernel: [  348.528052]  [<ffffffffa0331fbb>] rxe_setup_udp_tunnel.constprop.14+0x6b/0xc0 [rdma_rxe]
kernel: [  348.528052]  [<ffffffff81197185>] ? kmem_cache_create+0x85/0x1c0
kernel: [  348.528052]  [<ffffffffa0332320>] ? net_to_rxe+0x80/0x80 [rdma_rxe]
kernel: [  348.528052]  [<ffffffffa03326de>] rxe_net_init+0x1e/0xe0 [rdma_rxe]
kernel: [  348.528052]  [<ffffffffa033e027>] rxe_module_init+0x27/0x57 [rdma_rxe]
kernel: [  348.528052]  [<ffffffff8100214d>] do_one_initcall+0x3d/0x160
kernel: [  348.528052]  [<ffffffff811b4145>] ? __vunmap+0x85/0xd0
kernel: [  348.528052]  [<ffffffff811b41fe>] ? vfree+0x2e/0x70
kernel: [  348.528052]  [<ffffffff8116ce63>] do_init_module+0x60/0x1e0
kernel: [  348.528052]  [<ffffffff810ec622>] load_module+0x1dc2/0x2650
kernel: [  348.528052]  [<ffffffff810e9970>] ? __symbol_put+0x40/0x40
kernel: [  348.528052]  [<ffffffff810ecfae>] SYSC_init_module+0xfe/0x110
kernel: [  348.528052]  [<ffffffff810ed07e>] SyS_init_module+0xe/0x10
kernel: [  348.528052]  [<ffffffff81502df2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
kernel: [  348.528052] Code: ca 0e 10 e1 48 89 df e8 32 22 10 e1 5b 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 46 20 55 48 89 e5 <80> a0 d0 02 00 00 ef 80 80 d3 02 00 00 01 48 8b 0a 48 89 88 28
kernel: [  348.528052] RIP  [<ffffffffa03212bd>] setup_udp_tunnel_sock+0xd/0x70 [udp_tunnel]
kernel: [  348.528052]  RSP <ffff88003df53c38>
kernel: [  348.772092] ---[ end trace 432dfe51deb7b58e ]---

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 20 +++++++++-----------
 drivers/infiniband/sw/rxe/rxe_net.h |  2 --
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 0b8d2ea..dc9851f 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -48,6 +48,8 @@
 static LIST_HEAD(rxe_dev_list);
 static spinlock_t dev_list_lock; /* spinlock for device list */
 
+static struct rxe_recv_sockets recv_sockets;
+
 struct rxe_dev *net_to_rxe(struct net_device *ndev)
 {
 	struct rxe_dev *rxe;
@@ -81,9 +83,6 @@ struct rxe_dev *get_rxe_by_name(const char* name)
 	return found;
 }
 
-
-struct rxe_recv_sockets recv_sockets;
-
 static __be64 rxe_mac_to_eui64(struct net_device *ndev)
 {
 	unsigned char *mac_addr = ndev->dev_addr;
@@ -277,7 +276,8 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 
 static void rxe_release_udp_tunnel(struct socket *sk)
 {
-	udp_tunnel_sock_release(sk);
+	if (sk)
+		udp_tunnel_sock_release(sk);
 }
 
 static void prepare_udp_hdr(struct sk_buff *skb, __be16 src_port,
@@ -668,6 +668,7 @@ int rxe_net_init(void)
 
 	spin_lock_init(&dev_list_lock);
 
+#if IS_ENABLED(CONFIG_IPV6)
 	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
 			htons(ROCE_V2_UDP_DPORT), true);
 	if (IS_ERR(recv_sockets.sk6)) {
@@ -675,7 +676,7 @@ int rxe_net_init(void)
 		pr_err("rxe: Failed to create IPv6 UDP tunnel\n");
 		return -1;
 	}
-
+#endif
 	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
 			htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(recv_sockets.sk4)) {
@@ -688,8 +689,8 @@ int rxe_net_init(void)
 
 	err = register_netdevice_notifier(&rxe_net_notifier);
 	if (err) {
-		rxe_release_udp_tunnel(recv_sockets.sk6);
 		rxe_release_udp_tunnel(recv_sockets.sk4);
+		rxe_release_udp_tunnel(recv_sockets.sk6);
 		pr_err("rxe: Failed to rigister netdev notifier\n");
 	}
 
@@ -698,11 +699,8 @@ int rxe_net_init(void)
 
 void rxe_net_exit(void)
 {
-	if (recv_sockets.sk6)
-		rxe_release_udp_tunnel(recv_sockets.sk6);
-
-	if (recv_sockets.sk4)
-		rxe_release_udp_tunnel(recv_sockets.sk4);
+	rxe_release_udp_tunnel(recv_sockets.sk4);
+	rxe_release_udp_tunnel(recv_sockets.sk6);
 
 	unregister_netdevice_notifier(&rxe_net_notifier);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index 7b06f76..106c586 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -43,8 +43,6 @@ struct rxe_recv_sockets {
 	struct socket *sk6;
 };
 
-extern struct rxe_recv_sockets recv_sockets;
-
 struct rxe_dev *rxe_net_add(struct net_device *ndev);
 
 int rxe_net_init(void);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
