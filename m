From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 09/20] IB/hns: Optimize code of aeq and ceq
 interrupt handle and fix the bug of qpn
Date: Mon, 12 Sep 2016 15:47:48 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A713973@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-10-git-send-email-salil.mehta@huawei.com>
 <20160912123255.GG8812@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160912123255.GG8812-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huwei (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xuwei (O)" <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Monday, September 12, 2016 1:33 PM
> To: Salil Mehta
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> Subject: Re: [PATCH for-next 09/20] IB/hns: Optimize code of aeq and
> ceq interrupt handle and fix the bug of qpn
> 
> On Fri, Sep 09, 2016 at 06:30:40PM +0800, Salil Mehta wrote:
> 
> ....
> 
> > +			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
> > +			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S);
> > +	phy_port = roce_get_field(aeqe->event.qp_event.qp,
> > +			HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_M,
> > +			HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_S);
> > +	if (qpn <= 1)
> > +		qpn = HNS_ROCE_MAX_PORTS * qpn + phy_port;
> > +
> > +	switch (event_type) {
> > +	case HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR:
> > +		dev_warn(dev, "Invalid Req Local Work Queue Error.\n");
> > +		dev_warn(dev, "QP %d, phy_port %d.\n", qpn, phy_port);
> 
> dev_warn like all other printk flavours supports multi-line messages.
Yes, agreed. This can be done using single dev_warn as well, like below:
dev_warn(dev,
         "Invalid Req Local Work Queue Error.\n"
         "QP %d, phy_port %d.\n", qpn, phy_port);

Will change and refloat the patch.

Thanks
Salil
> 
> > +		break;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
