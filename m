From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Wed, 27 Dec 2017 14:20:56 +0200
Message-ID: <20171227122056.GD3494@mtr-leonro.local>
References: <20171212225936.GA29558@ziepe.ca>
 <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
 <1514368433.4412.2.camel@profitbricks.com>
 <20171227111348.GB3494@mtr-leonro.local>
 <1514374021.4412.9.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514374021.4412.9.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 27, 2017 at 12:27:01PM +0100, Benjamin Drung wrote:
> Am Mittwoch, den 27.12.2017, 13:13 +0200 schrieb Leon Romanovsky:
> > On Wed, Dec 27, 2017 at 10:53:53AM +0100, Benjamin Drung wrote:
> > > > > Am Sonntag, den 24.12.2017, 14:03 +0200 schrieb Yishai Hadas:
> > > >
> > > > On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> > > > > > pandoc is fairly widely available in the distros with the
> > > > > > notable
> > > > >
> > > > > problem that centos 6 and 7 can only get it from EPEL.
> > > > >
> > > >
> > > > There might be even a worse case scenario where pandoc may not
> > > > exist
> > > > as
> > > > a package to be installed, for example how about SLES OS ?
> > >
> > > The release tarball could contain pre-built man page. So in case
> > > the OS
> > > does provide pandoc to regenerate the man pages, the pre-built can
> > > be
> > > used.
> >
> > Why should OS be dependent on pandoc? IMHO all releases should
> > contain
> > pre-built man pages and they should be used without need to
> > regenerate
> > them at all.
>
> Debian's rule is to build everything from source where the source is in
> the preferred format for modification. So we will drop the pre-build
> man pages and build them from source - even if that would not be
> needed. This is useful in case we have to modify it (e.g. fix typos).

Thanks for the explanation.

>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL: https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=E4ftsf=FChrer: Achim Weiss, Matthias Steinberg



--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpDkCgACgkQ5GN7iDZy
WKd/EQ/7BI3VhHbnGR0iY/7VbClM2AvKmiV5QDsyb5tdlV/9M3Ic5nzKnhYUsucm
ZH8DydaNTyYEy+c5DMWhpAbHgGVo3j19Xt6xk7j+oSS5Y7FsWcAaAr73difTawmw
G+OWGZdtjzlqNX+DIZj0zM5xvNx/6RkRaFDXsZ7SQzpU8tj7rINygBYhF8gdiASB
1PHG6RNgq8dThGGpfhm0XnUS9nM77yOO7VdYoLIaM1P4qysywphOgXqQyzlvG1Nk
Te0pgBlUnQ9UmEACDtljbS3RMVy09yNym2lqBgPnPOb3rcNCyuc4tutHZkjUXCAD
U/WIgMHntdL2NWEnAIu+Efxf2xqV7rGCLZ58rDn++pxu6jQzMa1YUSn4rx3F8Yst
hat9akY3+m/kFFDWQ7MHbt50f6GJG/Ln/uySqPaK3/RCeVRK1/xMP2De7+qMcX6q
IlqYWzLE2s2UYaPuuNtmSTlZIn1wR4J0s+dIBEU/WuWe7z3ZCVbcdkYZnp0krs5z
GXne4AL0lhNqjVWE887mav7arQwNNY05pj3qlqJQ6ACrjlL9JVvfpN4r1fyR+Me3
E+ORDMuRTtT2WI1ruX0z/9xTRGtfQKiJQ3gjZs2Rudj8YDBmQtolJQlxoSZ2DYn7
aeyQ7qdXVCCkzvrKqnGjxOrOQsjjDcnT/xfJrQvB1s696gHq7+o=
=uTJ9
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
