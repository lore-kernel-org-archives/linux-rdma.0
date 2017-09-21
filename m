From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net 2/9] net/smc: add receive timeout check
Date: Thu, 21 Sep 2017 09:16:27 +0200
Message-ID: <20170921071634.16883-3-ubraun@linux.vnet.ibm.com>
References: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

From: Hans Wippel <hwippel@linux.vnet.ibm.com>

The SMC receive function currently lacks a timeout check under the
condition that no data were received and no data are available. This
patch adds such a check.

Signed-off-by: Hans Wippel <hwippel@linux.vnet.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index b17a333e9bb0..3e631ae4b6b6 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -148,6 +148,8 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg, size_t len,
 				read_done = sock_intr_errno(timeo);
 				break;
 			}
+			if (!timeo)
+				return -EAGAIN;
 		}
 
 		if (!atomic_read(&conn->bytes_to_rcv)) {
-- 
2.13.5
