From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] IB/rxe: Use DEFINE_SPINLOCK() for spinlock
Date: Sat, 29 Oct 2016 16:19:33 +0000
Message-ID: <1477757973-32052-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index b8258e4..4cb6378 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -46,7 +46,7 @@
 #include "rxe_loc.h"
 
 static LIST_HEAD(rxe_dev_list);
-static spinlock_t dev_list_lock; /* spinlock for device list */
+static DEFINE_SPINLOCK(dev_list_lock); /* spinlock for device list */
 
 struct rxe_dev *net_to_rxe(struct net_device *ndev)
 {
@@ -663,8 +663,6 @@ struct notifier_block rxe_net_notifier = {
 
 int rxe_net_ipv4_init(void)
 {
-	spin_lock_init(&dev_list_lock);
-
 	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
 				htons(ROCE_V2_UDP_DPORT), false);
 	if (IS_ERR(recv_sockets.sk4)) {
@@ -680,8 +678,6 @@ int rxe_net_ipv6_init(void)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 
-	spin_lock_init(&dev_list_lock);
-
 	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
 						htons(ROCE_V2_UDP_DPORT), true);
 	if (IS_ERR(recv_sockets.sk6)) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
