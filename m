From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 26/43] qib: Allocate a private page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:26 +0300
Message-ID: <1437548143-24893-27-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mr.c    | 9 +++++++++
 drivers/infiniband/hw/qib/qib_verbs.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 2a4afea..a58a347 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -303,6 +303,7 @@ int qib_dereg_mr(struct ib_mr *ibmr)
 	int ret = 0;
 	unsigned long timeout;
 
+	kfree(mr->pl);
 	qib_free_lkey(&mr->mr);
 
 	qib_put_mr(&mr->mr); /* will set completion if last */
@@ -341,7 +342,15 @@ struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
 	if (IS_ERR(mr))
 		return (struct ib_mr *)mr;
 
+	mr->pl = kcalloc(max_entries, sizeof(u64), GFP_KERNEL);
+	if (!mr->pl)
+		goto err;
+
 	return &mr->ibmr;
+
+err:
+	qib_dereg_mr(&mr->ibmr);
+	return ERR_PTR(-ENOMEM);
 }
 
 struct ib_fast_reg_page_list *
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 8fbd995..c8062ae 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -330,6 +330,8 @@ struct qib_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
 	struct qib_mregion mr;  /* must be last */
+	u64 *pl;
+	u32 npages;
 };
 
 /*
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
