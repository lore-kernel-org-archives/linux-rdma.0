From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 00/12] RDMA fixes 2018-06-24
Date: Tue, 26 Jun 2018 14:39:21 -0600
Message-ID: <20180626203921.GF5381@ziepe.ca>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180625213438.GA19857@ziepe.ca>
 <20180626042126.GM17747@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180626042126.GM17747@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 26, 2018 at 07:21:26AM +0300, Leon Romanovsky wrote:
> On Mon, Jun 25, 2018 at 03:34:38PM -0600, Jason Gunthorpe wrote:
> > On Sun, Jun 24, 2018 at 11:23:41AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Hi,
> > >
> > > This is bunch of patches trigged by running syzkaller internally.
> > >
> > > I'm sending them based on rdma-next mainly for two reasons:
> > > 1, Most of the patches fix the old issues and it doesn't matter when
> > > they will hit the Linus's tree: now or later in a couple of weeks
> > > during merge window.
> > > 2. They interleave with code cleanup, mlx5-next patches and Michael's
> > > feedback on flow counters series.
> > >
> > > Thanks
> > >
> > > Leon Romanovsky (12):
> > >   RDMA/uverbs: Protect from attempts to create flows on unsupported QP
> > >   RDMA/uverbs: Fix slab-out-of-bounds in ib_uverbs_ex_create_flow
> >
> > I applied these two to for-rc
> >
> > >   RDMA/uverbs: Check existence of create_flow callback
> > >   RDMA/verbs: Drop kernel variant of create_flow
> > >   RDMA/verbs: Drop kernel variant of destroy_flow
> > >   net/mlx5: Rate limit errors in command interface
> > >   RDMA/uverbs: Don't overwrite NULL pointer with ZERO_SIZE_PTR
> > >   RDMA/umem: Don't check for negative return value of dma_map_sg_attrs()
> > >   RDMA/uverbs: Remove redundant check
> >
> > These to for-next
> 
> Jason,
> 
> We would like to see patch "[PATCH mlx5-next 05/12] net/mlx5:
> Rate limit errors in command interface" in out mlx5-next. Is it possible
> at this point to drop it from for-next, so I'll be able to take it into
> mlx5-next?

Okay, you got to this while it was still 'wip', so it is dropped. Add
it to the mlx5-next branch and netdev or rdma can pull it next time
there is some reason to pull the branch..

Jason
