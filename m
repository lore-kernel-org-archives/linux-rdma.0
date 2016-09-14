From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 16/20] IB/hns: Validate mtu when modified qp
Date: Wed, 14 Sep 2016 02:07:27 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A716DDE@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-17-git-send-email-salil.mehta@huawei.com>
 <20160913063240.GO8812@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160913063240.GO8812-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huwei (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xuwei (O)" <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "chenguolong (A)" <luck.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Tuesday, September 13, 2016 7:33 AM
> To: Salil Mehta
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm; chenguolong (A)
> Subject: Re: [PATCH for-next 16/20] IB/hns: Validate mtu when modified
> qp
> 
> On Fri, Sep 09, 2016 at 06:30:47PM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >
> > The mtu should be validated when modify qp,so we check it.
> >
> > Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Peter Chen <luck.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_qp.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c
> b/drivers/infiniband/hw/hns/hns_roce_qp.c
> > index 51fefbf..1c5be59 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_qp.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
> > @@ -32,6 +32,7 @@
> >   */
> >
> >  #include <linux/platform_device.h>
> > +#include <rdma/ib_addr.h>
> >  #include <rdma/ib_umem.h>
> >  #include "hns_roce_common.h"
> >  #include "hns_roce_device.h"
> > @@ -658,6 +659,7 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct
> ib_qp_attr *attr,
> >  	struct device *dev = &hr_dev->pdev->dev;
> >  	int ret = -EINVAL;
> >  	int p;
> > +	u32 active_mtu = 0;
> 
> There is no need to assign value to a variable which will be
> overwritten.
Agreed. This initialization seems redundant. Will remove. Thanks!

Best regards
Salil
> 
> >
> >  	mutex_lock(&hr_qp->mutex);
> >
> > @@ -688,6 +690,19 @@ int hns_roce_modify_qp(struct ib_qp *ibqp,
> struct ib_qp_attr *attr,
> >  		}
> >  	}
> >
> > +	if (attr_mask & IB_QP_PATH_MTU) {
> > +		p = attr_mask & IB_QP_PORT ? (attr->port_num - 1) : hr_qp-
> >port;
> > +		active_mtu = iboe_get_mtu(hr_dev->iboe.netdevs[p]->mtu);
> 
> ib_mtu iboe_get_mtu returns "enum ib_mtu" and not u32.
Ok. This can be converted to 'enum'. Will change. Thanks!

Best regards
Salil 
> 
> > +
> > +		if (attr->path_mtu > IB_MTU_2048 ||
> > +		    attr->path_mtu < IB_MTU_256 ||
> > +		    attr->path_mtu > active_mtu) {
> > +			dev_err(dev, "attr path_mtu(%d)invalid while modify
> qp",
> > +				attr->path_mtu);
> > +			goto out;
> > +		}
> > +	}
> > +
> >  	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
> >  	    attr->max_rd_atomic > hr_dev->caps.max_qp_init_rdma) {
> >  		dev_err(dev, "attr max_rd_atomic invalid.attr-
> >max_rd_atomic=%d\n",
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
