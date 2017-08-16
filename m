From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH][V2] IB/hns: fix memory leak on ah on error return path
Date: Wed, 16 Aug 2017 11:31:17 -0400
Message-ID: <1502897477.33760.11.camel@redhat.com>
References: <20170808174102.28568-1-colin.king@canonical.com>
         <52e486f3-4cca-d31c-812e-4027d98b867b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52e486f3-4cca-d31c-812e-4027d98b867b@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun <oulijun@huawei.com>, Colin King <colin.king@canonical.com>, Wei Hu <xavier.huwei@huawei.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-08-11 at 09:45 +0800, oulijun wrote:
> 在 2017/8/9 1:41, Colin King 写道:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > When dmac is NULL, ah is not being freed on the error return path.
> > Fix
> > this by kfree'ing it.
> > 
> > Detected by CoverityScan, CID#1452636 ("Resource Leak")
> > 
> > Fixes: d8966fcd4c25 ("IB/core: Use rdma_ah_attr accessor
> > functions")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/infiniband/hw/hns/hns_roce_ah.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c
> > b/drivers/infiniband/hw/hns/hns_roce_ah.c
> > index f78a733a63ec..d545302b8ef8 100644
> > --- a/drivers/infiniband/hw/hns/hns_roce_ah.c
> > +++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
> > @@ -64,8 +64,10 @@ struct ib_ah *hns_roce_create_ah(struct ib_pd
> > *ibpd,
> >  	} else {
> >  		u8 *dmac = rdma_ah_retrieve_dmac(ah_attr);
> >  
> > -		if (!dmac)
> > +		if (!dmac) {
> > +			kfree(ah);
> >  			return ERR_PTR(-EINVAL);
> > +		}
> >  		memcpy(ah->av.mac, dmac, ETH_ALEN);
> >  	}
> >  
> 
> Thank you for reviewing and fixing

Thanks, patch applied to -rc.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
