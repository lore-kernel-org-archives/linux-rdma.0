From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Mon, 13 Apr 2015 15:29:41 +0200
Message-ID: <1428931781.22575.232.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
	 <1427992506.22575.80.camel@opteya.com>
	,<AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
	 <1427998401240.52348@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427998401240.52348-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 02 avril 2015 =C3=A0 18:12 +0000, Haggai Eran a =C3=A9crit :
> On Thursday, April 2, 2015 7:44 PM, Shachar Raindel wrote:
> >> -----Original Message-----
> >> From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org]
> >> Le jeudi 02 avril 2015 =C3=A0 18:18 +0300, Haggai Eran a =C3=A9cri=
t :
> >> > On 02/04/2015 16:30, Yann Droneaud wrote:
> >> >> Le jeudi 02 avril 2015 =C3=A0 10:52 +0000, Shachar Raindel a =C3=
=A9crit :
> >> >>>> -----Original Message-----
> >> >>>> From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org]
> >> >>>> Sent: Thursday, April 02, 2015 1:05 PM
> >> >>>> Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel =
a =C3=A9crit :
> >> >>
> >> >>>>> +      /*
> >> >>>>> +       * If the combination of the addr and size requested =
for this
> >> >>>> memory
> >> >>>>> +       * region causes an integer overflow, return error.
> >> >>>>> +       */
> >> >>>>> +      if ((PAGE_ALIGN(addr + size) <=3D size) ||
> >> >>>>> +          (PAGE_ALIGN(addr + size) <=3D addr))
> >> >>>>> +              return ERR_PTR(-EINVAL);
> >> >>>>> +
> >> >>>>
> >> >>>> Can access_ok() be used here ?
> >> >>>>
> >> >>>>          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ=
,
> >> >>>>                         addr, size))
> >> >>>>                   return ERR_PTR(-EINVAL);
> >> >>>>
> >> >>>
> >> >>> No, this will break the current ODP semantics.
> >> >>>
> >> >>> ODP allows the user to register memory that is not accessible =
yet.
> >> >>> This is a critical design feature, as it allows avoiding holdi=
ng
> >> >>> a registration cache. Adding this check will break the behavio=
r,
> >> >>> forcing memory to be all accessible when registering an ODP MR=
=2E
> >> >>>
> >> >>
> >> >> Where's the check for the range being in userspace memory space=
,
> >> >> especially for the ODP case ?
> >> >>
> >> >> For non ODP case (eg. plain old behavior), does get_user_pages(=
)
> >> >> ensure the requested pages fit in userspace region on all
> >> >> architectures ? I think so.
> >> >
> >> > Yes, get_user_pages will return a smaller amount of pages than
> >> requested
> >> > if it encounters an unmapped region (or a region without write
> >> > permissions for write requests). If this happens, the loop in
> >> > ib_umem_get calls get_user_pages again with the next set of page=
s, and
> >> > this time if it the first page still cannot be mapped an error i=
s
> >> returned.
> >> >
> >> >>
> >> >> In ODP case, I'm not sure such check is ever done ?
> >> >
> >> > In ODP, we also call get_user_pages, but only when a page fault =
occurs
> >> > (see ib_umem_odp_map_dma_pages()). This allows the user to pre-
> >> register
> >> > a memory region that contains unmapped virtual space, and then m=
map
> >> > different files into that area without needing to re-register.
> >> >
> >>
> >> OK, thanks for the description.
> >>
> >> ...
> >>
> >> Another related question: as the large memory range could be regis=
tered
> >> by user space with ibv_reg_mr(pd, base, size, IB_ACCESS_ON_DEMAND)=
,
> >> what's prevent the kernel to map a file as the result of mmap(0, .=
=2E.)
> >> in this  region, making it available remotely through IBV_WR_RDMA_=
READ /
> >> IBV_WR_RDMA_WRITE ?
> >>
> >=20
> > This is not a bug. This is a feature.
> >=20
> > Exposing a file through RDMA, using ODP, can be done exactly like t=
his.
> > Given that the application explicitly requested this behavior, I do=
n't
> > see why it is a problem. Actually, some of our tests use such flows=
=2E
> > The mmu notifiers mechanism allow us to do this safely. When the pa=
ge is
> > written back to disk, it is removed from the ODP mapping. When it i=
s
> > accessed by the HCA, it is brought back to RAM.
> >=20
>=20
> I want to add that we would like to see users registering a very larg=
e
> memory region (perhaps the entire process address space) for local
> access, and then enabling remote access only to specific regions usin=
g
> memory windows. However, this isn't supported yet by our driver.

In such scheme, the registration must still be handled "manually":
one has to create a memory window to get a rkey to be exchanged with
a peer, so why one would want to register such a large memory region
(the whole process space) ?

I guess creating the memory window is faster than registering memory
region. I'd rather say this is not an excuse to register a larger=20
memory region (up to the whole process space, current and future) as it=
=20
sounds like a surprising optimisation: let the HCA known too many
pages just to be sure it already knows some when the process want to=20
use them. It seems it would become difficult to handle if there's too
many processes.

I would prefer creating memory region becoming costless (through ODP :)=
=2E

>  Still, there are valid cases where you would still want the results
> of an mmap(0,...) call to be remotely accessible, in cases where ther=
e
> is enough trust between the local process and the remote process.

mmap(0, ...., fd) let the kernel choose where to put the file in=20
process virtual memory space, so it may, may not, partially, end up in=20
an ODP pre registered memory region for a range unallocated/unused yet.

I don't think one want such to happen.

>  It may help a middleware communication library register a large
> portion of the address space in advance, and still work with random
> pointers given to it by another application module.
>=20

But as said in the beginnig of your message, the middleware would have
bind a memory window before posting work request / exposing rkey for
the "random pointers".

So I fail to understand how could be used ODP when it comes to=20
registering a memory region not yet backed by something.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
