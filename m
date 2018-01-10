From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] RDMA/hns: Set the guid for hip08 RoCE
 device
Date: Wed, 10 Jan 2018 08:49:37 +0200
Message-ID: <20180110064937.GE7368@mtr-leonro.local>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
 <1515566393-63888-8-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515566393-63888-8-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 10, 2018 at 02:39:53PM +0800, Lijun Ou wrote:
> This patch assgin a guid(Global Unique identifer)
> value to the hip08 device.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> V2:
> - Use the correct way to update guid from Leon
>   Romanovsky's review.
>
> V1:
> - The initial submit
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index a1839a3..2af4948 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -34,6 +34,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
> +#include <net/addrconf.h>
>  #include <rdma/ib_umem.h>
>
>  #include "hnae3.h"
> @@ -4679,6 +4680,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
>  	hr_dev->iboe.netdevs[0] = handle->rinfo.netdev;
>  	hr_dev->iboe.phy_port[0] = 0;
>
> +	addrconf_addr_eui48((u8 *)&hr_dev->ib_dev.node_guid,
> +			    hr_dev->iboe.netdevs[0]->dev_addr);
> +

Are you sure that it is right thing to do?

ib_dev.node_guid is __be64 and you cast it for u8.

Maybe, it is right, but I don't have ability to test it now.

Thanks

>  	for (i = 0; i < HNS_ROCE_V2_MAX_IRQ_NUM; i++)
>  		hr_dev->irq[i] = pci_irq_vector(handle->pdev,
>  						i + handle->rinfo.base_vector);
> --
> 1.9.1
>

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpVt4EACgkQ5GN7iDZy
WKfJpBAAy0qlNhJJ5I8JQHolWz4g2rBDcCsin4qSfF/cPRXsM1T7pU+6o28XzQER
WW2fReEU0owT1mrpG1/xv/3FAucKpafhZ23QaLou2f+UbNBx/3uvllZU0POWK52R
K5xs0cvuFm4PKNxlQeuDUG+AL1JGYe6t9oFvWt5NpI5gMzkj6LKO5aaRls9oFLiM
06xWBPuA7NWxEGqp6sqHEoZVbVH6BDzjZS1liuBLZFV/vyoQ7j4CclBoo8f5MRSc
7L6ym3nPxerVcQQmGj8EQ9OV3JEcIKGfNW0DsyEalDuTZTCa9ZER8xZJFRs90ONh
gnhJcI1fsiSPnezpA5IOJUmabVW13F/SHL6ZMA/y3I9JzvieCEocGP58qet1XwKw
tDHETu2si8LU6sBJew5l+xWrrFHWC+PXmUQp4e73ovfDxD3W3oAHNM1qkO/ZUWiY
tFXKRy1GrEVYn3m601lrc69bTo30kFp01xAxjoQVMYbmMBgA+/dcpi13fMIe1Oue
1mtRmmQ2EzMQ7HQjA7niUVUCyQw5JNHsIAwlcPSXCQX3w+9tvd7IPMMztYA9xinJ
tRMFtdNSRYU7UsMJm6voDaS4UGLJkt9jIuTt2b6tHRLDXumX3ea1jhV8nLfwl7G3
Liu3g7jIrIDSZ7uQ3qmhEFj9aicmmTr4mTFmT5mkkKd7yxYpIcE=
=ooer
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
