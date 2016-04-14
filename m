From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] IB/hfi1: Fix MAD port poll for active cables
Date: Thu, 14 Apr 2016 08:31:48 -0700
Message-ID: <20160414153147.3322.87968.stgit@scvm10.sc.intel.com>
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

A MAD directive to start polling must go through the normal
link tuning and start steps in order to correctly handle
active cables.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index d1e7f4d..ed58cf2 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -999,7 +999,21 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
 			break;
 		}
 
-		set_link_state(ppd, link_state);
+		if ((link_state == HLS_DN_POLL ||
+		     link_state == HLS_DN_DOWNDEF)) {
+			/*
+			 * Going to poll.  No matter what the current state,
+			 * always move offline first, then tune and start the
+			 * link.  This correctly handles a FM link bounce and
+			 * a link enable.  Going offline is a no-op if already
+			 * offline.
+			 */
+			set_link_state(ppd, HLS_DN_OFFLINE);
+			tune_serdes(ppd);
+			start_link(ppd);
+		} else {
+			set_link_state(ppd, link_state);
+		}
 		if (link_state == HLS_DN_DISABLE &&
 		    (ppd->offline_disabled_reason >
 		     HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED) ||

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
