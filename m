From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: This merge window...
Date: Sat, 15 Jul 2017 14:12:42 -0400
Message-ID: <11752e09-6ac3-6362-0aac-8e735b80033b@redhat.com>
References: <824b3771-78a6-7c80-50d9-a34383169185@redhat.com>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg@mail.gmail.com>
 <1499875106.2924.26.camel@redhat.com> <20170712160432.GA24552@infradead.org>
 <20170712171044.GE1528@mtr-leonro.local>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136@grimberg.me>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="49F3TEoGCUpbbnOXSVcx79qupvhiIS5pr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--49F3TEoGCUpbbnOXSVcx79qupvhiIS5pr
Content-Type: multipart/mixed; boundary="FOObCgg566B1BolqDWFlhTxpT028FaKqf";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <11752e09-6ac3-6362-0aac-8e735b80033b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: This merge window...
References: <824b3771-78a6-7c80-50d9-a34383169185-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1499875106.2924.26.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20170712160432.GA24552-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20170712171044.GE1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
In-Reply-To: <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>

--FOObCgg566B1BolqDWFlhTxpT028FaKqf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/14/2017 10:28 AM, Christopher Lameter wrote:
> On Thu, 13 Jul 2017, Sagi Grimberg wrote:
>=20
>> Join on the awesomeness.
>=20
> It would even be more awesome if we had multiple people that can work t=
he
> release process so that we do not have a single person bottleneck.
>=20
> Doug: Would you please do some more detailed planning and delegate thin=
gs
> as possible? A couple of developers should be able to review the curren=
t
> state of things and help to move things forward if there is a bottlenec=
k
> currently or coming up.
>=20

I am, without a doubt, reworking my process.  I will not be syncing up
against Dave Miller's tree any more.  When I take patches, they should
apply cleanly to my tree and work without dependencies.  If there are
dependencies, then people need to send the dependencies through Dave's
tree (assuming that's where they go) in release X, and then send the
dependent code to my tree in release X + 1.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--FOObCgg566B1BolqDWFlhTxpT028FaKqf--

--49F3TEoGCUpbbnOXSVcx79qupvhiIS5pr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZalshAAoJELgmozMOVy/dencP/j/Sa/Xyf/Mo/M2KnbDYeg1+
X6S/czLKPzugWU/TlPuj3c+4PfRbHa1O+eZt7X0tZK5cdhNwsyukuFoJQly8mkNv
AUtM9yP2mYzDMombGk3BDxewB6Nt3w1n/vfjkOD9mCeAdkA8xSPSUsynO4EF0/7R
G+6+MBiQPQZNse5E48l66SE8aKpx+cmP5OBoV3RBPEL9APAhxG2Ccee/oWJdXyGo
OBW7PKRpmTUbGne66FCCayFAuQnFmIFqaZR6VSrQ55HD0C+TtjP6eMTUZQG+UAAn
NE/TYGBKdIfgG0xoYohx+J6WRohflFteeZBOP2OF2h4cUCHmEIrblCY0ufSx1cZn
XJOYuWR5TbJP6i7E2iSXyEGJ4A5IHrf7oma96uIRHpZ2iVnWgGlAbRqrKMTm53Kq
zmO8y6DUqir9j8/v8Hd5G1qu495zRjQ7XH4CD/z2ayapaWnjvZV5EnXFViVCXtRv
vowqLR6J/hXJIT0xw86VcYA4zRswVOU1Ej+AWg7p0zWCn505T0WPHJ3fPY+KSa2d
fu9aThe/FVYunR3TO4RUx4HuP6d78cmt/oJHUaBMX6tQWvCSIEGib9zw/BaJXqYQ
6Nt4/LHMyx3R+CNGPtEYW8BqBUVYfkoxaEgnQ4IJ7R9PRUPKTiSnFjGYcj6yZwly
c5gCH0AW7sX3NhB2Ta0s
=hNW1
-----END PGP SIGNATURE-----

--49F3TEoGCUpbbnOXSVcx79qupvhiIS5pr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
