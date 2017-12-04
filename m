From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Mon, 4 Dec 2017 06:33:07 +0200
Message-ID: <20171204043307.GC2110@mtr-leonro.local>
References: <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
 <20171201055732.GC8126@mtr-leonro.local>
 <1512151985.9183.4.camel@profitbricks.com>
 <20171201182806.GL7754@ziepe.ca>
 <20171202084019.GG8126@mtr-leonro.local>
 <20171202162856.GA28143@ziepe.ca>
 <20171203065501.GA2110@mtr-leonro.local>
 <20171203162704.GA8566@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171203162704.GA8566-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 03, 2017 at 09:27:04AM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 03, 2017 at 08:55:01AM +0200, Leon Romanovsky wrote:
> > > Are we?
> >
> > Rarely,
> >
> > Merge: cea6f4e0 e0ed9229
> > Author: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Date:   Thu Sep 28 16:58:57 2017 +0300
> >
> >     Merge branch 'jgunthorpe-new-init'
> >
> >     * jgunthorpe-new-init:
> >       rxe: Use VERBS_NAME_MATCH to match the rxe device
> >       hns: Use the generic modalias matcher
> >       cxgb: Use the new common PCI matching infrastructure
> >       providers: Use the new common PCI matching infrastructure
> >       verbs: Provide common code to match providers against kernel devices
> >       verbs: Remove the init_device entry point
> >       providers: Use the new match_device and allocate_device ops
> >       verbs: Split init_device into a match and alloc/bind step
> >       cxgb4: Move sysconf up to driver_init
> >       verbs: Change verbs_register_driver to accept the ops struct directly
> >
> >
> > > I wish github did that :(
> >
> > Github is doing it, it will help if PR authors place cover letter in
> > their PR.
>
> How do you do that? I always write a letter in the PR?

At the merge stage, there is an edit box, the content of that box will
be put in the merge commit.

As the latest example, see commit bf2450ea "Merge pull request #265 from yishaih/mlx5_tunnel"

Thanks

>
> Jason

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlok0AMACgkQ5GN7iDZy
WKfWDQ/8CHcWgPXDTBz/5u0Qz1Gd3wTYKISzdvaH2fpj8N21kKtpQ+Zghts73c52
egnTgHVJA2Uwnu3bPNlsxCqT2r3QGXeqHSHUNJ4X6B1F8bvc7oxt8JOKB3CXraoK
684t3t9l917nXQ37prd75cDzHLoo84xQzKvdolPUmJA04eT5QTulIZkHYm7rGknB
HCd1QkGHI64Z6dZF/jUsp/O2CTkurDci1wMyAsMSWpP4lEdmEBno/NTcyna9WQDx
MZl9MhMp5vhOQRIO2q6LyhKvBEKSOgHfVB2DaFjKAuF08vStzroY8LeNn8r4CpE3
prwdJV0TFiHST0TIG24RPIkjB0FDm+7r9nZTb+tStBczTh7+VdzOYqAjgau+/UWU
ZhuiHaAxgIgpPe3E0HQ8veuM6Um+BvPhfE9e9pu7yR8Tuv6D2Kl3WKaYyxFt2E77
HdH9gLH9jl5r4gzdjXy4OZgNG/rKZJ3XzM1UcVtB1R7U8aknYhLsOYE+9rR6wr5Q
HQuhdnY7nG7grUI1Y+yvOqWKZoa9FYy05Rs52AK5HcgJzVXZOsvdFWOVa/oCEnfb
0M1qL1RzpbNu6fBd58/qMjImBHyNuuxa25yZCPaqQEyGlArbnOj6GNFnoFovT0q+
YrBhJJpYATJpRJgLzPT/XO5YxNtfdVP8wcHtfgHNo+7YQOlog5A=
=xpnT
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
