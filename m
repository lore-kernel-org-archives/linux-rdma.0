From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH v2 net 1/2] net/smc: replace function pointer get_netdev()
Date: Wed, 11 Oct 2017 13:47:22 +0200
Message-ID: <20171011114723.30733-2-ubraun@linux.vnet.ibm.com>
References: <20171011114723.30733-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171011114723.30733-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com, parav@mellanox.com
List-Id: linux-rdma@vger.kernel.org

SMC should not open code the function pointer get_netdev of the
IB device. Replacing ib_query_gid(..., NULL) with
ib_query_gid(..., gid_attr) allows access to the netdev.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
Suggested-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
---
 net/smc/smc_ib.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 0b5852299158..468e1d725d97 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -369,26 +369,17 @@ void smc_ib_buf_unmap_sg(struct smc_ib_device *smcibdev,
 
 static int smc_ib_fill_gid_and_mac(struct smc_ib_device *smcibdev, u8 ibport)
 {
-	struct net_device *ndev;
+	struct ib_gid_attr gattr;
 	int rc;
 
 	rc = ib_query_gid(smcibdev->ibdev, ibport, 0,
-			  &smcibdev->gid[ibport - 1], NULL);
-	/* the SMC protocol requires specification of the roce MAC address;
-	 * if net_device cannot be determined, it can be derived from gid 0
-	 */
-	ndev = smcibdev->ibdev->get_netdev(smcibdev->ibdev, ibport);
-	if (ndev) {
-		memcpy(&smcibdev->mac, ndev->dev_addr, ETH_ALEN);
-		dev_put(ndev);
-	} else if (!rc) {
-		memcpy(&smcibdev->mac[ibport - 1][0],
-		       &smcibdev->gid[ibport - 1].raw[8], 3);
-		memcpy(&smcibdev->mac[ibport - 1][3],
-		       &smcibdev->gid[ibport - 1].raw[13], 3);
-		smcibdev->mac[ibport - 1][0] &= ~0x02;
-	}
-	return rc;
+			  &smcibdev->gid[ibport - 1], &gattr);
+	if (rc || !gattr.ndev)
+		return -ENODEV;
+
+	memcpy(smcibdev->mac[ibport - 1], gattr.ndev->dev_addr, ETH_ALEN);
+	dev_put(gattr.ndev);
+	return 0;
 }
 
 /* Create an identifier unique for this instance of SMC-R.
@@ -419,6 +410,7 @@ int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
 			   &smcibdev->pattr[ibport - 1]);
 	if (rc)
 		goto out;
+	/* the SMC protocol requires specification of the RoCE MAC address */
 	rc = smc_ib_fill_gid_and_mac(smcibdev, ibport);
 	if (rc)
 		goto out;
-- 
2.13.5
