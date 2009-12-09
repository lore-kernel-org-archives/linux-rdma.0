From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/11] RDMA/nes: check for zero stag
Date: Wed, 9 Dec 2009 16:42:31 -0600
Message-ID: <20091209224231.GA124820@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

STags are generated randomly but the driver does not correctly prevent
a zero STag.  Using STag zero is privileged and causes a user space
application to fail.  This change prevents the driver from trying to
allocate a zero STag.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c    |    3 ++-
 drivers/infiniband/hw/nes/nes_verbs.c |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 9fc0273..b1c2cbb 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -437,11 +437,12 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 	nesadapter->qp_table = (struct nes_qp **)(&nesadapter->allocated_arps[BITS_TO_LONGS(arp_table_size)]);
 
 
-	/* mark the usual suspect QPs and CQs as in use */
+	/* mark the usual suspect QPs, MR and CQs as in use */
 	for (u32temp = 0; u32temp < NES_FIRST_QPN; u32temp++) {
 		set_bit(u32temp, nesadapter->allocated_qps);
 		set_bit(u32temp, nesadapter->allocated_cqs);
 	}
+	set_bit(0, nesadapter->allocated_mrs);
 
 	for (u32temp = 0; u32temp < 20; u32temp++)
 		set_bit(u32temp, nesadapter->allocated_pds);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 0e3eee2..de53e88 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2503,9 +2503,6 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			stag = stag_index << 8;
 			stag |= driver_key;
 			stag += (u32)stag_key;
-			if (stag == 0) {
-				stag = 1;
-			}
 
 			iova_start = virt;
 			/* Make the leaf PBL the root if only one PBL */
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
