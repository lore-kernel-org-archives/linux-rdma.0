From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] IB/hfi1: Ignore link downgrade with 0 lanes
Date: Thu, 14 Apr 2016 08:31:30 -0700
Message-ID: <20160414153128.3322.47266.stgit@scvm10.sc.intel.com>
References: <20160414152929.3322.38247.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414152929.3322.38247.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Versions of the 8051 firmware < 0.38 may report a link failure
as a link downgrade with a width of 0 followed by a link down
notification.  Ignore the zero width downgrade notification -
the driver should follow the link down path.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 386309c..f50f1b1 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -7336,7 +7336,11 @@ retry:
 		ppd->link_width_downgrade_rx_active = rx;
 	}
 
-	if (lwde == 0) {
+	if (ppd->link_width_downgrade_tx_active == 0 ||
+	    ppd->link_width_downgrade_rx_active == 0) {
+		/* the 8051 reported a dead link as a downgrade */
+		dd_dev_err(ppd->dd, "Link downgrade is really a link down, ignoring\n");
+	} else if (lwde == 0) {
 		/* downgrade is disabled */
 
 		/* bounce if not at starting active width */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
