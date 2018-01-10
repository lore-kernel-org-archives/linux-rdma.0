From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] RDMA/hns: Set the guid for hip08 RoCE
 device
Date: Wed, 10 Jan 2018 14:01:26 -0700
Message-ID: <20180110210126.GM4518@ziepe.ca>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
 <1515566393-63888-8-git-send-email-oulijun@huawei.com>
 <20180110064937.GE7368@mtr-leonro.local>
 <f2c33ef8-2457-bccc-e6ac-80711ccec25f@huawei.com>
 <20180110102902.GI7368@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180110102902.GI7368-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 12:29:02PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 10, 2018 at 05:23:41PM +0800, oulijun wrote:
> > 在 2018/1/10 14:49, Leon Romanovsky 写道:
> > > On Wed, Jan 10, 2018 at 02:39:53PM +0800, Lijun Ou wrote:
> > >> This patch assgin a guid(Global Unique identifer)
> > >> value to the hip08 device.
> > >>
> > >> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > >> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > >> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > >> V2:
> > >> - Use the correct way to update guid from Leon
> > >>   Romanovsky's review.
> > >>
> > >> V1:
> > >> - The initial submit
> > >>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
> > >>  1 file changed, 4 insertions(+)
> > >>
> > >> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> > >> index a1839a3..2af4948 100644
> > >> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> > >> @@ -34,6 +34,7 @@
> > >>  #include <linux/etherdevice.h>
> > >>  #include <linux/interrupt.h>
> > >>  #include <linux/kernel.h>
> > >> +#include <net/addrconf.h>
> > >>  #include <rdma/ib_umem.h>
> > >>
> > >>  #include "hnae3.h"
> > >> @@ -4679,6 +4680,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
> > >>  	hr_dev->iboe.netdevs[0] = handle->rinfo.netdev;
> > >>  	hr_dev->iboe.phy_port[0] = 0;
> > >>
> > >> +	addrconf_addr_eui48((u8 *)&hr_dev->ib_dev.node_guid,
> > >> +			    hr_dev->iboe.netdevs[0]->dev_addr);
> > >> +
> > >
> > > Are you sure that it is right thing to do?
> > >
> > > ib_dev.node_guid is __be64 and you cast it for u8.
> > >
> > > Maybe, it is right, but I don't have ability to test it now.
> > >
> > > Thanks
> > Yes, it can be get rightly. I have test it again
> > The test result as follows:
> >
> > root@(none)# cat /sys/class/infiniband/hns_0/node_guid
> > 5816:89ff:fe28:a34b
> >
> > Besides, I confirm the orign definition for addrconf_addr_eui48, it defined as follows:
> > static inline void addrconf_addr_eui48(u8 *eui, const char *const addr)
> > {
> > 	addrconf_addr_eui48_base(eui, addr);
> > 	eui[0] ^= 2;
> > }
> >
> > The first input parameter type is u8 * and the patch [v4] {net,IB}/{rxe,usnic}: Utilize generic mac to eui32 function
> > have the same usage.
> 
> Indeed the first parameter is u8, but you are converting from __be64 to be u8.

addrconf_addr_eui48 accepts an array of 6 u8's in big endian byte
order representing the MAC.

If you use a be64 to hold the MAC then it must be unnaturally shifted
<< 16, eg

htobe64(0x1234 << 16);

Will work to set the mac to 00:00:00:00:12:34

So, it is really weird to store a mac in a __be64, but it can be done
correctly...

The *really* sketchy thing is pssing something called the node_guid to
something accepting a eui48. The node_guid is an eui64, and needs
translation before it can become an eui48, so *something* is wrong and
broken here.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
