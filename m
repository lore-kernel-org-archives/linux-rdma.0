From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH for-next 20/20] IB/hns: Delete the redundant lines in
 hns_roce_v1_m_qp()
Date: Tue, 20 Sep 2016 16:57:52 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A724B0E@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-21-git-send-email-salil.mehta@huawei.com>
 <20160915101529.GY26069@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915101529.GY26069@leon.nu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "Huwei (Xavier)" <xavier.huwei@huawei.com>, oulijun <oulijun@huawei.com>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "xuwei (O)" <xuwei5@hisilicon.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Leon Romanovsky
> Sent: Thursday, September 15, 2016 11:15 AM
> To: Salil Mehta
> Cc: dledford@redhat.com; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk@gmail.com; linux-rdma@vger.kernel.org;
> linux-kernel@vger.kernel.org; Linuxarm
> Subject: Re: [PATCH for-next 20/20] IB/hns: Delete the redundant lines
> in hns_roce_v1_m_qp()
> 
> On Fri, Sep 09, 2016 at 06:30:51PM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun@huawei.com>
> >
> > It doesn't need to assign for the filed of qp state in qpc separately
> > when qp happen to migrate state which supported in RoCE engine v1.
> >
> > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > index 7a61d7e..3bc32fc 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > @@ -2405,11 +2405,6 @@ static int hns_roce_v1_m_qp(struct ib_qp
> *ibqp, const struct ib_qp_attr *attr,
> >  		roce_set_bit(context->qpc_bytes_140,
> >  			     QP_CONTEXT_QPC_BYTES_140_RNR_RETRY_FLG_S, 0);
> >
> > -		roce_set_field(context->qpc_bytes_144,
> > -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
> > -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
> > -			       attr->qp_state);
> > -
> >  		roce_set_field(context->qpc_bytes_148,
> >  			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_M,
> >  			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_S, 0);
> > @@ -2524,13 +2519,10 @@ static int hns_roce_v1_m_qp(struct ib_qp
> *ibqp, const struct ib_qp_attr *attr,
> >  		   (cur_state == IB_QPS_RTS && new_state == IB_QPS_ERR) ||
> >  		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_RESET)
> ||
> >  		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_ERR)) {
> > -		roce_set_field(context->qpc_bytes_144,
> > -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
> > -			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
> > -			       attr->qp_state);
> > -
> > +		/* It will not do additional options in engine v1 */
> > +		;
> 
> It will leave empty if() {..}, it is worth to rewrite to have one if
> for
> error path only.
Agreed & changed in patch v2!

Thanks
Salil
> 
> >  	} else {
> > -		dev_err(dev, "not support this modify\n");
> > +		dev_err(dev, "not support this status migration\n");
> >  		goto out;
> >  	}
> >
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
