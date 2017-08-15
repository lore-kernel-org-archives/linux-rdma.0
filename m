From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 13/22] RDMA/hns: Remove empty functions
Date: Tue, 15 Aug 2017 08:35:52 +0300
Message-ID: <20170815053552.GK24282@mtr-leonro.local>
References: <20170813101816.3120-1-leon@kernel.org>
 <20170813101816.3120-14-leon@kernel.org>
 <9e60e6ca-4eae-1e83-7e24-4c0609dfb7bc@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O2g7+miYGsIKoR9l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9e60e6ca-4eae-1e83-7e24-4c0609dfb7bc-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Chenxin (Charles)" <charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, huwei <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Xushaobo (Elliott)" <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, weihaifeng <haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, huangdaode <huangdaode-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--O2g7+miYGsIKoR9l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 15, 2017 at 11:32:02AM +0800, oulijun wrote:
> =E5=9C=A8 2017/8/13 18:18, Leon Romanovsky =E5=86=99=E9=81=93:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The functions which are not implemented can be simply ignored
> > instead of defining empty function. This patch removes such functions
> > from hns driver.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_main.c | 14 --------------
> >  1 file changed, 14 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infini=
band/hw/hns/hns_roce_main.c
> > index d9777b662eba..250e2059ef07 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> > @@ -285,12 +285,6 @@ static enum rdma_link_layer hns_roce_get_link_laye=
r(struct ib_device *device,
> >  	return IB_LINK_LAYER_ETHERNET;
> >  }
> >
> > -static int hns_roce_query_gid(struct ib_device *ib_dev, u8 port_num, i=
nt index,
> > -			      union ib_gid *gid)
> > -{
> > -	return 0;
> > -}
> > -
> >  static int hns_roce_query_pkey(struct ib_device *ib_dev, u8 port, u16 =
index,
> >  			       u16 *pkey)
> >  {
> > @@ -316,12 +310,6 @@ static int hns_roce_modify_device(struct ib_device=
 *ib_dev, int mask,
> >  	return 0;
> >  }
> >
> > -static int hns_roce_modify_port(struct ib_device *ib_dev, u8 port_num,=
 int mask,
> > -				struct ib_port_modify *props)
> > -{
> > -	return 0;
> > -}
> > -
> >  static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *i=
b_dev,
> >  						   struct ib_udata *udata)
> >  {
> > @@ -462,10 +450,8 @@ static int hns_roce_register_device(struct hns_roc=
e_dev *hr_dev)
> >  	ib_dev->modify_device		=3D hns_roce_modify_device;
> >  	ib_dev->query_device		=3D hns_roce_query_device;
> >  	ib_dev->query_port		=3D hns_roce_query_port;
> > -	ib_dev->modify_port		=3D hns_roce_modify_port;
> >  	ib_dev->get_link_layer		=3D hns_roce_get_link_layer;
> >  	ib_dev->get_netdev		=3D hns_roce_get_netdev;
> > -	ib_dev->query_gid		=3D hns_roce_query_gid;
> >  	ib_dev->add_gid			=3D hns_roce_add_gid;
> >  	ib_dev->del_gid			=3D hns_roce_del_gid;
> >  	ib_dev->query_pkey		=3D hns_roce_query_pkey;
>
> Hi, Leon
>
>     I have test this patch on D05 board used 4.13 rc-0 kernel and the dri=
ver load fail.
>
> The log as follows:
>
> [   31.858931] sdhci: Secure Digital Host Controller Interface driver
> [   31.865179] sdhci: Copyright(c) Pierre Ossman
> [   31.869631] Synopsys Designware Multimedia Card Interface Driver
> [   31.875819] sdhci-pltfm: SDHCI platform and OF driver helper
> [   31.882683] ledtrig-cpu: registered to indicate activity on CPUs
> [   31.976315] Device hns_0 is missing mandatory function query_gid
> [   31.982436] hns_roce HISI00D1:00: ib_register_device failed!
> [   31.989561] usbcore: registered new interface driver usbhid
> [   31.995249] usbhid: USB HID core driver
> [   32.000197] NET: Registered protocol family 10
> [   32.005730] Segment Routing with IPv6
> [   32.009490] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [   32.015734] NET: Registered protocol family 17
>
>
> From the above log, I have analysed the quetion.  Firstly, I think that t=
he query_gid function is not
>
> be called and used because the IB core has do it.  However,  I think that=
 it should be reserved it
>
> and direct return because it need check the device's mandatory. The inter=
face implemented
>
> as follows:
>
> static int ib_device_check_mandatory(struct ib_device *device)
> {
> #define IB_MANDATORY_FUNC(x) { offsetof(struct ib_device, x), #x }
>     static const struct {
>         size_t offset;
>         char  *name;
>     } mandatory_table[] =3D {
>         IB_MANDATORY_FUNC(query_device),
>         IB_MANDATORY_FUNC(query_port),
>         IB_MANDATORY_FUNC(query_pkey),
>         IB_MANDATORY_FUNC(query_gid),
>         IB_MANDATORY_FUNC(alloc_pd),
>         IB_MANDATORY_FUNC(dealloc_pd),
>         IB_MANDATORY_FUNC(create_ah),
>         IB_MANDATORY_FUNC(destroy_ah),
>         IB_MANDATORY_FUNC(create_qp),
>         IB_MANDATORY_FUNC(modify_qp),
>         IB_MANDATORY_FUNC(destroy_qp),
>         IB_MANDATORY_FUNC(post_send),
>         IB_MANDATORY_FUNC(post_recv),
>         IB_MANDATORY_FUNC(create_cq),
>         IB_MANDATORY_FUNC(destroy_cq),
>         IB_MANDATORY_FUNC(poll_cq),
>         IB_MANDATORY_FUNC(req_notify_cq),
>         IB_MANDATORY_FUNC(get_dma_mr),
>         IB_MANDATORY_FUNC(dereg_mr),
>         IB_MANDATORY_FUNC(get_port_immutable)
>     };
>     int i;
>
>     for (i =3D 0; i < ARRAY_SIZE(mandatory_table); ++i) {
>         if (!*(void **) ((void *) device + mandatory_table[i].offset)) {
>             pr_warn("Device %s is missing mandatory function %s\n",
>                 device->name, mandatory_table[i].name);
>             return -EINVAL;
>         }
>     }
>
>     return 0;
> }
>
> In conclusion, I think that this patch may result in a bug for hns_roce d=
river.  Are your  suggestion?
>

The patch below can resolve your failure, but the warning will be fired
anyway, which is not clean as I would like to see.

[   31.976315] Device hns_0 is missing mandatory function query_gid

To look after solution, I compared the "InfiniBand Architecture Release 1.3"
and A"nnex A (RoCE)" and it looks like the query_gid is mandatory in IB (pa=
rt of
query HCA) and isn't required for RoCE.

I have prototype code to move RDMA core to use static ndo type of
initialization per supported mode (iWARP, RoCE, IB) instead of dynamic
assignments as it is done now, but unfortunately it is not ready for
prime time yet.

In the meantime, I'll drop this patch.

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/dev=
ice.c
index 475b93d62748..878760a858db 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -853,7 +853,10 @@ int ib_query_gid(struct ib_device *device,
 	if (attr)
 		return -EINVAL;

-	return device->query_gid(device, port_num, index, gid);
+	if (device->query_gid)
+		return device->query_gid(device, port_num, index, gid);
+
+	return 0;
 }
 EXPORT_SYMBOL(ib_query_gid);

Thank you for your excellent analysis and your report.

>
> Thanks
>
> Lijun Ou
>
>


--O2g7+miYGsIKoR9l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmSiDgACgkQ5GN7iDZy
WKfWzA/9Hb0T3GgYiWJh5SEnEfIXUgUw+b47hULcc3ix5rslY5fbv4QhO8GPBKPG
fNYat+2wQ+BccHP7IlO8i6Yc38pBDAh+t1Qi4qmNEbQ/S6SCUNTpMS9QlNce5MX8
0aKCrBvgLA/w7Fnh0vZRBJvjPxRQmll8vHYpsVNhua7bfeWZ2HxZRt1CrKvXMFSb
mb4crqlkgsXdlrYrd2i/XXPsFuBHQCICr/chJ0XtBJaXFH+BJKNU/ARbXKPmlPgR
zH4kb3bOHbCxAQL+IR56HnaULdaOQW8qupsGD/BvJc44xM3jsHdypPNAl4R7NI2I
eRnJWFHxaK/epHM8LLe/6fGOX/eN8jit6CvvwUxG+71Pw1tWgoxaxjkWSm8WM/60
DpBnmH/aiH6Fw+PAP0Po3UHhrIzH+AJOcvoakEvfFg7sTS7hMbYmT7mXfZXrEHmS
aMyE1OhVU6lqyCXgWF15A2IWGF6uVRbl/s39LP7o1T7IPS49jgBlneAJeGI+tpxd
CF0Rk58uOW55Zwaps6CO8aCj8o1JchaK86MyCOtUDLfWoYOYPJ/tFdkJ9ZokeK8S
bbcBisgE4j5vOgL15Q3JR7q2Bq6phf6c9h4YtvDYluZphq18Y4fx12WsrmXDQDc8
QqHFazjcsyUur318ZVJ8K2s8Gsb87XlP48BYQ0e4RDTjofjXX1A=
=ERa8
-----END PGP SIGNATURE-----

--O2g7+miYGsIKoR9l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
