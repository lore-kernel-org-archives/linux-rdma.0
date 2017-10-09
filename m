From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Fix C++ compilation break
Date: Mon, 9 Oct 2017 22:05:19 +0300
Message-ID: <20171009190519.GD1252@mtr-leonro.local>
References: <20171009081717.21478-1-leon@kernel.org>
 <20171009154104.GA3824@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009154104.GA3824-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 09:41:04AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 09, 2017 at 11:17:17AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The commit 983f80191923 ("verbs: fix compilation error with ICC") fixed
> > warning by using UINTPTR_MAX, however such change breaks compilation
> > of C++ applications.
> >
> > In C++ world, the UINTPTR_MAX is declared in <cstdint> and not stdint.h,
> > so in order to avoid messing with various defines to decide which
> > header
>
> I don't think this statement is right. In C++ land the 'cXXX' headers
> and the 'XXX.h' headers are usually the same.

Most of the time, it is true, but stdint.h is different and it is
different between C99 and C++11.

> On my system I see
> nothing that would cause stdint.h to not define the macros in C++ mode:
>
> $ echo t.cc
> #include <stdint.h>
>
> enum {foo = UINTPTR_MAX};
>
> $ g++-5 -c -Wall t.cc
>
> So, what environment fails here? It should be described in the
> commit message..

It means that your glibc is new enough.
On some systems, the stdint.h contains the following ifdef to protect UINTPTR_MAX
"#if !defined __cplusplus || defined __STDC_LIMIT_MACROS"

>
> The best fix is something like this:
>
> #ifdef __cplusplus
> #include <limits>
> #define __VERBS_ABI_IS_EXTENDED ((void *)std::numeric_limits<uintptr_t>::max())
> #else
> #define __VERBS_ABI_IS_EXTENDED ((void *)UINTPTR_MAX)
> #endif
>
> The static in a header file also a mistake.
>
> Using <cstdint> is a bit risky since it is a c++11 header and may not
> be in some of the older distros we still support.
>
> Jason

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnbyG8ACgkQ5GN7iDZy
WKewsQ//dFAx2Wu5RiYQ3CyXaONmVSH+PPdRiOSTYipwvxNEcxUVuLxqeTJy4ozz
XUdcPMOCzQ5uS8cSlULo3iI4nRtwiw0hOsu8VAq9eENYI97TqvmQqiHi0gSih/vw
2cDsuAzl5I2DGAnchJOr31APLjrC+fgTsDTQaQNUjqFWNYQ+mT+wxXyxUsZCpmkT
rH8/VAcopjKzHcmxIFO5qcnSP5RQ+A5vu4xjGd7nRKSIae5lgSssbZvS0NFIlN5x
G+MN7hZRsSRwfy8Ap842UO2msPmXTA7JN7PdH32gft7JOCV4blmxzzij6S2J5N5S
ZErHIVMqfRBnKO6p6nSYLEQvYSn2DKFyYfdb5qto3LpDuSzzdsCbzziqk0CXZJ2f
PixhVub7WprSymSXJZZY30mfWdxgPCAkSVA3AYCr1KVNP5esk/nEkFi4KDwnSfy3
zhCdzljIyXMjqAOvJchco22J8u2KEdWLYKi+xVyP+b9aFbtXp/UqX8I4/dj5oA3e
Tx4isi3sSMknrLKDqb7ZY/9BQuYNOrftZmq8ValrLGtJOnSgOP0nUVufwXo9PmBt
cbmxa/YJ083W9EEEn9emVCEYWu0ZQpCiwIahrxhAHR7ayd7DXCUrEFs0QCpm07Eo
op/t15xr8TlTyG1l8bmZXYcrzoE8aZxiMfCXGQhHJ9N2a/0rvBA=
=ZMg7
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
