From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Tue, 14 Apr 2015 11:11:29 +0300
Message-ID: <552CCBB1.6000207@mellanox.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
	 <1427992506.22575.80.camel@opteya.com>
	,<AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
	 <1427998401240.52348@mellanox.com> <1428931781.22575.232.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428931781.22575.232.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13/04/2015 16:29, Yann Droneaud wrote:
> Le jeudi 02 avril 2015 =C3=A0 18:12 +0000, Haggai Eran a =C3=A9crit :
=2E..
>>
>> I want to add that we would like to see users registering a very lar=
ge
>> memory region (perhaps the entire process address space) for local
>> access, and then enabling remote access only to specific regions usi=
ng
>> memory windows. However, this isn't supported yet by our driver.
>=20
> In such scheme, the registration must still be handled "manually":
> one has to create a memory window to get a rkey to be exchanged with
> a peer, so why one would want to register such a large memory region
> (the whole process space) ?
>=20
> I guess creating the memory window is faster than registering memory
> region.=20
Right.

It takes time to create and fill the hardware's page tables. Using
memory windows allows you to reuse the work done previously, while stil=
l
having a more granular control over the RDMA permissions. The larger MR
can be created with only local permissions, and the memory window can
add specific remote permissions to a smaller range. The memory window
utilizes the page tables created for the memory region.

> I'd rather say this is not an excuse to register a larger
> memory region (up to the whole process space, current and future) as =
it=20
> sounds like a surprising optimisation: let the HCA known too many
> pages just to be sure it already knows some when the process want to=20
> use them. It seems it would become difficult to handle if there's too
> many processes.
Are you worried about pinning too many pages? That is an issue we want
to solve with ODP :)

>=20
> I would prefer creating memory region becoming costless (through ODP =
:).
I agree :)

>=20
>>  Still, there are valid cases where you would still want the results
>> of an mmap(0,...) call to be remotely accessible, in cases where the=
re
>> is enough trust between the local process and the remote process.
>=20
> mmap(0, ...., fd) let the kernel choose where to put the file in=20
> process virtual memory space, so it may, may not, partially, end up i=
n=20
> an ODP pre registered memory region for a range unallocated/unused ye=
t.
>=20
> I don't think one want such to happen.
I think that in some cases the benefit of allowing this outweigh the
risks. This is why it is an opt-in feature.

>=20
>>  It may help a middleware communication library register a large
>> portion of the address space in advance, and still work with random
>> pointers given to it by another application module.
>>
>=20
> But as said in the beginnig of your message, the middleware would hav=
e
> bind a memory window before posting work request / exposing rkey for
> the "random pointers".
>=20
> So I fail to understand how could be used ODP when it comes to=20
> registering a memory region not yet backed by something.

In this scenario, the middleware would first register the full address
space as an ODP memory region with local permissions only. When it want=
s
to provide remote access to some buffer, it would bind a memory window
over the ODP MR. This is possible with multiple processes because it
uses the virtual memory system without pinning. It won't cause random
mmap regions to be mapped for RDMA without the specific intent of the
application.

However, we currently don't have support for memory windows over ODP
MRs. Even if we did, there is some performance penalty due to binding
and invalidating memory windows. Some applications will still need full
process address space access for RDMA.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
