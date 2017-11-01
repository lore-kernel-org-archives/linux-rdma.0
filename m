From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] libhns: Modify the usage of cmd_sn in
 hip08 RoCE userspace
Date: Wed, 1 Nov 2017 12:06:56 +0200
Message-ID: <20171101100656.GR16127@mtr-leonro.local>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-3-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NhnzZsTWd+R/yp6D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509530440-164400-3-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--NhnzZsTWd+R/yp6D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 01, 2017 at 06:00:39PM +0800, Lijun Ou wrote:
> The cmd_sn field of CQ doorbell should be 1 for the first
> db rung. It inits for 0. It should be increment on each
> first db rung after a complemention Event.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/hns/hns_roce_u_hw_v2.c | 4 +++-
>  providers/hns/hns_roce_u_hw_v2.h | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
> index 900387c..7777e75 100644
> --- a/providers/hns/hns_roce_u_hw_v2.c
> +++ b/providers/hns/hns_roce_u_hw_v2.c
> @@ -444,11 +444,13 @@ static int hns_roce_u_v2_poll_cq(struct ibv_cq *ibvcq, int ne,
>  static int hns_roce_u_v2_arm_cq(struct ibv_cq *ibvcq, int solicited)
>  {
>  	uint32_t ci;
> +	uint32_t cmd_sn;
>  	uint32_t solicited_flag;
>  	struct hns_roce_v2_cq_db cq_db;
>  	struct hns_roce_cq *cq = to_hr_cq(ibvcq);
>
>  	ci  = cq->cons_index & ((cq->cq_depth << 1) - 1);
> +	cmd_sn = cq->arm_sn & HNS_ROCE_CMDSN_MASK;

I didn't understand it from you commit message, so I'll ask it here.
cmd_en will be 1,2 and 3 now, is it ok?

Thanks

>  	solicited_flag = solicited ? HNS_ROCE_V2_CQ_DB_REQ_SOL :
>  				     HNS_ROCE_V2_CQ_DB_REQ_NEXT;
>
> @@ -462,7 +464,7 @@ static int hns_roce_u_v2_arm_cq(struct ibv_cq *ibvcq, int solicited)
>  		       CQ_DB_PARAMETER_CQ_CONSUMER_IDX_S, ci);
>
>  	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CMD_SN_M,
> -		       CQ_DB_PARAMETER_CMD_SN_S, 1);
> +		       CQ_DB_PARAMETER_CMD_SN_S, cmd_sn);
>  	roce_set_bit(cq_db.parameter, CQ_DB_PARAMETER_NOTIFY_S, solicited_flag);
>
>  	hns_roce_write64((uint32_t *)&cq_db, to_hr_ctx(ibvcq->context),
> diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
> index 28aab60..196ba4e 100644
> --- a/providers/hns/hns_roce_u_hw_v2.h
> +++ b/providers/hns/hns_roce_u_hw_v2.h
> @@ -38,6 +38,8 @@
>  #define HNS_ROCE_V2_CQ_DB_REQ_SOL		1
>  #define HNS_ROCE_V2_CQ_DB_REQ_NEXT		0
>
> +#define HNS_ROCE_CMDSN_MASK			0x3
> +
>  /* V2 REG DEFINITION */
>  #define ROCEE_VF_DB_CFG0_OFFSET			0x0230
>
> --
> 1.9.1
>

--NhnzZsTWd+R/yp6D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln5nMAACgkQ5GN7iDZy
WKcGig/+ND//EuHB2dGHPgCdrEyu+8/H9ZvVF1NNhFyV4koYoRSUW2LdfAiENwod
361W1A8FRNFj4tKqII5lWHCTE06El+u7o1+PVJ/7Yzwg3tptg/gxPVkPqdMupIrh
Rj9yw7r+77LrG2jbrnFFfeudFJx4Lpv5YvzC6av80Iq0vFWOQbNSGMk8ZY0vPx7T
/+p839FlwNz70dN17K5ica/HaodN7GtFNr8mce7umObHDVA/g4h7dq646nyJChSY
m5uOR6D7gf/ZCMxl58UbLIzFUnZ8dPEFzn3zwhdFvA7aG80IBnQUxhv5Yla0uc3/
nPPf/P/Z/Dt4+PeeVz/YY2RWCqDR58WkLzbu73yIX5oWCu1zYKYl77SG8gwORgPL
vnllYygXJLH0lQ7lY+SJBDwpkxLPfuB2u7ok1BfDXECgKuaYTewirksqiL3saweh
cEoh1eMIugQxhukpQ/CPp1TTudxvh0bIEJNBjc7+3MWk3Rde2LTBWWPKHgpozEFv
dclHSJqP3ElhOWwDh4IfMMvPw174k+MeKS2N/NA7mb6SukC6GtU7uZ7DyVuwFBcG
HaXWhd0jnMe8nmAPNMxnt4oJFXLlYstvqQlAgxE5voUAo3u8ywRaACkr6TDGeFUT
INuu2+RpfDuecmv47yw82WX17r+KcBqwbh0uSKkAOqbpC6uAJ0U=
=XohM
-----END PGP SIGNATURE-----

--NhnzZsTWd+R/yp6D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
