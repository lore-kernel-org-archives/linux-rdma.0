From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] staging/rdma/hfi1: Turning off LED without checking if
 stepping is Ax
Date: Tue, 09 Feb 2016 14:29:40 -0800
Message-ID: <20160209222936.7444.75860.stgit@scvm10.sc.intel.com>
References: <20160209222705.7444.85189.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209222705.7444.85189.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It prevents the LED from staying on when the QSFP module is
not present.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    4 ++--
 drivers/staging/rdma/hfi1/pcie.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 4750e3c..1294617 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13418,8 +13418,8 @@ static void init_chip(struct hfi1_devdata *dd)
 	write_csr(dd, CCE_DC_CTRL, 0);
 
 	/* Set the LED off */
-	if (is_ax(dd))
-		setextled(dd, 0);
+	setextled(dd, 0);
+
 	/*
 	 * Clear the QSFP reset.
 	 * An FLR enforces a 0 on all out pins. The driver does not touch
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 5642d85..04f2d8a 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -1261,8 +1261,7 @@ retry:
 	write_csr(dd, CCE_DC_CTRL, 0);
 
 	/* Set the LED off */
-	if (is_ax(dd))
-		setextled(dd, 0);
+	setextled(dd, 0);
 
 	/* check for any per-lane errors */
 	pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE2, &reg32);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
