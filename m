From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH for-next 12/20] IB/hns: Return bad wr while post send
 failed
Date: Tue, 20 Sep 2016 16:46:39 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A723617@lhreml503-mbx>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-13-git-send-email-salil.mehta@huawei.com>
 <20160915090742.GV26069@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915090742.GV26069@leon.nu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "Huwei (Xavier)" <xavier.huwei@huawei.com>, oulijun <oulijun@huawei.com>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "xuwei (O)" <xuwei5@hisilicon.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "Huangdongdong (Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Thursday, September 15, 2016 10:08 AM
> To: Salil Mehta
> Cc: dledford@redhat.com; Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> xuwei (O); mehta.salil.lnk@gmail.com; linux-rdma@vger.kernel.org;
> linux-kernel@vger.kernel.org; Linuxarm; Huangdongdong (Donald)
> Subject: Re: [PATCH for-next 12/20] IB/hns: Return bad wr while post
> send failed
> 
> On Fri, Sep 09, 2016 at 06:30:43PM +0800, Salil Mehta wrote:
> > From: Lijun Ou <oulijun@huawei.com>
> >
> > While post failed, hns roce should return the wr failed to user.
> > We omitted this while qp type is wrong and fixed it.
> >
> > Signed-off-by: Lijun Ou <oulijun@huawei.com>
> > Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
> > Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > index f4d2515..f0d6315 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> > @@ -264,8 +264,10 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp,
> struct ib_send_wr *wr,
> >  			}
> >  			ind++;
> >  		} else {
> 
> You should move the check of supported QPs to the beginning of
> post_send
> and don't enter into the loop at all.
Hi Leon,
Agreed. I have made this change in floated V2 patch.

Thanks
Salil
> 
> > -			dev_dbg(dev, "unSupported QP type\n");
> > -			break;
> > +			dev_err(dev, "unSupported QP type\n");
> 
> During initial review of hns driver, Lijun was asked to canonize debug
> messages and don't use different styles and especially sUcH case.
Ok. I have corrected for this instance in V2 patch.

Thanks
Salil
> 
> > +			ret = -EOPNOTSUPP;
> > +			*bad_wr = wr;
> 
> IMHO, the proper thing is to return NULL, because this is not wrong wr.
Ok. Done this change as well.

Thanks
Salil
> 
> > +			goto out;
> >  		}
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
