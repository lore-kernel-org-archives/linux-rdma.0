From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Fix C++ compilation break
Date: Mon, 9 Oct 2017 16:38:54 +0300
Message-ID: <20171009133854.GA1252@mtr-leonro.local>
References: <20171009081717.21478-1-leon@kernel.org>
 <537d72a7-19c3-d13d-4b49-538744a73845@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <537d72a7-19c3-d13d-4b49-538744a73845-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 09, 2017 at 03:12:00PM +0200, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 09/10/2017 =E0 10:17, Leon Romanovsky a =E9crit=A0:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The commit 983f80191923 ("verbs: fix compilation error with ICC") fixed
> > warning by using UINTPTR_MAX, however such change breaks compilation
> > of C++ applications.
> >
> > In C++ world, the UINTPTR_MAX is declared in <cstdint> and not stdint.h,
> > so in order to avoid messing with various defines to decide which header
> > file include: stdint.h or <cstdint>, we will check for the existence
> > of UINTPTR_MAX and will fallback to old implementation.
> >
> > Fixes: 983f80191923 ("verbs: fix compilation error with ICC")
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> > Cc: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> > Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ---
> >  libibverbs/verbs.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
> > index cc633a12..f540b660 100644
> > --- a/libibverbs/verbs.h
> > +++ b/libibverbs/verbs.h
> > @@ -82,7 +82,11 @@ union ibv_gid {
> >
> >  #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))
> >
> > +#ifdef UINTPTR_MAX
> >  static void *__VERBS_ABI_IS_EXTENDED =3D (void *)UINTPTR_MAX;
> > +#else
> > +static void *__VERBS_ABI_IS_EXTENDED =3D ((uint8_t *) NULL) - 1;
> > +#endif
> >
> >  enum ibv_node_type {
> >  	IBV_NODE_UNKNOWN	=3D -1,
> > --
> > 2.14.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Wouldn't something like this solve the issue without messing up the code ?
>
> diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
> index 8cdf8ab5..c5d932bf 100644
> --- a/libibverbs/verbs.h
> +++ b/libibverbs/verbs.h
> @@ -44,6 +44,7 @@
> =A0#include <linux/types.h>
> =A0
> =A0#ifdef __cplusplus
> +#include=A0 <cstdint>
> =A0#=A0 define BEGIN_C_DECLS extern "C" {
> =A0#=A0 define END_C_DECLS=A0=A0 }
> =A0#else /* !__cplusplus */
>

It will be enough, I'll resend the patch.

Thanks

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnbe+QACgkQ5GN7iDZy
WKcl6BAAhPBn+Nxc/IfvG44AB1qrEQjFuYxZ8Mt+GAMe7WdI/pmzga13A7EkYm1a
I43mNBYaaippQ6t1G2MjQljfhGiygYCjp0HCX6BeIFVlIYI7K7UiGNlGLslgcgZ1
LJJDtpAl8xAxXm7XTCv16wxgvR29PBcEtOvtP5d2rmB6fw/G1qS14YtlT0uqHz4T
7YzaPdvsoeTPEsSdX8r20mUi3vt1piya1BY7am3tpwDrBwdUisjla5UtC58RNlE7
1QJaSG/TPivTxdJttguphRIC0WlLCpti/5k8JnqnE5VOzHRKpQrTew/jwPi/aIft
vQSdK9slNXbmBIWlUUEpdjZamZhx6VUgdSJVFmfSFU13WiEL/Q62NnuUd9NLcvQb
BqzBnybw5Rb+JaXvdlTcuZhx3Xj/SgAwowMsi/KbUFdnsRBnfdMRd0jqEfLv/zVf
R2M9w0C7d0v6/G+qeAVPPzXepE3wBNrfRKyw+1/DkBOBN0uvS9brWHw8X8znchoI
ga0dytAPdi7g83Xdl338SXRr+2NA27/XxJMWIxC5B46UHhkiLerRAvNLuEefobc1
Chb+yM6oLxIigAfg+xBqrES/pZSDfUG2ePtxqbFO/legz9DgLKjwG2bsv5NfWGJP
Z0F2drW69k/tJSOs8gtVeSioV+Fp4Q8hBMFkMvK+dP6EleppQk0=
=PNBd
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
