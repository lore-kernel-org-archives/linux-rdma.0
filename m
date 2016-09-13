From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 16/20] IB/hns: Validate mtu when modified qp
Date: Tue, 13 Sep 2016 09:32:40 +0300
Message-ID: <20160913063240.GO8812@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-17-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DITGHUV3p5DjDsXt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-17-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Peter Chen <luck.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--DITGHUV3p5DjDsXt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:47PM +0800, Salil Mehta wrote:
> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> The mtu should be validated when modify qp,so we check it.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Peter Chen <luck.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_qp.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
> index 51fefbf..1c5be59 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_qp.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
> @@ -32,6 +32,7 @@
>   */
>
>  #include <linux/platform_device.h>
> +#include <rdma/ib_addr.h>
>  #include <rdma/ib_umem.h>
>  #include "hns_roce_common.h"
>  #include "hns_roce_device.h"
> @@ -658,6 +659,7 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  	struct device *dev = &hr_dev->pdev->dev;
>  	int ret = -EINVAL;
>  	int p;
> +	u32 active_mtu = 0;

There is no need to assign value to a variable which will be overwritten.

>
>  	mutex_lock(&hr_qp->mutex);
>
> @@ -688,6 +690,19 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  		}
>  	}
>
> +	if (attr_mask & IB_QP_PATH_MTU) {
> +		p = attr_mask & IB_QP_PORT ? (attr->port_num - 1) : hr_qp->port;
> +		active_mtu = iboe_get_mtu(hr_dev->iboe.netdevs[p]->mtu);

ib_mtu iboe_get_mtu returns "enum ib_mtu" and not u32.

> +
> +		if (attr->path_mtu > IB_MTU_2048 ||
> +		    attr->path_mtu < IB_MTU_256 ||
> +		    attr->path_mtu > active_mtu) {
> +			dev_err(dev, "attr path_mtu(%d)invalid while modify qp",
> +				attr->path_mtu);
> +			goto out;
> +		}
> +	}
> +
>  	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
>  	    attr->max_rd_atomic > hr_dev->caps.max_qp_init_rdma) {
>  		dev_err(dev, "attr max_rd_atomic invalid.attr->max_rd_atomic=%d\n",
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--DITGHUV3p5DjDsXt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX152IAAoJEORje4g2clinewQP/0xn4I8jAg8vBaTHMb3k2N14
lPOvq6o1fUPE0Ix+PoAPtQLbnPnrAXRzRZcv0MqTZQeO/v1aejlzGtp+OVzIU149
95sOUj3/VbxkWoLN+BOSzA1yWIvp2C45Y9RIJ8N4eSOljPwVwADcjBIbnh/0xlhK
FqSYA/UdI3csxdynVzYQq7/tJekAt4iG3vC0yMMzm8JlaFuCGpUR++Twy85UeXVu
ScOOQjmn6AokkvnMDiD7gUGFlMrfmBxfpzxBCoKdBiF85EyVRCbLLhljLdJRHdea
Rtrtooc676d4gK3orzLLV5BZ2JrGhxcPNJhLZAhS85ILN9TtLFI+eb6hxUDikec1
52pfoIKYByM1LWtljj+pgGkP9MsTqKM5evEM8Yra0ZMbwOHrjxLCBUDuWkrsnsr4
LQezUbmc3IkEOyWxb+G1GEJ1v0VzJln+AgJREeu9TnBP4uRvyjobmEjMCMyM76mw
cRJa8j9G1VFBpReoqQ7JscbaV/FB+BrvNpL01frEFFUakUuyJK9zz6fXdyHUwDWQ
QdB/UvxmLx/e0s8DJJkBrRrkynjMUyXTxaWIXu8yjaILK0PX2DXw6rvqG9jdflJZ
/YsG3chbg8h+Kz/Z173fTK4SrvZpsAnR9cN4dF3DFj0h4dlnmrxAEOC0rt4j8Hrj
TMPzPiS+trh/Nuic3ODn
=5Q1g
-----END PGP SIGNATURE-----

--DITGHUV3p5DjDsXt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
