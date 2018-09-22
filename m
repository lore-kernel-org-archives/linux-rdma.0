From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v1 0/7] Preparation to DevX extension series
Date: Sat, 22 Sep 2018 11:02:07 -0600
Message-ID: <20180922170207.GA13493@ziepe.ca>
References: <20180920183526.13995-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920183526.13995-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2018 at 09:35:19PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog v0->v1:
>  * Update commit messages
>  * Split DevX series to small sub-series.
>  * Change static initialization from {0} to be {}
> 
> 
> Set uid as part of various IB commands so that the firmware can manage
> the IB object in a secured way.
> 
> The firmware should mark this IB object with the given uid so that it
> can be used later on only by objects with the same uid.
> 
> Upon DEVX flows that use this objec, the pointed object must have
> the same uid as of the issuer uid command.
> 
> When a command is issued with uid=0 it means that the issuer of the
> command is trusted (i.e. kernel), in that case any pointed object
> can be used regardless of its uid.
> 
> Thanks
> 
> Leon Romanovsky (1):
>   net/mlx5: Update mlx5_ifc with DEVX UID bits
> 
> Yishai Hadas (6):
>   net/mlx5: Set uid as part of CQ commands
>   net/mlx5: Set uid as part of QP commands
>   net/mlx5: Set uid as part of RQ commands
>   net/mlx5: Set uid as part of SQ commands
>   net/mlx5: Set uid as part of SRQ commands
>   net/mlx5: Set uid as part of DCT commands

This and the next series look OK to me. Let me know when it is applied
to the mlx branch

Thanks,
Jason
