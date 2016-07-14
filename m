From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Thu, 14 Jul 2016 09:30:32 +0300
Message-ID: <20160714063032.GL10079@leon.nu>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
 <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
 <20160713163924.GA19657@obsidianresearch.com>
 <0959d391-75fb-75e8-ef2e-9d8c06b1b96f@mellanox.com>
 <20160713172116.GC19657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHuqAdgBYNjQz/wy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160713172116.GC19657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--lHuqAdgBYNjQz/wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2016 at 11:21:16AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 13, 2016 at 07:57:04PM +0300, Matan Barak wrote:
>=20
> > Maybe instead of having an idr per device, it's better to have an idr p=
er
> > uverbs file.
>=20
> Oh, I thought you were doing that already!
>=20
> Yes, the idr must be per ucontext, otherwise we create a big security
> problem. Access to one files object #'s cannot be allowed from another
> file.

On top of the Matan's response, regarding no security issue here. I
didn't see added value in multiplying IDRs, which would be if
creation per-file is done.

--lHuqAdgBYNjQz/wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhzGIAAoJEORje4g2clinLvEP/iQ7BcnLtnWRI+vA26semjQv
rZs8J2PEKDgnU45w4ek48jO08feSHwkEGE0vWqc2VOjqYB5G5xtSQ1xadbKstRDF
qqFXD663BdqWakmeGRusvgTu1ZC3bkD0buGgIXh2GGwujDi3cCTizpfn6ayNYMPs
jEWA+FcVLNS2tfdPH90WIlwtkCBp31AdB1MrNye4ttE+abdz1v4BhTCxjs8s8bHu
65hA0iskdhw39NEFKh8fmQQGPzZPIoj79IdeR6+OqfdIZKtjHdq0i0tXLxn1HeXy
FG+Wkivh2ALeM7xwokTDeibef8b+Z0GcK76F+INjSyNocwWj25zvwTVv5toWIoNF
X3lw3W28axNeH4PjoBZReGdnU8un8MsqHTwZrqA/6/aIq0nJuT15RQgMQC/VtLsD
Y56WJ2BFHOq05b7302X5hDCCpPoLQOeQJW57L8yITM1L6JELoN7+EjqBGENDgYVH
FYl/ygCZ9c+iG3BfOwZvKvgFmQyY2bULKBIGqttRNI2Z58kOLxTdB0JyHmtGOY6Y
czeiS4iDBfQLqhMAqPSFc/Eiwn6QaFuSRQj5ORAss2NR33QLYdf26VBHH5gTnPSM
cOW/s5wEWX3RKjq+X1hSZbMO0tf/1HV/NsYz1RTi2p7WP8PojmwnplVb1AdIVznB
DXzDNr7cJdAnk3StZ8iJ
=JBb6
-----END PGP SIGNATURE-----

--lHuqAdgBYNjQz/wy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
