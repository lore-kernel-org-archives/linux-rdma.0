From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/5] net/smc: Use IB device index instead of name
Date: Thu, 20 Sep 2018 14:21:59 +0300
Message-ID: <20180920112202.9181-3-leon@kernel.org>
References: <20180920112202.9181-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920112202.9181-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

IB device name is not stable and will be possible to rename in the
following patches, update SMC code to use IB index as a stable
identification.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/smc/smc_diag.c |  6 +++---
 net/smc/smc_pnet.c | 27 ++++++++++++++++-----------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index dbf64a93d68a..ba8b5a5671ec 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -156,9 +156,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 			.lnk[0].link_id = smc->conn.lgr->lnk[0].link_id,
 		};

-		memcpy(linfo.lnk[0].ibname,
-		       smc->conn.lgr->lnk[0].smcibdev->ibdev->name,
-		       sizeof(smc->conn.lgr->lnk[0].smcibdev->ibdev->name));
+		ib_device_get_name(smc->conn.lgr->lnk[0].smcibdev->ibdev,
+				   linfo.lnk[0].ibname);
+
 		smc_gid_be16_convert(linfo.lnk[0].gid,
 				     smc->conn.lgr->lnk[0].gid);
 		smc_gid_be16_convert(linfo.lnk[0].peer_gid,
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 01c6ce042a1c..67aec5ce6112 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -70,15 +70,14 @@ struct smc_pnetentry {
 	u8 ib_port;
 };

-/* Check if two RDMA device entries are identical. Use device name and port
+/* Check if two RDMA device entries are identical. Use device index and port
  * number for comparison.
  */
-static bool smc_pnet_same_ibname(struct smc_pnetentry *pnetelem, char *ibname,
-				 u8 ibport)
+static bool smc_pnet_same_ibindex(struct smc_pnetentry *pnetelem, u32 ibindex,
+				  u8 ibport)
 {
 	return pnetelem->ib_port == ibport &&
-	       !strncmp(pnetelem->smcibdev->ibdev->name, ibname,
-			sizeof(pnetelem->smcibdev->ibdev->name));
+	       pnetelem->smcibdev->ibdev->index == ibindex;
 }

 /* Find a pnetid in the pnet table.
@@ -179,9 +178,9 @@ static int smc_pnet_enter(struct smc_pnetentry *new_pnetelem)
 			     sizeof(new_pnetelem->pnet_name)) ||
 		    !strncmp(pnetelem->ndev->name, new_pnetelem->ndev->name,
 			     sizeof(new_pnetelem->ndev->name)) ||
-		    smc_pnet_same_ibname(pnetelem,
-					 new_pnetelem->smcibdev->ibdev->name,
-					 new_pnetelem->ib_port)) {
+		    smc_pnet_same_ibindex(pnetelem,
+					  new_pnetelem->smcibdev->ibdev->index,
+					  new_pnetelem->ib_port)) {
 			dev_put(pnetelem->ndev);
 			goto found;
 		}
@@ -227,10 +226,11 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)

 	spin_lock(&smc_ib_devices.lock);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
-		if (!strncmp(ibdev->ibdev->name, ib_name,
-			     sizeof(ibdev->ibdev->name))) {
+		char name[IB_DEVICE_NAME_MAX] = {};
+
+		ib_device_get_name(ibdev->ibdev, name);
+		if (!strncmp(name, ib_name, IB_DEVICE_NAME_MAX))
 			goto out;
-		}
 	}
 	ibdev = NULL;
 out:
@@ -267,6 +267,11 @@ static int smc_pnet_fill_entry(struct net *net, struct smc_pnetentry *pnetelem,
 		goto error;

 	rc = -EINVAL;
+	/* NOTE !!!: Sadly enough, but this is part of ABI.
+	 * From day one, the accesses are performed with device names and not
+	 * device indexes for both ETH and IB. It means that this function isn't
+	 * reliable after device renaming.
+	 */
 	if (!tb[SMC_PNETID_IBNAME])
 		goto error;
 	rc = -ENOENT;
