From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 08/15] IB/uverbs: Add ioctl support for 32bit
 processes
Date: Wed, 14 Feb 2018 06:31:19 -0500
Message-ID: <b678b4d6-39bc-f2ed-d9c3-33f1f90dee20@intel.com>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-9-leon@kernel.org>
 <f77173f4-703b-b5ec-06ad-24263805251d@intel.com>
 <20180213171632.GI4499@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213171632.GI4499-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/13/2018 12:16 PM, Jason Gunthorpe wrote:
> On Tue, Feb 13, 2018 at 11:56:47AM -0500, Dennis Dalessandro wrote:
>> On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
>>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> 32 bit processes running on a 64 bit kernel call compat_ioctl so that
>>> implementations can revise any structure layout issues. Point compat_ioctl
>>> at our normal ioctl because:
>>>
>>> - All our structures are designed to be the same on 32 and 64 bit, ie we
>>>    use __aligned_u64 when required and are careful to manage padding.
>>>
>>> - Any pointers are stored in u64's and userspace is expected
>>>    to prepare them properly.
>>>
>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>   drivers/infiniband/core/uverbs_main.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
>>> index 395a3b091229..cd72555ad457 100644
>>> +++ b/drivers/infiniband/core/uverbs_main.c
>>> @@ -942,6 +942,7 @@ static const struct file_operations uverbs_fops = {
>>>   	.llseek	 = no_llseek,
>>>   #if IS_ENABLED(CONFIG_INFINIBAND_EXP_USER_ACCESS)
>>>   	.unlocked_ioctl = ib_uverbs_ioctl,
>>> +	.compat_ioctl = ib_uverbs_ioctl,
>>>   #endif
>>>   };
>>> @@ -954,6 +955,7 @@ static const struct file_operations uverbs_mmap_fops = {
>>>   	.llseek	 = no_llseek,
>>>   #if IS_ENABLED(CONFIG_INFINIBAND_EXP_USER_ACCESS)
>>>   	.unlocked_ioctl = ib_uverbs_ioctl,
>>> +	.compat_ioctl = ib_uverbs_ioctl,
>>>   #endif
>>>   };
>>>
>>
>> Is this patch really necessary?
> 
> Yes. Without it 32 bit gets:
> 
> ioctl(3, _IOC(_IOC_READ|_IOC_WRITE, 0x1b, 0x1, 0x10), 0xffcaf5f8) = -1 ENOTTY (Inappropriate ioctl for device)
> 
>> Doesn't sys_ioctl() just end up calling unlocked_ioctl() if
>> .compat_ioctl is not set? I guess nothing wrong with being explicit
>> here, but this is just a clean-up then, and not an -rc patch.
> 
> No, the control flow is really tortured in compat_ioctl.c, but it
> will only call compat_ioctl for our case.

Ok, thanks, I'll go take another look.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
