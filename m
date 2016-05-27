From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH v8 07/22] IB/hns: Add event queue support
Date: Fri, 27 May 2016 10:57:44 +0800
Message-ID: <5747B7A8.4060500@huawei.com>
References: <df14eb59-6005-4412-8e85-d613b104ab96@redhat.com>
 <cafab3f2-e033-398c-563e-7f4ffcca1a61@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cafab3f2-e033-398c-563e-7f4ffcca1a61-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yankejian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liudongdong3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangjukuo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qiujiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tangchaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 2016/5/26 4:34, Doug Ledford wrote:
>
>
> -------- Forwarded Message --------
> Subject: Re: [PATCH v8 07/22] IB/hns: Add event queue support
> Date: Wed, 25 May 2016 15:22:05 -0400
> From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Organization: Red Hat, Inc.
> To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> On 05/25/2016 11:05 AM, Lijun Ou wrote:
>> This patch added event queue support for RoCE driver. It is used
>> for RoCE interrupt. RoCE includes 32 synchronous event irqs, 1
>> asynchronous event irq and 1 common overflow irq.
>> +#define roce_writel(value, addr)     writel((value), (addr))
>> +#define roce_readl(addr)            readl((addr))
> These two defines are useless.  They just make the code width longer for
> no real purpose.  Here's an example from my last email
>
>>> +				((u64)le32_to_cpu(roce_readl(hr_dev->reg_base +
>>> +					     ROCEE_SYS_IMAGE_GUID_H_REG)) <<
>>> +					     ADDR_SHIFT_32);
> If you are going to do a #define for this, at least let the #define do
> some work for you.  Something like:
>
> #define hns_readl(dev, reg) readl((dev)->reg_base + (reg))
>
> then the above can read more like this
>
>>> +				((u64)le32_to_cpu(hns_readl(hr_dev,
>>> +					     ROCEE_SYS_IMAGE_GUID_H_REG)) <<
>>> +					     ADDR_SHIFT_32);
> You could do additional tricks to make the overall length of lines
> shorter while loosing none of the readability if you altered your
> register names a little.  And if all of your ROCEE registers have a
> common prefix or postfix, you can embedd that in the #define to keep the
> register names shorter in your file.  For instance, they appear to all
> start with ROCEE and end with REG, so maybe something like this:
>
> #define hns_readl(dev, reg) readl((dev->)reg_base + ROCEE_##reg##_REG)
>
> so that the above starts to look like this:
>
>>> +				((u64)le32_to_cpu(hns_readl(hr_dev,
>>> +					     SYS_IMAGE_GUID_H)) << 32);
> which is much more readable in my opinion.
>
>
>
>> +/* Address shift 12bit with the special hardware address operation of RoCEE */
>> +#define ADDR_SHIFT_12				12
>> +
> And this is the one that should talk about the register that requires
> the address be shifted as though using a 4K page size even when you aren't.
Yes, we use a 4K page, but we can't use PAGE_SHIFT in the code. 
PAGE_SHIFT maybe is not equal 12.
your meaning is that we use literal number 12, right?

Regards
Wei Hu
>
>>   /* Address shift 32bit with the special hardware address operation of RoCEE */
>>   #define ADDR_SHIFT_32				32
> I really don't know when you actually need a define for a 32 bit shift....
>
>> +/* Address shift 44bit with the special hardware address operation of RoCEE */
>> +#define ADDR_SHIFT_44				44
> This one, just like the 12 shift, needs an explanation of some sort.
44 = 32 + 12
When evaluating addr to hardware, shift 12 because of using 4K page,
and shift more 32 because of caculating the high 32 bit value evaluated 
to hardware.
We prepare to delete the definition of macro ADDR_SHIFT_44, use literal 
44 directly in code,
add comments.

Regards
Wei HU
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
