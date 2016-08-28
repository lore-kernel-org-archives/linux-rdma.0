From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Sun, 28 Aug 2016 09:06:40 +0300
Message-ID: <20160828060640.GI594@leon.nu>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
 <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
 <20160826192957.GG594@leon.nu>
 <e86e76dc-811b-7002-a35d-1e515c833d46@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IbA9xpzOQlG26JSn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e86e76dc-811b-7002-a35d-1e515c833d46@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--IbA9xpzOQlG26JSn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 26, 2016 at 03:34:48PM -0400, Doug Ledford wrote:
> On 8/26/2016 3:29 PM, Leon Romanovsky wrote:
> > On Fri, Aug 26, 2016 at 02:01:55PM -0400, Doug Ledford wrote:
> >> On 8/26/2016 9:35 AM, Doug Ledford wrote:
> >>> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
> >>>> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> >>>> In this case, we are passing 'sizeof(unsigned long)' which is likely to
> >>>> be 4 or 8.
> >>>
> >>> If the size can be 4 or 8, then using 64 universally is not correct.
> >>> Why not use sizeof() * 8 (or << 3)?
> >>
> >> Better yet, why not put this patch in the kernel first:
> >>
> >> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> >> index d96a6118d26a..a8838c87668e 100644
> >> --- a/include/linux/kernel.h
> >> +++ b/include/linux/kernel.h
> >> @@ -52,6 +52,8 @@
> >>
> >>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> >> __must_be_array(arr))
> >>
> >> +#define bitsizeof(x)   (sizeof((x)) << 3)
> >> +
> >>  #define u64_to_user_ptr(x) (           \
> >>  {                                      \
> >>         typecheck(u64, x);              \
> >>
> >> then start going around replacing all these hard coded numbers with the
> >> use of bitsizeof().  It can be applied not just to the find_first*bit()
> >> routines, but to a bunch of other routines too.  Just look at
> >> include/linux/bitmap.h and any that have nbits as an argument are
> >> candidates.
> >
> > There is BITS_PER_LONG define for that. There is actual use of it in mlx5 for
> > the similar code pieces.
>
> BITS_PER_LONG only works if your bitfield is a single long.  It doesn't
> work for other bitfields.  What I posted above will work for anything.

Yes, the question to ask if it is really needed.

>
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG Key ID: 0E572FDD
>




--IbA9xpzOQlG26JSn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwn9wAAoJEORje4g2clin2mEP+wTheN80cuNq7nzhDa8qrfSy
7XDfROpQ2E50rM8qdWwjiNbZ2ayesMemSn/fNArbCU6vX6C9+FoUaDxdaT51ei2h
99YFlOhURs29SaaX6sfjtFZOQaDSKOMXJnssQN3DnbJporeB3sNExz+Lw8bgKprW
WP18oF+UlPhKE27Q41slaOJNf+CAxMGzszth1DImbY/2UnluoD44sePtUaD5ilgw
0yba4ymeBhroO2f3TbLWAlPtW4+DpONQqeKqZs8PYRMZ8dT/H/yrHLmCwI1XsZcC
Dtcaf7I3S4g2GdBwMdXdmEy8EljhCVCYQCbxNw20hMOnkwZci0FNgtV0PiM6xypw
+0yHXYiql5S62+C1e00M66szHteK3do3MaxYZ9zj5iGCp44bVknnOUC79i9rKbal
iqDVC25jLL2ovssfPb1RyXprRrr9o56N51d1ZVVzpmmn9jyZ7An4HHP2DASXtlmY
kwO/oMlwKbEBVaiH4t2/ZEgaa6aqY7pkjc5Z2QJ3Idi4B9Y6cXcd7IIYod6y+BZi
E9kr/8X++mjYt1X5IkH3EfzPc0+i09a/s8gPLUCZ775VUD2UrKsf7NsUoTnj0qyO
hxF8AYW3VtDeEEZu2T+DJtb2fRY1uumpbzSHOKVl1V8LBPPruU0654cDtefZQEHK
mDHuJwLKvZMjjLKjJ6xl
=YC3O
-----END PGP SIGNATURE-----

--IbA9xpzOQlG26JSn--
