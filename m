From: Michael Heinz <mheinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Adds SM CHANGE events to mthca and mlx4 drivers
Date: Wed, 01 Jun 2011 12:32:49 -0400
Message-ID: <20110601163217.27835.25961.stgit@kop-sds-dev-02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael Heinz <mheinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

This patch adds events to the handling of SM_LID and SM_SL changes.  When such changes occur, a event must be reported and driver stored copies of those addresses must be updated so that applications know the new path to the SM/SA.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c        |   18 +++++++++++++++---
 drivers/infiniband/hw/mthca/mthca_mad.c |   19 ++++++++++++++++---
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 57ffa50..e2c65a5 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -119,7 +119,8 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 	return err;
 }
 
-static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
+static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl,
+			 u16 *prev_sm_lid, u8 *prev_sm_sl)
 {
 	struct ib_ah *new_ah;
 	struct ib_ah_attr ah_attr;
@@ -138,8 +139,12 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 		return;
 
 	spin_lock(&dev->sm_lock);
-	if (dev->sm_ah[port_num - 1])
+	if (dev->sm_ah[port_num - 1]) {
+		struct mlx4_ib_ah *ah = to_mah(dev->sm_ah[port_num - 1]);
+		*prev_sm_lid = be16_to_cpu(ah->av.ib.dlid);
+		*prev_sm_sl = be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 28;
 		ib_destroy_ah(dev->sm_ah[port_num - 1]);
+	}
 	dev->sm_ah[port_num - 1] = new_ah;
 	spin_unlock(&dev->sm_lock);
 }
@@ -160,10 +165,13 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 			struct ib_port_info *pinfo =
 				(struct ib_port_info *) ((struct ib_smp *) mad)->data;
 			u16 lid = be16_to_cpu(pinfo->lid);
+			u16 prev_sm_lid = 0;
+			u8 prev_sm_sl = 0;
 
 			update_sm_ah(to_mdev(ibdev), port_num,
 				     be16_to_cpu(pinfo->sm_lid),
-				     pinfo->neighbormtu_mastersmsl & 0xf);
+				     pinfo->neighbormtu_mastersmsl & 0xf,
+		             &prev_sm_lid, &prev_sm_sl);
 
 			event.device	       = ibdev;
 			event.element.port_num = port_num;
@@ -171,6 +179,10 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 			if (pinfo->clientrereg_resv_subnetto & 0x80) {
 				event.event    = IB_EVENT_CLIENT_REREGISTER;
 				ib_dispatch_event(&event);
+			} else if (prev_sm_lid != be16_to_cpu(pinfo->sm_lid)
+					|| prev_sm_sl != (pinfo->neighbormtu_mastersmsl & 0xf)) {
+				event.event    = IB_EVENT_SM_CHANGE;
+				ib_dispatch_event(&event);
 			}
 
 			if (prev_lid != lid) {
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 03a59534..4566e75 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -72,7 +72,7 @@ out:
 }
 
 static void update_sm_ah(struct mthca_dev *dev,
-			 u8 port_num, u16 lid, u8 sl)
+			 u8 port_num, u16 lid, u8 sl, u16 *prev_sm_lid, u8 *prev_sm_sl)
 {
 	struct ib_ah *new_ah;
 	struct ib_ah_attr ah_attr;
@@ -92,8 +92,14 @@ static void update_sm_ah(struct mthca_dev *dev,
 		return;
 
 	spin_lock_irqsave(&dev->sm_lock, flags);
-	if (dev->sm_ah[port_num - 1])
+	if (dev->sm_ah[port_num - 1]) {
+		struct ib_ah_attr attr;
+		if (! mthca_ah_query(dev->sm_ah[port_num - 1], &attr)) {
+			*prev_sm_lid = attr.dlid;
+			*prev_sm_sl = attr.sl;
+		}
 		ib_destroy_ah(dev->sm_ah[port_num - 1]);
+	}
 	dev->sm_ah[port_num - 1] = new_ah;
 	spin_unlock_irqrestore(&dev->sm_lock, flags);
 }
@@ -116,11 +122,14 @@ static void smp_snoop(struct ib_device *ibdev,
 			struct ib_port_info *pinfo =
 				(struct ib_port_info *) ((struct ib_smp *) mad)->data;
 			u16 lid = be16_to_cpu(pinfo->lid);
+			u16 prev_sm_lid = 0;
+			u8 prev_sm_sl = 0;
 
 			mthca_update_rate(to_mdev(ibdev), port_num);
 			update_sm_ah(to_mdev(ibdev), port_num,
 				     be16_to_cpu(pinfo->sm_lid),
-				     pinfo->neighbormtu_mastersmsl & 0xf);
+				     pinfo->neighbormtu_mastersmsl & 0xf,
+			         &prev_sm_lid, &prev_sm_sl);
 
 			event.device           = ibdev;
 			event.element.port_num = port_num;
@@ -128,6 +137,10 @@ static void smp_snoop(struct ib_device *ibdev,
 			if (pinfo->clientrereg_resv_subnetto & 0x80) {
 				event.event    = IB_EVENT_CLIENT_REREGISTER;
 				ib_dispatch_event(&event);
+			} else if (prev_sm_lid != be16_to_cpu(pinfo->sm_lid)
+			           || prev_sm_sl != (pinfo->neighbormtu_mastersmsl & 0xf)) {
+				event.event    = IB_EVENT_SM_CHANGE;
+				ib_dispatch_event(&event);
 			}
 
 			if (prev_lid != lid) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
