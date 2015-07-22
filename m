From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 06/43] nes: Support ib_alloc_mr verb
Date: Wed, 22 Jul 2015 09:55:06 +0300
Message-ID: <1437548143-24893-7-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 73 +++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index fbc43e5..ac63763 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -375,6 +375,78 @@ static int alloc_fast_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 }
 
 /*
+ * nes_alloc_mr
+ */
+static struct ib_mr *nes_alloc_mr(struct ib_pd *ibpd,
+				  enum ib_mr_type mr_type,
+				  u32 max_entries,
+				  u32 flags)
+{
+	struct nes_pd *nespd = to_nespd(ibpd);
+	struct nes_vnic *nesvnic = to_nesvnic(ibpd->device);
+	struct nes_device *nesdev = nesvnic->nesdev;
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
+
+	u32 next_stag_index;
+	u8 stag_key = 0;
+	u32 driver_key = 0;
+	int err = 0;
+	u32 stag_index = 0;
+	struct nes_mr *nesmr;
+	u32 stag;
+	int ret;
+	struct ib_mr *ibmr;
+
+	if (mr_type != IB_MR_TYPE_FAST_REG || flags)
+		return ERR_PTR(-EINVAL);
+
+/*
+ * Note:  Set to always use a fixed length single page entry PBL.  This is to allow
+ *	 for the fast_reg_mr operation to always know the size of the PBL.
+ */
+	if (max_entries > (NES_4K_PBL_CHUNK_SIZE / sizeof(u64)))
+		return ERR_PTR(-E2BIG);
+
+	get_random_bytes(&next_stag_index, sizeof(next_stag_index));
+	stag_key = (u8)next_stag_index;
+	next_stag_index >>= 8;
+	next_stag_index %= nesadapter->max_mr;
+
+	err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
+				 nesadapter->max_mr, &stag_index,
+				 &next_stag_index, NES_RESOURCE_FAST_MR);
+	if (err)
+		return ERR_PTR(err);
+
+	nesmr = kzalloc(sizeof(*nesmr), GFP_KERNEL);
+	if (!nesmr) {
+		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	stag = stag_index << 8;
+	stag |= driver_key;
+	stag += (u32)stag_key;
+
+	nes_debug(NES_DBG_MR, "Allocating STag 0x%08X index = 0x%08X\n",
+		  stag, stag_index);
+
+	ret = alloc_fast_reg_mr(nesdev, nespd, stag, max_entries);
+
+	if (ret == 0) {
+		nesmr->ibmr.rkey = stag;
+		nesmr->ibmr.lkey = stag;
+		nesmr->mode = IWNES_MEMREG_TYPE_FMEM;
+		ibmr = &nesmr->ibmr;
+	} else {
+		kfree(nesmr);
+		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+		ibmr = ERR_PTR(-ENOMEM);
+	}
+	return ibmr;
+}
+
+/*
  * nes_alloc_fast_reg_mr
  */
 static struct ib_mr *nes_alloc_fast_reg_mr(struct ib_pd *ibpd, int max_page_list_len)
@@ -3929,6 +4001,7 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.dealloc_mw = nes_dealloc_mw;
 	nesibdev->ibdev.bind_mw = nes_bind_mw;
 
+	nesibdev->ibdev.alloc_mr = nes_alloc_mr;
 	nesibdev->ibdev.alloc_fast_reg_mr = nes_alloc_fast_reg_mr;
 	nesibdev->ibdev.alloc_fast_reg_page_list = nes_alloc_fast_reg_page_list;
 	nesibdev->ibdev.free_fast_reg_page_list = nes_free_fast_reg_page_list;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
