From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix DCT creation bad flow
Date: Wed, 6 Mar 2019 20:57:00 +0200
Message-ID: <20190306185700.GH1789@mtr-leonro.mtl.com>
References: <20190306172050.20033-1-leon@kernel.org>
 <20190306185212.GQ1758@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190306185212.GQ1758@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 06, 2019 at 08:52:16PM +0200, Jason Gunthorpe wrote:
> On Wed, Mar 06, 2019 at 07:20:50PM +0200, Leon Romanovsky wrote:
> > From: Yishai Hadas <yishaih@mellanox.com>
> >
> > In case the DCT creation command has succeeded a DRAIN must be issued
> > before calling DESTROY.
> >
> > In addition, the original code used the wrong parameter for the DESTROY
> > command, 'in' instead of 'din', which caused another creation try
> > instead of destroying.
> >
> > Cc: <stable@vger.kernel.org> # 4.15
> > Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
> > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > Jason, Doug
> >
> > If it is possible, I would like to take this patch too:
> > https://patchwork.kernel.org/patch/10828299/
>
> This should have been applied to the shared tree though??
>
> It is RDMA focused, do you want it to go to the RDMA tree?

Yes, it will be awesome, because net-next is closed, there is no need in
shared tree.

Thanks

>
> Jason
