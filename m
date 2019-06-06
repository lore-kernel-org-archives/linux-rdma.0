From: Petr Vorel <pvorel@suse.cz>
Subject: Re: [PATCH rdma-next 2/3] RDMA/mlx5: Consider eswitch encap mode
Date: Thu, 6 Jun 2019 13:56:55 +0200
Message-ID: <20190606115655.GB30976@dell5510>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-3-leon@kernel.org>
Reply-To: Petr Vorel <pvorel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606110609.11588-3-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

> From: Maor Gottlieb <maorg@mellanox.com>

> When flow steering is created, then the encap support should
> consider the eswitch encap mode. If the eswitch flow table (FDB)
> supports encap then it shouldn't be supported on NIC RX flow tables.

> Fixes: 4adda1122c490 ('RDMA/mlx5: Enable decap and packet reformat on flow tables')
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
