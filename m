From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 02/10] IB/hns: Register add_gid and del_gid for
 GID Table management
Date: Tue, 13 Sep 2016 03:27:53 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A714961@lhreml503-mbx>
References: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
 <1472765845-118972-3-git-send-email-salil.mehta@huawei.com>
 <20160912124010.GI8812@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160912124010.GI8812-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huwei (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Monday, September 12, 2016 1:40 PM
> To: Salil Mehta
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> Subject: Re: [PATCH for-next 02/10] IB/hns: Register add_gid and
> del_gid for GID Table management
> 
> On Fri, Sep 02, 2016 at 05:37:17AM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >
> > This patch adds support of add_gid() and del_gid() function in the
> > HNS RoCE driver for manipulation of the GID table associated with
> > port. This shall be used be used by CM when connection is
> > established.
> >
> > Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_main.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c
> b/drivers/infiniband/hw/hns/hns_roce_main.c
> > index 39e69c3..4e93120 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> > @@ -158,6 +158,19 @@ static void hns_roce_update_gids(struct
> hns_roce_dev *hr_dev, int port)
> >  	ib_dispatch_event(&event);
> >  }
> >
> > +static int hns_roce_add_gid(struct ib_device *device, u8 port_num,
> > +			    unsigned int index, const union ib_gid *gid,
> > +			    const struct ib_gid_attr *attr, void **context)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int hns_roce_del_gid(struct ib_device *device, u8 port_num,
> > +			    unsigned int index, void **context)
> > +{
> > +	return 0;
> > +}
> 
> This patch makes no sense to me. It is the same as not write this
> functions at all.
I think you are correct. Will remove this patch.  

Thanks
Salil
> 
> > +
> >  static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
> >  			   unsigned long event)
> >  {
> > @@ -639,6 +652,8 @@ static int hns_roce_register_device(struct
> hns_roce_dev *hr_dev)
> >  	ib_dev->get_link_layer		= hns_roce_get_link_layer;
> >  	ib_dev->get_netdev		= hns_roce_get_netdev;
> >  	ib_dev->query_gid		= hns_roce_query_gid;
> > +	ib_dev->add_gid			= hns_roce_add_gid;
> > +	ib_dev->del_gid			= hns_roce_del_gid;
> >  	ib_dev->query_pkey		= hns_roce_query_pkey;
> >  	ib_dev->alloc_ucontext		= hns_roce_alloc_ucontext;
> >  	ib_dev->dealloc_ucontext	= hns_roce_dealloc_ucontext;
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
