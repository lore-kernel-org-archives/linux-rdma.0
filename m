From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 3/3] RDMA/qedr: Fix endian problems around imm_data
Date: Mon, 15 Jan 2018 13:01:40 +0000
Message-ID: <CY1PR0701MB2012F77D6946E0E9E90B7A2388EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <20180111214307.501-1-jgg@ziepe.ca>
 <20180111214307.501-4-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111214307.501-4-jgg-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Thursday, January 11, 2018 11:43 PM
>=20
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The double swap matches what user space rdma-core does to imm_data.
>=20
> wc->imm_data is not used in the kernel so this change has no practical
> impact.
>=20
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index 3b9c89848d6698..5551120ac6ea52 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -3039,7 +3039,7 @@ static int __qedr_post_send(struct ib_qp *ibqp,
> struct ib_send_wr *wr,
>  		swqe->wqe_size =3D 2;
>  		swqe2 =3D qed_chain_produce(&qp->sq.pbl);
>=20
> -		swqe->inv_key_or_imm_data =3D cpu_to_le32(wr-
> >ex.imm_data);
> +		swqe->inv_key_or_imm_data =3D
> cpu_to_le32(be32_to_cpu(wr->ex.imm_data));
>  		length =3D qedr_prepare_sq_send_data(dev, qp, swqe,
> swqe2,
>  						   wr, bad_wr);
>  		swqe->length =3D cpu_to_le32(length);
> @@ -3590,7 +3590,7 @@ static inline int qedr_set_ok_cqe_resp_wc(struct
> rdma_cqe_responder *resp,
>  	wc->byte_len =3D le32_to_cpu(resp->length);
>=20
>  	if (resp->flags & QEDR_RESP_IMM) {
> -		wc->ex.imm_data =3D le32_to_cpu(resp-
> >imm_data_or_inv_r_Key);
> +		wc->ex.imm_data =3D cpu_to_be32(le32_to_cpu(resp-
> >imm_data_or_inv_r_Key));
>  		wc->wc_flags |=3D IB_WC_WITH_IMM;
>=20
>  		if (resp->flags & QEDR_RESP_RDMA)
> --
> 2.15.1
Acked-by: Michal Kalderon <michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Thanks Jason!=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
