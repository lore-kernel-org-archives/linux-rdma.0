From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 20:50:40 +0200
Message-ID: <20170110185040.GO7218@mtr-leonro.local>
References: <20170110143018.GM7218@mtr-leonro.local>
 <20170110143658.GA26753@lst.de>
 <1484067095.2149.12.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484067095.2149.12.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2017 at 11:51:35AM -0500, Doug Ledford wrote:
> On Tue, 2017-01-10 at 15:36 +0100, Christoph Hellwig wrote:
> > On Tue, Jan 10, 2017 at 04:30:18PM +0200, Leon Romanovsky wrote:
> > >
> > > The first patch which brought my attention was Christoph's change
> > > "IB: merge struct ib_device_attr into struct ib_device" [1].
> >
> > Doug decided to not kill off ib_device_attr entirely and just
> > embedded
> > it into the ib_device structure.
>
> Correct, I believe it was Or's patch that did that.

The original patch did more than just put all data into
ib_device. It removed the redundant parameter
(struct ib_device_attr *device_attr) from query_device().

Current code:
1883 struct ib_device {
=2E...
1930         int                        (*query_device)(struct ib_device *d=
evice,
1931                                                    struct ib_device_at=
tr *device_attr,
1932                                                    struct ib_udata *ud=
ata);

Do we want to continue that road and complete the cleanup?

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh1LQAACgkQ5GN7iDZy
WKfERQ/+JxuAzN0OuMCpF3NRpEzVH0VqeNPzk5UsxerPyILPds165q8KOskpcA2J
tVB3LdsJzq1lxbojDcNZvwcV5paKimTJ+zXknYoBT7LP7LjFw8zHmYxvmafNqecT
EmqaeKFj3B20TFfxc1QMwVNVLApmZD+ZbeQGYlP2NrmU6Exn42GJUaShVGejLAkq
cBZK0HSeoy/W7NXEb70CCIuLTFhfXNrhOXrwwzikesj/r9mTqD88tY+wlJerltOM
iz9W70fiWVuP+Q0jKKZuvPe4SgGbWSXFiinM+vTVgI6jLE8PwEJbScSBBcUxV3Xs
48S7oFu1ta5kdXdunTPRzcOvhp5Pg96c5qnH2Rp/cAv9DoD9zDWPVoD5EqPPGn6x
B+J+YaqaYrOKBhNMuYAbyHkY/QqK+YmtII6Glosg5aPl4g6DbuY8SL4xPI0f5xdW
vXCBWDzdkZ8fsmCp7YpoY8mAce/d6paV0qoFRDB2kRotS9LWIxx++0qlsp6I856t
U+mNiujVq0lOmZ0B4+3okIZmlOIKnNG3ggF31oWnLwscFdKbCimc5RXj8ZHwhD50
iOw/XwMUSRutt2XI1HWcc+7ukEnlL4Ic16hXJSXxdw8pSaPv3K2HOOJ3s5rfR8xt
CczJ+ANDkQhAXFmvlRhxtekqi0r2+LptCkSVqvBXpaGmGLqXLfU=
=MoNp
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
