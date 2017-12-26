From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Tue, 26 Dec 2017 10:15:26 +0200
Message-ID: <20171226081526.GB10734@mtr-leonro.local>
References: <1514209039-9388-1-git-send-email-liuyixian@huawei.com>
 <1514209039-9388-3-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514209039-9388-3-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 25, 2017 at 09:37:19PM +0800, Yixian Liu wrote:
> The array defined for doorbell is not guaranteed to be 64 bit
> aligned while we write it to the hardware with 64 bit
> alignment required.
>
> This patch fixes this problem by defining a union for doorbell
> to make sure it 64 bit alignment.

Are you sure that it gives you alignment?
The macros ALIGN/PTR_ALIGN are usually used for that.

Thanks

>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h |  5 +++++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 16 ++++++++--------
>  2 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index dde5178..defc4ee 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -569,6 +569,11 @@ struct hns_roce_eq_table {
>  	void __iomem		**eqc_base; /* only for hw v1 */
>  };
>
> +union hns_roce_db {
> +	u64	doorbell64;
> +	u32	doorbell[2];
> +};
> +
>  struct hns_roce_caps {
>  	u8		num_ports;
>  	int		gid_table_len[HNS_ROCE_MAX_PORTS];
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 7f393f6..ee26bbd 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -3172,33 +3172,33 @@ static int hns_roce_v2_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
>
>  static void set_eq_cons_index_v2(struct hns_roce_eq *eq)
>  {
> -	u32 doorbell[2];
> +	union hns_roce_db db;
>
> -	doorbell[0] = 0;
> -	doorbell[1] = 0;
> +	db.doorbell[0] = 0;
> +	db.doorbell[1] = 0;
>
>  	if (eq->type_flag == HNS_ROCE_AEQ) {
> -		roce_set_field(doorbell[0], HNS_ROCE_V2_EQ_DB_CMD_M,
> +		roce_set_field(db.doorbell[0], HNS_ROCE_V2_EQ_DB_CMD_M,
>  			       HNS_ROCE_V2_EQ_DB_CMD_S,
>  			       eq->arm_st == HNS_ROCE_V2_EQ_ALWAYS_ARMED ?
>  			       HNS_ROCE_EQ_DB_CMD_AEQ :
>  			       HNS_ROCE_EQ_DB_CMD_AEQ_ARMED);
>  	} else {
> -		roce_set_field(doorbell[0], HNS_ROCE_V2_EQ_DB_TAG_M,
> +		roce_set_field(db.doorbell[0], HNS_ROCE_V2_EQ_DB_TAG_M,
>  			       HNS_ROCE_V2_EQ_DB_TAG_S, eq->eqn);
>
> -		roce_set_field(doorbell[0], HNS_ROCE_V2_EQ_DB_CMD_M,
> +		roce_set_field(db.doorbell[0], HNS_ROCE_V2_EQ_DB_CMD_M,
>  			       HNS_ROCE_V2_EQ_DB_CMD_S,
>  			       eq->arm_st == HNS_ROCE_V2_EQ_ALWAYS_ARMED ?
>  			       HNS_ROCE_EQ_DB_CMD_CEQ :
>  			       HNS_ROCE_EQ_DB_CMD_CEQ_ARMED);
>  	}
>
> -	roce_set_field(doorbell[1], HNS_ROCE_V2_EQ_DB_PARA_M,
> +	roce_set_field(db.doorbell[1], HNS_ROCE_V2_EQ_DB_PARA_M,
>  		       HNS_ROCE_V2_EQ_DB_PARA_S,
>  		       (eq->cons_index & HNS_ROCE_V2_CONS_IDX_M));
>
> -	hns_roce_write64_k(doorbell, eq->doorbell);
> +	hns_roce_write64_k(db.doorbell, eq->doorbell);
>
>  	/* Make sure we update the consumer index of EQ before
>  	 * accessing it later
> --
> 1.9.1
>

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpCBR4ACgkQ5GN7iDZy
WKdUdQ/7B85lqjhb5Kq7VKDaMWP7iCgFdgwZQpwbJCaNJgQ3HU12QbcijZwVP8Ev
LszA2tNQj/ptjsmbCNGTUhDVuULVgBkjiTeuw0qAy8Q82JVIhSwXZaQv299WxUYB
9w8FLNJkRbLjopYM2ru6TGLnI+5cM0ofxop+sjObRZsrybCKQN/IuVOLAJEsmJ0E
64I10IfJMgVudKUGQPcpSleqZxrPyHGcR9EEkjVYZQgzUsZ3xmYFSQ5jRtVy4O+Y
hsUEi93gGtITSm1ilEdPuW+jcXrX+gvYsOuDF8n4GWMC3bxPsxUb3NK8k1qk5Grr
6jkmGYp8k/RKblzwxLg7PQ593M2jmGc7OMpReptmqac/nqwXrDcNgQ+jPNCbQ4c5
Tu46jpTjNseKOLuqBRUuoO6yvqz9JU+XFs3Z16rVytXobUdQ51Ob8y36ynQA0Jk/
O0euO9vo9RW+KqBn7jSmDhxxv89S5vFqXxok43ULPlLTSdr8Op3D2veWl/b8ynxI
k6EDh8PakfVCNPvywd2OEJZUK77ShCnwMt3l162Ot/79UFr54NEsIPqNM9zoo7gz
ME14yRAaxmfWY6s9E6zTICbjdNCdtJMBP/xq4LGvG5qn2W8jJRdUO27k2qEjUFxB
4rACdkyqVEaF1ZQVe9JiF1NqKEyjSEwR7Rpp3gSvRd88q+NOPSA=
=2SbD
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
