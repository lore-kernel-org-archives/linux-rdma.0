From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 02 Apr 2015 22:40:08 +0200
Message-ID: <1428007208.22575.104.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
	 <1427992506.22575.80.camel@opteya.com>
	 <AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shachar Raindel <raindel@mellanox.com>
Cc: Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 02 avril 2015 =C3=A0 16:44 +0000, Shachar Raindel a =C3=A9crit=
 :
> > -----Original Message-----
> > From: Yann Droneaud [mailto:ydroneaud@opteya.com]
> > Sent: Thursday, April 02, 2015 7:35 PM

> > Another related question: as the large memory range could be regist=
ered
> > by user space with ibv_reg_mr(pd, base, size, IB_ACCESS_ON_DEMAND),
> > what's prevent the kernel to map a file as the result of mmap(0, ..=
=2E)
> > in this  region, making it available remotely through IBV_WR_RDMA_R=
EAD /
> > IBV_WR_RDMA_WRITE ?
> >=20
>=20
> This is not a bug. This is a feature.
>=20
> Exposing a file through RDMA, using ODP, can be done exactly like thi=
s.
> Given that the application explicitly requested this behavior, I don'=
t
> see why it is a problem.=20

If the application cannot choose what will end up in the region it has
registered, it's an issue !

What might happen if one library in a program call mmap(0, size, ...) t=
o
load a file storing a secret (a private key), and that file ends up=20
being mapped in an registered but otherwise free region (afaict, the=20
kernel is allowed to do it) ?
What might happen if one library in a program call call mmap(0,=20
size, ..., MAP_ANONYMOUS,...) to allocate memory, call mlock(), then
write in this location a secret (a passphrase), and that area ends up
in the memory region registered for on demand paging ?

The application haven't choose to disclose these confidential piece of=20
information, but they are available for reading/writing by remote
through RDMA given it knows the rkey of the memory region (which is a=20
32bits value).

I hope I'm missing something, because I'm not feeling confident such
behavor is a feature.


> Actually, some of our tests use such flows.
> The mmu notifiers mechanism allow us to do this safely. When the page=
 is
> written back to disk, it is removed from the ODP mapping. When it is
> accessed by the HCA, it is brought back to RAM.
>=20

I'm not discussing about the benefit of On Demand Paging and why it's a
very good feature to expose files through RDMA.

I'm trying to understand how the application can choose what is exposed
through RDMA if it registers a very large memory region for later use=20
(but do not actually explicitly map something there yet): what's the
consequences ?

   void *start =3D sbrk(0);
   size_t size =3D ULONG_MAX - (unsigned long)start;

   ibv_reg_mr(pd, start, size, IB_ACCESS_ON_DEMAND)


Regards.

--=20
Yann Droneaud
OPTEYA
