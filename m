From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 06/18] IB/hfi1: Add VL XmitDiscards counters to the
 opapmaquery
Date: Fri, 01 Jul 2016 16:01:17 -0700
Message-ID: <20160701230116.20160.82948.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add per VL XmitDiscards counters to the opapmaquery
status and error response.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 223dd46..349a138 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2487,6 +2487,9 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BCN_VL,
 						  idx_from_vl(vl)));
 
+		rsp->vls[vfi].port_vl_xmit_discards =
+			cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD_VL,
+						   idx_from_vl(vl)));
 		vlinfo++;
 		vfi++;
 	}
@@ -2878,7 +2881,9 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
 			 8 * sizeof(req->vl_select_mask)) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
-		/* vlinfo->vls[vfi].port_vl_xmit_discards ??? */
+		rsp->vls[vfi].port_vl_xmit_discards =
+			cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD_VL,
+						   idx_from_vl(vl)));
 		vlinfo += 1;
 		vfi++;
 	}
@@ -3211,7 +3216,9 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 		/* if (counter_select & CS_PORT_MARK_FECN)
 		 *     write_csr(dd, DCC_PRF_PORT_VL_MARK_FECN_CNT + offset, 0);
 		 */
-		/* port_vl_xmit_discards ??? */
+		if (counter_select & C_SW_XMIT_DSCD_VL)
+			write_port_cntr(ppd, C_SW_XMIT_DSCD_VL,
+					idx_from_vl(vl), 0);
 	}
 
 	if (resp_len)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
