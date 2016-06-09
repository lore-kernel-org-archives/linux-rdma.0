From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/10] IB/hfi1: Increase packet egress timeout
Date: Thu, 09 Jun 2016 07:51:27 -0700
Message-ID: <20160609145125.12702.47309.stgit@scvm10.sc.intel.com>
References: <20160609144644.12702.4832.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current value of 500us for the packet egress timeout is too small
which causes the host to declare failure on draining packets too early
and unnecessarily bounces the link. Increase this to 50ms taking into
account the switch packet discard timer default and the worst case
per-VL package drainage rate.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index e0e1ff2..d402245 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -995,7 +995,7 @@ static void sc_wait_for_packet_egress(struct send_context *sc, int pause)
 		/* counter is reset if occupancy count changes */
 		if (reg != reg_prev)
 			loop = 0;
-		if (loop > 500) {
+		if (loop > 50000) {
 			/* timed out - bounce the link */
 			dd_dev_err(dd,
 				   "%s: context %u(%u) timeout waiting for packets to egress, remaining count %u, bouncing link\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
