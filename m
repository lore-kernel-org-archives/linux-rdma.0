From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net-next 05/10] net/smc: adapt send request completion notification
Date: Wed, 20 Sep 2017 13:58:08 +0200
Message-ID: <20170920115813.63745-6-ubraun@linux.vnet.ibm.com>
References: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

The solicited flag is meaningful for the receive completion queue.
Ask for next work completion of any type on the send queue.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc_wr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index ab56bda66783..525d91e0d57e 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -244,7 +244,7 @@ int smc_wr_tx_send(struct smc_link *link, struct smc_wr_tx_pend_priv *priv)
 	int rc;
 
 	ib_req_notify_cq(link->smcibdev->roce_cq_send,
-			 IB_CQ_SOLICITED_MASK | IB_CQ_REPORT_MISSED_EVENTS);
+			 IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
 	pend = container_of(priv, struct smc_wr_tx_pend, priv);
 	rc = ib_post_send(link->roce_qp, &link->wr_tx_ibs[pend->idx],
 			  &failed_wr);
-- 
2.13.5
