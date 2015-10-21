From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] usnix: correctly handle kzalloc return value
Date: Wed, 21 Oct 2015 16:44:12 -0400
Message-ID: <5627F91C.9050102@redhat.com>
References: <1445108816-7616-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ft94oJLCkavKJ6wThAhwK64nBRsruStwq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445108816-7616-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ft94oJLCkavKJ6wThAhwK64nBRsruStwq
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/17/2015 03:06 PM, Insu Yun wrote:
> Since kzalloc returns memory address, not error code,
> it should be checked whether it is null or not.=20
>=20
> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.

> ---
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/in=
finiband/hw/usnic/usnic_ib_qp_grp.c
> index db3588d..a678a66 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> @@ -221,8 +221,8 @@ create_roce_custom_flow(struct usnic_ib_qp_grp *qp_=
grp,
> =20
>  	/* Create Flow Handle */
>  	qp_flow =3D kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
> -	if (IS_ERR_OR_NULL(qp_flow)) {
> -		err =3D qp_flow ? PTR_ERR(qp_flow) : -ENOMEM;
> +	if (!qp_flow) {
> +		err =3D -ENOMEM;
>  		goto out_dealloc_flow;
>  	}
>  	qp_flow->flow =3D flow;
> @@ -296,8 +296,8 @@ create_udp_flow(struct usnic_ib_qp_grp *qp_grp,
> =20
>  	/* Create qp_flow */
>  	qp_flow =3D kzalloc(sizeof(*qp_flow), GFP_ATOMIC);
> -	if (IS_ERR_OR_NULL(qp_flow)) {
> -		err =3D qp_flow ? PTR_ERR(qp_flow) : -ENOMEM;
> +	if (!qp_flow) {
> +		err =3D -ENOMEM;
>  		goto out_dealloc_flow;
>  	}
>  	qp_flow->flow =3D flow;
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ft94oJLCkavKJ6wThAhwK64nBRsruStwq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJ/kcAAoJELgmozMOVy/djlwP/0Dea+D3sxy0kfFtxArjkJkE
58jjYOMVjZ+R3nUTfz7IT2HVsJn2RGKr+ZT8yrb/P90vRu7jcM4FYJr7lF0eoFY4
GU6VtPwoKKs/HoYowRrmeG2mNBxnxD/NqDUNX3clskuEbX9DriENxB7Zz5tmygvQ
8IDvHO6yYSIqNmbHDQigWDpAQglmzjBklhC0e1nronbKaqvFORb/BM89kTd7DvMc
TDKcVEKlrYmsTFq6JqctGp9wxXlJKZxPrwbvYN8FwXRS6m1QHbqI6kZFepWkUp+O
N/TZgN0qHMTs6lNwnKM0A2y44ffvRchvlhN4bb3wCW8jGHHy3N48YhUQNZXmlIVt
E5ZV8ivDBcBHDqEL6lzX8VinQRwV5+HdgBoI+/gWJFigjU5aa7OuYTpWORK5dvmC
I7eQ0B6Blmu2snXS0G4tKsjFoTpWDkiOZsB5+Fr8yXtiUBCNGvhWVspGwipUuQg5
k/+J+dR6NxyvFq6o5FpyDMT2KuFW0a13FnP1kRHOKG/ceLG3NZy+2rIYJNwMugET
QxW+W47+DntqVTCWt1aMHlWth5nSHFW6t6hhySkz9giPWKZZ6xLS3O3izIauwUZ6
y/pfRjrUCTznRT2JPtEj4ZTPvdqFYTJFHqBhmdVDeQNzo3doXMT2DsxxkzS89Bc7
hzsWieSkS9t6C2dF77g+
=ic4f
-----END PGP SIGNATURE-----

--ft94oJLCkavKJ6wThAhwK64nBRsruStwq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
