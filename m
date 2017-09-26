From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 4/7] IB/hfi1: Return correct value in general
 interrupt handler
Date: Tue, 26 Sep 2017 06:06:15 -0700
Message-ID: <20170926130614.31476.12014.stgit@scvm10.sc.intel.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926130434.31476.81826.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The general interrupt handler returns IRQ_HANDLED whether an IRQ
was handled or not.
Determine if an IRQ was handled and return the correct value.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 27b75a8..0be4278 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8240,6 +8240,7 @@ static irqreturn_t general_interrupt(int irq, void *data)
 	u64 regs[CCE_NUM_INT_CSRS];
 	u32 bit;
 	int i;
+	irqreturn_t handled = IRQ_NONE;
 
 	this_cpu_inc(*dd->int_counter);
 
@@ -8260,9 +8261,10 @@ static irqreturn_t general_interrupt(int irq, void *data)
 	for_each_set_bit(bit, (unsigned long *)&regs[0],
 			 CCE_NUM_INT_CSRS * 64) {
 		is_interrupt(dd, bit);
+		handled = IRQ_HANDLED;
 	}
 
-	return IRQ_HANDLED;
+	return handled;
 }
 
 static irqreturn_t sdma_interrupt(int irq, void *data)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
