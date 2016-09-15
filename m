From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 12/20] IB/hns: Return bad wr while post send
 failed
Date: Thu, 15 Sep 2016 12:07:42 +0300
Message-ID: <20160915090742.GV26069@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-13-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xVUAO+xN0VJlKSe3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-13-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Dongdong Huang(Donald)" <hdd.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xVUAO+xN0VJlKSe3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:43PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> While post failed, hns roce should return the wr failed to user.
> We omitted this while qp type is wrong and fixed it.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dongdong Huang(Donald) <hdd.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index f4d2515..f0d6315 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -264,8 +264,10 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  			}
>  			ind++;
>  		} else {

You should move the check of supported QPs to the beginning of post_send
and don't enter into the loop at all.

> -			dev_dbg(dev, "unSupported QP type\n");
> -			break;
> +			dev_err(dev, "unSupported QP type\n");

During initial review of hns driver, Lijun was asked to canonize debug
messages and don't use different styles and especially sUcH case.

> +			ret = -EOPNOTSUPP;
> +			*bad_wr = wr;

IMHO, the proper thing is to return NULL, because this is not wrong wr.

> +			goto out;
>  		}
>  	}
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--xVUAO+xN0VJlKSe3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2mTeAAoJEORje4g2clinSwgQAIxiBtp+xVZy5C/wWpGAKgpV
L0mYm6PD7hoZthTRZVkiaSEUnNBfc/bB+lpob6wuk0xWdwNgp3j5YWNy1DfnygS1
4DWl+KbbUQvZDDLlh+CZl26wcvJy9+OifTOJnxvzh3oJ6Z/AHpgujye3RzHaKr0R
uiFXHjl1lBVK5HlzCwXh8aYL9CjXVYB743TXBgouputXkG8ORtNO5UP/CHYl0eef
Td7hgaEPB7zysvwvfvdXeMdEW15BSh//sliF3ZXzWYPo3E3HxnpKwaeVhYV6qxvo
hRpthaHR8Tmy4NY25GTXSygdSqQc5z97DNsiO2BWYPjWSTueg+u7rqdBzSA2OlvM
UUbhGU8/5+29Z776NJ8bb2WBwp6+olTAgZLgiCq0hsPPh9Mkg44vsGs73PDPkRwf
tmt9lbKXWX1WRyRPKn1r32i4fIrlMGOZxqDwOVRNyZSZY83ipAnykcI5EiuULIBn
moKk7RD7XJWZWbVVI2ndMHVEqqJpOcTr72nDMj32P6gZWveFcy4BX68Hc8Y2WozH
nfTDIkpI55rR9EW6JClgrbUmuUYZ7psJjqj6dlCti+ucSqQBHnfCRpX1l14LyFS3
jyWefhFZtaTdOSq1a6y0fhJkEoV6EJNnV2EM8roqSFySgnuJYKQeZA6OCNJRpASK
YE5bya5/KA3k1WYxFS+T
=sNIe
-----END PGP SIGNATURE-----

--xVUAO+xN0VJlKSe3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
