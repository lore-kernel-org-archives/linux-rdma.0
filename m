From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 00/17] Statistics counter support
Date: Wed, 22 May 2019 14:31:17 -0300
Message-ID: <20190522173117.GH15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:36AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
>  v1 -> v2:
>  * Rebased to latest rdma-next
>  v0 -> v1:
>  * Changed wording of counter comment
>  * Removed unneeded assignments
>  * Added extra patch to present global counters
> 
>  * I didn't change QP type from int to be enum ib_qp_type,
>    because it caused to cyclic dependency between ib_verbs.h and
>    rdma_counter.h.
> 
> 
> Hi,
> 
> This series from Mark provides dynamic statistics infrastructure.
> He uses netlink interface to configure and retrieve those counters.
> 
> This infrastructure allows to users monitor various objects by binding
> to them counters. As the beginning, we used QP object as target for
> those counters, but future patches will include ODP MR information too.
> 
> Two binding modes are supported:
>  - Auto: This allows a user to build automatic set of objects to a counter
>    according to common criteria. For example in a per-type scheme, where in
>    one process all QPs with same QP type are bound automatically to a single
>    counter.
>  - Manual: This allows a user to manually bind objects on a counter.
> 
> Those two modes are mutual-exclusive with separation between processes,
> objects created by different processes cannot be bound to a same counter.
> 
> For objects which don't support counter binding, we will return
> pre-allocated counters.
> 
> $ rdma statistic qp set link mlx5_2/1 auto type on
> $ rdma statistic qp set link mlx5_2/1 auto off
> $ rdma statistic qp bind link mlx5_2/1 lqpn 178
> $ rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
> $ rdma statistic show
> $ rdma statistic qp mode

Can you please include the command outputs?

Jason
