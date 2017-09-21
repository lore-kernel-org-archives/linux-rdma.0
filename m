From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net 4/9] net/smc: adjust net_device refcount
Date: Thu, 21 Sep 2017 09:16:29 +0200
Message-ID: <20170921071634.16883-5-ubraun@linux.vnet.ibm.com>
References: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

smc_pnet_fill_entry() uses dev_get_by_name() adding a refcount to ndev.
The following smc_pnet_enter() has to reduce the refcount if the entry
to be added exists already in the pnet table.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc_pnet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 78f7af28ae4f..31f8453c25c5 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -181,8 +181,10 @@ static int smc_pnet_enter(struct smc_pnetentry *new_pnetelem)
 			     sizeof(new_pnetelem->ndev->name)) ||
 		    smc_pnet_same_ibname(pnetelem,
 					 new_pnetelem->smcibdev->ibdev->name,
-					 new_pnetelem->ib_port))
+					 new_pnetelem->ib_port)) {
+			dev_put(pnetelem->ndev);
 			goto found;
+		}
 	}
 	list_add_tail(&new_pnetelem->list, &smc_pnettable.pnetlist);
 	rc = 0;
-- 
2.13.5
