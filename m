From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Fri, 03 Apr 2015 13:49:45 +0200
Message-ID: <1428061785.22575.139.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
	 <1427992506.22575.80.camel@opteya.com>
	 <AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
	,<1428007208.22575.104.camel@opteya.com> <1428050408201.35668@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1428050408201.35668@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 03 avril 2015 =C3=A0 08:39 +0000, Haggai Eran a =C3=A9crit =
:
> On Thursday, April 2, 2015 11:40 PM, Yann Droneaud <ydroneaud@opteya.=
com> wrote:
> > Le jeudi 02 avril 2015 =C3=A0 16:44 +0000, Shachar Raindel a =C3=A9=
crit :
> >> > -----Original Message-----
> >> > From: Yann Droneaud [mailto:ydroneaud@opteya.com]
> >> > Sent: Thursday, April 02, 2015 7:35 PM
> >=20
> >> > Another related question: as the large memory range could be reg=
istered
> >> > by user space with ibv_reg_mr(pd, base, size, IB_ACCESS_ON_DEMAN=
D),
> >> > what's prevent the kernel to map a file as the result of mmap(0,=
 ...)
> >> > in this  region, making it available remotely through IBV_WR_RDM=
A_READ /
> >> > IBV_WR_RDMA_WRITE ?
> >> >
> >>
> >> This is not a bug. This is a feature.
> >>
> >> Exposing a file through RDMA, using ODP, can be done exactly like =
this.
> >> Given that the application explicitly requested this behavior, I d=
on't
> >> see why it is a problem.
> >=20
> > If the application cannot choose what will end up in the region it =
has
> > registered, it's an issue !
> >=20
> > What might happen if one library in a program call mmap(0, size, ..=
=2E) to
> > load a file storing a secret (a private key), and that file ends up
> > being mapped in an registered but otherwise free region (afaict, th=
e
> > kernel is allowed to do it) ?
> > What might happen if one library in a program call call mmap(0,
> > size, ..., MAP_ANONYMOUS,...) to allocate memory, call mlock(), the=
n
> > write in this location a secret (a passphrase), and that area ends =
up
> > in the memory region registered for on demand paging ?
> >=20
> > The application haven't choose to disclose these confidential piece=
 of
> > information, but they are available for reading/writing by remote
> > through RDMA given it knows the rkey of the memory region (which is=
 a
> > 32bits value).
> >=20
> > I hope I'm missing something, because I'm not feeling confident suc=
h
> > behavor is a feature.
>=20
> What we are aiming for is the possibility to register the entire proc=
ess' address=20
> space for RDMA operations (if the process chooses to use this feature=
).
> This is similar to multiple threads accessing the same address space.=
 I'm sure=20
> you wouldn't be complaining about the ability of one thread to access=
 the secret=20
> passphrase mmapped by another thread in your example.
>=20
> > I'm trying to understand how the application can choose what is exp=
osed
> > through RDMA if it registers a very large memory region for later u=
se
> > (but do not actually explicitly map something there yet): what's th=
e
> > consequences ?
> >=20
> >    void *start =3D sbrk(0);
> >    size_t size =3D ULONG_MAX - (unsigned long)start;
> >=20
> >    ibv_reg_mr(pd, start, size, IB_ACCESS_ON_DEMAND)
>=20
> The consequences are exactly as you wrote. Just as giving a non-ODP r=
key=20
> to a remote node allows the node to access the registered memory behi=
nd that=20
> rkey, giving an ODP rkey to a remote node allows that node to access =
the=20
> virtual address space behind that rkey.
>=20

There's a difference: it's impossible to give a valid non-ODP rkey that
point to a memory region not already mapped (backed by a file for=20
example), so the application *choose* the content of the memory to be
made accessible remotely before making it accessible.

As I understand the last explanation regarding ODP, at creation time,
an ODP rkey can point to a free, unused, unallocated memory portion.
At this point the kernel can happily map anything the application
(and its libraries) want to map at a (almost) *random* address that
could be in (or partially in) the ODP memory region.

And I have a problem with such random behavior. Allowing this is seems
dangerous and should be done with care.

I believe the application must kept the control of what's end up in its=
=20
ODP registered memory region.

Especially for multi thread program: imagine one thread creating a larg=
e
memory region for its future purposes, then send the rkey to a remote=20
peer and wait for some work to be done.
In the mean time another call mmap(0, ...) to map a file at a kernel=20
chosen address, and that address happen to be in the memory region=20
registered by the other thread:

1) the first thread is amputated from a portion of memory it was=20
willing to use;
2) the data used by the second thread is accessible to the remote=20
peer(s) while not expected.

Speculatively registering memory seems dangerous for any use case I
could think of.

Regards.

--=20
Yann Droneaud
OPTEYA
