From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] RDMA/hns: Set the guid for hip08 RoCE
 device
Date: Wed, 10 Jan 2018 22:31:02 -0700
Message-ID: <20180111053102.GC16668@ziepe.ca>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
 <1515566393-63888-8-git-send-email-oulijun@huawei.com>
 <20180110064937.GE7368@mtr-leonro.local>
 <f2c33ef8-2457-bccc-e6ac-80711ccec25f@huawei.com>
 <20180110102902.GI7368@mtr-leonro.local>
 <71771a6a-ef08-1750-69c3-f2fca8294751@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <71771a6a-ef08-1750-69c3-f2fca8294751-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 10:49:57AM +0800, oulijun wrote:
> >>>> @@ -4679,6 +4680,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
> >>>>  	hr_dev->iboe.netdevs[0] = handle->rinfo.netdev;
> >>>>  	hr_dev->iboe.phy_port[0] = 0;
> >>>>
> >>>> +	addrconf_addr_eui48((u8 *)&hr_dev->ib_dev.node_guid,
> >>>> +			    hr_dev->iboe.netdevs[0]->dev_addr);
> >>>> +
> >>>
> >>> Are you sure that it is right thing to do?
> >>>
> >>> ib_dev.node_guid is __be64 and you cast it for u8.
> >>>
> >>> Maybe, it is right, but I don't have ability to test it now.
> >>>
> >>> Thanks
> >> Yes, it can be get rightly. I have test it again
> >> The test result as follows:
> >>
> >> root@(none)# cat /sys/class/infiniband/hns_0/node_guid
> >> 5816:89ff:fe28:a34b
> >>
> >> Besides, I confirm the orign definition for addrconf_addr_eui48, it defined as follows:
> >> static inline void addrconf_addr_eui48(u8 *eui, const char *const addr)
> >> {
> >> 	addrconf_addr_eui48_base(eui, addr);
> >> 	eui[0] ^= 2;
> >> }
> >>
> >> The first input parameter type is u8 * and the patch [v4] {net,IB}/{rxe,usnic}: Utilize generic mac to eui32 function
> >> have the same usage.
> > 
> > Indeed the first parameter is u8, but you are converting from __be64 to be u8.
> > 
> > Thanks
> > 
> Yes, the type of node_guid is defined by ib core. the function of addrconf_addr_eui48 is also
> defined by ib core. I could not modify them. Did I need to change u8 to unsigned char?

Actually, now that I look more closely, what you have is right.

It is just a very strange and misleading name of a function
'addrconf_addr_eui48' which takes in an eui48 and writes out a IB
GUID. Would have expected 'addrconf_ib_guid_eui48' or something..

Even more confusing because the commit message talks about eui32 and
misses a signed-off-by? Baffling.

.. and there are dragons here, because the IPv6 interface id (eg what
the similar addrconf_ifid_eui48 is handling) uses an inverted U/L bit
to the IEEE EUI-64.

.. and I can't quite recall what the IBTA eventually settled on as the
standard for IB - if it was EUI-64 or modified IPv6 EUI-64 ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
