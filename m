From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH mlx5-next 4/4] net/mlx5: Move flow counters data
 structures from flow steering header
Date: Tue, 4 Dec 2018 21:04:43 -0800
Message-ID: <CAM_iQpX4W4svScQC+49gbx84om4gRLa9L5oKP01-H23ZuQ-PNw@mail.gmail.com>
References: <20181205020303.16318-1-saeedm@mellanox.com> <20181205020303.16318-5-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205020303.16318-5-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: leonro@mellanox.com, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 4, 2018 at 6:05 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> After the following flow counters API refactoring:
> ("net/mlx5: Use flow counter IDs and not the wrapping cache object")
> flow counters private data structures mlx5_fc_cache and mlx5_fc are
> redundantly exposed in fs_core.h, they have nothing to do with flow
> steering core and they are private to fs_counter.c, this patch moves them
> to where they belong and reduces their exposure in the driver.
>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/fs_core.h | 23 -------------------
>  .../ethernet/mellanox/mlx5/core/fs_counters.c | 23 +++++++++++++++++++

The #include <linux/llist.h> can be moved together too.
