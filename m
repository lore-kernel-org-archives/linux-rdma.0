From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1] RDMA: Remove kernel private defines and
 reference to header from UAPI
Date: Wed, 8 Feb 2017 19:25:44 +0200
Message-ID: <20170208172544.GF6005@mtr-leonro.local>
References: <20170208150409.29537-1-leon@kernel.org>
 <8c2f6c58-f622-95cf-e146-ed7a5747fd9a@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3pz5mxW9ZsNVjNmM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8c2f6c58-f622-95cf-e146-ed7a5747fd9a-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3pz5mxW9ZsNVjNmM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 08, 2017 at 05:15:49PM +0200, Matan Barak (External) wrote:
> On 08/02/2017 17:04, Leon Romanovsky wrote:
> > Remove references to private kernel header and defines from exported
> > ib_user_verb.h file.
> >
> > The code snippet below is used to reproduce the issue:
> >
> >  #include <stdio.h>
> >  #include <rdma/ib_user_verb.h>
> >
> >  int main(void)
> >  {
> > 	printf("IB_USER_VERBS_ABI_VERSION =3D %d\n", IB_USER_VERBS_ABI_VERSION=
);
> > 	return 0;
> >  }
> >
> > It fails during compilation phase with an error:
> > =E2=9E=9C  /tmp gcc main.c
> > main.c:2:31: fatal error: rdma/ib_user_verb.h: No such file or directory
> >  #include <rdma/ib_user_verb.h>
> >                                ^
> > compilation terminated.
> >
> > Fixes: 189aba99e700 ("IB/uverbs: Extend modify_qp and support packet pa=
cing")
> > CC: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > CC: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Tested-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > Changelog v0 -> v1
> >  * Document the origin of hard-coded values.
> > ---
> >  include/uapi/rdma/ib_user_verbs.h | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_u=
ser_verbs.h
> > index dfdfe4e92d31..f4f87cff6dc6 100644
> > --- a/include/uapi/rdma/ib_user_verbs.h
> > +++ b/include/uapi/rdma/ib_user_verbs.h
> > @@ -37,7 +37,6 @@
> >  #define IB_USER_VERBS_H
> >
> >  #include <linux/types.h>
> > -#include <rdma/ib_verbs.h>
> >
> >  /*
> >   * Increment this value if any changes that break userspace ABI
> > @@ -548,11 +547,17 @@ enum {
> >  };
> >
> >  enum {
> > -	IB_USER_LEGACY_LAST_QP_ATTR_MASK =3D IB_QP_DEST_QPN
> > +	/*
> > +	 * This value is equal to IB_QP_DEST_QPN.
> > +	 */
> > +	IB_USER_LEGACY_LAST_QP_ATTR_MASK =3D 1ULL << 20,
> >  };
> >
> >  enum {
> > -	IB_USER_LAST_QP_ATTR_MASK =3D IB_QP_RATE_LIMIT
> > +	/*
> > +	 * This value is equal to IB_QP_RATE_LIMIT.
> > +	 */
> > +	IB_USER_LAST_QP_ATTR_MASK =3D 1ULL << 25,
> >  };
> >
> >  struct ib_uverbs_ex_create_qp {
> > --
> > 2.11.1
> >
>
> I tried to write this earlier, but for some reason my mailer didn't really
> send it.
> IMHO, since these enum values are actually passed between user-space and
> kernel (attr_mask), it's acceptable to expose all enum values.
> Otherwise, user-space should define all these symbols by by itself (as do=
ne
> today), so why bother introduce only this explicit symbol?

Mainly because it is -rc7 fix and it is MUST be applied as soon
as possible, currently IB stack is broken.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3pz5mxW9ZsNVjNmM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlibVJcACgkQ5GN7iDZy
WKfp6xAAkfI3osmencweydFlF6ouS+yzKAwHVqo9xrCTdhh2przbvOpdsaiC378H
4ciSCvlFM79HlrONrYSY42Z9MHT1Yyb/1VISU/V0GWApzOSjvpuxtCctoWXl/aIu
jY14Gbjv3+643S8+b4cII44VJzpi5JNYkS8NDVepCS3D8bkgz3fYBt+5ItlYWUPe
5sQPKbujicPMso6JThe9wvxgYYtMaZmXNiTCC9ypAyruBNUgVx+d44xftp4czT5a
o1j7gHM6yLGeoWdACfGqeHKV88jZ5WJx6w6QMhOC9QlN2ojNbEtg4FISG4BWWeVU
vFUDjSUYezejEg1SIHJIApiDAgS+MjGw3binl02mExKM+CM6ZFGkzOhjYMxEUhtt
dD8cwXkuQfWw8FJiVc0KWIA9DBdz8k8J/wb5JR6T9RVnnTdJih2P21x6U0pDA76r
V/24xrNRf1bFU7Umlv4pEpjCRbPoo2wBVSFVA46UI0dvUxiRiNzNy0Y2lyUld19q
0IaXUGHciRMJN+NR+E2Y2TjngMu51srLfVjiufgnoWY0ykK4mc7jIHu77Yn8mg7N
F05nVEnWjCna/BGqN0WIGGbhreECmrOB/i55XnQTvtbIEl82yEwI4nRJct3U9cM+
ke5983ba89Vf0PrPkW8SQRVA1Ip53ReiUrTLZQknBPZc2AKh0gE=
=X3lH
-----END PGP SIGNATURE-----

--3pz5mxW9ZsNVjNmM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
