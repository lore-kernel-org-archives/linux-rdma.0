From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/8] IB/hfi1: Do not enable disabled port on cable
 insert
Date: Sat, 29 Jul 2017 08:43:26 -0700
Message-ID: <20170729154325.21487.65122.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix issue where a disabled port can be enabled by
inserting a cable. The port should be explicitly
enabled instead.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index eca31dd..bd594e7 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9306,12 +9306,6 @@ int start_link(struct hfi1_pportdata *ppd)
 	 */
 	tune_serdes(ppd);
 
-	if (!ppd->link_enabled) {
-		dd_dev_info(ppd->dd,
-			    "%s: stopping link start because link is disabled\n",
-			    __func__);
-		return 0;
-	}
 	if (!ppd->driver_link_ready) {
 		dd_dev_info(ppd->dd,
 			    "%s: stopping link start because driver is not ready\n",
@@ -9529,6 +9523,13 @@ void qsfp_event(struct work_struct *work)
 	if (!qsfp_mod_present(ppd))
 		return;
 
+	if (ppd->host_link_state == HLS_DN_DISABLE) {
+		dd_dev_info(ppd->dd,
+			    "%s: stopping link start because link is disabled\n",
+			    __func__);
+		return;
+	}
+
 	/*
 	 * Turn DC back on after cable has been re-inserted. Up until
 	 * now, the DC has been in reset to save power.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
