From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH] Revert "net/smc: Replace ib_query_gid with rdma_get_gid_attr"
Date: Thu, 16 Aug 2018 14:31:30 -0600
Message-ID: <20180816203130.GA24043@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This reverts commit ddb457c6993babbcdd41fca638b870d2a2fc3941.

The include rdma/ib_cache.h is kept, and we have to add a memset
to the compat wrapper to avoid compiler warnings in gcc-7

This revert is done to avoid extensive merge conflicts with SMC
changes in netdev during the 4.19 merge window.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 include/rdma/ib_cache.h |  1 +
 net/smc/smc_core.c      | 19 ++++++++++---------
 net/smc/smc_ib.c        | 24 ++++++++++--------------
 3 files changed, 21 insertions(+), 23 deletions(-)

As discussed before, the above patch to SMC in the rdma.git causes too
many merge conflicts, I am reverting it prior to sending the pull
request for RDMA and instead relying on the ibv_query_gid() compat
wrapper that has been in linux-next for some time.

Parav, please respin this patch against this branch:

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-for-next

Thanks,
Jason

diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index a4ce441f36f0ad..3e11e7cc60b745 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -143,6 +143,7 @@ static inline __deprecated int ib_query_gid(struct ib_device *device,
 {
 	const struct ib_gid_attr *attr;
 
+	memset(attr_out, 0, sizeof(*attr_out));
 	attr = rdma_get_gid_attr(device, port_num, index);
 	if (IS_ERR(attr))
 		return PTR_ERR(attr);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d99a75f75e42be..15bad268f37d8b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -451,7 +451,8 @@ static int smc_vlan_by_tcpsk(struct socket *clcsock, unsigned short *vlan_id)
 static int smc_link_determine_gid(struct smc_link_group *lgr)
 {
 	struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
-	const struct ib_gid_attr *gattr;
+	struct ib_gid_attr gattr;
+	union ib_gid gid;
 	int i;
 
 	if (!lgr->vlan_id) {
@@ -461,18 +462,18 @@ static int smc_link_determine_gid(struct smc_link_group *lgr)
 
 	for (i = 0; i < lnk->smcibdev->pattr[lnk->ibport - 1].gid_tbl_len;
 	     i++) {
-		gattr = rdma_get_gid_attr(lnk->smcibdev->ibdev, lnk->ibport, i);
-		if (IS_ERR(gattr))
+		if (ib_query_gid(lnk->smcibdev->ibdev, lnk->ibport, i, &gid,
+				 &gattr))
 			continue;
-		if (gattr->ndev) {
-			if (is_vlan_dev(gattr->ndev) &&
-			    vlan_dev_vlan_id(gattr->ndev) == lgr->vlan_id) {
-				lnk->gid = gattr->gid;
-				rdma_put_gid_attr(gattr);
+		if (gattr.ndev) {
+			if (is_vlan_dev(gattr.ndev) &&
+			    vlan_dev_vlan_id(gattr.ndev) == lgr->vlan_id) {
+				lnk->gid = gid;
+				dev_put(gattr.ndev);
 				return 0;
 			}
+			dev_put(gattr.ndev);
 		}
-		rdma_put_gid_attr(gattr);
 	}
 	return -ENODEV;
 }
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 74f29f814ec1f9..117b05f1a49475 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -373,21 +373,17 @@ void smc_ib_buf_unmap_sg(struct smc_ib_device *smcibdev,
 
 static int smc_ib_fill_gid_and_mac(struct smc_ib_device *smcibdev, u8 ibport)
 {
-	const struct ib_gid_attr *gattr;
-	int rc = 0;
+	struct ib_gid_attr gattr;
+	int rc;
 
-	gattr = rdma_get_gid_attr(smcibdev->ibdev, ibport, 0);
-	if (IS_ERR(gattr))
-		return PTR_ERR(gattr);
-	if (!gattr->ndev) {
-		rc = -ENODEV;
-		goto done;
-	}
-	smcibdev->gid[ibport - 1] = gattr->gid;
-	memcpy(smcibdev->mac[ibport - 1], gattr->ndev->dev_addr, ETH_ALEN);
-done:
-	rdma_put_gid_attr(gattr);
-	return rc;
+	rc = ib_query_gid(smcibdev->ibdev, ibport, 0,
+			  &smcibdev->gid[ibport - 1], &gattr);
+	if (rc || !gattr.ndev)
+		return -ENODEV;
+
+	memcpy(smcibdev->mac[ibport - 1], gattr.ndev->dev_addr, ETH_ALEN);
+	dev_put(gattr.ndev);
+	return 0;
 }
 
 /* Create an identifier unique for this instance of SMC-R.
-- 
2.18.0
