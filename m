From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core package version schema
Date: Wed, 11 Jan 2017 16:47:34 +0200
Message-ID: <20170111144734.GC7218@mtr-leonro.local>
References: <1483642867.5227.18.camel@profitbricks.com>
 <20170105230928.GA4262@obsidianresearch.com>
 <1483723704.5227.23.camel@profitbricks.com>
 <20170108084759.GJ15685@mtr-leonro.local>
 <1484139556.2191.48.camel@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4WCFFtl4AQpQKunj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484139556.2191.48.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4WCFFtl4AQpQKunj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 11, 2017 at 01:59:16PM +0100, Knut Omang wrote:
> On Sun, 2017-01-08 at 10:47 +0200, Leon Romanovsky wrote:
> > On Fri, Jan 06, 2017 at 06:28:24PM +0100, Benjamin Drung wrote:
> > >
> > > Am Donnerstag, den 05.01.2017, 16:09 -0700 schrieb Jason Gunthorpe:
> > > >
> > > > On Thu, Jan 05, 2017 at 08:01:07PM +0100, Benjamin Drung wrote:
> > > >
> > > > This is very exciting news! Please feel free to send any patches or
> > > > pull requests to improve the packaging, or otherwise!
> > >
> > > Expect patches from me. Before starting a bigger review, I will wait
> > > for the pull request https://github.com/linux-rdma/rdma-core/pull/50
> >
> > Thanks, Talat is working to address your's and Jason's feedback.
> >
> > >
> > >
> > > >
> > > > I hope that
> > > > significant parts of the the debian/ dir can be maintained upstream
> > > > like Redhat is going to do for their packaging.
> > >
> > > That is doable as long as the future Debian maintainers will have
> > > commit access. Otherwise the debian directory will get out of sync
> > > soon.
> >
> > I don't think so, we are pretty fast to accept pull requests, and
> > especially distro related ones from verified committers. However if it
> > stops future Debian maintainer to manage this package upstream, we will
> > give write access without doubts.
> >
> > >
> > >
> > > PS: How will you create the release tarballs?
> >
> > Via github interface.
> > https://help.github.com/articles/creating-releases/
>
> It seems that interface is only available for those with write access to =
the github repo
> which does not cover the (for me at least) common use case that I want to=
 built my own
> slightly modified test .rpm of something. Then users will end up creating=
 tarballs manually,
> or outside the build logic, with potentials for mistakes, not to mention =
the=A0
> documentation need to tell users this.
>
> Isn't a dist target a well established standard the rdma_core packages sh=
ould=A0
> support for simplicity and uniformity?

I have a long standing task for myself to connect rdma-core to SuSe's
open build facilities [1]. It will give us RPM and DEB packages.

[1] https://build.opensuse.org

>
> Thanks,
> Knut
>
> >
> > >
> > >
> > > --
> > > Benjamin Drung
> > > System Developer
> > > Debian & Ubuntu Developer
> > >
> > > ProfitBricks GmbH
> > > Greifswalder Str. 207
> > > D - 10405 Berlin
> > >
> > > Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> > > URL:=A0=A0http://www.profitbricks.com
> > >
> > > Sitz der Gesellschaft: Berlin.
> > > Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> > > Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at=A0=A0http://vger.kernel.org/majordomo-info.html

--4WCFFtl4AQpQKunj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh2RYYACgkQ5GN7iDZy
WKeiig/+JFNaxH5pJBWg+b4QJKwZ/2v/Cf1j03xZPYuoTxA5x7+YvJETXDxqCN1R
S5ZSylEZkbnkmQvfdCOpxF1iWnSBm6DcZtGDufKl49Y80Bg0AnXL5p9uzl3hluq2
4EmIRls1g/zWhT/N1OorKR57M6JGzXAqRsHc9rEtQkujmvS/ZXMbXfYqNN7116Q9
Onh55PikzH4zxTjigjJRoLASriPb+FaGQMxPfzkWIJPB8pbS8BJN687atId2WnJ0
rD+kZxklYMmpMLs7c707BavFQ5IvziQJ5AlhOTsXXVb236LOStRYDWhXqpd2OXyK
oETMokVb+xmtielvTDOq2xUr81V9BPUE5xIe4jfrU6erPtN0x9oRo/IuL/ERvFeN
tLOUGxY8uZZhga5Q+Mu0Zm5/K+jxgwf4zi+bXJVMEXk/9zAHf5BQzctca55uNDxT
YqRmmA7wPC5H0bRdZW1Mx1f8PJPu9LmQi+f1kLtnKyIiwK/o1exdcM5Ico7/+OsV
TnXL1HGPFPmuLx7OsmOI6oK5yUNzOaMm/YAnlqWCB+armECibuHS0JOFgYZ6+kzS
Jed8byR7Z9P+gn1TzjJavZPwn9ByRNf+BDn3eX2XcP8Ms6ZARz92G5Nq++V4cOJX
YKm+Lg/BwWOLHVDAfqTs2eNNh91naUBW2IIjxnZPwX1Q/qKUcdw=
=z0IR
-----END PGP SIGNATURE-----

--4WCFFtl4AQpQKunj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
