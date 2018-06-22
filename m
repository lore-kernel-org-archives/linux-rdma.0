From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/2] RoCE ICRC counter
Date: Fri, 22 Jun 2018 09:03:52 -0600
Message-ID: <20180622150352.GA26942@ziepe.ca>
References: <20180621123756.32645-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180621123756.32645-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Talat Batheesh <talatb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 21, 2018 at 03:37:54PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This series exposes RoCE ICRC counter through existing RDMA hw_counters
> sysfs interface.
> 
> First patch has all HW definitions in mlx5_ifc.h file and second patch is
> actual counter implementation.
> 
> Thanks
> 
> Talat Batheesh (2):
>   net/mlx5: Add RoCE RX ICRC encapsulated counter
>   IB/mlx5: Support RoCE ICRC encapsulated error counter
> 
>  drivers/infiniband/hw/mlx5/cmd.c     | 12 +++++++
>  drivers/infiniband/hw/mlx5/cmd.h     |  1 +
>  drivers/infiniband/hw/mlx5/main.c    | 62 ++++++++++++++++++++++++++++++++++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
>  include/linux/mlx5/mlx5_ifc.h        | 11 +++++--
>  5 files changed, 81 insertions(+), 6 deletions(-)

Applied to rdma for-next with the mellanox/mlx5-next branch

Thanks,
Jason
