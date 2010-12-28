From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/24] IB/qib: set port physical state even if other fields
	are invalid
Date: Tue, 28 Dec 2010 10:27:21 -0500
Message-ID: <20101228152721.19960.64839.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The IBTA vol. 1 release 1.2.1 spec. says:
C14-24.2.1: If PortInfo:Portstate=Down, then a SubnSet(PortInfo)
shall make any changes it specifies to PortInfo:PortPhysicalState;
any other result is vendor-dependent.

The patch changes the error handling so that the reply says there
are invalid fields but still attempts to set fields that are
in range including PortInfo:PortPhysicalState.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |   45 +++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 9794020..113807b 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -668,8 +668,8 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	lid = be16_to_cpu(pip->lid);
 	/* Must be a valid unicast LID address. */
 	if (lid == 0 || lid >= QIB_MULTICAST_LID_BASE)
-		goto err;
-	if (ppd->lid != lid || ppd->lmc != (pip->mkeyprot_resv_lmc & 7)) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+	else if (ppd->lid != lid || ppd->lmc != (pip->mkeyprot_resv_lmc & 7)) {
 		if (ppd->lid != lid)
 			qib_set_uevent_bits(ppd, _QIB_EVENT_LID_CHANGE_BIT);
 		if (ppd->lmc != (pip->mkeyprot_resv_lmc & 7))
@@ -683,8 +683,8 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	msl = pip->neighbormtu_mastersmsl & 0xF;
 	/* Must be a valid unicast LID address. */
 	if (smlid == 0 || smlid >= QIB_MULTICAST_LID_BASE)
-		goto err;
-	if (smlid != ibp->sm_lid || msl != ibp->sm_sl) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+	else if (smlid != ibp->sm_lid || msl != ibp->sm_sl) {
 		spin_lock_irqsave(&ibp->lock, flags);
 		if (ibp->sm_ah) {
 			if (smlid != ibp->sm_lid)
@@ -707,8 +707,9 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		if (lwe == 0xFF)
 			lwe = ppd->link_width_supported;
 		else if (lwe >= 16 || (lwe & ~ppd->link_width_supported))
-			goto err;
-		set_link_width_enabled(ppd, lwe);
+			smp->status |= IB_SMP_INVALID_FIELD;
+		else if (lwe != ppd->link_width_enabled)
+			set_link_width_enabled(ppd, lwe);
 	}
 
 	lse = pip->linkspeedactive_enabled & 0xF;
@@ -721,8 +722,9 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		if (lse == 15)
 			lse = ppd->link_speed_supported;
 		else if (lse >= 8 || (lse & ~ppd->link_speed_supported))
-			goto err;
-		set_link_speed_enabled(ppd, lse);
+			smp->status |= IB_SMP_INVALID_FIELD;
+		else if (lse != ppd->link_speed_enabled)
+			set_link_speed_enabled(ppd, lse);
 	}
 
 	/* Set link down default state. */
@@ -738,7 +740,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 					IB_LINKINITCMD_POLL);
 		break;
 	default:
-		goto err;
+		smp->status |= IB_SMP_INVALID_FIELD;
 	}
 
 	ibp->mkeyprot = pip->mkeyprot_resv_lmc >> 6;
@@ -748,15 +750,17 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 
 	mtu = ib_mtu_enum_to_int((pip->neighbormtu_mastersmsl >> 4) & 0xF);
 	if (mtu == -1)
-		goto err;
-	qib_set_mtu(ppd, mtu);
+		smp->status |= IB_SMP_INVALID_FIELD;
+	else
+		qib_set_mtu(ppd, mtu);
 
 	/* Set operational VLs */
 	vls = (pip->operationalvl_pei_peo_fpi_fpo >> 4) & 0xF;
 	if (vls) {
 		if (vls > ppd->vls_supported)
-			goto err;
-		(void) dd->f_set_ib_cfg(ppd, QIB_IB_CFG_OP_VLS, vls);
+			smp->status |= IB_SMP_INVALID_FIELD;
+		else
+			(void) dd->f_set_ib_cfg(ppd, QIB_IB_CFG_OP_VLS, vls);
 	}
 
 	if (pip->mkey_violations == 0)
@@ -770,10 +774,10 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 
 	ore = pip->localphyerrors_overrunerrors;
 	if (set_phyerrthreshold(ppd, (ore >> 4) & 0xF))
-		goto err;
+		smp->status |= IB_SMP_INVALID_FIELD;
 
 	if (set_overrunthreshold(ppd, (ore & 0xF)))
-		goto err;
+		smp->status |= IB_SMP_INVALID_FIELD;
 
 	ibp->subnet_timeout = pip->clientrereg_resv_subnetto & 0x1F;
 
@@ -792,7 +796,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	state = pip->linkspeed_portstate & 0xF;
 	lstate = (pip->portphysstate_linkdown >> 4) & 0xF;
 	if (lstate && !(state == IB_PORT_DOWN || state == IB_PORT_NOP))
-		goto err;
+		smp->status |= IB_SMP_INVALID_FIELD;
 
 	/*
 	 * Only state changes of DOWN, ARM, and ACTIVE are valid
@@ -812,8 +816,10 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 			lstate = QIB_IB_LINKDOWN;
 		else if (lstate == 3)
 			lstate = QIB_IB_LINKDOWN_DISABLE;
-		else
-			goto err;
+		else {
+			smp->status |= IB_SMP_INVALID_FIELD;
+			break;
+		}
 		spin_lock_irqsave(&ppd->lflags_lock, flags);
 		ppd->lflags &= ~QIBL_LINKV;
 		spin_unlock_irqrestore(&ppd->lflags_lock, flags);
@@ -835,8 +841,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		qib_set_linkstate(ppd, QIB_IB_LINKACTIVE);
 		break;
 	default:
-		/* XXX We have already partially updated our state! */
-		goto err;
+		smp->status |= IB_SMP_INVALID_FIELD;
 	}
 
 	ret = subn_get_portinfo(smp, ibdev, port);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
