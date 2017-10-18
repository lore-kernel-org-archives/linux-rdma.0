From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/4] RDMA/hns: Add IOMMU enable support in hip08
Date: Wed, 18 Oct 2017 17:23:28 +0300
Message-ID: <20171018142328.GQ2106@mtr-leonro.local>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
 <1506763741-81429-3-git-send-email-xavier.huwei@huawei.com>
 <20170930161023.GI2965@mtr-leonro.local>
 <59E713EE.5040703@huawei.com>
 <59E71AE2.6080202@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QV9egoCq9O4JbpTr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59E71AE2.6080202-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lijun_nudt-9Onoh4P/yGk@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org, shaobo.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Chenxin (Charles)" <charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--QV9egoCq9O4JbpTr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 18, 2017 at 05:12:02PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2017/10/18 16:42, Wei Hu (Xavier) wrote:
> >
> >
> > On 2017/10/1 0:10, Leon Romanovsky wrote:
> > > On Sat, Sep 30, 2017 at 05:28:59PM +0800, Wei Hu (Xavier) wrote:
> > > > If the IOMMU is enabled, the length of sg obtained from
> > > > __iommu_map_sg_attrs is not 4kB. When the IOVA is set with the sg
> > > > dma address, the IOVA will not be page continuous. and the VA
> > > > returned from dma_alloc_coherent is a vmalloc address. However,
> > > > the VA obtained by the page_address is a discontinuous VA. Under
> > > > these circumstances, the IOVA should be calculated based on the
> > > > sg length, and record the VA returned from dma_alloc_coherent
> > > > in the struct of hem.
> > > >
> > > > Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > Doug,
> > >
> > > I didn't invest time in reviewing it, but having "is_vmalloc_addr" in
> > > driver code to deal with dma_alloc_coherent is most probably wrong.
> > >
> > > Thanks
> > >
> > Hi, Doug
> >     When running in ARM64 platform, there probably be calltrace
> > currently.
> >     Now our colleague will report it to iommu maillist and try to solve
> > it.
> >     I also think RoCE driver shouldn't sense the difference.
> >     I will pull it out of this series and send v2.
> >     Thanks.
> >
> Hi, Doug & Leon
>     I have sent patch v2.
>     Thanks
>

Thanks

--QV9egoCq9O4JbpTr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnnY+AACgkQ5GN7iDZy
WKelfhAAm2g/HrQIN9yp3IT4TPlrgMIbb8JSf3e2ewkLEzmPNb4+IWgQukawfCYo
KP9aOaynoHLxkePEjuu4jj5ufFdjMeZKjGBmW70u9F2WaMN3T/ix/xYZMs+xIr36
nrirQxoe38E+V1oNknAsz0I1YYb2HcbTlXOZ+fxE9jznrocKScZCyC0Ny4/LR16D
meyzfx21bQNReALUR1bjfbuw2zxIB6y+V3OkQoTdiKxh0RS+H1bK0m6r2AD6s6Ps
s4lPfdp8NqIyN97X+I9el4DSV6NFu3YKosMHEGMupQdLJBTsOjLoi95fncC1rpLj
T2V3eIt2hequaAtQUGWfG3tpfkNXxXGSbpMekQDkAHLmCsXXXhMKgmlDOw9IsuTc
eGJt2vbl89jyvS7c3PmKXj8rHtt3zXUs67i5lhBDRt2kx9XujEsErjSiIhwU+oCY
WnzGSqTP1N0qIxbCVOgK7m+39j5kg9/yS6hm8srIJUxuBneAqclA3kbimMQoP7Kg
dx5uw/pC0qP4E5rQNOvjJ67Wq/g5jQwQV0sdBWpU5onrUXNgxWgdAn1/KkBUY1JM
Yb4HFereHLQFHBc1F5AJoX4/s+6V2X9r99HD5BLPhEMO6aIh59F8RUrgvr0I8FkY
tqN6vFR1DvuylUptU5RWhB3kWsKUDGrGCx+t4n1/aKSj9U656Xc=
=2/sh
-----END PGP SIGNATURE-----

--QV9egoCq9O4JbpTr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
