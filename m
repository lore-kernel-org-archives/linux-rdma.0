From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Update active link width
Date: Thu, 14 Jul 2011 09:40:24 -0400
Message-ID: <20110714134024.5549.93153.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Update the active link width on QLE7220 chips when
link goes down if chip width does not match shadowed
width.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7220.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index c765a2e..e1f9474 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2434,6 +2434,7 @@ static int qib_7220_set_ib_cfg(struct qib_pportdata *ppd, int which, u32 val)
 	int lsb, ret = 0, setforce = 0;
 	u16 lcmd, licmd;
 	unsigned long flags;
+	u32 tmp = 0;
 
 	switch (which) {
 	case QIB_IB_CFG_LIDLMC:
@@ -2467,9 +2468,6 @@ static int qib_7220_set_ib_cfg(struct qib_pportdata *ppd, int which, u32 val)
 		maskr = IBA7220_IBC_WIDTH_MASK;
 		lsb = IBA7220_IBC_WIDTH_SHIFT;
 		setforce = 1;
-		spin_lock_irqsave(&ppd->lflags_lock, flags);
-		ppd->lflags |= QIBL_IB_FORCE_NOTIFY;
-		spin_unlock_irqrestore(&ppd->lflags_lock, flags);
 		break;
 
 	case QIB_IB_CFG_SPD_ENB: /* set allowed Link speeds */
@@ -2643,6 +2641,28 @@ static int qib_7220_set_ib_cfg(struct qib_pportdata *ppd, int which, u32 val)
 			goto bail;
 		}
 		qib_set_ib_7220_lstate(ppd, lcmd, licmd);
+
+		maskr = IBA7220_IBC_WIDTH_MASK;
+		lsb = IBA7220_IBC_WIDTH_SHIFT;
+		tmp = (ppd->cpspec->ibcddrctrl >> lsb) & maskr;
+		/* If the width active on the chip does not match the
+		 * width in the shadow register, write the new active
+		 * width to the chip.
+		 * We don't have to worry about speed as the speed is taken
+		 * care of by set_7220_ibspeed_fast called by ib_updown.
+		 */
+		if (ppd->link_width_enabled-1 != tmp) {
+			ppd->cpspec->ibcddrctrl &= ~(maskr << lsb);
+			ppd->cpspec->ibcddrctrl |=
+				(((u64)(ppd->link_width_enabled-1) & maskr) <<
+				 lsb);
+			qib_write_kreg(dd, kr_ibcddrctrl,
+				       ppd->cpspec->ibcddrctrl);
+			qib_write_kreg(dd, kr_scratch, 0);
+			spin_lock_irqsave(&ppd->lflags_lock, flags);
+			ppd->lflags |= QIBL_IB_FORCE_NOTIFY;
+			spin_unlock_irqrestore(&ppd->lflags_lock, flags);
+		}
 		goto bail;
 
 	case QIB_IB_CFG_HRTBT: /* set Heartbeat off/enable/auto */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
