From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 2/2] IB/core: don't disallow registering region starting
 at 0x0
Date: Tue, 14 Apr 2015 15:50:50 +0300
Message-ID: <552D0D2A.8000604@dev.mellanox.co.il>
References: <cover.1428929103.git.ydroneaud@opteya.com>	 <ca0fad20f6eff1dae5c4c8cd92fccad188d685c4.1428929103.git.ydroneaud@opteya.com>	 <552CDBD6.1020205@dev.mellanox.co.il> <1429012859.4333.2.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429012859.4333.2.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/14/2015 3:00 PM, Yann Droneaud wrote:
> Hi,
>
> Le mardi 14 avril 2015 =C3=A0 12:20 +0300, Sagi Grimberg a =C3=A9crit=
 :
>> On 4/13/2015 3:56 PM, Yann Droneaud wrote:
>>> In a call to ib_umem_get(), if address is 0x0 and size is
>>> already page aligned, check added in commit 8494057ab5e4
>>> ("IB/uverbs: Prevent integer overflow in ib_umem_get address
>>> arithmetic") will refuse to register a memory region that
>>> could otherwise be valid (provided vm.mmap_min_addr sysctl
>>> and mmap_low_allowed SELinux knobs allow userspace to map
>>> something at address 0x0).
>>>
>>> This patch allows back such registration: ib_umem_get()
>>> should probably don't care of the base address provided it
>>> can be pinned with get_user_pages().
>>>
>>> There's two possible overflows, in (addr + size) and in
>>> PAGE_ALIGN(addr + size), this patch keep ensuring none
>>> of them happen while allowing to pin memory at address
>>> 0x0. Anyway, the case of size equal 0 is no more (partially)
>>> handled as 0-length memory region are disallowed by an
>>> earlier check.
>>>
>>> Link: http://mid.gmane.org/cover.1428929103.git.ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m
>>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 8494057ab5e4 ("IB/uverbs: Prevent in=
teger overflow in ib_umem_get address arithmetic")
>>> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>    drivers/infiniband/core/umem.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/co=
re/umem.c
>>> index 9ac4068d2088..38acb3cfc545 100644
>>> --- a/drivers/infiniband/core/umem.c
>>> +++ b/drivers/infiniband/core/umem.c
>>> @@ -106,8 +106,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext =
*context, unsigned long addr,
>>>    	 * If the combination of the addr and size requested for this m=
emory
>>>    	 * region causes an integer overflow, return error.
>>>    	 */
>>> -	if ((PAGE_ALIGN(addr + size) <=3D size) ||
>>> -	    (PAGE_ALIGN(addr + size) <=3D addr))
>>> +	if (((addr + size) < addr) ||
>>> +	    PAGE_ALIGN(addr + size) < (addr + size))
>>
>> If you do change the first statement to be: (addr + size) <=3D addr
>> wouldn't it cover patch #1?
>>
>
> Yes, but it doesn't sound a great place to do it: here it's about
> overflow, so I'd prefer not doing the null memory region check there.
>
> Regards.
>

Sounds reasonable to me.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Let's poke Shachar/Haggai to comment/approve on this as well.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
