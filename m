From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 00/12] Add SRQ and XRC support for ODP MRs
Date: Thu, 31 Jan 2019 16:27:39 -0700
Message-ID: <20190131232739.GA13446@ziepe.ca>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 22, 2019 at 08:48:39AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This series extend ODP to work with SRQ and XRC. Being both per-operation
> (e.g. RDMA write, RDMA read and atomic) and per-transport (e.g. RC, UD and XRC),
> we extend IB/core and mlx5 driver to provide needed information to user space.
> 
> Thanks
> 
> Moni Shoua (12):
>   IB/mlx5: Fix locking SRQ object in ODP event
>   IB/core: Allocate bit for SRQ ODP support
>   IB/uverbs: Expose XRC ODP device capabilities
>   IB/mlx5: Remove useless check in ODP handler
>   IB/mlx5: Clean mlx5_ib_mr_responder_pfault_handler() signature
>   IB/mlx5: Add XRC initiator ODP support
>   IB/mlx5: Let read user wqe also from SRQ buffer
>   IB/mlx5: Add ODP SRQ support
>   IB/mlx5: Advertise SRQ ODP support for supported transports

I applied these patches to for-next

>   net/mlx5: Add XRC transport to ODP device capabilities layout
>   IB/mlx5: Advertise XRC ODP support
>   net/mlx5: Set ODP SRQ support in firmware

This might need some re-organizing - the last patch could be split
(possibly merge with the first) so the header changes can go to the
shared branch, but the handle_hca_cap_odp() stuff must only be applied
to the rdma tree.

I'm fine either way, if you don't want to split it send a commit ID
for the first patch on mlx5-next.

Thanks,
Jason
