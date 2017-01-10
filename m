From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 01/15] IB/rxe: Suppress sparse warnings
Date: Tue, 10 Jan 2017 11:15:40 -0800
Message-ID: <20170110191554.17359-2-bart.vanassche@sandisk.com>
References: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110191554.17359-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that sparse complains about using 0 as a pointer, about
missing function declarations and also avoid that sparse complains
about endianness.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c  | 8 ++++----
 drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 342e78163613..151f639abebf 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -243,8 +243,8 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 {
 	int err;
 	struct socket *sock;
-	struct udp_port_cfg udp_cfg = {0};
-	struct udp_tunnel_sock_cfg tnl_cfg = {0};
+	struct udp_port_cfg udp_cfg = { };
+	struct udp_tunnel_sock_cfg tnl_cfg = { };
 
 	if (ipv6) {
 		udp_cfg.family = AF_INET6;
@@ -658,7 +658,7 @@ struct notifier_block rxe_net_notifier = {
 	.notifier_call = rxe_notify,
 };
 
-int rxe_net_ipv4_init(void)
+static int rxe_net_ipv4_init(void)
 {
 	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
 				htons(ROCE_V2_UDP_DPORT), false);
@@ -671,7 +671,7 @@ int rxe_net_ipv4_init(void)
 	return 0;
 }
 
-int rxe_net_ipv6_init(void)
+static int rxe_net_ipv6_init(void)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 
diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 252b4d637d45..50886031096f 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -389,7 +389,7 @@ int rxe_rcv(struct sk_buff *skb)
 	calc_icrc = rxe_icrc_hdr(pkt, skb);
 	calc_icrc = crc32_le(calc_icrc, (u8 *)payload_addr(pkt),
 			     payload_size(pkt));
-	calc_icrc = cpu_to_be32(~calc_icrc);
+	calc_icrc = (__force u32)cpu_to_be32(~calc_icrc);
 	if (unlikely(calc_icrc != pack_icrc)) {
 		if (skb->protocol == htons(ETH_P_IPV6))
 			pr_warn_ratelimited("bad ICRC from %pI6c\n",
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
