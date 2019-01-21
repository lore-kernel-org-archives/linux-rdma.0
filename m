From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 4/4] net/mlx5: Remove spinlock support from mlx5_write64
Date: Mon, 21 Jan 2019 10:12:58 -0800
Message-ID: <CALzJLG9Lr4VcOpYLXKNHmHLzjxDCMN6AvaTRjW7ZZEMukPdZ4w@mail.gmail.com>
References: <20190119003313.16711-1-saeedm@mellanox.com> <20190119003313.16711-5-saeedm@mellanox.com>
 <20190119074308.GH15600@mtr-leonro.mtl.com> <20190121164551.GF25149@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190121164551.GF25149@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Maxim Mikityanskiy <maximmi@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 21, 2019 at 8:46 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Sat, Jan 19, 2019 at 12:43:14AM -0700, Leon Romanovsky wrote:
> > You need to do one of two things:
> > 1. Require CONFIG_64BIT and delete this 32bit code.
> > 2. Declare global mlx5 DB spinlock and use on 32bit systems, something
> > like this:
> > #if BITS_PER_LONG == 64
> >  __raw_writeq(*(u64 *)val, dest);
> > #else
> >   spin_lock_irqsave(doorbell_lock, flags);
> >   __raw_writel((__force u32) val[0], dest);
> >   __raw_writel((__force u32) val[1], dest + 4);
> >    spin_unlock_irqrestore(doorbell_lock, flags);
> > #endif
>
> And why is this code using the __raw_ versions? Seems wrong too...
>

for 64 and 32 as well?
what is wrong with the raw version ?

> Jason
