From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 18/20] IB/hns: Update the rq head when modify qp
 state
Date: Thu, 15 Sep 2016 13:12:46 +0300
Message-ID: <20160915101246.GX26069@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-19-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8MA55IEjTDEadc2f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-19-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8MA55IEjTDEadc2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:49PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> The rq head in qpc was zero will miss the rq wqes which
> have be sent, so here we should take the real value.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index bdd9453..7a61d7e 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -2266,7 +2266,8 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
>
>  		roce_set_field(context->qpc_bytes_68,
>  			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_M,
> -			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S, 0);
> +			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S,
> +			       hr_qp->rq.head);

Are you sure that it should be list_head and not value?

>  		roce_set_field(context->qpc_bytes_68,
>  			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_M,
>  			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_S, 0);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--8MA55IEjTDEadc2f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2nQeAAoJEORje4g2clin5p0QAJasT/etvEQjDJqMzdx4LrJm
4jyNYbBjtD0SGHc+IexyOYlaujV3CkNtvGgQdB+GI2JXxnhXk/0ITME5v09HfkeL
zVCKBRYiTpwzmuX1PD+TlpDixNKus/JWjmwvOfi0p3KbiGu4PDI6UHr+AvtDkoWK
vQj/bibOOIdCOg6GCIQLq0FCstrsPvB6w5ltAz3MX9IVnCwcS1wh0P9U7BNf7Zir
uXyan6C/16qquOjBDZom4vbrOPcHt3yLCJrGU3una4EdeAuvLewlzAM44NJo0Qin
LCgVw7CSZtpLf00+4HnS41fJOqu0VBmIxVQBQVdYX0hM1WKtUHeumrwcYyE+ax5v
ee50/+N0ykBvBEkxOuZR4RXlSvXCEP2UAznFf5LAcbLr1xqJXXpi4mfVUqPcKyNY
5dgRKMZUqKdy52GYGoIubR8ZomYApHwruvbuEhtzKY/EKA+v8OTZLRQel0tDcYwa
/aObbnEALGVL4Zi+Ic9KQtdjhO/RoOzornVWCg4uxqLmc8APajKcCW7o7b9tHGbI
R2nKnc+J1wdJoov9y0jbyKn9H1LKVnee7JVm8cycyFAnaCZOHcUvnPLKxL1evycx
pWQwsv/IszgAnYPUDrfWdNmHXyxaYboY5w/FRuYeV81i2YZ8dyo/tPtjAFE19QST
layVQqIFe19O3tF6dgQ7
=fSVd
-----END PGP SIGNATURE-----

--8MA55IEjTDEadc2f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
