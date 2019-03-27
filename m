From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/4] Small set of mlx5 related fixes
Date: Wed, 27 Mar 2019 15:29:56 -0300
Message-ID: <20190327182956.GA14341@ziepe.ca>
References: <20190319092439.10701-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319092439.10701-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 19, 2019 at 11:24:35AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> Despite one change in mlx5_core, all those changes are for mlx5_ib. The
> change in mlx5_core is related to MR cache initialization that is not
> used in mlx5_core at all.
> 
> Thanks
> 
> Artemy Kovalyov (3):
>   IB/mlx5: WQE dump jumps over first 16 bytes
>   IB/mlx5: Compare only index part of a memory window rkey

Applied to for-next

>   net/mlx5: Decrease default mr cache size

For you and Saeed
 
> Moni Shoua (1):
>   IB/mlx5: Reset access mask when looping inside page fault handler

I sent this one to for-rc since it is @stable

Thanks,
Jason
