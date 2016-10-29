From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Sat, 29 Oct 2016 09:16:25 +0800
Message-ID: <5813F869.7010606@huawei.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com> <5811776F.20908@huawei.com>
 <20161027145139.GD6818@obsidianresearch.com> <58130573.4010902@huawei.com>
 <20161028164030.GA17289@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161028164030.GA17289-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/10/29 0:40, Jason Gunthorpe 写道:
> On Fri, Oct 28, 2016 at 03:59:47PM +0800, oulijun wrote:
> 
>> total 0
>> lrwxrwxrwx    1 root     root             0 Oct 27 11:07 driver -> ../../../../bus/platform/drivers/hns_roce
>>
>> but I think it is the standard approach. because my device(hip06) is
>> only platform device and the other device(hip07/hip0x0 will be pcie
>> device, it will be distinguished separately.  Hence, we adpot the
>> origin approach.
> 
> You have to parse out 'hns_roce' at the end of the readlink result and
> compare against that, drop the 'bus/platform/drivers' stuff
> 
> Your PCI and Platform device should both have the same driver name.
> 
> Jason
> 
> .
> 
Hi, Jason
   I could not express clearly. We hope that the only copy of libhns will be used for the diff
erent type chip(hip06, hip07, ...), and it can distinguish the hardware of these chip at the same time.
Hence, i think that your plan will not attain our demand.

We hope that the only one userspace library file named libhns-rdmav2.so will be used for the different hardware version(hip06, hip07, ...),
because there are only little change between their userspace drivers. So we need to distinguish hardware version.

We can't distinguish them if only matching driver name "hns_roce".

thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
