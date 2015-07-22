From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 27/43] nes: Allocate a private page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:27 +0300
Message-ID: <1437548143-24893-28-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 27 +++++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_verbs.h |  5 +++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 752e6ea..532496d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -51,6 +51,7 @@ atomic_t qps_created;
 atomic_t sw_qps_destroyed;
 
 static void nes_unregister_ofa_device(struct nes_ib_device *nesibdev);
+static int nes_dereg_mr(struct ib_mr *ib_mr);
 
 /**
  * nes_alloc_mw
@@ -443,7 +444,25 @@ static struct ib_mr *nes_alloc_mr(struct ib_pd *ibpd,
 		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
 		ibmr = ERR_PTR(-ENOMEM);
 	}
+
+	nesmr->pl = kcalloc(max_entries, sizeof(u64), GFP_KERNEL);
+	if (!nesmr->pl)
+		goto err;
+
+	nesmr->mpl = pci_alloc_consistent(nesdev->pcidev,
+					  max_entries * sizeof(u64),
+					  &nesmr->mpl_addr);
+	if (!nesmr->mpl_addr)
+		goto err;
+
+	nesmr->max_pages = max_entries;
+
 	return ibmr;
+
+err:
+	nes_dereg_mr(ibmr);
+
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -2681,6 +2700,14 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
 	u16 major_code;
 	u16 minor_code;
 
+
+	kfree(nesmr->pl);
+	if (nesmr->mpl)
+		pci_free_consistent(nesdev->pcidev,
+				    nesmr->max_pages * sizeof(u64),
+				    nesmr->mpl,
+				    nesmr->mpl_addr);
+
 	if (nesmr->region) {
 		ib_umem_release(nesmr->region);
 	}
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 309b31c..e99aa69 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -79,6 +79,11 @@ struct nes_mr {
 	u16               pbls_used;
 	u8                mode;
 	u8                pbl_4k;
+	u64               *pl;
+	u64               *mpl;
+	dma_addr_t        mpl_addr;
+	u32               max_pages;
+	u32		  npages;
 };
 
 struct nes_hw_pb {
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
