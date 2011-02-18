From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Return correct MAD when setting link width to 255
Date: Fri, 18 Feb 2011 06:54:21 -0500
Message-ID: <20110218115421.20818.55497.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Fix a bug which cause the driver to return incorrect MADs
as a response to Set(PortInfo) which sets the link width
to 0xFF or link speed to 0xF.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 43f8bbd..7c44726 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -705,7 +705,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	lwe = pip->link_width_enabled;
 	if (lwe) {
 		if (lwe == 0xFF)
-			lwe = ppd->link_width_supported;
+			set_link_width_enabled(ppd, ppd->link_width_supported);
 		else if (lwe >= 16 || (lwe & ~ppd->link_width_supported))
 			smp->status |= IB_SMP_INVALID_FIELD;
 		else if (lwe != ppd->link_width_enabled)
@@ -720,7 +720,8 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		 * speeds.
 		 */
 		if (lse == 15)
-			lse = ppd->link_speed_supported;
+			set_link_speed_enabled(ppd,
+					       ppd->link_speed_supported);
 		else if (lse >= 8 || (lse & ~ppd->link_speed_supported))
 			smp->status |= IB_SMP_INVALID_FIELD;
 		else if (lse != ppd->link_speed_enabled)
@@ -849,7 +850,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	if (clientrereg)
 		pip->clientrereg_resv_subnetto |= 0x80;
 
-	goto done;
+	goto get_only;
 
 err:
 	smp->status |= IB_SMP_INVALID_FIELD;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
