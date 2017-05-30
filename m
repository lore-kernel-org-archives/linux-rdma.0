From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/9] IB/hfi1: Ensure dd->gi_mask can not be
 overflowed
Date: Mon, 29 May 2017 17:18:14 -0700
Message-ID: <20170530001733.534.8558.stgit@scvm10.sc.intel.com>
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

As the code stands today the array access in remap_intr() is OK. To
future proof the code though we should explicitly check to ensure the
index value is not outside of the valid range. This is not a straight
forward calculation so err on the side of caution.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index aab107f..33fd7fe 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12832,7 +12832,12 @@ static void remap_intr(struct hfi1_devdata *dd, int isrc, int msix_intr)
 	/* clear from the handled mask of the general interrupt */
 	m = isrc / 64;
 	n = isrc % 64;
-	dd->gi_mask[m] &= ~((u64)1 << n);
+	if (likely(m < CCE_NUM_INT_CSRS)) {
+		dd->gi_mask[m] &= ~((u64)1 << n);
+	} else {
+		dd_dev_err(dd, "remap interrupt err\n");
+		return;
+	}
 
 	/* direct the chip source to the given MSI-X interrupt */
 	m = isrc / 8;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
