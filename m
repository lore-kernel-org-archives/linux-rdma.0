From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] RDMA/hns: Set the guid for hip08 RoCE
 device
Date: Wed, 10 Jan 2018 12:29:02 +0200
Message-ID: <20180110102902.GI7368@mtr-leonro.local>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
 <1515566393-63888-8-git-send-email-oulijun@huawei.com>
 <20180110064937.GE7368@mtr-leonro.local>
 <f2c33ef8-2457-bccc-e6ac-80711ccec25f@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f2c33ef8-2457-bccc-e6ac-80711ccec25f-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 10, 2018 at 05:23:41PM +0800, oulijun wrote:
> =E5=9C=A8 2018/1/10 14:49, Leon Romanovsky =E5=86=99=E9=81=93:
> > On Wed, Jan 10, 2018 at 02:39:53PM +0800, Lijun Ou wrote:
> >> This patch assgin a guid(Global Unique identifer)
> >> value to the hip08 device.
> >>
> >> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> ---
> >> V2:
> >> - Use the correct way to update guid from Leon
> >>   Romanovsky's review.
> >>
> >> V1:
> >> - The initial submit
> >> ---
> >>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infi=
niband/hw/hns/hns_roce_hw_v2.c
> >> index a1839a3..2af4948 100644
> >> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> >> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> >> @@ -34,6 +34,7 @@
> >>  #include <linux/etherdevice.h>
> >>  #include <linux/interrupt.h>
> >>  #include <linux/kernel.h>
> >> +#include <net/addrconf.h>
> >>  #include <rdma/ib_umem.h>
> >>
> >>  #include "hnae3.h"
> >> @@ -4679,6 +4680,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roc=
e_dev *hr_dev,
> >>  	hr_dev->iboe.netdevs[0] =3D handle->rinfo.netdev;
> >>  	hr_dev->iboe.phy_port[0] =3D 0;
> >>
> >> +	addrconf_addr_eui48((u8 *)&hr_dev->ib_dev.node_guid,
> >> +			    hr_dev->iboe.netdevs[0]->dev_addr);
> >> +
> >
> > Are you sure that it is right thing to do?
> >
> > ib_dev.node_guid is __be64 and you cast it for u8.
> >
> > Maybe, it is right, but I don't have ability to test it now.
> >
> > Thanks
> Yes, it can be get rightly. I have test it again
> The test result as follows:
>
> root@(none)# cat /sys/class/infiniband/hns_0/node_guid
> 5816:89ff:fe28:a34b
>
> Besides, I confirm the orign definition for addrconf_addr_eui48, it defin=
ed as follows:
> static inline void addrconf_addr_eui48(u8 *eui, const char *const addr)
> {
> 	addrconf_addr_eui48_base(eui, addr);
> 	eui[0] ^=3D 2;
> }
>
> The first input parameter type is u8 * and the patch [v4] {net,IB}/{rxe,u=
snic}: Utilize generic mac to eui32 function
> have the same usage.

Indeed the first parameter is u8, but you are converting from __be64 to be =
u8.

Thanks

>
> Thanks
> Lijun Ou
>
> >
> >>  	for (i =3D 0; i < HNS_ROCE_V2_MAX_IRQ_NUM; i++)
> >>  		hr_dev->irq[i] =3D pci_irq_vector(handle->pdev,
> >>  						i + handle->rinfo.base_vector);
> >> --
> >> 1.9.1
> >>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpV6u0ACgkQ5GN7iDZy
WKcflBAAo8waMyKtU3zaReTejp9zL/b9geokYcGclNRpsHT1n18OsIWrmz8T+OQ5
a8xhjpmy/DYKCZKybWnvX6mAkOEBu0GCR7tjXmyxOQiz7fpRGRSeYYphhBovjc2h
QBZqqX2mnyWE4N+A+IPqCXbN9Phtek3c7SXTH1p0VaPQDHLK0YKmjgvvGfo+PHGG
EWtYKOVvmL8UqHNISGwvRFLUIsYzuMSuEzdVYMkY8dp5hLd6UXso8cTmn1tO2p0V
sgqmt10ukURxByeQlPJgjbP1KpWwLfEcjHM6UU7voUumF8BmWW2h8VApRZsBYrpO
+JQIMmsKG7Omcz59585PwAywRLtNzazuf2sxpRmMmWPq2//Vv1Y2PPsXaIzDdYWD
4UD+T9+R55r1B+WtBuGxRvs1NLEAA32FRTIkv0CVlnaXLqYWx8W/40BJlImqJgC/
OHBjkye65rxRxnv2kRSTJTsqNBEw6dyAPKK+JtKVL5TP1m7hbqqBs8fmkHmDcJPo
ZRgGeDKZZnV5Q/y5FshxH9X+Y6USprJOT+JN9JOOlwFU+Pv8yXxkpGySYL4YbFqE
bZaxpuwQcGnMg8ZzzpnejgeZGQh+p3Si6KsywukuIFtseEN5Rskc8Z5QAEUDgSPr
AiZUEl462P5JhiHIZY/TFjiNNQ2XV7OkLx1IGeD4U88FZyyktGQ=
=PyFq
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
