From: Petr Vorel <pvorel@suse.cz>
Subject: Re: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Date: Wed, 12 Jun 2019 14:36:24 +0200
Message-ID: <20190612123624.GA25535@x230>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
Reply-To: Petr Vorel <pvorel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190612122014.22359-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Parav Pandit <parav@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

> From: Leon Romanovsky <leonro@mellanox.com>

> Devlink has UAPI declaration for encap mode, so there is no
> need to be loose on the data get/set by drivers.

> Update call sites to use enum devlink_eswitch_encap_mode
> instead of plain u8.

> Suggested-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
