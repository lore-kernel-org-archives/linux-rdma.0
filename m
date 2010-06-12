From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH 1/2] ib_ipath: Fix probe failure path
Date: Sat, 12 Jun 2010 03:25:09 +0100
Message-ID: <1276309509.14011.173.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FCF7xaRmpto3s4reMrj/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-FCF7xaRmpto3s4reMrj/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The failure path in ipath_init_one() does not match the cleanup code
in ipath_remove_one() and appears to leave interrupts enabled in some
cases.  Change it to match.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
In recent Debian kernel packages this driver is patched to use an
external firmware image for the SD7220.  A user reported in
<http://bugs.debian.org/579393> that if the firmware image is missing
the driver crashes about a second later, and I believe this is due to
incomplete cleanup on the failure path.  He has not yet had an
opportunity to test this patch.

Ben.

 drivers/infiniband/hw/ipath/ipath_driver.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniban=
d/hw/ipath/ipath_driver.c
index 2133746..765f0fc 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -390,6 +390,8 @@ done:
 	ipath_enable_armlaunch(dd);
 }
=20
+static void cleanup_device(struct ipath_devdata *dd);
+
 static int __devinit ipath_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
@@ -616,8 +618,13 @@ static int __devinit ipath_init_one(struct pci_dev *pd=
ev,
 	goto bail;
=20
 bail_irqsetup:
-	if (pdev->irq)
-		free_irq(pdev->irq, dd);
+	cleanup_device(dd);
+
+	if (dd->ipath_irq)
+		dd->ipath_f_free_irq(dd);
+
+	if (dd->ipath_f_cleanup)
+		dd->ipath_f_cleanup(dd);
=20
 bail_iounmap:
 	iounmap((volatile void __iomem *) dd->ipath_kregbase);
@@ -635,7 +642,7 @@ bail:
 	return ret;
 }
=20
-static void __devexit cleanup_device(struct ipath_devdata *dd)
+static void cleanup_device(struct ipath_devdata *dd)
 {
 	int port;
 	struct ipath_portdata **tmp;
--=20
1.7.1




--=-FCF7xaRmpto3s4reMrj/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATBLv/ue/yOyVhhEJAQKYFRAAioeWEyyKVBvA/mfHwyU/FVidd7xmyPS4
VvFvp1AGR3vfu1JWs8OHKi+ZHKyTCy3RRU/v0N6Qp4qWb0nAjmK3HaM/LLXBvwpa
Udf1sflN7XfwAzcjM2L5JTHyau8LGM6A1vjjF0DBDafvOfT8wPCb1z73CvbXJHaQ
Wbqi2vBPDHgSkSWle+dtu2nmmOkdeQVxT57/fpnPC9ossK6ArkZbvenJD0JrC6Nl
tRRjLrdypFUyH41hHns42jgS3hVxvEChbOiTLR6pnz9KQkj7qwO484x7cYs3yiFz
YD8dTWembQo7J5jl+bluq5t8osOFRzN9VtFEMpwglo6F0tqo4VQvFj8dFT40m+9L
IhHED0g9mlB1exfWjAbz0a90/cbOD8IG4guGp/FufxQhi0wv4zFd7LhYsr1/Y7WX
pFPSLPAV3ID8g1Q7H3oxD2IgbNXfMQ7xDtTO17R4G8ICZybhUisuHckgklwCtNkC
383MakfClhvaN9iDUm6P2hR3DMpAql9YLGc81rSs6GQWZYajrOecJld5iu0ztZug
SA6SFY1KYm6QlOhPmlpi5lVBR3DPfPNsGEauB50xBuGOedxcnTB4MHjMPsA/S5+m
Rm2JYdfPrq2yrDG/9v+71pAJoeiiqcc6upRzUeZ5YFcEApROlPNqTiOP0s8anNvY
KsbBZZPkb/k=
=lS24
-----END PGP SIGNATURE-----

--=-FCF7xaRmpto3s4reMrj/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
