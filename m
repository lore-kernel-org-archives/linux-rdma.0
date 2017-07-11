From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libqedr: fix bugs introduced in "sparse fixes"
Date: Tue, 11 Jul 2017 11:34:07 +0300
Message-ID: <20170711083407.GW1528@mtr-leonro.local>
References: <1499680112-7347-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+l3g4Y4ANQ+hgh+q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499680112-7347-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+l3g4Y4ANQ+hgh+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 10, 2017 at 12:48:32PM +0300, Ram Amrani wrote:
> Fix byte swapping function (pointer must advance).
> Fix WQE size to be multiples of 16 bytes, not 8 bytes.
> Pass a pointer to wqe_size to allow it to be updated.
> Update the immediate value before the wqe is copied.
>
> Fixes: 259ddded0e16 ("libqedr: fix sparse warnings")
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr.h       |  1 +
>  providers/qedr/qelr_verbs.c | 59 ++++++++++++++++++++++++---------------------
>  2 files changed, 32 insertions(+), 28 deletions(-)
>

Thanks, applied.

--+l3g4Y4ANQ+hgh+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllkjX4ACgkQ5GN7iDZy
WKfSuhAAj37ettFVDrjN4MKvmNxaHFjDCgJk435nT/hS+HdBVjshsP6f0k2oOb10
qudAhNLTmL+HV4020BtPr1O6EooP6sV7KjzcrkwD2kohCyhLKNqKAAM54oNv7yqs
WmJihwLHQQNlTUDvHN/YyNw1vFIJfY4qfMW8WdVWesGX1MH2u90/fPbqoWrJrgiq
WkZosDqMXcXAgjY2z4OEV7mFLRdlzrHTw4EY9TQvFlYDqato0o3FDuxSADmWhQoW
n/KpdOldfxkVAogoggzlhkYE0+GOdEU7o0hz+Zzz+l0wH/UGNuSX2B5GzMGqObk6
XB1ne0qjiNqnmFGyuqfmtK/mvV7QGBqMAaPaiQyCdjoFKZWjT+tbnhrvnNSDInoj
r9pG3LLBYH0K0cA/nhujmUSiDmGBzMBgPy0YkoEwu04sIB5NRdj80OeZU2m/3l+l
PhY9gJeaEi6fWMcVCdBZRCSKwfF21dxVgSZTcDITGm7D3XlqUeAYjD5ghdOu9zDX
kf/OLi2E7U6QIo01uXEY/++c4WbXkYI7Js8W1qDox7uegU9/oDe8SQnp/GNqvy9n
ralxifgdgAXdl5wUPo4JKf4eLKoe9Kk/Ctty5t9Q1NUWhH9oE3+84dX803gye4SI
r79BtzzUfNxB8WUoMX1eVJd/ONa5O59oU2zn9zr16+rt8IB0/6k=
=19Yn
-----END PGP SIGNATURE-----

--+l3g4Y4ANQ+hgh+q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
