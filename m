From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] RDMA/hns: Add gsi qp support for modifying
 qp in hip08
Date: Mon, 08 Jan 2018 16:20:59 -0500
Message-ID: <1515446459.3403.94.camel@redhat.com>
References: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
         <1515039563-73084-3-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-g4Q6VVu827OSLW1pYdXt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515039563-73084-3-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-g4Q6VVu827OSLW1pYdXt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-04 at 12:19 +0800, Lijun Ou wrote:
> @@ -2342,7 +2366,7 @@ static void modify_qp_init_to_init(struct ib_qp *ib=
qp,
>                        V2_QPC_BYTE_80_RX_CQN_S, 0);
> =20
>         roce_set_field(context->byte_252_err_txcqn, V2_QPC_BYTE_252_TX_CQ=
N_M,
> -                      V2_QPC_BYTE_252_TX_CQN_S, to_hr_cq(ibqp->recv_cq)-=
>cqn);
> +                      V2_QPC_BYTE_252_TX_CQN_S, to_hr_cq(ibqp->send_cq)-=
>cqn);

This looks like a bugfix unrelated to the rest of the patch.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-g4Q6VVu827OSLW1pYdXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpT4LsACgkQuCajMw5X
L91A8A/+Ok6hblAXig7IJaMA11+hyrTcD4653gZRHvsxVhVcMfbMq0d/A1stLrK8
FZzE/sAUO47kNh/NzpS8mEe3czh5aNSU0oVV09QL+Yr4DR4triTC44b+QSR07F+K
S82a5tYl8VmQ8h4saie5LoESNrGpoyxdhhF4fSBT5Rb0zrNzwFE23857TWnk8A9d
//UMqL+1iq6Veays/ClXIAxJPq8w7WP5HtqCHkd9uACym+vXMpandmroqNLDn1Wx
5+Ck+fCbnqmX0JI8ufzt5EGXSNqJVtTx2lKjimmvTWxQZWkxxLL0joM5xL+8fier
e8uzkYgi7qcgnDYlvPB72LowRfMMHOsCriCc2ei7bsangl076GbbjHAly9tpD1QY
xIrSTzEd8k0yGSPQFookx9mTQqAJt2FbizmVHV+5vJgM1olLHVf9nryc7NLHYuTK
+xh1CGgqzqWgpWioZRJiB4xOe3lBfdD3MVH9OD0f7t2c3dqlB+KAVj8qVJclg9Zo
StozgoMuC4k3WNSRHXmeArqkr6pUuPxauMjYLWvULCd3wofV1nsmrmF52+4t5L5s
w2tym9QpeSz4nnoCABfcYt3IPwmvKDigNzUGYI6ahoP3xodQ/CWVHYm2tDs4cFJZ
WVXFXJxv1PeH95jMqptPN+g9u1lBtqYS87rstnLKZP8gYD+Lz4o=
=gKbW
-----END PGP SIGNATURE-----

--=-g4Q6VVu827OSLW1pYdXt--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
