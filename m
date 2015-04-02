From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 2 Apr 2015 18:18:32 +0300
Message-ID: <551D5DC8.6070909@mellanox.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
 <1427981431.22575.21.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1427981431.22575.21.camel@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>, Shachar Raindel <raindel@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 02/04/2015 16:30, Yann Droneaud wrote:
> Hi,
>=20
> Le jeudi 02 avril 2015 =C3=A0 10:52 +0000, Shachar Raindel a =C3=A9cr=
it :
>>> -----Original Message-----
>>> From: Yann Droneaud [mailto:ydroneaud@opteya.com]
>>> Sent: Thursday, April 02, 2015 1:05 PM
>>> Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel a =C3=A9=
crit :
>=20
>>>> +	/*
>>>> +	 * If the combination of the addr and size requested for this
>>> memory
>>>> +	 * region causes an integer overflow, return error.
>>>> +	 */
>>>> +	if ((PAGE_ALIGN(addr + size) <=3D size) ||
>>>> +	    (PAGE_ALIGN(addr + size) <=3D addr))
>>>> +		return ERR_PTR(-EINVAL);
>>>> +
>>>
>>> Can access_ok() be used here ?
>>>
>>>          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
>>>                         addr, size))
>>>                   return ERR_PTR(-EINVAL);
>>>
>>
>> No, this will break the current ODP semantics.
>>
>> ODP allows the user to register memory that is not accessible yet.
>> This is a critical design feature, as it allows avoiding holding
>> a registration cache. Adding this check will break the behavior,
>> forcing memory to be all accessible when registering an ODP MR.
>>
>=20
> Where's the check for the range being in userspace memory space,
> especially for the ODP case ?
>=20
> For non ODP case (eg. plain old behavior), does get_user_pages()
> ensure the requested pages fit in userspace region on all=20
> architectures ? I think so.

Yes, get_user_pages will return a smaller amount of pages than requeste=
d
if it encounters an unmapped region (or a region without write
permissions for write requests). If this happens, the loop in
ib_umem_get calls get_user_pages again with the next set of pages, and
this time if it the first page still cannot be mapped an error is retur=
ned.

>=20
> In ODP case, I'm not sure such check is ever done ?

In ODP, we also call get_user_pages, but only when a page fault occurs
(see ib_umem_odp_map_dma_pages()). This allows the user to pre-register
a memory region that contains unmapped virtual space, and then mmap
different files into that area without needing to re-register.

> (Aside, does it take special mesure to protect shared mapping from
> being read and/or *written* ?)

I'm not sure I understand the question. Shared mappings that the proces=
s
is allowed to read or write are also allowed for the HCA (specifically,
to local and remote operations the same process performs using the HCA)=
,
provided the application has registered their virtual address space as =
a
memory region.

Regards,
Haggai
