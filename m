From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next v2 07/17] IB/mlx5: Support set qp counter
Date: Mon, 29 Apr 2019 21:38:32 +0300
Message-ID: <20190429183832.GA6705@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-8-leon@kernel.org>
 <ecdb1a67243d50854af74fb95271cc63e9b6c508.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ecdb1a67243d50854af74fb95271cc63e9b6c508.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 06:22:03PM +0000, Saeed Mahameed wrote:
> On Mon, 2019-04-29 at 11:34 +0300, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > Support bind a qp with counter. If counter is null then bind the qp
> > to
> > the default counter. Different QP state has different operation:
> > - RESET: Set the counter field so that it will take effective
> >   during RST2INIT change;
> > - RTS: Issue an RTS2RTS change to update the QP counter;
> > - Other: Set the counter field and mark the counter_pending flag,
> >   when QP is moved to RTS state and this flag is set, then issue
> >   an RTS2RTS modification to update the counter.
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++
> >  drivers/infiniband/hw/mlx5/qp.c      | 76
> > +++++++++++++++++++++++++++-
> >  include/linux/mlx5/qp.h              |  1 +
>
> I don't see any reason why this patch should go to mlx5-next branch.
> Just because you have one liner in include/linux/mlx5/qp.h, is not
> enough reason.
>

I'm changing target automatically based on get_maintainer.pl output.

If "$GET_MAINTAINER --email --nol --nos --nosubsystem --noroles $_file | grep Saeed -c"
returns Saeed, it means that such patch has all potential to create merge conflict.

Thanks
