From: Parav Pandit <parav@mellanox.com>
Subject: RE: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_valid
 (4)
Date: Thu, 23 Aug 2018 16:39:29 +0000
Message-ID: <VI1PR0501MB22714BE9A34FA333671A0623D1370@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <001a1141551246502d056845782e@google.com>
 <001a1140f6ac1677460568489287@google.com>
 <20180823061630.GB736@sol.localdomain> <20180823145458.GC9366@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180823145458.GC9366@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Eric Biggers <ebiggers@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dasaratharaman.chandramouli@intel.com" <dasaratharaman.chandramouli@intel.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Moni Shoua <monis@mellanox.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, syzbot <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, August 23, 2018 9:55 AM
> To: Eric Biggers <ebiggers@kernel.org>
> Cc: Doug Ledford <dledford@redhat.com>; linux-rdma@vger.kernel.org;
> dasaratharaman.chandramouli@intel.com; Leon Romanovsky
> <leonro@mellanox.com>; linux-kernel@vger.kernel.org; Mark Bloch
> <markb@mellanox.com>; Moni Shoua <monis@mellanox.com>; Parav Pandit
> <parav@mellanox.com>; syzkaller-bugs@googlegroups.com; syzbot
> <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
> Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_va=
lid
> (4)
>=20
> On Wed, Aug 22, 2018 at 11:16:31PM -0700, Eric Biggers wrote:
> > Hello RDMA / InfiniBand maintainers,
> >
> > This is an RDMA bug and it still occurs on Linus' tree as of today
> > (commit 815f0ddb346c1960).
> >
> > I've also simplified the reproducer for it; see below after the origina=
l report.
> > Apparently it involves a race between RDMA_USER_CM_CMD_RESOLVE_IP
> and
> > RDMA_USER_CM_CMD_LISTEN.
>=20
> That is an amazing reproducer!
>=20
> I have a feeling this is the same cause as all the other syzkaller bugs i=
n this code:
> lack of any sane locking at all :\
>=20
> We've talked about chucking a big lock around this whole thing, but nobod=
y has
> done it yet.. It isn't so simple.
>=20
I had some code in which reduces three locks (handler_lock, qp_mutex, id_lo=
ck) to single mutex to protect the cm_id and protects every exported symbol=
 of rdmacm which works on cm_id.
But not ready enough to post it as patch yet. Lot of tests required before =
I get there and some refactor too before that.

> Jason
