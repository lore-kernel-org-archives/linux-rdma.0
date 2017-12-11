From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: IB/mlx5: revisit -Wmaybe-uninitialized warning
Date: Mon, 11 Dec 2017 16:41:23 -0700
Message-ID: <20171211234123.GI32020@ziepe.ca>
References: <20171211114600.3636211-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211114600.3636211-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 12:45:44PM +0100, Arnd Bergmann wrote:
> A warning that I thought I had fixed before occasionally comes
> back in rare randconfig builds (I found 7 instances in the last
> 100000 builds, originally it was much more frequent):
> 
> drivers/infiniband/hw/mlx5/mr.c: In function 'mlx5_ib_reg_user_mr':
> drivers/infiniband/hw/mlx5/mr.c:1229:5: error: 'order' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>   if (order <= mr_cache_max_order(dev)) {
>      ^
> drivers/infiniband/hw/mlx5/mr.c:1247:8: error: 'ncont' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/infiniband/hw/mlx5/mr.c:1247:8: error: 'page_shift' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/infiniband/hw/mlx5/mr.c:1260:2: error: 'npages' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> I've looked at all those findings again and noticed that they are all
> with CONFIG_INFINIBAND_USER_MEM=n, which means ib_umem_get() returns
> an error unconditionally and we never initialize or use those variables.
> This triggers a condition in gcc iff mr_umem_get() is partially but not
> entirely inlined, which in turn depends on the exact combination of
> optimization settings. This is a known problem with gcc, with no
> easy solution in the compiler, so this adds another workaround that
> should be more reliable than my previous attempt.
> 
> Returning an error from mlx5_ib_reg_user_mr() earlier means that we
> can completely bypass the logic that caused the warning, the compiler
> can now see that the variable is never accessed.
> 
> Fixes: 14ab8896f5d9 ("IB/mlx5: avoid bogus -Wmaybe-uninitialized warning")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>  drivers/infiniband/hw/mlx5/mr.c | 3 +++
>  1 file changed, 3 insertions(+)

Appled to for-next, thanks

Jason
