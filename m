From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 06/17] IB/hfi1: Remove debug prints after
 allocation failure
Date: Sat, 03 Dec 2016 13:31:59 -0500
Message-ID: <1480789919.15032.67.camel@redhat.com>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
         <1478184265-9620-7-git-send-email-leon@kernel.org>
         <1478923438.2458.9.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-J1jl7m2ZxlDHsSDCxSCq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478923438.2458.9.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-J1jl7m2ZxlDHsSDCxSCq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-11-12 at 04:04 +0000, Dalessandro, Dennis wrote:
> On Thu, 2016-11-03 at 16:44 +0200, Leon Romanovsky wrote:
> >=20
> > The prints after [k|v][m|z|c]alloc() functions are not needed,
> > because in case of failure, allocator will print their internal
> > error prints anyway.
> >=20
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Denny,

Your Ack was not recorded by patchworks. =C2=A0Something about the way it
was signed or something like that. =C2=A0All patchworks saw was what looked
like an encyrpted or signed block, with no legible text.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-J1jl7m2ZxlDHsSDCxSCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYQw+fAAoJELgmozMOVy/dRfIQAMG8cJshzFw1lphYlURghi43
+8ff55W8A5eD5OLZ0F+ax6PwPVqmWGqdIFHegGg8A5+WL3B9pzjoYGccLPlS0wwS
CBTdF/fQIGppnpgPHlM6EIY1W7gk8P/leOuNRIlOAD0yhFtfdNO7zG1GdbjzviQQ
Z9J25eDxFS6RdY6CqP27z0kkcrysPTIZTy8N7s6jQxCfVcpWrhNXniDy0i3DRA28
WOC3hwl0FUIx3FGfldXdqbrHDc4W7SEshY0fhyP2xxT8l7uFu1X3xCUI2P6kNLfy
vRHwk4yTUBKuBJ9wBYAjiuM/FTWj7g8hm+h61H1z/13XWrXSiAB9HjfHM1+6MVho
Vmm7NVb3JK04AMrUJGLAZVrNQ9+4YqZbFGjQ8lFX3rdV47BSiaqYboAtY/SI0Dnh
7ToQoPv17ckXCu3SW99n2IEtaX5c5pLtM697AAocp8vRCQxASV2CupLPwD/hAS9l
6Y7eb1qdLGVv2UOWZQaKmoc8arfMD911mUfpbXBDP6fkF7Mhhfx8vIyr7BwLh/m1
C+gll3Mja/szBNPwgUDGMb/b6+JzBx7jZO1nOWsRMJ2U0K3wl5uS5j/R11iqCZAo
dEsC1LlNVvWo8/TKDJoP183MH1r+HYhzO5neZJ+gFF65bBEibMgRYTqmaeUK1MLT
G6+ozdY+aw/ubSQiidOq
=cnEa
-----END PGP SIGNATURE-----

--=-J1jl7m2ZxlDHsSDCxSCq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
