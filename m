From: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] infiniband: mthca: Replace pci_pool_alloc by
 pci_pool_zalloc
Date: Fri, 2 Dec 2016 00:11:59 +0530
Message-ID: <20161201184159.GA2949@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sahu.rameshwar73-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In mthca_create_ah(), pci_pool_alloc() followed by memset will be
replaced by pci_pool_zalloc()

Signed-off-by: Souptick joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
v2:
  - Alignment changes
  - Remove empty lines

 drivers/infiniband/hw/mthca/mthca_av.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index bcac294..c9f0f36 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -186,8 +186,8 @@ int mthca_create_ah(struct mthca_dev *dev,

 on_hca_fail:
 	if (ah->type == MTHCA_AH_PCI_POOL) {
-		ah->av = pci_pool_alloc(dev->av_table.pool,
-					GFP_ATOMIC, &ah->avdma);
+		ah->av = pci_pool_zalloc(dev->av_table.pool,
+					 GFP_ATOMIC, &ah->avdma);
 		if (!ah->av)
 			return -ENOMEM;

@@ -196,8 +196,6 @@ int mthca_create_ah(struct mthca_dev *dev,

 	ah->key = pd->ntmr.ibmr.lkey;

-	memset(av, 0, MTHCA_AV_SIZE);
-
 	av->port_pd = cpu_to_be32(pd->pd_num | (ah_attr->port_num << 24));
 	av->g_slid  = ah_attr->src_path_bits;
 	av->dlid    = cpu_to_be16(ah_attr->dlid);
--
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
