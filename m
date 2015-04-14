From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 2/2] IB/core: don't disallow registering region starting
 at 0x0
Date: Tue, 14 Apr 2015 17:35:02 +0300
Message-ID: <552D2596.50901@mellanox.com>
References: <cover.1428929103.git.ydroneaud@opteya.com>
	 <ca0fad20f6eff1dae5c4c8cd92fccad188d685c4.1428929103.git.ydroneaud@opteya.com>
	 <552CDBD6.1020205@dev.mellanox.co.il> <1429012859.4333.2.camel@opteya.com>
 <552D0D2A.8000604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552D0D2A.8000604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/04/2015 15:50, Sagi Grimberg wrote:
> On 4/14/2015 3:00 PM, Yann Droneaud wrote:
>> Le mardi 14 avril 2015 =C3=A0 12:20 +0300, Sagi Grimberg a =C3=A9cri=
t :
>>> On 4/13/2015 3:56 PM, Yann Droneaud wrote:
=2E..
>>>> diff --git a/drivers/infiniband/core/umem.c
>>>> b/drivers/infiniband/core/umem.c
>>>> index 9ac4068d2088..38acb3cfc545 100644
>>>> --- a/drivers/infiniband/core/umem.c
>>>> +++ b/drivers/infiniband/core/umem.c
>>>> @@ -106,8 +106,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext=
 *context, unsigned long addr,
>>>>         * If the combination of the addr and size requested for th=
is memory
>>>>         * region causes an integer overflow, return error.
>>>>         */
>>>> -    if ((PAGE_ALIGN(addr + size) <=3D size) ||
>>>> -        (PAGE_ALIGN(addr + size) <=3D addr))
>>>> +    if (((addr + size) < addr) ||
>>>> +        PAGE_ALIGN(addr + size) < (addr + size))
>>>
>>> If you do change the first statement to be: (addr + size) <=3D addr
>>> wouldn't it cover patch #1?
>>>
>>
>> Yes, but it doesn't sound a great place to do it: here it's about
>> overflow, so I'd prefer not doing the null memory region check there=
=2E
>>
>> Regards.
>>
>=20
> Sounds reasonable to me.

Me too. As long as we prevent the integer overflow, there is no need to
disallow regions starting at 0x0.

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>=20
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Let's poke Shachar/Haggai to comment/approve on this as well.
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
