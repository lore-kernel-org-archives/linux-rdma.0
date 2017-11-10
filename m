From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage
Date: Fri, 10 Nov 2017 12:58:02 -0500
Message-ID: <1510336682.3735.3.camel@redhat.com>
References: <20171002101309.dpxylk77ud5gsr2i@mwanda>
         <CAK8P3a1t6zyQXtfov6HguOb9V7E4i54pK8+y8BjPqGqvsc9mpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OjmFU4DEjjwlk8L9JiFD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a1t6zyQXtfov6HguOb9V7E4i54pK8+y8BjPqGqvsc9mpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-OjmFU4DEjjwlk8L9JiFD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-10-02 at 13:00 +0200, Arnd Bergmann wrote:
> On Mon, Oct 2, 2017 at 12:13 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=
 wrote:
> > Hello Arnd Bergmann,
> >=20
> > The patch 12f727721eee: "IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL
> > usage" from Sep 6, 2017, leads to the following static checker
> > warning:
> >=20
> >         drivers/infiniband/core/uverbs_std_types.c:249 create_udata()
> >         error: uninitialized symbol 'inbuf'.
> >=20
> > drivers/infiniband/core/uverbs_std_types.c
> >    222  static void create_udata(struct uverbs_attr_bundle *ctx,
> >    223                           struct ib_udata *udata)
> >    224  {
> >    225          /*
> >    226           * This is for ease of conversion. The purpose is to co=
nvert all drivers
> >    227           * to use uverbs_attr_bundle instead of ib_udata.
> >    228           * Assume attr =3D=3D 0 is input and attr =3D=3D 1 is o=
utput.
> >    229           */
> >    230          void __user *inbuf;
> >    231          size_t inbuf_len =3D 0;
> >    232          void __user *outbuf;
> >    233          size_t outbuf_len =3D 0;
> >    234          const struct uverbs_attr *uhw_in =3D
> >    235                  uverbs_attr_get(ctx, UVERBS_UHW_IN);
> >    236          const struct uverbs_attr *uhw_out =3D
> >    237                  uverbs_attr_get(ctx, UVERBS_UHW_OUT);
> >    238
> >    239          if (!IS_ERR(uhw_in)) {
> >    240                  inbuf =3D uhw_in->ptr_attr.ptr;
> >    241                  inbuf_len =3D uhw_in->ptr_attr.len;
> >    242          }
> >    243
> >    244          if (!IS_ERR(uhw_out)) {
> >    245                  outbuf =3D uhw_out->ptr_attr.ptr;
> >    246                  outbuf_len =3D uhw_out->ptr_attr.len;
> >    247          }
> >    248
> >    249          ib_uverbs_init_udata_buf_or_null(udata, inbuf, outbuf, =
inbuf_len,
> >    250                                           outbuf_len);
> >=20
> > In the original code, this was a macro so smatch understood that we
> > don't use inbuf and outbuf if they aren't initialized.  Now it's a
> > function and smatch generates a warning if you pass uninitialized
> > variables to a function.
> >=20
> > It's not a bug, but it's really ugly.
>=20
> I see. Should we maybe open-code the ib_uverbs_init_udata_buf_or_null()
> call in this function?
>=20
> diff --git a/drivers/infiniband/core/uverbs_std_types.c
> b/drivers/infiniband/core/uverbs_std_types.c
> index b095bce7f238..039802ae7332 100644
> --- a/drivers/infiniband/core/uverbs_std_types.c
> +++ b/drivers/infiniband/core/uverbs_std_types.c
> @@ -227,27 +227,26 @@ static void create_udata(struct uverbs_attr_bundle =
*ctx,
>          * to use uverbs_attr_bundle instead of ib_udata.
>          * Assume attr =3D=3D 0 is input and attr =3D=3D 1 is output.
>          */
> -       void __user *inbuf;
> -       size_t inbuf_len =3D 0;
> -       void __user *outbuf;
> -       size_t outbuf_len =3D 0;
>         const struct uverbs_attr *uhw_in =3D
>                 uverbs_attr_get(ctx, UVERBS_UHW_IN);
>         const struct uverbs_attr *uhw_out =3D
>                 uverbs_attr_get(ctx, UVERBS_UHW_OUT);
>=20
>         if (!IS_ERR(uhw_in)) {
> -               inbuf =3D uhw_in->ptr_attr.ptr;
> -               inbuf_len =3D uhw_in->ptr_attr.len;
> +               udata->inbuf =3D uhw_in->ptr_attr.ptr;
> +               udata->inbuf_len =3D uhw_in->ptr_attr.len;
> +       } else {
> +               udata->inbuf =3D NULL;
> +               udata->inbuf_len =3D 0;
>         }
>=20
>         if (!IS_ERR(uhw_out)) {
> -               outbuf =3D uhw_out->ptr_attr.ptr;
> -               outbuf_len =3D uhw_out->ptr_attr.len;
> +               udata->outbuf =3D uhw_out->ptr_attr.ptr;
> +               udata->outbuf_len =3D uhw_out->ptr_attr.len;
> +       } else {
> +               udata->outbuf =3D NULL;
> +               udata->outbuf_len =3D 0;
>         }
> -
> -       ib_uverbs_init_udata_buf_or_null(udata, inbuf, outbuf, inbuf_len,
> -                                        outbuf_len);
>  }
>=20
>  static int uverbs_create_cq_handler(struct ib_device *ib_dev,
>=20
>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Arnd, can you send this as a proper patch with attribution and a Signed-
off-by: please.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-OjmFU4DEjjwlk8L9JiFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF6KoACgkQuCajMw5X
L90KHA/9E7HgTkfx81ibz5QbQUo7OuPxoAkmT+37b/auDOlxF6z8L4yCJ1ZBQjCv
nNnfjWivdDfjpnxK5WSkfPUs1nukUzKee+X8EEz/rTYVa+c61bdNsKq6wYhwWQ+P
AaJH/mI7ExZisih3v9lv/Zl7d88SDsynN8Y3O65blikFzCAzwY/333phtlet4VzR
eesEhcLntlFVMjeMI0UDBytFA0PB62e4lYKB0/Y9rm0j59oyH85OZElyM9wD2M/m
YqSci/q6/60Sc5z2pzCSHCgPsgu0AAM6H7b1xdDd5mk5JFdx0dQPvMsQipZVJiMM
36HFU3+NoV4lamVTKFkUVbwehWIzTdmua6m4zYNzXeUvDNwzVRFVD1wMQuiOjApI
uJa3YrQj5HpwBnechn9oYa0DA3++vcvLpCMc297DttT0mpE2q3Ze27LfPk+ZSk5k
Gdj+AH2WeCBuhz3kcmHTjvNZZrGt3XTZ+7X+EwuWlLff041SLlXVdAtbBYoIAUtc
azGdg1owJEfWbI0ABqf0bre+J70P0+kUMwqf47o9cqheC5zIa5yg0cDlOWIYm+W6
UeHSRgo0LPXIPEom5GT9T1T4KRbbD5yHq8a6JqpCknP7JbFzJqF80hKIaefAo9rZ
/2jK73Vois3vp7WIhhGLt1vP/mlW8Seu6YEv6K4I2Wkcm3BYoPg=
=1uQ+
-----END PGP SIGNATURE-----

--=-OjmFU4DEjjwlk8L9JiFD--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
