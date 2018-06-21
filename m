From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] RoCE ICRC counter
Date: Thu, 21 Jun 2018 11:43:07 -0600
Message-ID: <20180621174307.GH18143@mellanox.com>
References: <20180621123756.32645-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180621123756.32645-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Talat Batheesh <talatb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 21, 2018 at 03:37:54PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This series exposes RoCE ICRC counter through existing RDMA hw_counters
> sysfs interface.
> 
> First patch has all HW definitions in mlx5_ifc.h file and second patch is
> actual counter implementation.

The RDMA parts are OK, can you please send me the commit for the mlx5
patch when applied?

Thanks,
Jason
