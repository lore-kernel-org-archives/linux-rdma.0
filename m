From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/5] Some fixes for HNS RoCE driver
Date: Sat, 10 Jun 2017 16:46:16 +0800
Message-ID: <9c2a0ecc-8b09-016d-af5e-e10c1ad2e43d@huawei.com>
References: <1496712288-63434-1-git-send-email-oulijun@huawei.com>
 <20170606062144.GU6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606062144.GU6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/6/6 14:21, Leon Romanovsky 写道:
> On Tue, Jun 06, 2017 at 09:24:43AM +0800, Lijun Ou wrote:
>> This patchset introduces some fixes for the identified problems
>> according to the changed IB/core and others reviews.
>>
>> Lijun Ou (5):
>>   IB/hns: Fix the bug of polling cq failed for loopback Qps
>>   IB/hns: Fix the bug with wild pointer when destroy rc qp
>>   IB/hns: Fix the bug with rdma operation
>>   IB/hns: Fix the bug with modifying the MAC address without removing
>>     the driver
>>   IB/hns: Fix for checkpatch.pl comment style warnings
> It will be really helpful if you follow the SubmittingPatches guide,
> use proper title, add Fixes line and provide meaningful description.
>
> Thanks
ok, I will do and resend a patch.

Thanks
Lijun Ou
>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 82 ++++++++++++++++++------------
>>  drivers/infiniband/hw/hns/hns_roce_main.c  |  3 --
>>  2 files changed, 50 insertions(+), 35 deletions(-)
>>
>> --
>> 1.9.1
>>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
