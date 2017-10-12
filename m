From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 42/47] IB/qib: Remove set-but-not-used variables
Date: Thu, 12 Oct 2017 11:44:12 +0300
Message-ID: <20171012084412.GO2106@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-43-bart.vanassche@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3442B95A@fmsmsx120.amr.corp.intel.com>
 <1507668036.2815.55.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KDy5+/kaQUC2a3Gw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507668036.2815.55.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--KDy5+/kaQUC2a3Gw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 08:40:37PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 20:25 +0000, Marciniszyn, Mike wrote:
> > I'm curious about the kbuild modificaitons to expose these issues.
> > Did you add them yourself, or are they now upstream?
>
> Hello Mike,
>
> Thanks for the review. Is what you would like to know what build options
> I used to enable the warnings addressed by this patch series? What I did
> is to build the IB subsystem as follows:
>
> $ for opt in "W=1" "C=2" "C=2 CHECK='smatch -p=kernel'"; do make -j5 M=drivers/infiniband $opt; done
>

Bart,
I'm running more or less the same checks ( + "CHECK=sparse C=2") and for
a long time I'm trying to fix nes and orcdma endianess errors, but
without much luck. Did you look on them and plan to address in near
future?

Thanks

> Instructions for how to download the source code of sparse and smatch are
> available at:
> * https://sparse.wiki.kernel.org/index.php/Main_Page
> * http://smatch.sourceforge.net/
>
> Bart.

--KDy5+/kaQUC2a3Gw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnfK1sACgkQ5GN7iDZy
WKcZDQ/+MMcO2a6KfVisjwBkHgDKyQqI/pZoBFW7c3SuHMg/yezEekXkgrycrKtB
wYQlb8IW5mlOmof8Mcxwl4vPsJdW2PhtzX2nL+6Gx7EZsJphRQoCK+daXbB8IA6t
ZdAReHdLYX1LouuxpuSX8/QwHBdOsh+lpxqYcru+e3/OcwYwmlEYeR5opxe7Gpip
/LhJCMbNjIZmD1FxbWkZMshleEYnQ8RQ2NMu3MSGS192sspptAu8YD3NbVbRQwUE
f2CM4VH93Vy/Rp2ngYy4wtcthWuSYjLpXQF6lFTIFXw8z6ynM4skd/s1MOth4io6
zXStEzHlb61BoVxaVL8ql0S44n7CBlzwDSs6bqO0voAviH9+/fxEqiRePp8QNlFR
2XK/96mIYjQ+ddblBrvDBm8q4/z/OE3Mtn92JCOVPtlS1ftBM+6OsBd5RFAAPxGt
r0Drk2DDzNoQSZtuS0y00fdiAeJTvq4gz2wDCbzPml75way3bp5717yvDR/vnbWk
tkEf02aeHOyb66oVDG9QNXBKfYAsngJDuUaQ0d/ZHwlu2svAG4U4FhJbEaa2dBt4
YlWHf90bBkToQ9RVBABisTqPByLJxjcZconCCgUIjfjzkLpaQ3D9oBoayz0p1mPk
UHuCH01a6JkrepJtjy76tEbaqlkCHLKDI4w+hkxuI0z8t/KOD54=
=KyKR
-----END PGP SIGNATURE-----

--KDy5+/kaQUC2a3Gw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
