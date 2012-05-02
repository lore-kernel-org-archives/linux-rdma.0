From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: correct ordering of reregister vs. port active event
Date: Wed, 2 May 2012 14:35:18 -0400
Message-ID: <20120502183518.1595.6540.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

When a port first goes active with SMA Set(PortInfo) and reregister bit set, the
driver sends up the reregister event followed by a port active event.

The problem is that in response to reregister event most apps try to issue a SA
query of some sort, but that fails because port is not active.

The qib driver needs to a trivial change to correct this behavior.

This issue has been there for a while, however the recent serdes
work has probably made the delay between the reregister event and the active
event larger and hence opened the race far enough so that its being seen more
often.

This fragment in subn_set_portinfo needs to move:

if (pip->clientrereg_resv_subnetto & 0x80) {
        clientrereg = 1;
        event.event = IB_EVENT_CLIENT_REREGISTER;
        ib_dispatch_event(&event);
}

This patch moves the code to just before the nested call to subn_get_portinfo():

    TO HERE
    ret = subn_get_portinfo(smp, ibdev, port);

The patch also changes the clientrereg local to a u8 and saves off the rereg bit into
it.  The code following the nested subn_get_portinfo() now restores that bit per o14-12.2.1
with a logical from that copy.

Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index c4ff788..9292c76 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -631,7 +631,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	struct qib_devdata *dd;
 	struct qib_pportdata *ppd;
 	struct qib_ibport *ibp;
-	char clientrereg = 0;
+	u8 clientrereg = (pip->clientrereg_resv_subnetto & 0x80);
 	unsigned long flags;
 	u16 lid, smlid;
 	u8 lwe;
@@ -781,12 +781,6 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 
 	ibp->subnet_timeout = pip->clientrereg_resv_subnetto & 0x1F;
 
-	if (pip->clientrereg_resv_subnetto & 0x80) {
-		clientrereg = 1;
-		event.event = IB_EVENT_CLIENT_REREGISTER;
-		ib_dispatch_event(&event);
-	}
-
 	/*
 	 * Do the port state change now that the other link parameters
 	 * have been set.
@@ -844,10 +838,15 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		smp->status |= IB_SMP_INVALID_FIELD;
 	}
 
+	if (clientrereg) {
+		event.event = IB_EVENT_CLIENT_REREGISTER;
+		ib_dispatch_event(&event);
+	}
+
 	ret = subn_get_portinfo(smp, ibdev, port);
 
-	if (clientrereg)
-		pip->clientrereg_resv_subnetto |= 0x80;
+	/* restore re-reg bit per o14-12.2.1 */
+	pip->clientrereg_resv_subnetto |= clientrereg;
 
 	goto get_only;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
