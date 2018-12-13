From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5e: Remove set but not used variable
 'upriv'
Date: Wed, 12 Dec 2018 21:39:35 -0800 (PST)
Message-ID: <20181212.213935.1380628677390085263.davem@davemloft.net>
References: <1544603633-170212-1-git-send-email-yuehaibing@huawei.com>
        <20181212151012.GD3933@mtr-leonro.mtl.com>
        <78a81cd9ded813a3838a6cfcbe87c84d4fd1821b.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <78a81cd9ded813a3838a6cfcbe87c84d4fd1821b.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: yuehaibing@huawei.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 13 Dec 2018 01:24:06 +0000

> On Wed, 2018-12-12 at 17:10 +0200, Leon Romanovsky wrote:
>> On Wed, Dec 12, 2018 at 08:33:53AM +0000, YueHaibing wrote:
>> > Fixes gcc '-Wunused-but-set-variable' warning:
>> > 
>> > drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function
>> > 'mlx5e_vport_rep_load':
>> > drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1490:21: warning:
>> >  variable 'upriv' set but not used [-Wunused-but-set-variable]
>> > 
>> > drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function
>> > 'mlx5e_vport_rep_unload':
>> > drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1557:21: warning:
>> >  variable 'upriv' set but not used [-Wunused-but-set-variable]
>> > 
>> > It not used any more since commit ef381359e3a8 ("net/mlx5e: Replace
>> > egdev with
>> > indirect block notifications"). Also remove unused variable
>> > 'uplink_rpriv'
>> > after this change.
>> > 
>> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> > ---
>> >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 ----------
>> >  1 file changed, 10 deletions(-)
>> > 
>> 
>> Thanks,
>> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> 
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> Dave as agreed, you can apply this patch to net-next directly.

Done, thanks.
