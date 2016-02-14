From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/16] staging/rdma/hfi1: Determine actual operational VLs
Date: Sun, 14 Feb 2016 12:46:01 -0800
Message-ID: <20160214204558.29247.43262.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use shared credits and dedicated credits for each VL to determine
the actual number of operational VLs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   37 +++++++++++++++++++++++++++++--------
 drivers/staging/rdma/hfi1/diag.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h  |    3 ++-
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 36e8e3e..b169e89 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10305,12 +10305,6 @@ int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val)
 			ppd->vls_operational = val;
 			if (!ppd->port)
 				ret = -EINVAL;
-			else
-				ret = sdma_map_init(
-					ppd->dd,
-					ppd->port - 1,
-					val,
-					NULL);
 		}
 		break;
 	/*
@@ -10721,12 +10715,15 @@ static void wait_for_vl_status_clear(struct hfi1_devdata *dd, u64 mask,
  * raise = if the new limit is higher than the current value (may be changed
  *	earlier in the algorithm), set the new limit to the new value
  */
-int set_buffer_control(struct hfi1_devdata *dd, struct buffer_control *new_bc)
+int set_buffer_control(struct hfi1_pportdata *ppd,
+		       struct buffer_control *new_bc)
 {
+	struct hfi1_devdata *dd = ppd->dd;
 	u64 changing_mask, ld_mask, stat_mask;
 	int change_count;
 	int i, use_all_mask;
 	int this_shared_changing;
+	int vl_count = 0, ret;
 	/*
 	 * A0: add the variable any_shared_limit_changing below and in the
 	 * algorithm above.  If removing A0 support, it can be removed.
@@ -10878,6 +10875,28 @@ int set_buffer_control(struct hfi1_devdata *dd, struct buffer_control *new_bc)
 	/* bracket the credit change with a total adjustment */
 	if (new_total < cur_total)
 		set_global_limit(dd, new_total);
+
+	/*
+	 * Determine the actual number of operational VLS using the number of
+	 * dedicated and shared credits for each VL.
+	 */
+	if (change_count > 0) {
+		for (i = 0; i < TXE_NUM_DATA_VL; i++)
+			if (be16_to_cpu(new_bc->vl[i].dedicated) > 0 ||
+			    be16_to_cpu(new_bc->vl[i].shared) > 0)
+				vl_count++;
+		ppd->actual_vls_operational = vl_count;
+		ret = sdma_map_init(dd, ppd->port - 1, vl_count ?
+				    ppd->actual_vls_operational :
+				    ppd->vls_operational,
+				    NULL);
+		if (ret == 0)
+			ret = pio_map_init(dd, ppd->port - 1, vl_count ?
+					   ppd->actual_vls_operational :
+					   ppd->vls_operational, NULL);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
@@ -10969,7 +10988,7 @@ int fm_set_table(struct hfi1_pportdata *ppd, int which, void *t)
 				     VL_ARB_LOW_PRIO_TABLE_SIZE, t);
 		break;
 	case FM_TBL_BUFFER_CONTROL:
-		ret = set_buffer_control(ppd->dd, t);
+		ret = set_buffer_control(ppd, t);
 		break;
 	case FM_TBL_SC2VLNT:
 		set_sc2vlnt(ppd->dd, t);
@@ -13990,6 +14009,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		}
 		ppd->vls_supported = num_vls;
 		ppd->vls_operational = ppd->vls_supported;
+		ppd->actual_vls_operational = ppd->vls_supported;
 		/* Set the default MTU. */
 		for (vl = 0; vl < num_vls; vl++)
 			dd->vld[vl].mtu = hfi1_max_mtu;
@@ -14074,6 +14094,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 			   num_vls, dd->chip_sdma_engines);
 		num_vls = dd->chip_sdma_engines;
 		ppd->vls_supported = dd->chip_sdma_engines;
+		ppd->vls_operational = ppd->vls_supported;
 	}
 
 	/*
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 9523dc1..b8faee0 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1017,7 +1017,7 @@ static long hfi1_assign_snoop_link_credits(struct hfi1_pportdata *ppd,
 		t.vl[i].dedicated = be_per_vl_credits;
 
 	t.vl[15].dedicated  = cpu_to_be16(vl15_credits);
-	return set_buffer_control(ppd->dd, &t);
+	return set_buffer_control(ppd, &t);
 
 err_exit:
 	snoop_dbg("port_state = 0x%x, total_credits = %d, vl15_credits = %d",
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 43d4861..4ac3de6 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -644,6 +644,7 @@ struct hfi1_pportdata {
 	u16 link_speed_active;
 	u8 vls_supported;
 	u8 vls_operational;
+	u8 actual_vls_operational;
 	/* LID mask control */
 	u8 lmc;
 	/* Rx Polarity inversion (compensate for ~tx on partner) */
@@ -1516,7 +1517,7 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			   u64 pbc);
 void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 			   u64 pbc, const void *from, size_t count);
-int set_buffer_control(struct hfi1_devdata *dd, struct buffer_control *bc);
+int set_buffer_control(struct hfi1_pportdata *ppd, struct buffer_control *bc);
 
 static inline struct hfi1_devdata *dd_from_ppd(struct hfi1_pportdata *ppd)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
