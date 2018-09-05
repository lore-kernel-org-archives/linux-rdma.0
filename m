From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v1 00/15] Flow actions to mutate packets
Date: Wed, 5 Sep 2018 15:29:50 -0600
Message-ID: <20180905212950.GD21028@ziepe.ca>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180904221205.GB3895@ziepe.ca>
 <20180905051458.GD2977@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905051458.GD2977@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 05, 2018 at 08:14:58AM +0300, Leon Romanovsky wrote:

> > This looks OK to me, can you make the shared commit please?
> 
> Thanks, I pushed to mlx5-next
> 
> 50acec06f392 net/mlx5: Export packet reformat alloc/dealloc functions
> 31ca3648f01b net/mlx5: Pass a namespace for packet reformat ID allocation
> bea4e1f6c6c5 net/mlx5: Expose new packet reformat capabilities
> 60786f0987c0 {net, RDMA}/mlx5: Rename encap to reformat packet
> e0e7a3861b6c net/mlx5: Move header encap type to IFC header file
> 61444b458b01 net/mlx5: Break encap/decap into two separated flow table creation flags
> c3c062f80665 net/mlx5: Add support for more namespaces when allocating modify header
> 90c1d1b8da67 net/mlx5: Export modify header alloc/dealloc functions
> 8ce78257965e net/mlx5: Add proper NIC TX steering flow tables support
> 2226dcb424bf net/mlx5: Cleanup flow namespace getter switch logic

Okay, done thanks

Jason
