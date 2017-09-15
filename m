From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 11/20] RDMA/hns: Split CQE from MTT in hip08
Date: Fri, 15 Sep 2017 09:09:28 +0800
Message-ID: <59BB2848.6080802@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-12-git-send-email-xavier.huwei@huawei.com>
 <20170913175259.GW3405@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170913175259.GW3405-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/9/14 1:52, Leon Romanovsky wrote:
> On Wed, Aug 30, 2017 at 05:23:09PM +0800, Wei Hu (Xavier) wrote:
>> From: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> In hip08, the SQWQE/SGE/RQWQE and CQE have different hop num and
>> page size, so we need to manage the base address table of the
>> SQWQE/SGE/RQWQE and CQE separately.
>>
>> This patch is to split CQE from MTT(SQWQE/SGE/RQWQE).
>>
>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/hns/hns_roce_cq.c     | 15 ++++++-
>>   drivers/infiniband/hw/hns/hns_roce_device.h | 14 ++++--
>>   drivers/infiniband/hw/hns/hns_roce_hem.c    |  3 ++
>>   drivers/infiniband/hw/hns/hns_roce_main.c   | 17 ++++++++
>>   drivers/infiniband/hw/hns/hns_roce_mr.c     | 66 ++++++++++++++++++++++-------
>>   drivers/infiniband/hw/hns/hns_roce_qp.c     |  2 +
>>   6 files changed, 98 insertions(+), 19 deletions(-)
> <...>
>
>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -170,6 +170,11 @@ enum {
>>   	HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE	= 0x07,
>>   };
>>
>> +enum hns_roce_mtt_type {
>> +	MTT_TYPE_WQE = 0,
>> +	MTT_TYPE_CQE,
>> +};
> No need to initialize enum to zero.
> Thanks
Hi, Leon
     We will send a followup patch to fix it at your suggestion.
     Thanks

     Regards
Wei Hu


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
