From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v1 0/5] Cleanup of
 CONFIG_INFINIBAND_ON_DEMAND_PAGING usage
Date: Mon, 7 Jan 2019 11:31:28 -0700
Message-ID: <20190107183128.GA4613@ziepe.ca>
References: <20181223091418.26218-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181223091418.26218-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 23, 2018 at 11:14:13AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog v0->v1:
>  * Don't set ODP caps always (patch #2)
>  * Set invalidate_range callback based on device_cap only
> 
> -------------------------------------------------------------------------------
> 
> Hi,
> 
> As a followup to Jason's request to rethink CONFIG_INFINIBAND_ON_DEMAND_PAGING
> usage, this series cleans mlx5_ib and RDMA/core code and it is based on accepted
> patch https://patchwork.kernel.org/patch/10735547/
> 
> I think that we will see more patches in that area, I would like to
> remove CONFIG_INFINIBAND_ON_DEMAND_PAGING completely.
> 
> Thanks
> 
> Leon Romanovsky (5):
>   RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
>   RDMA/core: Don't depend device ODP capabilities on kconfig option
>   RDMA/mlx5: Introduce and reuse helper to identify ODP MR
>   RDMA/mlx5: Embed into the code flow the ODP config option
>   RDMA/mlx5: Delete declaration of already removed function

This doesn't apply anymore, can you resend it please?

Jason
