From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Date: Thu, 6 Jun 2019 13:07:18 +0000
Message-ID: <20190606130713.GC17392@mellanox.com>
References: <20190605232348.6452-1-saeedm@mellanox.com>
 <20190606071427.GU5261@mtr-leonro.mtl.com>
 <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
Content-Language: en-US
Content-ID: <3133F2B66F95664CBC0D308614FA41E0@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Michael Chan <michael.chan@broadcom.com>, Andy Gospodarek <andy@greyhouse.net>, Tal Gilboa <talgi@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 06, 2019 at 10:19:41AM +0300, Max Gurtovoy wrote:
> > > Solution:
> > > - Common logic is declared in include/linux/dim.h and implemented in
> > >    lib/dim/dim.c
> > > - Net DIM (existing) logic is declared in include/linux/net_dim.h and
> > >    implemented in lib/dim/net_dim.c, which uses the common logic from=
 dim.h
> > > - Any new DIM logic will be declared in "/include/linux/new_dim.h" an=
d
> > >     implemented in "lib/dim/new_dim.c".
> > > - This new implementation will expose modified versions of profiles,
> > >    dim_step() and dim_decision().
> > >=20
> > > Pros for this solution are:
> > > - Zero impact on existing net_dim implementation and usage
> > > - Relatively more code reuse (compared to two separate solutions)
> > > - Increased extensibility
> > >=20
> > > Tal Gilboa (6):
> > >        linux/dim: Move logic to dim.h
> > >        linux/dim: Remove "net" prefix from internal DIM members
> > >        linux/dim: Rename externally exposed macros
> > >        linux/dim: Rename net_dim_sample() to net_dim_update_sample()
> > >        linux/dim: Rename externally used net_dim members
> > >        linux/dim: Move implementation to .c files
> > >=20
> > > Yamin Friedman (3):
> > >        linux/dim: Add completions count to dim_sample
> > >        linux/dim: Implement rdma_dim
> > >        RDMA/core: Provide RDMA DIM support for ULPs
> > Saeed,
> >=20
> > No, for the RDMA patches.
> > We need to see usage of those APIs before merging.
>=20
> I've asked Yamin to prepare patches for NVMeoF initiator and target for
> review, so I guess he has it on his plate (this is how he tested it..).
>=20
> It might cause conflict with NVMe/blk branch maintained by Sagi, Christop=
h
> and Jens.

It looks like nvme could pull this series + the RDMA patches into the
nvme tree via PR? I'm not familiar with how that tree works.

But we need to get the patches posted right away..

Jason
