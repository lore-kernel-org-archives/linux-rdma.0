From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/hns: Refactor eq code for hip06
Date: Tue, 19 Dec 2017 20:38:01 +0800
Message-ID: <674c7109-5c26-cea6-1f0e-942e3717c1e9@huawei.com>
References: <1510651577-20794-1-git-send-email-liuyixian@huawei.com>
 <1510651577-20794-2-git-send-email-liuyixian@huawei.com>
 <20171114091146.GT18825@mtr-leonro.local>
 <7a93b747-4745-86ab-4366-7b883dc2f133@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7a93b747-4745-86ab-4366-7b883dc2f133-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/11/14 17:40, Liuyixian (Eason) wrote:
> 
> 
> On 2017/11/14 17:11, Leon Romanovsky wrote:
>> On Tue, Nov 14, 2017 at 05:26:16PM +0800, Yixian Liu wrote:
>>> Considering the compatibility of supporting hip08's eq
>>> process and possible changes of data structure, this patch
>>> refactors the eq code structure of hip06.
>>>
>>> We move all the eq process code for hip06 from hns_roce_eq.c
>>> into hns_roce_hw_v1.c, and also for hns_roce_eq.h. With
>>> these changes, it will be convenient to add the eq support
>>> for later hardware version.
>>>
>>> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  drivers/infiniband/hw/hns/Makefile          |   2 +-
>>>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |   1 +
>>>  drivers/infiniband/hw/hns/hns_roce_cq.c     |  19 +-
>>>  drivers/infiniband/hw/hns/hns_roce_device.h |  57 ++-
>>>  drivers/infiniband/hw/hns/hns_roce_eq.c     | 759 ----------------------------
>>>  drivers/infiniband/hw/hns/hns_roce_eq.h     | 134 -----
>>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 740 ++++++++++++++++++++++++++-
>>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |  44 +-
>>>  drivers/infiniband/hw/hns/hns_roce_main.c   |  16 +-
>>>  drivers/infiniband/hw/hns/hns_roce_qp.c     |   1 +
>>>  10 files changed, 843 insertions(+), 930 deletions(-)
>>>  delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.c
>>>  delete mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.h
>>>
>>> diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
>>> index ff426a6..97bf2cd 100644
>>> --- a/drivers/infiniband/hw/hns/Makefile
>>> +++ b/drivers/infiniband/hw/hns/Makefile
>>> @@ -5,7 +5,7 @@
>>>  ccflags-y :=  -Idrivers/net/ethernet/hisilicon/hns3
>>>
>>>  obj-$(CONFIG_INFINIBAND_HNS) += hns-roce.o
>>> -hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_eq.o hns_roce_pd.o \
>>> +hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
>>>  	hns_roce_ah.o hns_roce_hem.o hns_roce_mr.o hns_roce_qp.o \
>>>  	hns_roce_cq.o hns_roce_alloc.o
>>>  obj-$(CONFIG_INFINIBAND_HNS_HIP06) += hns-roce-hw-v1.o
>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
>>> index 1085cb2..9ebe839 100644
>>> --- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
>>> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
>>> @@ -103,6 +103,7 @@ void hns_roce_cmd_event(struct hns_roce_dev *hr_dev, u16 token, u8 status,
>>>  	context->out_param = out_param;
>>>  	complete(&context->done);
>>>  }
>>> +EXPORT_SYMBOL_GPL(hns_roce_cmd_event);
>>
>> Are you sure that you need these symbols to be exported (used in other modules)?
>>
>> Thanks
>>
> Yes, this symbol has been used in asynchronous event handle to query
> the result of mailbox cmd execution. It is in a different module.
> 
As we have moved the eq code from hns_roce_eq.c to hns_roce_hw_v1.c,
which is from the module hns-roce.ko to the another module hns-roce-hw-v1.ko,
these symbols in hns-roce.ko should be exported and then could be
called by the eq code.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
