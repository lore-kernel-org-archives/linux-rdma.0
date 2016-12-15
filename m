From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Thu, 15 Dec 2016 08:48:07 +0200
Message-ID: <20161215064807.GB811@mtr-leonro.local>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161214212103.GA6947-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 14, 2016 at 02:21:03PM -0700, Jason Gunthorpe wrote:
> On Wed, Dec 14, 2016 at 07:11:11PM +0200, Leon Romanovsky wrote:
>
> > > > This patch duplicates already existing code in most of providers and libraries
> > > > in rdma-core, while two of our main goals for creating this consolidated
> > > > library were simplification for users and reduce code duplication.
> > > >
> > > > It will be very beneficial if you:
> > > > 1. Use and promote general pr_debug(..), srp_tools has nice piece of code,
> > > > to be general code.
> > >
> > > [Tatyana Nikolova] The debug/error printing macros available in
> > > rdma-core use different mechanisms to report information, for
> > > instance, they set/check one or more variables, or they use a bit
> > > mask to enable debug level. They also print to different outputs:
> > > stderr/stdout, debug files or syslog.
> >
> > At the end, all these prints are for debug. It is hard to see any
> > objections to see output from them in one place.
>
> Yes, let us just use stderr for now for provider debugging. If someone
> wants syslog then that can be a later patch. It makes no sense that
> there are difference here.
>
> > in rdma-core/util/env.h|c
> >
> > #define SET_VAR(type, var, field) \
> > 		(struct ##name*)env->field = get_env_var(...)
> >
> > void *get_env_vars(enum typ)
> > {
> > 	void *env;
> > 	switch(type) {
> > 	case I40W_ENV:
> > 		env = malloc(sizeof(struct i40w_env));
> > 		....
> > 		SET_VAR(i40w_env, "I40W_DEBUG", debug);
> > 		...
> > }
>
> Why?

It will give common place for all different variables and debug was an
example. My request from Tatyana was to come with 2 common mechanisms:
1. Common debug prints.
2. Common place for all various getenv() calls.

And the pseudo-code above was example of second mechsnism.

>
> I was thinking more like a standard:
>
>   VERBS_PROVIDER_DEBUG=qp,ah,blah
>
> parser since other than mlx5 that is what providers use env vars for.

It is not providers only, but many other libraries in rdma-core are
using env variables for tuning (libibverbs/librdmacm/rdma-ndd).

>
> I'm not sure I agree at all with what mlx5 is doing with tuning
> parameters via env vars :\
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhSPKcACgkQ5GN7iDZy
WKd0cQ/9G5KQ6d7Geqqo9U9+z8P3ZXWMU3dxyw3sBNv0U7iD6V/xR93x3Ud2guKC
LiidjVW9AUmIuwmv61bSTzI9L7RnjXKuWeeciUKMuZCzXV8QnUPdHpFhYIBAYU8W
Td5mETkc+tPaXUbL7pfMSd+/f2s56DcnF4BC+PxBDULzYKty9FaahyGxv6S0cZYG
dlLdhez33GIl12RjyvvgzOULRunsifGZBvpS6zim3l+DpP8BsQVQn7NFgrA74k/z
mmJwXNdp0/6Q36dkTBo9Z8E5Zb8aaplm4CG/rrmzQNO0hiJtndleuwr4C6FJBIxo
mPbFm1eRykpXW3AGjBN+v1vKnMix0GpwsriEEhuzfDuBokJGM9OXpdPBwwk6Am74
Vu8HUmH2yU4AYDx6jzBUXazL1ifJTFSyLmDnHMhVK9lsQrSMq5SGQ5KAZxEFwX25
5EzJChE3QIOX7cdUbE4kqE+VvJe7mgJPVL6cJYj9rdalRLd9zTuOKVzmFTGyHf6E
UEj6AgV2HO5E+f/kCR3dt33L6lugH/Wt/43Go3/Tjtu45GxCs2YVUv6D2kSRB+gb
j9Bb9seReIvO8R7ccgERFvDZEFGfphk4xrWBapOwoiyRhZFdTQW0ehwEPojS6azD
/BiBxZhDeVUWNMR3yDT366dGrjCfXOOcwSegBuuZfVqjGn1JS9g=
=OPGe
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
