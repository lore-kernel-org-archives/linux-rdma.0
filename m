From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 24/43] cxgb3: Allocate a provate page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:24 +0300
Message-ID: <1437548143-24893-25-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 9 +++++++++
 drivers/infiniband/hw/cxgb3/iwch_provider.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index af55b79..c9368e6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -463,6 +463,7 @@ static int iwch_dereg_mr(struct ib_mr *ib_mr)
 		return -EINVAL;
 
 	mhp = to_iwch_mr(ib_mr);
+	kfree(mhp->pl);
 	rhp = mhp->rhp;
 	mmid = mhp->attr.stag >> 8;
 	cxio_dereg_mem(&rhp->rdev, mhp->attr.stag, mhp->attr.pbl_size,
@@ -817,6 +818,12 @@ static struct ib_mr *iwch_alloc_mr(struct ib_pd *pd,
 	if (!mhp)
 		goto err;
 
+	mhp->pl = kcalloc(max_entries, sizeof(u64), GFP_KERNEL);
+	if (!mhp->pl) {
+		ret = -ENOMEM;
+		goto pl_err;
+	}
+
 	mhp->rhp = rhp;
 	ret = iwch_alloc_pbl(mhp, max_entries);
 	if (ret)
@@ -843,6 +850,8 @@ err3:
 err2:
 	iwch_free_pbl(mhp);
 err1:
+	kfree(mhp->pl);
+pl_err:
 	kfree(mhp);
 err:
 	return ERR_PTR(ret);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 87c14b0..8e16da9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -77,6 +77,8 @@ struct iwch_mr {
 	struct iwch_dev *rhp;
 	u64 kva;
 	struct tpt_attributes attr;
+	u64 *pl;
+	u32 npages;
 };
 
 typedef struct iwch_mw iwch_mw_handle;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
