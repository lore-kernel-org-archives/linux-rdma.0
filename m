From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 18/20] IB/hns: Update the rq head when modify
 qp state
Date: Tue, 20 Sep 2016 17:49:14 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A724BF6@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-19-git-send-email-salil.mehta@huawei.com>
 <20160915101246.GX26069@leon.nu>
 <F4CC6FACFEB3C54C9141D49AD221F7F91A724AFE@lhreml503-mbx>
 <20160920170553.GU26673@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920170553.GU26673-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huwei (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xuwei (O)" <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Tuesday, September 20, 2016 6:06 PM
> To: Salil Mehta
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> Subject: Re: [PATCH for-next 18/20] IB/hns: Update the rq head when
> modify qp state
> 
> On Tue, Sep 20, 2016 at 04:56:35PM +0000, Salil Mehta wrote:
> >
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > > Sent: Thursday, September 15, 2016 11:13 AM
> > > To: Salil Mehta
> > > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Huwei (Xavier); oulijun; Zhuangyuzeng
> (Yisen);
> > > xuwei (O); mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> > > Subject: Re: [PATCH for-next 18/20] IB/hns: Update the rq head when
> > > modify qp state
> > >
> > > On Fri, Sep 09, 2016 at 06:30:49PM +0800, Salil Mehta wrote:
> > > > From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > >
> > > > The rq head in qpc was zero will miss the rq wqes which
> > > > have be sent, so here we should take the real value.
> > > >
> > > > Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > > index bdd9453..7a61d7e 100644
> > > > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > > > @@ -2266,7 +2266,8 @@ static int hns_roce_v1_m_qp(struct ib_qp
> *ibqp,
> > > const struct ib_qp_attr *attr,
> > > >
> > > >  		roce_set_field(context->qpc_bytes_68,
> > > >  			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_M,
> > > > -			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S, 0);
> > > > +			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S,
> > > > +			       hr_qp->rq.head);
> > >
> > > Are you sure that it should be list_head and not value?
> > This is correct. Variable head is not list_head but a u32 value.
> > Hope I understood your point correctly.
> 
> Thanks, you understood me right.
> The name "head" mislead me.
> Sorry for that.
No worries at all :)

Thanks
Salil
> 
> >
> > Best regards
> > Salil
> > >
> > > >  		roce_set_field(context->qpc_bytes_68,
> > > >  			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_M,
> > > >  			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_S,
> 0);
> > > > --
> > > > 1.7.9.5
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-
> rdma"
> > > in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-
> info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
