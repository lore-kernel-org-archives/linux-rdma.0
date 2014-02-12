From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: add missing serdes init sequeuce
Date: Wed, 12 Feb 2014 11:54:15 -0500
Message-ID: <20140212165415.25744.84561.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Research has shown that commit a77fcf89
("IB/qib: Use a single txselect module parameter for serdes tuning")
missed a key serdes init sequence.

This patch add that sequence.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 5bfc02f..d1bd213 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2395,6 +2395,11 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	qib_write_kreg_port(ppd, krp_ibcctrl_a, ppd->cpspec->ibcctrl_a);
 	qib_write_kreg(dd, kr_scratch, 0ULL);
 
+	/* ensure previous Tx parameters are not still forced */
+	qib_write_kreg_port(ppd, krp_tx_deemph_override,
+		SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		reset_tx_deemphasis_override));
+
 	if (qib_compat_ddr_negotiate) {
 		ppd->cpspec->ibdeltainprog = 1;
 		ppd->cpspec->ibsymsnap = read_7322_creg32_port(ppd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
