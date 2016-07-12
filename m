From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 1/8] RDMA/core: Export RDMA IOCTL declarations
Date: Tue, 12 Jul 2016 22:43:03 +0300
Message-ID: <20160712194303.GB10079@leon.nu>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-2-git-send-email-matanb@mellanox.com>
 <20160712191256.GA8206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160712191256.GA8206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 01:12:56PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 30, 2016 at 04:39:24PM +0300, Matan Barak wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > Place all external RDMA IOCTL declarations into one UAPI exported
> > header file and move all legacy MAD commands to that file.
> >=20
> > Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patch seems fine to me.
>=20
> > +/* Legacy part
> > + * !!!! NOTE: It uses the same command index as VERBS
>=20
> Not sure what this comment means, all IOCTLs in this file should use
> IB_IOCTL_MAGIC  ..

I meant numbers 1,2,... in the defines, wrote as a reminder.
+#define IB_USER_MAD_REGISTER_AGENT     _IOWR(IB_IOCTL_MAGIC, 1, \
------------------------------------------------------------^^^^^---

>=20
> > +#include <rdma/ib_user_mad.h>
>=20
> Strange not to be at the top.

To be on safe side, to preserve legacy structure.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhUhHAAoJEORje4g2clingRAQALW3gmd8mt3XfJvUXJeOpFqz
4LnQzQcdU4PuQYw3/mz8z9lulz8v4qWHdAidZjyZiDA0xjI+CPTGyJFjOU4ue+8P
Kr7Co3QtEqhlOKgjz2F7yBMaafv73cHM3kMLVQ3rTuHskYiLVNMAH54uFCd4QIXi
ADt1QqgDCrVpkPbSCqipjLN7K23XX1uFN4JnnvY24Qi3q3jTRSFxjew2IgGoG3jh
u3ayilYbHHOtsnjvh0/+d495PUAFHYZiXVnJ+ZtnobWB2YqQKZoPruNO0bPGNAQ9
6hCeMbYtqq3BCt3/Xp8oOuiV8NU27ljSx7H3jfE4bRKmMHZSIdHZ11yJIs215gN+
Sq1mybzqHvEy3RCcmN63XT5pDtt8glSVO2WwkgeQlA4V/eBsgQQQDb2rkqUYwsND
pTv7y0E5Fi+6VxqC+iAcJb9onhLY/iW3UycMZaznMOHm2z/YmWdWh+uR1CVJDVpR
I6ZXfVLKeJNwRGf5jPviSGd1u/mgMcV2xOp2GdIq2W1baFaQSS6/dA68Ngw1/YEI
u690DOVbdTmuDhIeC87xlEmeeoKEIpykX1fX462H3gaUpvfT7taXXuJhkM9cwzYO
ldRABC/+d/0Cev90AfRjn4bsbQJutX/irFk4o2eEyrRGijn6vNdUnRlc2q0l2M/x
grOUfRgLCdFjvSnaHerY
=MyQo
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
