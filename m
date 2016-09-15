From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 20/20] IB/hns: Delete the redundant lines in
 hns_roce_v1_m_qp()
Date: Thu, 15 Sep 2016 13:15:29 +0300
Message-ID: <20160915101529.GY26069@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-21-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="npbjE3dh3wBH6WIP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-21-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--npbjE3dh3wBH6WIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:51PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> It doesn't need to assign for the filed of qp state in qpc separately
> when qp happen to migrate state which supported in RoCE engine v1.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 7a61d7e..3bc32fc 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -2405,11 +2405,6 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
>  		roce_set_bit(context->qpc_bytes_140,
>  			     QP_CONTEXT_QPC_BYTES_140_RNR_RETRY_FLG_S, 0);
>
> -		roce_set_field(context->qpc_bytes_144,
> -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
> -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
> -			       attr->qp_state);
> -
>  		roce_set_field(context->qpc_bytes_148,
>  			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_M,
>  			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_S, 0);
> @@ -2524,13 +2519,10 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
>  		   (cur_state == IB_QPS_RTS && new_state == IB_QPS_ERR) ||
>  		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_RESET) ||
>  		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_ERR)) {
> -		roce_set_field(context->qpc_bytes_144,
> -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
> -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
> -			       attr->qp_state);
> -
> +		/* It will not do additional options in engine v1 */
> +		;

It will leave empty if() {..}, it is worth to rewrite to have one if for
error path only.

>  	} else {
> -		dev_err(dev, "not support this modify\n");
> +		dev_err(dev, "not support this status migration\n");
>  		goto out;
>  	}
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--npbjE3dh3wBH6WIP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2nTBAAoJEORje4g2clinw7MQAJpLeDwZjRAU4wJTBr9ojcCj
AEq6oUFK0AdElp02HC/vD2g0avfmTpoTPzEb6H/zZhfl09axtmNAAeVRCEulBhpJ
zPqEgR3epylH2FgyzxmmjKT3XYhX4dML09tEePNUlWaAo89HkkMiKNAPblMEcojU
1xj1MlRfE321GQDcrcRtuVwDahD0pr0RqBJesrBbS7bLkzYPPpDkCd62CxCWxDtI
Wxhr++Cx5SkgtIl1/JWpj0OXG53BKdygP0cqz+Lw/FzF866r38ETHk6jEws+HWIZ
wbkiay7U60EzhAhGaLN/erLYq9LeY2w7Q98iLQseHB9ZvCZUrMJeEDodpfal3jwF
DkBYiQ9xo0Duqoy+l5BkStk/1GPaeaiscPcg2qcrPgBvAJLkFAJPYlHt3xfyQVms
/pVMs5kI1+Yp9nmbKZBBrQueCxH6mN2FSNsBWgtGTs2sgxvE2uiwzkDXJucDkYiE
MNnlzoMtbnevZerkRLCcjgAGGA/stZdishKiH+IhGOlYrkPFNOZsEh/kSxHGoXM9
i8gwkGN05Dljlm+1AnkkiPPk6+2dhemZbiVtE5y1h6rPUTCvarmStuXKCUkr+5NO
oGZhsVHBq0dmWl2g8qofCGawJQxPZAB4ra10KJdmIWT2zlazzAYS9tft0jLozZAc
5rNcHIdjDo54eoK3W5va
=KG/7
-----END PGP SIGNATURE-----

--npbjE3dh3wBH6WIP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
