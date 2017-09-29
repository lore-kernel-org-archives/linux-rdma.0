From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/9] RDMA/hns: Factor out the code for checking
 sdb status into a new function
Date: Fri, 29 Sep 2017 10:05:04 +0800
Message-ID: <59CDAA50.60809@huawei.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-3-git-send-email-xavier.huwei@huawei.com>
 <20170928135014.GY2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170928135014.GY2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/9/28 21:50, Leon Romanovsky wrote:
> On Thu, Sep 28, 2017 at 12:57:27PM +0800, Wei Hu (Xavier) wrote:
>> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> It mainly places the lines for checking send doorbell status
>> into a special functions. As a result, we can directly call it in
>> check_qp_db_process_status function and keep consistent indenting
>> style.
>>
>> It fixes: 5f110ac4bed8 ("IB/hns: Fix for checkpatch.pl comment style)
> You forgot " at the end of the line, and there is need to put fixes
> (should be Fixes) in the line before Signed-off-by.
Thanks, Leon
We will modify the statement(Fixes: xx)  and put it before signed-off-by 
in patch v2.

>> The warning from static checker:
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:3562 check_qp_db_process_status()
>> warn: inconsistent indenting
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 95 ++++++++++++++++--------------
>>   1 file changed, 51 insertions(+), 44 deletions(-)
>>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
