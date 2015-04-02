From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 02 Apr 2015 18:35:06 +0200
Message-ID: <1427992506.22575.80.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <551D5DC8.6070909@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Haggai,

Le jeudi 02 avril 2015 =C3=A0 18:18 +0300, Haggai Eran a =C3=A9crit :
> On 02/04/2015 16:30, Yann Droneaud wrote:
> > Hi,
> >=20
> > Le jeudi 02 avril 2015 =C3=A0 10:52 +0000, Shachar Raindel a =C3=A9=
crit :
> >>> -----Original Message-----
> >>> From: Yann Droneaud [mailto:ydroneaud@opteya.com]
> >>> Sent: Thursday, April 02, 2015 1:05 PM
> >>> Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel a =C3=
=A9crit :
> >=20
> >>>> +	/*
> >>>> +	 * If the combination of the addr and size requested for this
> >>> memory
> >>>> +	 * region causes an integer overflow, return error.
> >>>> +	 */
> >>>> +	if ((PAGE_ALIGN(addr + size) <=3D size) ||
> >>>> +	    (PAGE_ALIGN(addr + size) <=3D addr))
> >>>> +		return ERR_PTR(-EINVAL);
> >>>> +
> >>>
> >>> Can access_ok() be used here ?
> >>>
> >>>          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
> >>>                         addr, size))
> >>>                   return ERR_PTR(-EINVAL);
> >>>
> >>
> >> No, this will break the current ODP semantics.
> >>
> >> ODP allows the user to register memory that is not accessible yet.
> >> This is a critical design feature, as it allows avoiding holding
> >> a registration cache. Adding this check will break the behavior,
> >> forcing memory to be all accessible when registering an ODP MR.
> >>
> >=20
> > Where's the check for the range being in userspace memory space,
> > especially for the ODP case ?
> >=20
> > For non ODP case (eg. plain old behavior), does get_user_pages()
> > ensure the requested pages fit in userspace region on all=20
> > architectures ? I think so.
>=20
> Yes, get_user_pages will return a smaller amount of pages than reques=
ted
> if it encounters an unmapped region (or a region without write
> permissions for write requests). If this happens, the loop in
> ib_umem_get calls get_user_pages again with the next set of pages, an=
d
> this time if it the first page still cannot be mapped an error is ret=
urned.
>=20
> >=20
> > In ODP case, I'm not sure such check is ever done ?
>=20
> In ODP, we also call get_user_pages, but only when a page fault occur=
s
> (see ib_umem_odp_map_dma_pages()). This allows the user to pre-regist=
er
> a memory region that contains unmapped virtual space, and then mmap
> different files into that area without needing to re-register.
>=20

OK, thanks for the description.

> > (Aside, does it take special mesure to protect shared mapping from
> > being read and/or *written* ?)
>=20
> I'm not sure I understand the question. Shared mappings that the proc=
ess
> is allowed to read or write are also allowed for the HCA (specificall=
y,
> to local and remote operations the same process performs using the HC=
A),
> provided the application has registered their virtual address space a=
s a
> memory region.
>=20

I was refering to description of get_user_pages():

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/mm/=
gup.c?id=3Dv4.0-rc6#n765

 * @force:	whether to force access even when user mapping is currently
 *		protected (but never forces write access to shared mapping).

But since ib_umem_odp_map_dma_pages() use get_user_pages() with force
argument set to 0, it's OK.

Another related question: as the large memory range could be registered=
=20
by user space with ibv_reg_mr(pd, base, size, IB_ACCESS_ON_DEMAND),=20
what's prevent the kernel to map a file as the result of mmap(0, ...)
in this  region, making it available remotely through IBV_WR_RDMA_READ =
/
IBV_WR_RDMA_WRITE ?

Again, thanks for the information I was missing to understand how ODP i=
s
checking the memory ranges.

Regards.

--=20
Yann Droneaud
OPTEYA
