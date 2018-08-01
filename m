From: Parav Pandit <parav@mellanox.com>
Subject: RE: linux-next: manual merge of the net-next tree with the rdma tree
Date: Wed, 1 Aug 2018 18:30:36 +0000
Message-ID: <VI1PR0502MB3008C0158C43DC42A06C5255D12D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
 <20180727024832.GA30023@mellanox.com>
 <20180727132847.2be8563b@canb.auug.org.au>
 <VI1PR0502MB3008702AFA64F44DE57DC9F5D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180727150903.0f2816ba@canb.auug.org.au>
 <VI1PR0502MB3008076016496152D4898D8ED12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180801153345.22692adb@canb.auug.org.au> <20180801171346.GC10824@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801171346.GC10824@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, August 1, 2018 12:14 PM
> To: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Parav Pandit <parav@mellanox.com>; David Miller
> <davem@davemloft.net>; Networking <netdev@vger.kernel.org>; Doug
> Ledford <dledford@redhat.com>; Linux-Next Mailing List <linux-
> next@vger.kernel.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; Ursula Braun <ubraun@linux.ibm.com>; Leon
> Romanovsky <leonro@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: linux-next: manual merge of the net-next tree with the rdma =
tree
>=20
> On Wed, Aug 01, 2018 at 03:33:45PM +1000, Stephen Rothwell wrote:
> > Hi Parav,
> >
> > On Tue, 31 Jul 2018 21:12:00 +0000 Parav Pandit <parav@mellanox.com>
> wrote:
> > >
> > > You might want to consider this compatibility patch in Linux-rdma
> > > tree to avoid a merge conflict of smc.
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit
> > > /?h=3Dfor-next&id=3D7aaa1807e698f73094b78f0ef25b1a37a4409a55
> >
> > Ok, since commit that is now in the rdma tree, my resolution of the
> > original conflicts comes down to dropping all the changes to
> > net/smc/smc_core.c net/smc/smc_ib.c that come from the rdma tree and
> > adding
> >
> > #include <rdma/ib_cache.h>
> >
> > to net/smc/smc_ib.c.
>=20
> Oh, that means I put the compat inline in the wrong header? Sigh.
>=20
It was in wrong place originally in ib_verbs.h because lately it returned a=
ll the entries from the cache.
So ib_cache.h was/is correct place.
But devel happened at pace where we eventually deprecated it.
So from pure compat perspective, yeah, it should be in wrong file i.e. ib_v=
erbs.h but otherwise its correct in ib_cache.h.
