From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/9] RDMA/hns: Add return statement when kzalloc
 return NULL in hns_roce_v1_recreate_lp_qp
Date: Fri, 29 Sep 2017 14:07:22 +0800
Message-ID: <59CDE31A.5090707@huawei.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-4-git-send-email-xavier.huwei@huawei.com>
 <20170928091308.GT2297@mtr-leonro.local> <59CCE38B.4040408@huawei.com>
 <20170928125912.GU2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170928125912.GU2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/9/28 20:59, Leon Romanovsky wrote:
> On Thu, Sep 28, 2017 at 07:56:59PM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2017/9/28 17:13, Leon Romanovsky wrote:
>>> On Thu, Sep 28, 2017 at 12:57:28PM +0800, Wei Hu (Xavier) wrote:
>>>> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> When lp_qp_work is NULL, it should be returned ENOMEM. This patch
>>>> mainly fixes it.
>>>>
>>>> Ihis patch fixes the smatch error as below:
>>>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:918 hns_roce_v1_recreate_lp_qp()
>>>> error: potential null dereference 'lp_qp_work'.  (kzalloc returns null)
>>>>
>>>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>>>> index 95f5c88..1071fa2 100644
>>>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>>>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>>>> @@ -912,6 +912,8 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
>>>>
>>>>    	lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
>>>>    			     GFP_KERNEL);
>>>> +	if (!lp_qp_work)
>>>> +		return -ENOMEM;
>>>>
>>> You will treat this error in the same was as you will treat timeout,
>>> which is wrong.
>> Thanks,  Leon
>> We will send v2 to fix the compatible warn info.
> No, you missed the point.
>  From the code flow below the behavior of hns_roce_v1_recreate_lp_qp
> for ENOMEM and ETIMEOUT returns will be the same and it is wrong.
>
> For the ETIMEOUT, you can continue, for ENOMEM, you should properly
> unfold the whole flow.
>
> Thanks
>
Hi, Leon
     We prepare to modify the warn info as bleow:

         if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
             dev_warn(&hr_dev->pdev->dev, "recreate lp qp failed!\n");

     for -ETIMEDOUT,  there is a warn info as blow, but there isn't this 
one for -ENOMEM.
         dev_warn(dev, "recreate lp qp failed 20s timeout and return 
failed!\n");

         static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
         {
             <snip>
             lp_qp_work = kzalloc(sizeof(struct 
hns_roce_recreate_lp_qp_work),
                  GFP_KERNEL);
             if (!lp_qp_work)
                 return -ENOMEM;

             <snip>
             dev_warn(dev, "recreate lp qp failed 20s timeout and return 
failed!\n");
             return -ETIMEDOUT;
         }

     Regards
Wei Hu
>>> 1656          */
>>> 1657         if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
>>> 1658                 dev_warn(&hr_dev->pdev->dev, "recreate lp qp timeout!\n");
>>> 1659
>>> 1660         p = (u32 *)(&addr[0]);
>>>
>>>
>>>>    	INIT_WORK(&(lp_qp_work->work), hns_roce_v1_recreate_lp_qp_work_fn);
>>>>
>>>> --
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
