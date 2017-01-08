From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core package version schema
Date: Sun, 8 Jan 2017 10:47:59 +0200
Message-ID: <20170108084759.GJ15685@mtr-leonro.local>
References: <1483642867.5227.18.camel@profitbricks.com>
 <20170105230928.GA4262@obsidianresearch.com>
 <1483723704.5227.23.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bgQAstJ9X1Eg13Dy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483723704.5227.23.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bgQAstJ9X1Eg13Dy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 06, 2017 at 06:28:24PM +0100, Benjamin Drung wrote:
> Am Donnerstag, den 05.01.2017, 16:09 -0700 schrieb Jason Gunthorpe:
> > On Thu, Jan 05, 2017 at 08:01:07PM +0100, Benjamin Drung wrote:
> >
> > This is very exciting news! Please feel free to send any patches or
> > pull requests to improve the packaging, or otherwise!
>
> Expect patches from me. Before starting a bigger review, I will wait
> for the pull request https://github.com/linux-rdma/rdma-core/pull/50

Thanks, Talat is working to address your's and Jason's feedback.

>
> > I hope that
> > significant parts of the the debian/ dir can be maintained upstream
> > like Redhat is going to do for their packaging.
>
> That is doable as long as the future Debian maintainers will have
> commit access. Otherwise the debian directory will get out of sync
> soon.

I don't think so, we are pretty fast to accept pull requests, and
especially distro related ones from verified committers. However if it
stops future Debian maintainer to manage this package upstream, we will
give write access without doubts.

>
> PS: How will you create the release tarballs?

Via github interface.
https://help.github.com/articles/creating-releases/

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
> URL:  http://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bgQAstJ9X1Eg13Dy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhx/L8ACgkQ5GN7iDZy
WKcnvw/+LpU1IIbS2wJdHR61EOr8+HoEJQm7HG0jDx+qi7atdL9ZCmjSGhu5N/sJ
0u9Y9W7b81mIAXX+eq2pxV2otlVGWDfIfJVU4c36HL46T3uR7AhoRS1XBB8sfpZH
nZ+qsyu919uD2yPJZU6gKbLrfdqKJBMiHZbOiBHc2aV1oKWhXDceHSTXWJXfCUwB
5ZL+jkQPG3EH6uB9BfntU4QLEfUhpTEZC8a+jkjvSXE8ktT/D2QO1r3nivBfIiv6
NQCqKZmVtlYz5fKrZkQ0iqWeSxb+6zIZC8n4dIk3RilatCshqyw8poRuGz/Empwy
YkxbWbm8pE2b850MCujtcH7Qy8nJLzP+gJpi30Fco0n0wOx+1UoGvD+i9UtNh+yp
WSIAQDlTZj0f6sVHWEqPrXzxhnJp/hSDSA3j5HrWOIh3NxOLHl2wAFrTc3KC73ns
wn17H+E43XbaSz4tOmT+dPVx9zsl+smjfbxfjkLqLRsblOmu26iiiexLcnKtkK9t
zeqNN2y0/fMjuiQ5b5ZohyY8DD3bO7W470MFKJTXhfVLnqYFUlcD0uP2CLV7Okt5
pvrnyXh33zSQ2dh0em3BqTDLRanXIjl2sw4dnn7XgysMSxtShTv/XtQiQnu/EpY8
d4Ub6jcfLSZTCbZ1EFyeyA8yRrPNvCUDH+N6w8Mqshfk6dpiLh0=
=oW/A
-----END PGP SIGNATURE-----

--bgQAstJ9X1Eg13Dy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
