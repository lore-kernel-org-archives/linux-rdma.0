From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/16] IB/hfi1: Ratelimit prints from sdma_interrupt
Date: Mon, 21 Aug 2017 18:26:38 -0700
Message-ID: <20170822012637.32701.52654.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Ratelimit error prints from sdma_interrupt function
that could swarm dmesg otherwise.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 ++--
 drivers/infiniband/hw/hfi1/hfi.h  |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 45f6874..ac967a9 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8290,8 +8290,8 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
 		/* handle the interrupt(s) */
 		sdma_engine_interrupt(sde, status);
 	} else {
-		dd_dev_err(dd, "SDMA engine %u interrupt, but no status bits set\n",
-			   sde->this_idx);
+		dd_dev_err_ratelimited(dd, "SDMA engine %u interrupt, but no status bits set\n",
+				       sde->this_idx);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index eadb735..3ac9c30 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -2119,9 +2119,15 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 #define dd_dev_emerg(dd, fmt, ...) \
 	dev_emerg(&(dd)->pcidev->dev, "%s: " fmt, \
 		  get_unit_name((dd)->unit), ##__VA_ARGS__)
+
 #define dd_dev_err(dd, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: " fmt, \
 			get_unit_name((dd)->unit), ##__VA_ARGS__)
+
+#define dd_dev_err_ratelimited(dd, fmt, ...) \
+	dev_err_ratelimited(&(dd)->pcidev->dev, "%s: " fmt, \
+			get_unit_name((dd)->unit), ##__VA_ARGS__)
+
 #define dd_dev_warn(dd, fmt, ...) \
 	dev_warn(&(dd)->pcidev->dev, "%s: " fmt, \
 			get_unit_name((dd)->unit), ##__VA_ARGS__)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
