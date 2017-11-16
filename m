From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in
 iwpm_send_mapinfo()
Date: Thu, 16 Nov 2017 13:21:22 +0200
Message-ID: <20171116112122.GI18825@mtr-leonro.local>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
 <CAK8P3a2D6dnQELKww5V-=mNAzrD-XQoWtNTXCmgMtsnFnujq5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aeNKbBIuxxrR531c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2D6dnQELKww5V-=mNAzrD-XQoWtNTXCmgMtsnFnujq5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aeNKbBIuxxrR531c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 16, 2017 at 11:50:48AM +0100, Arnd Bergmann wrote:
> On Thu, Nov 16, 2017 at 11:26 AM, Geert Uytterhoeven
> <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
> > With gcc-4.1.2:
> >
> >     drivers/infiniband/core/iwpm_util.c: In function =E2=80=98iwpm_send=
_mapinfo=E2=80=99:
> >     drivers/infiniband/core/iwpm_util.c:647: warning: =E2=80=98ret=E2=
=80=99 may be used uninitialized in this function
> >
> > Indeed, if nl_client is not found in any of the scanned has buckets, ret
> > will be used uninitialized.
> >
> > Preinitialize ret to zero to fix this.
> >
> > Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper =
user space service")
> > Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> > ---
> > RFC as I have no idea if this can ever happen, and if yes, what's the
> > correct behavior to handle it:
> >   - return 0,
> >   - return an error code,
> >   - don't send anything,
> >   - anything else?
>
> This looks like a reasonable warning. I don't see on my box with any comp=
iler
> version. Do you have a configuration I can use to reproduce it, I'd just =
like
> to see out of curiosity which other compilers report it.
>
> Looking at one caller (iwpm_mapping_info_cb), it seems that we try to make
> sure that nl_client is valid first by calling iwpm_valid_client(), and re=
turning
> -EINVAL otherwise, so that seems like an appropriate return code if any
> caller forgets to test for iwpm_valid_client() first.

The checks of nl_client are leftovers from RDMA core netlink refactoring
work. The call to iwpm_mapping_info_cb() can occur only if core checked
and identified this client as safe.

Thanks

>
>       Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aeNKbBIuxxrR531c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloNdLIACgkQ5GN7iDZy
WKdiXxAAzkoBM/BChPTOvZoPkZWhoE2fUpVXI55unlFK4dBmcdyP7lcWiRJ4FaoF
HMV0LTcZUnZxHQRWDh1IBWCIyNrafR+Y7BzVVkYmKnbhMLi1O6HpWpNKxm6f6ZZf
dBe5jaPZoUYhBMbZ5nj5shXv1dvB+rf91xLlrk2te2TXZ+hS0F00cMMNweellgWG
VQytiBB2GpvTl9wwlxi5InWJ1oxNzHO6j5wKlMa4iNzPW0voEmzbZu0wA0wj/o6b
hVTbTWe3Zmgb16Ux/7SihGKXSzw43hdwMJrTx5gCik80XkveD0Cul+TETiMIcyo8
avIFTIaMo/qUzqdRqCncWGr3KnSdtAQ22yELhIe7hWV9yzZXrOnLXkzx/PnU8LB0
FomWYzD644v5WDH8rjMc3b/4R+iP6VDFaXpZWFDNbokfc+lAYJONH/AgVtYYRUHs
tG+OVI4xnuTy+P6wxIFveDw162W0POUtTiq8t6z2FFR3KDEQkHSVoFRI0pnf+U1B
RhLCEy55W7McArYX+GmufVTb0HGQlY3iakC37Gl24IT4i5dUr1A7LJZfKZIYOaQr
xE4lSYGagvYFxdSnxNGDGQTG48Amp90vXAekVlSz8yRb+Ts2DAZLXl3ks1hNU+Rl
KFu0q990e1fzW+Slwvhi6isSUyXMRbz96BStmP1zHhHMJpnHSNE=
=NpTc
-----END PGP SIGNATURE-----

--aeNKbBIuxxrR531c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
