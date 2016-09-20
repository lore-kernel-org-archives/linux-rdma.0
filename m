From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma_rxe: Ensure rdma_rxe module init occurs at correct
 time
Date: Tue, 20 Sep 2016 16:59:02 +0300
Message-ID: <a1fb47ca-c466-7044-79ee-269f094b5006@mellanox.com>
References: <1473975936-9970-1-git-send-email-sbates@raithlin.com>
 <2fa6c4b3-6fcb-b0f1-adaf-94895710827d@redhat.com>
 <a3e5f61b65cdf92c192daef1da319718.squirrel@webmail.raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a3e5f61b65cdf92c192daef1da319718.squirrel-2RFepEojUI2m/tTznewQxVaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/19/2016 2:59 AM, Stephen Bates wrote:
> On Fri, September 16, 2016 1:06 pm, Doug Ledford wrote:
>> On 9/15/2016 5:45 PM, Stephen Bates wrote:
>>
>>> When the Soft-RoCE module is built into the kernel there is a
>>> initialization issue when CONFIG_IPV6 is selected. Use late_initcall to
>>> ensure the rxe module is loaded later. This fix is based on one proposed
>>> by Logan Gunthorpe on a much older code base [1].
>>
>> Your commit message doesn't make sense.  You start by saying that
>> soft-RoCE is compiled in, then say "the rxe module is loaded later". Well,
>> which is it?  I'm not sure exactly the problem you are fixing. However, I
>> know that the series Leon posted for the rxe driver included a fix
>> specifically for IPv6 tunnel creation issues that result in an oops.  I
>> suspect that patch might solve your problem.  So, I'm going to drop this
>> patch.  Once you get a chance to test with the other patch applied, if
>> your problem still exists, then please repost this patch with a clearer
>> commit message and we can add this as well.
>
> Doug
>
> Yes on reflection the commit message associated with this patch was not as
> clear as it could have been. Apologies. I will be more explicit on the v1.
> To answer your questions:
>
> 1. This patch should be applied on top of the three patches that came from
> Leon [1]. I will make that clear in v1.
>
> 2. My patch applies to the case where rmda_rxe is built-in and not when it
> is a module. Currently the module_init is called before IPv6 is setup and
> that results in a load failure of rxe.
>
> 3. When rdma_rxe is built as a module the problem is not observed because
> the rdma_rxe module is not probed until the system is up and running.
>
> 4. The change from module_init to late_initcall means that IPv6 has had
> enough time to come up befoe the rdma_rxe init is executed.
>
> I hope that clarifies things. I will get a v1 out shortly with an improved
> commit log.
>
> [1] http://marc.info/?l=linux-rdma&m=147307739626544&w=2
>
> Cheers
>
> Stephen Bates
>
Hi Stephen,

I reproduced the issue you've reported, and tested your fix as well and 
it looks good to me.

You can add my reviewed-by tag to the future v1 patch.

Yonatan,

Thanks
>>
>>> [1] https://github.com/sbates130272/qemu-minimal/blob/rdma/patches/\
>>> 0001-Changes-needed-to-use-rxe-compiled-into-the-kernel.patch
>>>
>>>
>>> Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Reviewed-By: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>> drivers/infiniband/sw/rxe/rxe.c | 2 +- 1 file changed, 1 insertion(+), 1
>>> deletion(-)
>>>
>>> diff --git a/drivers/infiniband/sw/rxe/rxe.c
>>> b/drivers/infiniband/sw/rxe/rxe.c index 08e09d9..97bc74a 100644 ---
>>> a/drivers/infiniband/sw/rxe/rxe.c +++ b/drivers/infiniband/sw/rxe/rxe.c
>>> @@ -392,5 +392,5 @@ static void __exit rxe_module_exit(void)
>>> pr_info("rxe: unloaded\n");
>>> }
>>>
>>>
>>> -module_init(rxe_module_init);
>>> +late_initcall(rxe_module_init);
>>> module_exit(rxe_module_exit);
>>>
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> GPG Key ID: 0E572FDD
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
