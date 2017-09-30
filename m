From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/8] Bug fixes & Code improvements in hip06
 and hip08 RoCE driver
Date: Sat, 30 Sep 2017 10:11:54 +0800
Message-ID: <59CEFD6A.9060500@huawei.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
 <1506702175.2919.28.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506702175.2919.28.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, xushaobo <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "zhangxiping (C)" <zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2017/9/30 0:22, Doug Ledford wrote:
> On Fri, 2017-09-29 at 23:10 +0800, Wei Hu (Xavier) wrote:
>> This patch-set introduces some bug fixes and code improvements
>> for hip06 and hip08 RoCE driver. It includes a patch for fixing
>> the assign algorithm of qp_attr->max_rd_atomic and
>> qp_attr->max_dest_rd_atomic, three patches for static check errors,
>> one for setting attr mask, one for returning RoCE device ah_attr
>> type when querying qp, one for unregistering inet addr, and the
>> last one for command queue delay processing in hip08 driver.
>>
>> Lijun Ou (6):
>>    RDMA/hns: Modify the value with rd&dest_rd of qp_attr
>>    RDMA/hns: Factor out the code for checking sdb status into a new
>>      function
>>    RDMA/hns: Set mask for destination qp field of qp context
>> assignment
>>    RDMA/hns: Set rdma_ah_attr type for querying qp
>>    RDMA/hns: Remove unnecessarily calling unregister_inetaddr_notifier
>>      function
>>    RDMA/hns: Replace usleep_range with udelay when checking command
>>      status
>>
>> Wei Hu (Xavier) (2):
>>    RDMA/hns: Add return statement when kzalloc return NULL in
>>      hns_roce_v1_recreate_lp_qp
>>    RDMA/hns: Add return statement when checking error in
>>      hns_roce_v1_mr_free_work_fn
>>
>>   drivers/infiniband/hw/hns/hns_roce_device.h |   3 +-
>>   drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 131 +++++++++++++++++-
>> ----------
>>   drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |   9 +-
>>   drivers/infiniband/hw/hns/hns_roce_main.c   |  18 ++--
>>   4 files changed, 96 insertions(+), 65 deletions(-)
> Hi Wei,
>
> I've taken this series into for-next.  However, a lot of the commit
> subjects needed fixing up (and a few of the commit logs as well for
> general readability).  Please don't use such long subjects as they
> interrupt the output of git log --oneline when using the kernel
> standard 12 digit hex output for commit hashes.
Hi Doug
     I got it and will make improvements in subsequent patches.
     Thanks.

     Best Regards
Wei Hu


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
