From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/9] IB/hfi1: Fix spelling mistake in linkdown
 reason
Date: Mon, 29 May 2017 17:18:46 -0700
Message-ID: <20170530001819.534.55715.stgit@scvm10.sc.intel.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Spell receive correctly in OPA_LINKDOWN_REASON_RCV_ERROR

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 33fd7fe..619ce0b 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6906,7 +6906,7 @@ static void reset_neighbor_info(struct hfi1_pportdata *ppd)
 
 static const char * const link_down_reason_strs[] = {
 	[OPA_LINKDOWN_REASON_NONE] = "None",
-	[OPA_LINKDOWN_REASON_RCV_ERROR_0] = "Recive error 0",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_0] = "Receive error 0",
 	[OPA_LINKDOWN_REASON_BAD_PKT_LEN] = "Bad packet length",
 	[OPA_LINKDOWN_REASON_PKT_TOO_LONG] = "Packet too long",
 	[OPA_LINKDOWN_REASON_PKT_TOO_SHORT] = "Packet too short",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
