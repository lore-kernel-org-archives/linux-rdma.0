From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH for-next 18/20] IB/hns: Update the rq head when modify
 qp state
Date: Tue, 20 Sep 2016 16:56:35 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A724AFE@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-19-git-send-email-salil.mehta@huawei.com>
 <20160915101246.GX26069@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915101246.GX26069@leon.nu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "Huwei (Xavier)" <xavier.huwei@huawei.com>, oulijun <oulijun@huawei.com>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "xuwei (O)" <xuwei5@hisilicon.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Thursday, September 15, 2016 11:13 AM
> To: Salil Mehta
> Cc: dledford@redhat.com; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk@gmail.com; linux-rdma@vger.kernel.org;
> linux-kernel@vger.kernel.org; Linuxarm
> Subject: Re: [PATCH for-next 18/20] IB/hns: Update the rq head when
> modify qp state
> 
> On Fri, Sep 09, 2016 at 06:30:49PM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun@huawei.com>
> >
> > The rq head in qpc was zero will miss the rq wqes which
> > have be sent, so here we should take the real value.
> >
> > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > index bdd9453..7a61d7e 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > @@ -2266,7 +2266,8 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp,
> const struct ib_qp_attr *attr,
> >
> >  		roce_set_field(context->qpc_bytes_68,
> >  			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_M,
> > -			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S, 0);
> > +			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S,
> > +			       hr_qp->rq.head);
> 
> Are you sure that it should be list_head and not value?
This is correct. Variable head is not list_head but a u32 value. 
Hope I understood your point correctly.

Best regards
Salil
> 
> >  		roce_set_field(context->qpc_bytes_68,
> >  			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_M,
> >  			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_S, 0);
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
