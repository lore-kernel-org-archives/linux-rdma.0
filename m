From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/9] Support mlx5 flow steering with RAW data
Date: Tue, 10 Jul 2018 12:28:54 -0600
Message-ID: <20180710182854.GA24311@ziepe.ca>
References: <20180708102445.25496-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180708102445.25496-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 08, 2018 at 01:24:36PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> >From Yishai:
> 
> This series introduces vendor create and destroy flow methods on the
> uverbs flow object by using the KABI infra-structure.
> 
> It's done in a way that enables the driver to get its specific device
> attributes in a raw data to match its underlay specification while still
> using the generic ib_flow object for cleanup and code sharing.
> 
> In addition, a specific mlx5 matcher object and its create/destroy
> methods were introduced. This object matches the underlay flow steering
> mask specification and is used as part of mlx5 create flow input data.
> 
> This series supports IB_QP/TIR as its flow steering destination as
> applicable today via the ib_create_flow API, however, it adds also an
> option to work with DEVX object which its destination can be both TIR
> and flow table.
> 
> Few changes were done in the mlx5 core layer to support forward
> compatible for the device specification raw data and to support flow
> table when the DEVX destination is used.
> 
> As part of this series the default IB destroy handler
> (i.e. uverbs_destroy_def_handler()) was exposed from IB core to be
> used by the drivers and existing code was refactored to use it.
> 
> Thanks

>   IB: Enable uverbs_destroy_def_handler to be used by drivers

I applied this one

> Yishai Hadas (9):
>   net/mlx5: Add forward compatible support for the FTE match data
>   net/mlx5: Add support for flow table destination number
>   IB/mlx5: Introduce flow steering matcher object
>   IB: Consider ib_flow creation by the KABI infrastructure
>   IB/mlx5: Introduce vendor create and destroy flow methods
>   IB/mlx5: Support adding flow steering rule by raw data
>   IB/mlx5: Add support for a flow table destination
>   IB/mlx5: Expose vendor flow trees

The rest will need to be resent after the comments are addressed.

Thanks,
Jason
