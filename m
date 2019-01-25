From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 0/4] mlx5 next misc updates
Date: Fri, 25 Jan 2019 10:08:00 -0800
Message-ID: <CALzJLG9hjOZ=+pommPcjP0He_mBSUMK5+q3F9k8qGGhJvmJPQw@mail.gmail.com>
References: <20190119003313.16711-1-saeedm@mellanox.com> <20190124123041.GS3604@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190124123041.GS3604@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 24, 2019 at 4:30 AM Leon Romanovsky <leonro@mellanox.com> wrote:
>
> On Fri, Jan 18, 2019 at 04:33:09PM -0800, Saeed Mahameed wrote:
> > Hi all,
> >
> > This series includes updates to mlx5-next shared branch.
> >
> > 1) from Jason, improve mlx5_cmd_exec_cb async API to be safer
> > 2) from Maxim Mikityanskiy, cleanups for mlx5_write64 doorbell API
> > 3) from Michael Guralnik, Add pci AtomicOps request
> >
> > Thanks,
> > Saeed.
> >
> > ---
> >
> > Jason Gunthorpe (1):
> >   net/mlx5: Make mlx5_cmd_exec_cb() a safe API
> >
> > Michael Guralnik (1):
> >   net/mlx5: Add pci AtomicOps request
>
> Those two were applied to mlx5-next branch.
>
> ce4eee5340a9 (mlx5-next) net/mlx5: Add pci AtomicOps request
> e355477ed9e4 net/mlx5: Make mlx5_cmd_exec_cb() a safe API
>
> > Maxim Mikityanskiy (2):
> >   net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
> >   net/mlx5: Remove spinlock support from mlx5_write64
>
> Those two needs extra work,

What extra work ?

>
> Thanks
>
> >
> > --
> > 2.20.1
> >
