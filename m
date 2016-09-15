From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH for-next 13/20] IB/hns: Add check for some NULL pointer
 scenes
Date: Thu, 15 Sep 2016 03:41:30 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A719A2B@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-14-git-send-email-salil.mehta@huawei.com>
 <20160913065937.GS8812@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913065937.GS8812@leon.nu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "Huwei (Xavier)" <xavier.huwei@huawei.com>, oulijun <oulijun@huawei.com>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "xuwei (O)" <xuwei5@hisilicon.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "Huangdongdong (Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Leon Romanovsky
> Sent: Tuesday, September 13, 2016 8:00 AM
> To: Salil Mehta
> Cc: dledford@redhat.com; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk@gmail.com; linux-rdma@vger.kernel.org;
> linux-kernel@vger.kernel.org; Linuxarm; Huangdongdong (Donald)
> Subject: Re: [PATCH for-next 13/20] IB/hns: Add check for some NULL
> pointer scenes
> 
> On Fri, Sep 09, 2016 at 06:30:44PM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun@huawei.com>
> >
> > Some pointers have not be checked when they are null,
> > so we add check for them.
> >
> > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
> > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> 
> I may admit that I didn't check your code to read the implementations
> of
> get_send_wqe() and hns_roce_v1_poll_one(), but based on my assumption
> that the code is similar to mlx4.
> 
> These failures can't occur.
> 
> Can you throw a light on how did you find them and check it?
Hi Leon,
Looks like this is another redundant patch. These return checks should
never be required. I think the mistake lies in the wrong check placed
inside below function:

void *get_send_wqe(struct hns_roce_qp *hr_qp, int n)
{
.................................................
.................................................
/* To Be Deleted: Below check is redundantly placed. */
	if ((n < 0) || (n > hr_qp->sq.wqe_cnt)) {
		dev_err(&hr_dev->pdev->dev, "sq wqe index:%d,sq wqe cnt:%d\r\n",
			n, hr_qp->sq.wqe_cnt);
		return NULL;
	}

	return get_wqe(hr_qp, hr_qp->sq.offset + (n << hr_qp->sq.wqe_shift));
}

and perhaps same is the case in function get_rcv_wqe(). The same check needs
to be removed from there as well and also the error handling in the calling
functions. Thanks for figuring it out. Will correct in the subsequent patch.

Best regards
Salil 
> 
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > index f0d6315..e3e154c 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > @@ -92,6 +92,12 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp,
> struct ib_send_wr *wr,
> >  		}
> >
> >  		wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
> > +		if (unlikely(!wqe)) {
> > +			dev_err(dev, "get send wqe failed\n");
> > +			ret = -EINVAL;
> > +			*bad_wr = wr;
> > +			goto out;
> > +		}
> >  		qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
> >  								      wr->wr_id;
> >
> > @@ -1558,6 +1564,11 @@ static int hns_roce_v1_poll_one(struct
> hns_roce_cq *hr_cq,
> >  		sq_wqe = get_send_wqe(*cur_qp, roce_get_field(cqe-
> >cqe_byte_4,
> >  						CQE_BYTE_4_WQE_INDEX_M,
> >  						CQE_BYTE_4_WQE_INDEX_S));
> > +		if (unlikely(!sq_wqe)) {
> > +			dev_err(dev, "Get send wqe failed!\n");
> > +			return -EFAULT;
> > +		}
> > +
> >  		switch (sq_wqe->flag & HNS_ROCE_WQE_OPCODE_MASK) {
> >  		case HNS_ROCE_WQE_OPCODE_SEND:
> >  			wc->opcode = IB_WC_SEND;
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
