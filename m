From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/20] IB/hfi1: Permanently enable P_Key checking in HFI
Date: Sun, 09 Apr 2017 10:16:59 -0700
Message-ID: <20170409171658.10579.67996.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Ingress and egress port P_Key checking should always be performed for
HFIs. This patch will enable ingress and egress P_Key checking when
the port is initialized and will ignore the P_Key information sent by
the FM in the port info structure which is meant to be used only by the
switch.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |    3 +++
 drivers/infiniband/hw/hfi1/mad.c  |   10 ----------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 55a11a6..838d3a8 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -482,6 +482,9 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	default_pkey_idx = 1;
 
 	ppd->pkeys[default_pkey_idx] = DEFAULT_P_KEY;
+	ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
+	ppd->part_enforce |= HFI1_PART_ENFORCE_OUT;
+
 	if (loopback) {
 		hfi1_early_err(&pdev->dev,
 			       "Faking data partition 0x8001 in idx %u\n",
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index db5494d..7059a0f 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1151,16 +1151,6 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 		ppd->linkinit_reason =
 			(pi->partenforce_filterraw &
 			 OPA_PI_MASK_LINKINIT_REASON);
-	/* enable/disable SW pkey checking as per FM control */
-	if (pi->partenforce_filterraw & OPA_PI_MASK_PARTITION_ENFORCE_IN)
-		ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
-	else
-		ppd->part_enforce &= ~HFI1_PART_ENFORCE_IN;
-
-	if (pi->partenforce_filterraw & OPA_PI_MASK_PARTITION_ENFORCE_OUT)
-		ppd->part_enforce |= HFI1_PART_ENFORCE_OUT;
-	else
-		ppd->part_enforce &= ~HFI1_PART_ENFORCE_OUT;
 
 	/* Must be a valid unicast LID address. */
 	if ((smlid == 0 && ls_old > IB_PORT_INIT) ||

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
