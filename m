From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/11] IB/hfi1: Reduce 8051 command timeout
Date: Mon, 06 Nov 2017 06:38:23 -0800
Message-ID: <20171106143821.27539.86712.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Duane McCrory <duane.mccrory-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Timeout of 20 seconds is too long for active wait performed
for 8051 command completion. It was required for scenarios
when transition to polling was requested before offline.quiet
state was reached. Currently wait for offline.quiet is
properly implemented and timeout can be reduced to 1 second.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Duane McCrory <duane.mccrory-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index fc122c1..133e313 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -560,7 +560,7 @@ enum {
 /* timeouts */
 #define LINK_RESTART_DELAY 1000		/* link restart delay, in ms */
 #define TIMEOUT_8051_START 5000         /* 8051 start timeout, in ms */
-#define DC8051_COMMAND_TIMEOUT 20000	/* DC8051 command timeout, in ms */
+#define DC8051_COMMAND_TIMEOUT 1000	/* DC8051 command timeout, in ms */
 #define FREEZE_STATUS_TIMEOUT 20	/* wait for freeze indicators, in ms */
 #define VL_STATUS_CLEAR_TIMEOUT 5000	/* per-VL status clear, in ms */
 #define CCE_STATUS_TIMEOUT 10		/* time to clear CCE Status, in ms */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
