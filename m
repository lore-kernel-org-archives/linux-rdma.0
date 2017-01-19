From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 18 Jan 2017 19:16:29 -0500
Message-ID: <1484784989.2406.67.camel@redhat.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
         <20170111181042.GC22783@obsidianresearch.com>
         <1484773260.2406.58.camel@redhat.com>
         <20170118210831.GA7590@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-l05oIzPa7IuaY++C21vt"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170118210831.GA7590@obsidianresearch.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org


--=-l05oIzPa7IuaY++C21vt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 14:08 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 18, 2017 at 04:01:00PM -0500, Doug Ledford wrote:
>=20
> >=20
> > OK, sure, as far as the reordering stuff is concerned, all you need
> > to
> > do is to make use of the EPROBE_DEFER return option to your PCI
> > probe
> > routine. =C2=A0That way, when you get the probe for the out of order
> > port,
>=20
> EPROBE_DEFER is intended when waiting on other components the driver
> may need, not for setting stable names.

What it's intended for, and what it can be used for, need not be the
same.

> This is a 'stable device naming' problem, which we have never tried
> to
> solve in RDMA.

No, that would imply they must be hfi1_0 and hfi1_1, when this is not
the case. =C2=A0If you had two cards in this system, both dual port, then
you may be wanting to rename hfi_3 to hfi1_2 and vice versa. =C2=A0It is a
relative name problem, not a stable name problem. =C2=A0We need only revers=
e
the order that the ports are probed in, their names are whatever they
end up being once reversed.

> udev is the expected kernel way to solve this. Trying to hack stable
> names by forcing device bind order is horrible.

This is a manufacturing defect. =C2=A0Something I'm sure Intel wants to
resolve without requiring users to go in and manually name their ports.
=C2=A0I have no doubt that they would prefer that the user remain blissfull=
y
unaware of the issue, all except for the ones that probably reported it
and already have their system cabled up wrong as a result.

> hfi runs smack into this because it is the first scheme to actually
> typically operate in a multi-struct ib_device world, which means they
> get to solve it properly :\

No, mlx5 could have easily hit this too as their ports are separate PCI
functions. =C2=A0As I said, it's a manufacturing defect and that means I'm
sure Intel would prefer to solve it silently and automatically. =C2=A0I
would if I were them anyway.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-l05oIzPa7IuaY++C21vt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYgAVdAAoJELgmozMOVy/dMpoP/2bAIyv0RJKFzqhOiwriFj77
CZtzAYm7Yr8L5JSqG9TWEa51aZa6x2w26VryYkaxxWnm716XmMkpFMyT/0WPx9Sy
7HRxoDTeEFywjNHeevDVmouTEnqR4C+QZx0xPKPb4VQ9Af90qiTdoZUDv0jMPzWX
JJENIeBZLERB27nAtap5MCtCKWs5jrx0CNq7F1KDE72iWAdlxTyPshlenFu61Y5y
nci3DTd1czaRUyOKRpRDqsFMAn41KR35hNwTGqMMz1ko4eWy3nCFZPvKsrkWEdUQ
NUXH1yJPMk5AJGK6Y6n8h1zlKjx7jWljfzEK1fV0IiyTon0ntT7l+56yak0OkuaB
Vr7jfVUmhygS9WYnAirDTBccBHdsGAGuLinoxX12Q7Ow8B69PL1ubeATwp3rPNIi
Js3fyWUVZPo8ZOix2rbhCpoXZglIFZpZj4ll0icZoXd0ksZS8/BIldevBYneCgeN
/yuelxDcHQSumD3X7+g91bobbfDO0P72pInmNl2arxkm1vS/SriXweqyPFum71Ab
n1HSuSrtJ4R1GYBR3Owa6P+jTD0vinplqDZc2ndANaRxx05aEh8UHzWG0RsD84og
q/TzP93FPAgh39NxCrQv+JGhVSIWe8UaXWT8sQ63GP7tTmVcbgc31xQsjjSFN3o6
S4eSfsi+bsRgJAbtxJ+J
=9pxy
-----END PGP SIGNATURE-----

--=-l05oIzPa7IuaY++C21vt--
