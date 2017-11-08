From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] RDMA/bnxt_re: report vlan_id and sl in qp1 recv
 completion
Date: Wed, 8 Nov 2017 06:27:26 +0000
Message-ID: <VI1PR0502MB3008145309EC3989B23415CED1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1510119893-24676-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510119893-24676-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Devesh Sharma [mailto:devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org]
> Sent: Tuesday, November 07, 2017 11:45 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH] RDMA/bnxt_re: report vlan_id and sl in qp1 recv completi=
on
>=20
> In a real RoCE v2 network it is possible to have two Sections of network =
have
> same IP hence same gid. However those may have different vlans. During
> connection resolution it is important to report the actual vlan on which =
the MAD
> packet was received instead of relying on other means to resolve vlan-id.
> ib_find_gid_index should not be used to resolve the vlan-id using sgid of=
 the
> local system where the packet was received.
>=20
> Our device has the capability to report the actual VLAN-ID in the GSI qp
> completions. Since we have the capability our driver should move away fro=
m
> resolving the vlan-id with the help of SGID at the destination port.
>=20
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 33
> ++++++++++++++++++++++++++++++++
> drivers/infiniband/hw/bnxt_re/qplib_fp.c |  1 +
>  2 files changed, 34 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index ebcdfb4..558d786 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2771,6 +2771,32 @@ static void bnxt_re_process_res_rawqp1_wc(struct
> ib_wc *wc,
>  	wc->wc_flags |=3D IB_WC_GRH;
>  }
>=20
> +static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
> +				u16 *vid, u8 *sl)
> +{
> +	u32 metadata;
> +	u16 tpid;
> +	bool ret =3D false;
> +
Large number of places reverse Christmas tree reverse order is not followed=
, but let's try to follow for newly added code  like below.
	bool ret =3D false;
	u32 metadata;
	u16 tpid;

> +	metadata =3D orig_cqe->raweth_qp1_metadata;
> +	if (orig_cqe->raweth_qp1_flags2 &
> +
> 	CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_META_FORMAT_VLAN)
> {
> +		tpid =3D ((metadata &
> +
> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_MASK) >>
> +
> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_SFT);
> +		if (tpid =3D=3D ETH_P_8021Q) {
> +			*vid =3D metadata &
> +
> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_VID_MASK;
> +			*sl =3D (metadata &
> +
> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_MASK) >>
> +
> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_SFT;
> +			ret =3D true;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  static void bnxt_re_process_res_rc_wc(struct ib_wc *wc,
>  				      struct bnxt_qplib_cqe *cqe)
>  {
> @@ -2796,6 +2822,8 @@ static void
> bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
>  	struct bnxt_qplib_cqe *orig_cqe =3D NULL;
>  	struct bnxt_re_sqp_entries *sqp_entry =3D NULL;
>  	int nw_type;
> +	u16 vlan_id;
> +	u8 sl;
>=20
>  	tbl_idx =3D cqe->wr_id;
>=20
> @@ -2810,6 +2838,11 @@ static void
> bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
>  	wc->ex.imm_data =3D orig_cqe->immdata;
>  	wc->src_qp =3D orig_cqe->src_qp;
>  	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
> +	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
> +		wc->vlan_id =3D vlan_id;
> +		wc->sl =3D sl;
> +		wc->wc_flags |=3D IB_WC_WITH_VLAN;
> +	}
>  	wc->port_num =3D 1;
>  	wc->vendor_err =3D orig_cqe->status;
>=20
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> index a82044d..8962621 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> @@ -2236,6 +2236,7 @@ static int
> bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
>=20
>  	cqe->raweth_qp1_flags =3D le16_to_cpu(hwcqe->raweth_qp1_flags);
>  	cqe->raweth_qp1_flags2 =3D le32_to_cpu(hwcqe->raweth_qp1_flags2);
> +	cqe->raweth_qp1_metadata =3D le32_to_cpu(hwcqe-
> >raweth_qp1_metadata);
>=20
>  	rq =3D &qp->rq;
>  	if (wr_id_idx > rq->hwq.max_elements) {
> --
> 1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
