From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] ccan: Add likely implementation
Date: Thu, 17 Nov 2016 10:30:07 +0200
Message-ID: <20161117083007.GI4240@leon.nu>
References: <1479318011-26878-1-git-send-email-leon@kernel.org>
 <20161116201343.GB19593@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1ou9v+QBCNysIXaH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161116201343.GB19593-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1ou9v+QBCNysIXaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2016 at 01:13:43PM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 16, 2016 at 07:40:11PM +0200, Leon Romanovsky wrote:
>
> > index b5de515..153426f 100644
> > +++ b/ccan/CMakeLists.txt
> > @@ -6,11 +6,13 @@ publish_internal_headers(ccan
> >    minmax.h
> >    str.h
> >    str_debug.h
> > +  likely.h
> >    )
> >
> >  set(C_FILES
> >    list.c
> >    str.c
> > +  likely.c
> >    )
>
> Keep these lists sorted please

Sure

>
> > +++ b/ccan/likely.c
> > @@ -0,0 +1,136 @@
> > +/* CC0 (Public domain) - see LICENSE file for details. */
> > +#ifdef CCAN_LIKELY_DEBUG
> > +#include <ccan/likely/likely.h>
> > +#include <ccan/hash/hash.h>
> > +#include <ccan/htable/htable_type.h>
>
> Hmm, this isn't going to compile if the debug is set, maybe drop the
> .c - but this seems really interesting to see if likely is being used
> sensibly....
>
> > +#ifndef CCAN_LIKELY_DEBUG
> > +#if HAVE_BUILTIN_EXPECT
>
> You need to add '#define HAVE_BUILTIN_EXPECT 1' to
> buildlib/config.h.in - or this doesn't work at all.

This is exactly what I wanted to discuss over ML.

=46rom one side, I wanted to ensure that ccan files are similar to
official ones, so upgrade to new versions will be seamless.

=46rom another side, I don't see the real usage of likely/unlikely debug
facilities.

So my approach was to add these files as is, but don't connect debug
functionality.

>
> Jason

--1ou9v+QBCNysIXaH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYLWqPAAoJEORje4g2clinEqQP+wepPs7RuC/fl6GMhCvTGBe7
LB60bPwbQr+zth9bpx3AHhBeb1xeqepPCvi2YEi+xN819JNJ6jwVmxdaSFklGTSq
0BE3/0lZLrLF/WJsHHLJL4j4kvSc2tlZ7DLkdfVhutUXBF62XMxvA8njlNycNg+v
9nlUCoyZEfrwTYO9kREnT8+xT8hShaM51IvpuGdlX2gK+NOuiH+JEKmKMxT/41Lm
SozkoR0/mSE1zxf4Ui8NOP/Pe0EvZmytWtqqcmjVUuyFAkzvFe6cli5DfcOJKHds
8RIxEnXloBqFltOPdTuDXBbSQ6jx7DYsAkIn+Aknl+rrPj6hp34le2JEoaka6Y8W
9UflEJR5YgDyBGbEPl3kYouqcRx9v2GDL4BwaOmKKmQ9foSMU2JPFVUu2GK3LQEF
OrO6oXQWeV156RCAOMbN5p37p68qE5yXLl3vLU7HU/hSafIxHQAj93irExI5pGn6
1eYgIVdTDF4JrI7lEK2RCRA7CfZy7XXFjBzrOcMzZve4scA79ItP8Ue1zFuVkcF2
1t69nEzgdbeSuhHuzt/piBrxZhT1y5JXmr8xCjikmYIm1Ej2uomAr8BLH28I9EWa
E0JzKt2awshThTJBMHj9CP8XkdkOs4QrN6CqyA/ndEDbWzva6AhUz5Cq9n8SepIS
AbYK6U2sQDR/NHeL3CHa
=F+Uo
-----END PGP SIGNATURE-----

--1ou9v+QBCNysIXaH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
