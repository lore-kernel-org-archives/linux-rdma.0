From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [patch] ib/rxe: double free on error
Date: Sat, 18 Jun 2016 13:34:30 +0300
Message-ID: <20160618103430.GC5408@leon.nu>
References: <20160618084021.GB21713@mwanda>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FexDM9E/OpjgUmaq"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160618084021.GB21713@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--FexDM9E/OpjgUmaq
Content-Type: multipart/mixed; boundary="uWA6ivsFTdIbDdzo"
Content-Disposition: inline


--uWA6ivsFTdIbDdzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 18, 2016 at 11:40:21AM +0300, Dan Carpenter wrote:
> "goto err1" could probably be remained "goto free_pkey_tbl" since
> that's what it does.  This is a double free.
>=20
> Fixes: 0784481b2f32 ('Add initialization for Soft RoCE driver, pools cons=
tants etc.')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Hi Dan,

Thank you for pointing it out.

I rewrote your patch a little bit and applied it.


--uWA6ivsFTdIbDdzo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-IB-rxe-Simplify-rxe_init_ports-logic.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 6a320576c7304905df722afcf1b8d49242c8ae48 Mon Sep 17 00:00:00 2001
=46rom: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 18 Jun 2016 11:40:21 +0300
Subject: [PATCH] IB/rxe: Simplify rxe_init_ports logic

Simplify rxe_init_ports and remove double free.

Fixes: 0784481b2f32 ('Add initialization for Soft RoCE driver, pools consta=
nts etc.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/hw/rxe/rxe.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/rxe/rx=
e.c
index 48c41e00..156a1021 100644
--- a/drivers/infiniband/hw/rxe/rxe.c
+++ b/drivers/infiniband/hw/rxe/rxe.c
@@ -165,42 +165,25 @@ static int rxe_init_port_param(struct rxe_port *port)
  */
 static int rxe_init_ports(struct rxe_dev *rxe)
 {
-	int err;
-	struct rxe_port *port;
-
-	port =3D &rxe->port;
+	struct rxe_port *port =3D  rxe->port;
=20
 	rxe_init_port_param(port);
=20
-	if (!port->attr.pkey_tbl_len) {
-		err =3D -EINVAL;
-		goto err1;
-	}
+	if (!port->attr.pkey_tbl_len || !port->attr.gid_tbl_len)
+		return -EINVAL;
=20
 	port->pkey_tbl =3D kcalloc(port->attr.pkey_tbl_len,
 			sizeof(*port->pkey_tbl), GFP_KERNEL);
-	if (!port->pkey_tbl) {
-		err =3D -ENOMEM;
-		goto err1;
-	}
-
-	port->pkey_tbl[0] =3D 0xffff;
=20
-	if (!port->attr.gid_tbl_len) {
-		kfree(port->pkey_tbl);
-		err =3D -EINVAL;
-		goto err1;
-	}
+	if (!port->pkey_tbl)
+		return -ENOMEM;
=20
+	port->pkey_tbl[0] =3D 0xffff;
 	port->port_guid =3D rxe->ifc_ops->port_guid(rxe);
=20
 	spin_lock_init(&port->port_lock);
=20
 	return 0;
-
-err1:
-	kfree(port->pkey_tbl);
-	return err;
 }
=20
 /* init pools of managed objects */
--=20
2.1.4


--uWA6ivsFTdIbDdzo--

--FexDM9E/OpjgUmaq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXZSO2AAoJEORje4g2cliny7YP/RHz9kle2cA6y3/252uAAVTL
rVoIDm12wPZkLwHHoqaIOJ2XrJWumcY5PJflJkHo8NrrQHfd2C+v1FIOnW6dZtDj
+C2Z8Np5KLeH3IEShSYDGijeTEU08ubJSFNZK415FNpfN5Hb4HgttkeREULCwHEf
3iPi3Wqr20fRdmDBpOwU5ZejxSgKhSSFTW8BoN/65U5X/NJeYlIsXuSAmAXKQ3Th
zScIWyrYMo2yGquJO5kBWKHHHkThXTHrm+diCD0MpIOdd6trnh67o+Did6Vv7U0/
SZ23Bv+whTKwTdKVt+dX4AHuRfEHH/LTBgR3WpvN4P/rAIZO8nwksGquKeaJCYDP
F401xclkaMAI0V0pFnjotDgpvjCujIsCU9qMReMW2qJSUMEtiLyiPuxF1O34vaQ2
vAPOxBbBkYv9TdmzDlgXRrxOlGMt/QMYqHWpJvHxSFdNtcuYZXOQgCBU1OocNqfL
+kNs6BxTP1l5Q/cAfSeQwTMj4aEN8/165hH81ElkBJqTEKv3KrfJ6NJnQzJAiU30
CS7uSEPUQBGPwGU7TT45a2I6tJBLYuhivNgoOwnf4QhyG3RjnnmIcQA6yGF0g1Cr
w0BV0sVe+CE4BcDdb5huWaCNxZdriRNfXOwet6xrMtA8v7iUyBtBcZf7/en2Ygbo
57AHwiNS9c01U0gFowjS
=cHrg
-----END PGP SIGNATURE-----

--FexDM9E/OpjgUmaq--
