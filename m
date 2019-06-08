From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Date: Sat, 8 Jun 2019 11:25:38 +0300
Message-ID: <20190608082538.GR5261@mtr-leonro.mtl.com>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-2-leon@kernel.org>
 <20190606115635.GA30976@dell5510>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606115635.GA30976@dell5510>
Sender: netdev-owner@vger.kernel.org
To: Petr Vorel <pvorel@suse.cz>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 06, 2019 at 01:56:36PM +0200, Petr Vorel wrote:
> Hi,
>
> > From: Maor Gottlieb <maorg@mellanox.com>
>
> > Add API to get the current Eswitch encap mode.
> > It will be used in downstream patches to check if
> > flow table can be created with encap support or not.
>
> > Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>

Thanks Petr for review, I'll add your tags and resend.

>
> Kind regards,
> Petr
