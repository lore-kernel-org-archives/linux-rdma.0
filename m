From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
Date: Mon, 24 Oct 2016 22:46:26 +0200
Message-ID: <4613531.FpoFIBnNDo@wuerfel>
References: <20161024151658.2413803-1-arnd@arndb.de> <20161024170642.GL25013@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161024170642.GL25013@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Noa Osherovich <noaos@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Monday, October 24, 2016 8:06:42 PM CEST Leon Romanovsky wrote:
> 
> Acked-by: Leon Romanovsky <leonro@mellanox.com>

Thanks!

> >  drivers/infiniband/hw/mlx5/mr.c | 39 +++++++++++++++++++++------------------
> >  1 file changed, 21 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> > index d4ad672b905b..88d8d292677b 100644
> > --- a/drivers/infiniband/hw/mlx5/mr.c
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -815,29 +815,33 @@ static void prep_umr_unreg_wqe(struct mlx5_ib_dev *dev,
> >       umrwr->mkey = key;
> >  }
> >
> > -static struct ib_umem *mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
> > -                                int access_flags, int *npages,
> > -                                int *page_shift, int *ncont, int *order)
> > +static int mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
> > +                    int access_flags, struct ib_umem ** umem,
> 
> I wonder if checkpatch does differentiate between "struct ib_umem ** umem"
> and "struct ib_umem **umem". According to coding style, the second is preferable.

It was unintended, I'll send a v2 patch in a minute.

	Arnd
