From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net-next 01/10] net/smc: add missing dev_put
Date: Wed, 20 Sep 2017 13:58:04 +0200
Message-ID: <20170920115813.63745-2-ubraun@linux.vnet.ibm.com>
References: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

From: Hans Wippel <hwippel@linux.vnet.ibm.com>

In the infiniband part, SMC currently uses get_netdev which calls
dev_hold on the returned net device. However, the SMC code never calls
dev_put on that net device resulting in a wrong reference count.

This patch adds a dev_put after the usage of the net device to fix the
issue.

Signed-off-by: Hans Wippel <hwippel@linux.vnet.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
---
 net/smc/smc_ib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 547e0e113b17..0b5852299158 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -380,6 +380,7 @@ static int smc_ib_fill_gid_and_mac(struct smc_ib_device *smcibdev, u8 ibport)
 	ndev = smcibdev->ibdev->get_netdev(smcibdev->ibdev, ibport);
 	if (ndev) {
 		memcpy(&smcibdev->mac, ndev->dev_addr, ETH_ALEN);
+		dev_put(ndev);
 	} else if (!rc) {
 		memcpy(&smcibdev->mac[ibport - 1][0],
 		       &smcibdev->gid[ibport - 1].raw[8], 3);
-- 
2.13.5
