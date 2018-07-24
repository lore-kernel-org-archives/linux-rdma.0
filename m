From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Mon, 23 Jul 2018 20:42:36 -0600
Message-ID: <20180724024236.GA16958@ziepe.ca>
References: <20180723122512.20967-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723122512.20967-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 23, 2018 at 03:25:04PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v1->v2:
>  * Fix matcher to use the correct size.
>  * Rephrase commit log of the first patch.
> v0->v1:
>  * Fixed ADD_UVERBS_ATTRIBUTES_SIMPLE macro to pass the real address.
>  ?* Replaced UA_ALLOC_AND_COPY to regular copy_from
>  * Added UVERBS_ATTR_NO_DATA new macro for cleaner code.
>  * Used ib_dev from uobj when it exists.
>  * ib_is_destroy_retryable was replaced by ib_destroy_usecnt
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
> 
> Yishai Hadas (8):
>   net/mlx5: Add forward compatible support for the FTE match data
>   net/mlx5: Add support for flow table destination number
>   IB/mlx5: Introduce flow steering matcher object
>   IB: Consider ib_flow creation by the KABI infrastructure
>   IB/mlx5: Introduce vendor create and destroy flow methods
>   IB/mlx5: Support adding flow steering rule by raw data
>   IB/mlx5: Add support for a flow table destination
>   IB/mlx5: Expose vendor flow trees

This seems fine to me. Can you send the mlx5 shared branch for the
first two patches?

Thanks,
Jason
