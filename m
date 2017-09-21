From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net 3/9] net/smc: take RCU read lock for routing cache lookup
Date: Thu, 21 Sep 2017 09:16:28 +0200
Message-ID: <20170921071634.16883-4-ubraun@linux.vnet.ibm.com>
References: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

smc_netinfo_by_tcpsk() looks up the routing cache. Such a lookup requires
protection by an RCU read lock.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/af_smc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8c6d24b2995d..2e8d2dabac0c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -282,6 +282,7 @@ int smc_netinfo_by_tcpsk(struct socket *clcsock,
 			 __be32 *subnet, u8 *prefix_len)
 {
 	struct dst_entry *dst = sk_dst_get(clcsock->sk);
+	struct in_device *in_dev;
 	struct sockaddr_in addr;
 	int rc = -ENOENT;
 	int len;
@@ -298,14 +299,17 @@ int smc_netinfo_by_tcpsk(struct socket *clcsock,
 	/* get address to which the internal TCP socket is bound */
 	kernel_getsockname(clcsock, (struct sockaddr *)&addr, &len);
 	/* analyze IPv4 specific data of net_device belonging to TCP socket */
-	for_ifa(dst->dev->ip_ptr) {
-		if (ifa->ifa_address != addr.sin_addr.s_addr)
+	rcu_read_lock();
+	in_dev = __in_dev_get_rcu(dst->dev);
+	for_ifa(in_dev) {
+		if (!inet_ifa_match(addr.sin_addr.s_addr, ifa))
 			continue;
 		*prefix_len = inet_mask_len(ifa->ifa_mask);
 		*subnet = ifa->ifa_address & ifa->ifa_mask;
 		rc = 0;
 		break;
-	} endfor_ifa(dst->dev->ip_ptr);
+	} endfor_ifa(in_dev);
+	rcu_read_unlock();
 
 out_rel:
 	dst_release(dst);
-- 
2.13.5
