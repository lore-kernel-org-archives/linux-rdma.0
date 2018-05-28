From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 02/13] net/mlx5: Export flow counter related
 API
Date: Mon, 28 May 2018 12:16:37 +0300
Message-ID: <20180528091637.GJ3085@mtr-leonro.mtl.com>
References: <20180527102346.15149-1-leon@kernel.org>
 <20180527102346.15149-3-leon@kernel.org>
 <CAJ3xEMg_2zd1yr4vZjvgEEmAAYbXX9Ax9C+Jtyt87eQNrioPVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMg_2zd1yr4vZjvgEEmAAYbXX9Ax9C+Jtyt87eQNrioPVA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Raed Salem <raeds@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 28, 2018 at 11:34:18AM +0300, Or Gerlitz wrote:
> On Sun, May 27, 2018 at 1:23 PM, Leon Romanovsky <leon@kernel.org> wrote:
> > From: Raed Salem <raeds@mellanox.com>
> >
> > Exports counters API to be used in both IB and EN.
> >
> > Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> > Signed-off-by: Raed Salem <raeds@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 23 ----------------------
> >  .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  3 +++
> >  include/linux/mlx5/fs.h                            | 22 +++++++++++++++++++++
> >  3 files changed, 25 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
> > index b6da322a8016..40992aed1791 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
> > @@ -131,29 +131,6 @@ struct mlx5_flow_table {
> >         struct rhltable                 fgs_hash;
> >  };
> >
> > -struct mlx5_fc_cache {
> > -       u64 packets;
> > -       u64 bytes;
> > -       u64 lastuse;
> > -};
> > -
> > -struct mlx5_fc {
> > -       struct rb_node node;
> > -       struct list_head list;
> > -
> > -       /* last{packets,bytes} members are used when calculating the delta since
> > -        * last reading
> > -        */
> > -       u64 lastpackets;
> > -       u64 lastbytes;
> > -
> > -       u32 id;
> > -       bool deleted;
> > -       bool aging;
> > -
> > -       struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
> > -};
> > -
>
> are you using the caching services @ the IB driver? please point me to
> the patch that does so

IB doesn't use cache, but uses "struct mlx5_fc", which needs
mlx5_fc_cache struct for compilation.

For example in this patch [1], Raed uses "struct mlx5_fc".

[1] https://patchwork.ozlabs.org/patch/921076/

Thanks
