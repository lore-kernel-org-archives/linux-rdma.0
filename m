From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/3] Indirect MKEY over DEVX
Date: Mon, 21 Jan 2019 20:08:00 -0700
Message-ID: <20190122030800.GA18299@ziepe.ca>
References: <20190113140118.10204-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190113140118.10204-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 13, 2019 at 04:01:15PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> >From Yishai,
> 
> This series enables using indirect mkey over DEVX.
> 
> The first patch recognizes the creation of an indirect mkey as part of
> DEVX object creation, in that case the umem valid bit shouldn't be set as
> this mkey doesn't really hold a umem.
> 
> The next two patches manage indirection mkey upon DEVX flow to support ODP.
> 
> To support a page fault event on an indirection mkey it needs to be part
> of the device mkey radix tree. Both the creation and the deletion flows for a
> DEVX object which is indirection mkey were adapted to handle that.
> 
> In addition, the page fault flow was adapted to support indirect mkey type,
> it's handled in a similar flow as of the memory window mkey type.
> 
> Yishai
> 
> Yishai Hadas (3):
>   IB/mlx5: DEVX handling for indirection MKEY
>   IB/mlx5: Manage indirection mkey upon DEVX flow for ODP
>   IB/mlx5: Add support for ODP for DEVX indirection mkey

applied to for-next

Thanks,
Jason
