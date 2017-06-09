From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/10] IB/hfi1: Fix DC 8051 host info flag array
Date: Fri, 09 Jun 2017 15:59:26 -0700
Message-ID: <20170609225924.26710.81908.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix info array of host message flags by adding entry
for link width downgrade and reverse values for
BC SMA and BC PWR_MSG messages

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 5dbf2ec..a344dd8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1012,14 +1012,15 @@ struct flag_table {
  */
 static struct flag_table dc8051_info_host_msg_flags[] = {
 	FLAG_ENTRY0("Host request done", 0x0001),
-	FLAG_ENTRY0("BC SMA message", 0x0002),
-	FLAG_ENTRY0("BC PWR_MGM message", 0x0004),
+	FLAG_ENTRY0("BC PWR_MGM message", 0x0002),
+	FLAG_ENTRY0("BC SMA message", 0x0004),
 	FLAG_ENTRY0("BC Unknown message (BCC)", 0x0008),
 	FLAG_ENTRY0("BC Unknown message (LCB)", 0x0010),
 	FLAG_ENTRY0("External device config request", 0x0020),
 	FLAG_ENTRY0("VerifyCap all frames received", 0x0040),
 	FLAG_ENTRY0("LinkUp achieved", 0x0080),
 	FLAG_ENTRY0("Link going down", 0x0100),
+	FLAG_ENTRY0("Link width downgraded", 0x0200),
 };
 
 static u32 encoded_size(u32 size);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
