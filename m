From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Sun, 18 Dec 2016 10:19:15 +0200
Message-ID: <20161218081915.GC1074@mtr-leonro.local>
References: <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
 <20161215165420.GA3264@obsidianresearch.com>
 <20161215183537.GH811@mtr-leonro.local>
 <20161215185034.GB16552@obsidianresearch.com>
 <20161215191751.GJ811@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7E53@fmsmsx104.amr.corp.intel.com>
 <20161215201917.GL811@mtr-leonro.local>
 <20161216042632.GC3797@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161216042632.GC3797-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 15, 2016 at 09:26:32PM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 15, 2016 at 10:19:17PM +0200, Leon Romanovsky wrote:
>
> > > Jason gave an example with "
> > > VERBS_PROVIDER_DEBUG=qp,ah,blah". Should all of the environment
> > > variables, enabling other features in rdma-core use a similar
> > > approach?
> >
> > I think that Jason is over designing it, but it is better to ask him
> > about it.
>
> Well, this is what mlx5 does for debugging and I want to see it move
> to the common API. Are you saying we can get rid of the classifications??

This is my personal opinion and Yishai can provide official opinion.

I see litle value in current implementation of debug mask, it is
protected by compilation flag. The enablement of this will require to
recompile code and to set env variable prior execution of application =>
it will print for all CQ/QP. The same can be achieved without debug
mask.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhWRoMACgkQ5GN7iDZy
WKfYCxAAh9uXW7MbnUtewZhyiUWPGZQqNYd92rMe7plQwRHTac7BxE9TgiXSxpiP
TmVOKoAjl/6fCV6kljwhO5hqAJG9+f/+9d2nD8Q3zBAdQ68EttEK8VWIyB7H5q2n
cVTC+yDr9jK9W3Hp07MQFQsrUkYOfVUoTEQhh3R3t6rD5zwQKBJKE7qDGjSi61yU
xgnlDNbe/o8M01X9x9q8ps4O5pPtOBbH6l3XdeZGvlYIGOC+U0px/yvjfVZ72dz5
T6aU/TUrGP/JEomOckVm+7n4R98UTksgVAiUXGXZTU5v0NMQJejbpeRFpQuzyJbo
2TjRTQUP56Kqk+pOESXRaytMkH64/muNAjWgEoZ8KI03lsPTVjIFHD1rhg4PklG8
O5FrpPjVfKKLAVko94nb2n0mtpAkhGlKcs4xrMJj7RP/GEWE2WqkhCFZnmT1LwDj
8A55sTNcyJsKs/J2KRL9Qj2qS+DNaF/6WJock0WVSX2pAOoFFW91ws5xvsYOBZDc
rWybTArW5ZTtHWdgpSo7HG0kZ6e+0jrf3LW8lGfCSYCYEE6YfgRXnvS3wS8l5IpK
gt88f+QEYCoU4OsfxlBYx8rP5KRPDEIXDW7urqArdT9AUliB5IboCkl/PL5BR0yf
xPdaWtnPhG3es/8L5ryP2lzillAnQmYxk+R66madzY+AsWi1qhA=
=3Hsz
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
