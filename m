From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net-next 5/5] net/smc: return booleans instead of integers
Date: Fri, 26 Jan 2018 09:28:50 +0100
Message-ID: <20180126082850.20655-6-ubraun@linux.vnet.ibm.com>
References: <20180126082850.20655-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180126082850.20655-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

Return statements in functions returning bool should use
true/false instead of 1/0.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index bfbe20234105..9518986c97b1 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -252,12 +252,12 @@ static inline int smc_uncompress_bufsize(u8 compressed)
 static inline bool using_ipsec(struct smc_sock *smc)
 {
 	return (smc->clcsock->sk->sk_policy[0] ||
-		smc->clcsock->sk->sk_policy[1]) ? 1 : 0;
+		smc->clcsock->sk->sk_policy[1]) ? true : false;
 }
 #else
 static inline bool using_ipsec(struct smc_sock *smc)
 {
-	return 0;
+	return false;
 }
 #endif
 
-- 
2.13.5
