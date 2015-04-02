From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 2 Apr 2015 18:12:58 +0000
Message-ID: <1427998401240.52348@mellanox.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
 <1427992506.22575.80.camel@opteya.com>,<AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM2PR05MB0929FB71C5A4DE92A7709F92DCF20-Wc3DjHnhGicijy4iGQu0rtqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thursday, April 2, 2015 7:44 PM, Shachar Raindel wrote:
>> -----Original Message-----
>> From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org]
>> Sent: Thursday, April 02, 2015 7:35 PM
>> To: Haggai Eran
>> Cc: Shachar Raindel; Sagi Grimberg; oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org;
>> <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); linux-
>> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected
>> physical memory access
>>
>> Hi Haggai,
>>
>> Le jeudi 02 avril 2015 =E0 18:18 +0300, Haggai Eran a =E9crit :
>> > On 02/04/2015 16:30, Yann Droneaud wrote:
>> >> Hi,
>> >>
>> >> Le jeudi 02 avril 2015 =E0 10:52 +0000, Shachar Raindel a =E9crit=
 :
>> >>>> -----Original Message-----
>> >>>> From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org]
>> >>>> Sent: Thursday, April 02, 2015 1:05 PM
>> >>>> Le mercredi 18 mars 2015 =E0 17:39 +0000, Shachar Raindel a =E9=
crit :
>> >>
>> >>>>> +      /*
>> >>>>> +       * If the combination of the addr and size requested fo=
r this
>> >>>> memory
>> >>>>> +       * region causes an integer overflow, return error.
>> >>>>> +       */
>> >>>>> +      if ((PAGE_ALIGN(addr + size) <=3D size) ||
>> >>>>> +          (PAGE_ALIGN(addr + size) <=3D addr))
>> >>>>> +              return ERR_PTR(-EINVAL);
>> >>>>> +
>> >>>>
>> >>>> Can access_ok() be used here ?
>> >>>>
>> >>>>          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
>> >>>>                         addr, size))
>> >>>>                   return ERR_PTR(-EINVAL);
>> >>>>
>> >>>
>> >>> No, this will break the current ODP semantics.
>> >>>
>> >>> ODP allows the user to register memory that is not accessible ye=
t.
>> >>> This is a critical design feature, as it allows avoiding holding
>> >>> a registration cache. Adding this check will break the behavior,
>> >>> forcing memory to be all accessible when registering an ODP MR.
>> >>>
>> >>
>> >> Where's the check for the range being in userspace memory space,
>> >> especially for the ODP case ?
>> >>
>> >> For non ODP case (eg. plain old behavior), does get_user_pages()
>> >> ensure the requested pages fit in userspace region on all
>> >> architectures ? I think so.
>> >
>> > Yes, get_user_pages will return a smaller amount of pages than
>> requested
>> > if it encounters an unmapped region (or a region without write
>> > permissions for write requests). If this happens, the loop in
>> > ib_umem_get calls get_user_pages again with the next set of pages,=
 and
>> > this time if it the first page still cannot be mapped an error is
>> returned.
>> >
>> >>
>> >> In ODP case, I'm not sure such check is ever done ?
>> >
>> > In ODP, we also call get_user_pages, but only when a page fault oc=
curs
>> > (see ib_umem_odp_map_dma_pages()). This allows the user to pre-
>> register
>> > a memory region that contains unmapped virtual space, and then mma=
p
>> > different files into that area without needing to re-register.
>> >
>>
>> OK, thanks for the description.
>>
>> ...
>>
>> Another related question: as the large memory range could be registe=
red
>> by user space with ibv_reg_mr(pd, base, size, IB_ACCESS_ON_DEMAND),
>> what's prevent the kernel to map a file as the result of mmap(0, ...=
)
>> in this  region, making it available remotely through IBV_WR_RDMA_RE=
AD /
>> IBV_WR_RDMA_WRITE ?
>>
>=20
> This is not a bug. This is a feature.
>=20
> Exposing a file through RDMA, using ODP, can be done exactly like thi=
s.
> Given that the application explicitly requested this behavior, I don'=
t
> see why it is a problem. Actually, some of our tests use such flows.
> The mmu notifiers mechanism allow us to do this safely. When the page=
 is
> written back to disk, it is removed from the ODP mapping. When it is
> accessed by the HCA, it is brought back to RAM.
>=20

I want to add that we would like to see users registering a very large =
memory region (perhaps the entire process address space) for local acce=
ss, and then enabling remote access only to specific regions using memo=
ry windows. However, this isn't supported yet by our driver. Still, the=
re are valid cases where you would still want the results of an mmap(0,=
=2E..) call to be remotely accessible, in cases where there is enough t=
rust between the local process and the remote process. It may help a mi=
ddleware communication library register a large portion of the address =
space in advance, and still work with random pointers given to it by an=
other application module.

Regards,
Haggai--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
