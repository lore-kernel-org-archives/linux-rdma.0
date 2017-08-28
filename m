From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/9] IB/hfi1: Acquire QSFP cable information on
 loopback
Date: Mon, 28 Aug 2017 11:23:21 -0700
Message-ID: <20170828182319.29434.60189.stgit@scvm10.sc.intel.com>
References: <20170828182121.29434.18989.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828182121.29434.18989.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, QSFP information is not queried
in cases where loopback was set up and QSFP module is
present.

Acquire QSFP information in case of loopback.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 8004f1d..a8af96d 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -944,6 +944,21 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 	if (loopback != LOOPBACK_NONE ||
 	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
 		ppd->driver_link_ready = 1;
+
+		if (qsfp_mod_present(ppd)) {
+			ret = acquire_chip_resource(ppd->dd,
+						    qsfp_resource(ppd->dd),
+						    QSFP_WAIT);
+			if (ret) {
+				dd_dev_err(ppd->dd, "%s: hfi%d: cannot lock i2c chain\n",
+					   __func__, (int)ppd->dd->hfi1_id);
+				goto bail;
+			}
+
+			refresh_qsfp_cache(ppd, &ppd->qsfp_info);
+			release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
+		}
+
 		return;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
