From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 08/11] IB/hfi1: Send 'reboot' as planned down
 remote reason
Date: Mon, 06 Nov 2017 06:39:07 -0800
Message-ID: <20171106143904.27539.60994.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On host shutdown, driver sends 'SMA_Disabled' as a reason
for link down. This is incorrect.

Send 'reboot' as a linkdown reason.

Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index bb3b65a..4f057e8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9786,9 +9786,9 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 	cancel_delayed_work_sync(&ppd->start_link_work);
 
 	ppd->offline_disabled_reason =
-			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED);
-	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SMA_DISABLED, 0,
-			     OPA_LINKDOWN_REASON_SMA_DISABLED);
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_REBOOT);
+	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_REBOOT, 0,
+			     OPA_LINKDOWN_REASON_REBOOT);
 	set_link_state(ppd, HLS_DN_OFFLINE);
 
 	/* disable the port */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
