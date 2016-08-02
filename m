From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Disable rdmavt and hfi1 drivers by default
Date: Tue, 02 Aug 2016 15:05:35 -0400
Message-ID: <1470164735.18081.30.camel@redhat.com>
References: <e6761c19-f301-ffc4-8283-ea958a387313@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/nC3wXlmHxJ+AnLub63H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e6761c19-f301-ffc4-8283-ea958a387313-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/nC3wXlmHxJ+AnLub63H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-19 at 10:02 -0700, Bart Van Assche wrote:
> Hi Doug,
>=20
> Since there is a strict policy in the Linux kernel that new drivers
> must=C2=A0
> be disabled by default, hence this series with two small patches
> that=C2=A0
> ensure that e.g. "make oldconfig" neither enables the rdmavt nor the=C2=
=A0
> hfi1 driver. The patches in this series are:
>=20
> 0001-IB-rdmavt-Disable-by-default.patch
> 0002-IB-hfi1-Disable-by-default.patch
>=20
> Thanks,
>=20
> Bart.

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-/nC3wXlmHxJ+AnLub63H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoO7/AAoJELgmozMOVy/dT6oP/AtfI/qbN4ye95BK05KMX88P
PFZqiuj+VOtLnZISeRWbHFX8i15IgfDY3Zqy4hznb/2U+bW4mOylPa1cN815ABlB
MrC2n5PWBQdGVfdr8TbLm/URIoY/vrE7Xs7g5ZPuOli/METYeGCp/LYZqgN7RQ+E
psUsCojMhMUit4XAYWK9p48bHsoTbz7GbTrDSFLcs7Hp7baMMRBE8fjmBXbGX8H9
dCsQmWlw7UJFeN3vXu1AN1D+hx1+LK3wKvcTinrgwpBqn4bN8RUPokR/jR5q2kap
aEV4QUm035Qx+t2OYhiwBbqFbsDvR9xXrELgSzxRoEut7WAkG0glYWm24tTtUCm2
Dh2AitwOhaCp/JyucZHVEwtUj8xNDJVIWGSIJz79llztoZT1aqpf1Vh6nVT5+vv2
/Ku7O1he3oIdKWzR0Nm8jLGjC0Hb8XpQhbQlEataexbpudNkLUjUQIFhOCgpo1Zr
n3mllXjrq2TnFQdfNO+hperT1az9/1QBFukwLWN4f9toh/5Vp2AvxBVslny8qPcq
W/qyx7C+412ITZR2/SDiO07bl6+8TiAjtaYM3ncpwZrgIcIOo9g+FDe3qBaFvva2
1NXvxpAGirrnBFDU5jzK/tMOjU7/iWen5cBY7rAB0hDG88WdPtKzv3AhE2WBTF91
sezGPxmXqY6YwFD+xOSQ
=M02V
-----END PGP SIGNATURE-----

--=-/nC3wXlmHxJ+AnLub63H--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
