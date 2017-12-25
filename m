From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] RDMA/hns: Update the usage of sr_max and
 rr_max field
Date: Mon, 25 Dec 2017 11:41:12 +0200
Message-ID: <20171225094112.GA2942@mtr-leonro.local>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
 <1514017342-91468-3-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4A5jqvouPF9zMMhx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514017342-91468-3-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4A5jqvouPF9zMMhx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 23, 2017 at 04:22:18PM +0800, Lijun Ou wrote:
> This patch fixes the usage with sr_max filed and rr_max of qp
> context when modify qp. Its modifications include:
> 1. Adjust location of filling sr_max filed of qpc
> 2. Only assign the number of responder resource if
>    IB_QP_MAX_DEST_RD_ATOMIC bit is set
> 3. Only assign the number of outstanding resource if
>    IB_QP_MAX_QP_RD_ATOMIC
> 4. Fix the assgin algorithms for the field of sr_max
>    and rr_max of qp context
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 33 ++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index b17dcfa..092f133 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -2531,11 +2531,17 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
>  		roce_set_bit(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_LBI_S, 0);
>  	}
>
> -	roce_set_field(context->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
> -		       V2_QPC_BYTE_140_RR_MAX_S,
> -		       ilog2((unsigned int)attr->max_dest_rd_atomic));
> -	roce_set_field(qpc_mask->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
> -		       V2_QPC_BYTE_140_RR_MAX_S, 0);
> +	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
> +		if (attr->max_dest_rd_atomic) {

if ((attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) && attr->max_dest_rd_atomic) {



> +			roce_set_field(context->byte_140_raq,
> +				       V2_QPC_BYTE_140_RR_MAX_M,
> +				       V2_QPC_BYTE_140_RR_MAX_S,
> +				       fls(attr->max_dest_rd_atomic - 1));
> +			roce_set_field(qpc_mask->byte_140_raq,
> +				       V2_QPC_BYTE_140_RR_MAX_M,
> +				       V2_QPC_BYTE_140_RR_MAX_S, 0);
> +		}
> +	}
>
>  	roce_set_field(context->byte_56_dqpn_err, V2_QPC_BYTE_56_DQPN_M,
>  		       V2_QPC_BYTE_56_DQPN_S, attr->dest_qp_num);
> @@ -2625,12 +2631,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
>  		       V2_QPC_BYTE_168_LP_SGEN_INI_M,
>  		       V2_QPC_BYTE_168_LP_SGEN_INI_S, 0);
>
> -	roce_set_field(context->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
> -		       V2_QPC_BYTE_208_SR_MAX_S,
> -		       ilog2((unsigned int)attr->max_rd_atomic));
> -	roce_set_field(qpc_mask->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
> -		       V2_QPC_BYTE_208_SR_MAX_S, 0);
> -
>  	roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
>  		       V2_QPC_BYTE_28_SL_S, rdma_ah_get_sl(&attr->ah_attr));
>  	roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
> @@ -2834,6 +2834,17 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
>  	roce_set_field(qpc_mask->byte_196_sq_psn, V2_QPC_BYTE_196_SQ_MAX_PSN_M,
>  		       V2_QPC_BYTE_196_SQ_MAX_PSN_S, 0);
>
> +	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC) {
> +		if (attr->max_rd_atomic) {
> +			roce_set_field(context->byte_208_irrl,
> +				       V2_QPC_BYTE_208_SR_MAX_M,
> +				       V2_QPC_BYTE_208_SR_MAX_S,
> +				       fls(attr->max_rd_atomic - 1));
> +			roce_set_field(qpc_mask->byte_208_irrl,
> +				       V2_QPC_BYTE_208_SR_MAX_M,
> +				       V2_QPC_BYTE_208_SR_MAX_S, 0);
> +		}
> +	}
>  	return 0;
>  }
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4A5jqvouPF9zMMhx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpAx7gACgkQ5GN7iDZy
WKfMQw//VFgcSV47HTMdWKHOUQha1AMeH2BCKEUJ7fB2A0GAlq9WG/H2F/NRbm05
cEF61Uc2X0vl5j0NDg3FNncob5Jt63/2+35i2ike/9gPeRBbu3o4LvOUZ/P4dIcx
NvE2f/pl4J0TFgLdwCT/LnGSxqc9vDjqU4c9XKpx77r3wWm3V6QRDBzLuzwUyyAs
aIurbWf7sUp/fAkftSkRB6hrv+u/LAmv5PgdWdEJpWTXgDDzle7g/AnXiDDqIEcZ
bdM035y5xSaYq5E7tKuTYD7VxF0dlasOiCGJdvs49/ptYGRMJ9NaOCYyay25HWhB
HCyrKJpHbJVKD2IEf/LZxWOjet/Tic2gsKUwCVSdjSefJv2e5Lqs10nBhQ1Xepkx
+CNfvuM9FiuTS7GcD6J75hwEWVEo1VXWHlNLH3epEbRngS25lC3bAXcp811dyifA
go53xGfa0ltnlKN1EMYa87NarYmPHHUu5peY6fkABb0SSimkm5GIx5Dp32IMfJVr
7CrN9LiSxf/yq664n4GpW6Ef/kHOGC6rWSVHpPHelhMLQHHcK/sV7bvTSm1qkwYy
9etLnROfd0xDM4VIzWJzlbzBCfMNft4sTGQ3MX3o1NVH/GeA1/X8ZmjS5NQE5+bB
Ush7YdwDtcvFJCoeApuSZLcPUJ3INuzcbLKDqV42o/EIxE/wMjQ=
=YlXj
-----END PGP SIGNATURE-----

--4A5jqvouPF9zMMhx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
