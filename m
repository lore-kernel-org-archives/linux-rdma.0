From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 23/43] ocrdma: Allocate a private page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:23 +0300
Message-ID: <1437548143-24893-24-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b396344..37deea2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -178,6 +178,8 @@ struct ocrdma_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
 	struct ocrdma_hw_mr hwmr;
+	u64 *pl;
+	u32 npages;
 };
 
 struct ocrdma_stats {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index fb97db1..a764cb9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -957,6 +957,7 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 
 	(void) ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);
 
+	kfree(mr->pl);
 	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
 
 	/* it could be user registered memory. */
@@ -3003,6 +3004,12 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->pl = kcalloc(max_entries, sizeof(u64), GFP_KERNEL);
+	if (!mr->pl) {
+		status = -ENOMEM;
+		goto pl_err;
+	}
+
 	status = ocrdma_get_pbl_info(dev, mr, max_entries);
 	if (status)
 		goto pbl_err;
@@ -3026,6 +3033,8 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
 mbx_err:
 	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
 pbl_err:
+	kfree(mr->pl);
+pl_err:
 	kfree(mr);
 	return ERR_PTR(-ENOMEM);
 }
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
