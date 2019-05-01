From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-for-next 0/9] drivers/infiniband: Introduce rdma_dim
Date: Wed, 1 May 2019 13:04:09 -0300
Message-ID: <20190501160409.GA15547@ziepe.ca>
References: <1556721879-35987-1-git-send-email-talgi@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1556721879-35987-1-git-send-email-talgi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Tal Gilboa <talgi@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Idan Burstein <idanb@mellanox.com>, Yamin Friedman <yaminf@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 01, 2019 at 05:44:30PM +0300, Tal Gilboa wrote:
> net_dim.h lib exposes an implementation of the DIM algorithm for dynamically-tuned interrupt
> moderation for networking interfaces.
> 
> We want a similar functionality for RDMA. The main motivation is to benefit from maximized
> completion rate and reduced interrupt overhead that DIM may provide.
> 
> Current DIM implementation prioritizes reducing interrupt overhead over latency. Also, in
> order to reduce DIM's own overhead, the algorithm might take take some time to identify it
> needs to change profiles. For these reasons we got to the understanding that a slightly
> modified algorithm is needed. Early tests with current implementation show it doesn't react
> fast and sharply enough in order to satisfy the RDMA CQ needs.
> 
> I would like to suggest an implementation for RDMA DIM. The idea is to expose the new
> functionality without the risk of breaking Net DIM behavior for netdev. Below are main
> similarities and differences between the two implementations and general guidelines for the
> suggested solution.
> 
> Performance improvement (ConnectX-5 100GbE, x86) running FIO benchmark over
> NVMf between two equal end-hosts with 56 cores across a Mellanox switch
> using null_blk device:
> 
> READS without DIM:
> blk size | BW       | IOPS | 99th percentile latency  | 99.99th latency
> 512B     | 3.8GiB/s | 7.7M | 1401  usec               | 2442  usec
> 4k       | 7.0GiB/s | 1.8M | 4817  usec               | 6587  usec
> 64k      | 10.7GiB/s| 175k | 9896  usec               | 10028 usec
> 
> IO WRITES without DIM:
> blk size | BW       | IOPS | 99th percentile latency  | 99.99th latency
> 512B     | 3.6GiB/s | 7.5M | 1434  usec               | 2474  usec
> 4k       | 6.3GiB/s | 1.6M | 938   usec               | 1221  usec
> 64k      | 10.7GiB/s| 175k | 8979  usec               | 12780 usec
> 
> IO READS with DIM:
> blk size | BW       | IOPS | 99th percentile latency  | 99.99th latency
> 512B     | 4GiB/s   | 8.2M | 816    usec              | 889   usec
> 4k       | 10.1GiB/s| 2.65M| 3359   usec              | 5080  usec
> 64k      | 10.7GiB/s| 175k | 9896   usec              | 10028 usec
> 
> IO WRITES with DIM:
> blk size | BW       | IOPS  | 99th percentile latency | 99.99th latency
> 512B     | 3.9GiB/s | 8.1M  | 799   usec              | 922   usec
> 4k       | 9.6GiB/s | 2.5M  | 717   usec              | 1004  usec
> 64k      | 10.7GiB/s| 176k  | 8586  usec              | 12256 usec
> 
> Common logic, main DIM procedure:
> - Calculate current stats from a given sample
> - Compare current stats vs. previous iteration stats
> - Make a decision -> choose a new profile
> 
> Differences:
> - Different parameters for moving between profiles
> - Different moderation values and number of profiles
> - Different sampled data
> 
> Suggested solution:
> - Common logic will be declared in include/linux/dim.h and implemented in lib/dim/dim.c
> - Net DIM (existing) logic will be declared in include/linux/net_dim.h and implemented in
>   lib/dim/net_dim.c, which will use the common logic from dim.h
> - RDMA DIM logic will be declared in /include/linux/rdma_dim.h and implemented in
>   lib/dim/rdma_dim.c.
>   This new implementation will expose modified versions of profiles, dim_step() and dim_decision()
> 
> Pros for this solution are:
> - Zero impact on existing net_dim implementation and usage
> - Relatively more code reuse (compared to two separate solutions)
> - Readiness for future implementations
>  
> Tal Gilboa (6):
>   linux/dim: Move logic to dim.h
>   linux/dim: Remove "net" prefix from internal DIM members
>   linux/dim: Rename externally exposed macros
>   linux/dim: Rename net_dim_sample() to net_dim_create_sample()
>   linux/dim: Rename externally used net_dim members
>   linux/dim: Move implementation to .c files
> 
> Yamin Friedman (3):
>   linux/dim: Add completions count to dim_sample
>   linux/dim: Implement rdma_dim
>   drivers/infiniband: Use rdma_dim in infiniband driver
> 
>  MAINTAINERS                                        |   3 +
>  drivers/infiniband/core/cq.c                       |  79 ++++-
>  drivers/infiniband/hw/mlx4/qp.c                    |   2 +-
>  drivers/infiniband/hw/mlx5/qp.c                    |   2 +-
>  drivers/net/ethernet/broadcom/bcmsysport.c         |  20 +-
>  drivers/net/ethernet/broadcom/bcmsysport.h         |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  13 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_debugfs.c  |   4 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_dim.c      |   7 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  18 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en.h       |   8 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_dim.c   |  12 +-
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  22 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  12 +-

A lot of this is touching netdev, why wasn't netdev cc'd?

Who is supposed to merge this? 

I think you need to take two steps and have netdev merge the above
part and then send the single patch to RDMA for the last part, I don't
really want to take so much netdev code here.

The maintainers file should also have some indication which tree
patches for lib/dim/* this should go through..

Jason
