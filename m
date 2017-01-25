From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ANNOUNCE - New release of rdma-core
Date: Wed, 25 Jan 2017 12:27:49 -0500
Message-ID: <1485365269.2432.8.camel@redhat.com>
References: <1484683744.2406.29.camel@redhat.com>
         <20170125090506.GA746@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-s9T5ixyyl+9uG1k3geIe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125090506.GA746-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-s9T5ixyyl+9uG1k3geIe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-25 at 01:05 -0800, Christoph Hellwig wrote:
> On Tue, Jan 17, 2017 at 03:09:04PM -0500, Doug Ledford wrote:
> >=20
> > The final upstream release of version 12 of the rdma-core package
> > has
> > been tagged and pushed to github.
> >=20
> > This marks the first official release of the rdma-core package, and
> > also the first release of libibverbs not to be hosted on kernel.org
> > and
> > openfabrics.org.
>=20
> So where is it hosted?=C2=A0=C2=A0I don't see any link to a tarball.

It's on github. =C2=A0When viewing the repo, click on the "Releases" tab
above the code listing, there you will find the list of releases, and
under each one there is a link to either a zip or tgz download. =C2=A0As ha=
s
been pointed out, the internal directory structure of the release
tarball is wonky on this one. =C2=A0Still working that out...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-s9T5ixyyl+9uG1k3geIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYiOAVAAoJELgmozMOVy/dl/EQAIaK84Ee0JumOtYiokzR6HVp
9SUla68LS9MbO4elC8PBv4msdIozmH4L+Ig5br4/z/4j/zXFUmrGmPS8/sRCmfEa
pHqs95oF3ENKTta6vXF0DAwhfkCkss7+N7eSdSfdsU0SxeMtvxmcAks6BcCTOgtk
lCxw7c3oj9bLHI/8Aj7OG0yHbKRwH8DtaCqhinr+IwvcXdN8omaebJawzNnLwSWl
iR5aXH2XQkTxMlLiZ72DXtU/Is05QEJbXN/ryyfRFphXD57R3+w6YdeD2zwhn62B
db6N7LFHnYf+VJshWYEsu8JdZiYSaDkghW8Lv28rAT3lGNqg2VPsaunyb/PxKrxi
IWdTqmRnGoKAKD+aGkYHQRvZX+KIEEQqk1lyXje/umnjbv+F4iETJdIU/IaYRIRg
ioudjH9AqwhdO9/DYILqLRCbuJVndtrwoiB70ENVGVKaLvha5hYgee2h9mc1jFQn
nVgb0mqUgW15jk1EaVCA4GYXiRWigwc+PYdmHNitvOqvzRxodyCfrUMgavEvzlkX
kPInN+d+80475Zp3Xc/SI+ZyPrXkHZ2wOolld9PyyuQlDByk59oLILcw6J7D8ZK7
+ch0VciHG6tKyyobnQeMtDKwwVqsamfzDYulw17AYqhC0HSNbAsRJNrOwRwcW4MR
O+hntNo+RrI9xKWUDfU4
=GAM9
-----END PGP SIGNATURE-----

--=-s9T5ixyyl+9uG1k3geIe--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
