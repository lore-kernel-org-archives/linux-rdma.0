From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 28/26] IB/ipath: Remove fast registration from the code
Date: Thu, 29 Oct 2015 11:45:06 -0400
Message-ID: <56323F02.8040803@redhat.com>
References: <1446132812-20170-1-git-send-email-sagig@mellanox.com>
 <1446132812-20170-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dwee0Fw0lxeuxbCURPu22lKmW9AJel9nL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446132812-20170-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dwee0Fw0lxeuxbCURPu22lKmW9AJel9nL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 11:33 AM, Sagi Grimberg wrote:
> The driver does not support it anyway, and the support
> should be added to a generic layer shared by both hfi1,
> qib and softroce drivers.

Thanks, applied.

> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/staging/rdma/ipath/ipath_verbs.c |    3 ---
>  drivers/staging/rdma/ipath/ipath_verbs.h |    1 -
>  2 files changed, 0 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/staging=
/rdma/ipath/ipath_verbs.c
> index 15633ec..29e9179 100644
> --- a/drivers/staging/rdma/ipath/ipath_verbs.c
> +++ b/drivers/staging/rdma/ipath/ipath_verbs.c
> @@ -399,9 +399,6 @@ static int ipath_post_one_send(struct ipath_qp *qp,=
 struct ib_send_wr *wr)
>  	if (qp->ibqp.qp_type !=3D IB_QPT_UC &&
>  	    qp->ibqp.qp_type !=3D IB_QPT_RC)
>  		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
> -	else if (wr->opcode =3D=3D IB_WR_FAST_REG_MR)
> -		memcpy(&wqe->fast_reg_wr, fast_reg_wr(wr),
> -			sizeof(wqe->fast_reg_wr));
>  	else if (wr->opcode =3D=3D IB_WR_RDMA_WRITE_WITH_IMM ||
>  		 wr->opcode =3D=3D IB_WR_RDMA_WRITE ||
>  		 wr->opcode =3D=3D IB_WR_RDMA_READ)
> diff --git a/drivers/staging/rdma/ipath/ipath_verbs.h b/drivers/staging=
/rdma/ipath/ipath_verbs.h
> index ed102a2..0a90a56 100644
> --- a/drivers/staging/rdma/ipath/ipath_verbs.h
> +++ b/drivers/staging/rdma/ipath/ipath_verbs.h
> @@ -280,7 +280,6 @@ struct ipath_swqe {
>  	union {
>  		struct ib_send_wr wr;   /* don't use wr.sg_list */
>  		struct ib_ud_wr ud_wr;
> -		struct ib_fast_reg_wr fast_reg_wr;
>  		struct ib_rdma_wr rdma_wr;
>  		struct ib_atomic_wr atomic_wr;
>  	};
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--dwee0Fw0lxeuxbCURPu22lKmW9AJel9nL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMj8CAAoJELgmozMOVy/djlMP+gIX3y+s7T3uHWjaxBLfL/Ju
60g5KR4LS/RAYIHNehmmsdzPgCbTDqFwkU/J/DXpub/Z41EFc3ggfqVpVVQ6QQ+c
loaYbqkXZkr7++mNnYb61eYQcMjUbWr3bfU2/mVlFHBkSUJF+QMsI6fbvyg8kIAJ
HocpD1zdj840Ur9zmlXGIHqiNuj9jA7xZeIqnjjd2oY2OPpLpQvfLPHqmWmCnq9z
agkX+mnUYaZD4aYFalkNg7GPolbuVY7uKwyxBEUMcdUWFMHr//DDHdWcp7+w4gBu
pBizzGDYO03VGEwK6VzuLvS1xG/+T+l9+KpbER5F5t6wFbLSKPuClV4fXA8zhtIT
jo2e8qTDpb+es1F1FvPn3xQp+JoKp7/moSKr16BKn9uNQb3YE/tJm5Npffk6bGAr
g87frLGJ5/SH38fWgOcuwzaEDE/rF5aGQ4GZlXiGNKdCSd4mMzw199yq5HfUfHF+
/Hi8qUY37/vT7HpQOZyggW8bLlAVJJZvRNp0h4pKfihQizgAuJTm/sHSVq7OpTnp
BDusN+76jcAxFyfeMIxFFDayOix16jzD0UNtWqmQDhkdHaxbi/T5PiWVevihWpL4
EjRVlhULYg8hwMkDa5R/qbulS8OJwYtrWW3IhgOaFn0QF6ARJkgN64b16x87ZvCJ
aG17baPSLFtV9E4kXbXm
=apqB
-----END PGP SIGNATURE-----

--dwee0Fw0lxeuxbCURPu22lKmW9AJel9nL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
