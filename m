From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx5e: hide an unused variable
Date: Fri, 05 Jan 2018 10:56:24 -0500 (EST)
Message-ID: <20180105.105624.1086162210595261552.davem@davemloft.net>
References: <20180103224022.3737385-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180103224022.3737385-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de
Cc: saeedm@mellanox.com, matanb@mellanox.com, leonro@mellanox.com, ogerlitz@mellanox.com, hadarh@mellanox.com, paulb@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed,  3 Jan 2018 23:40:11 +0100

> The uplink_rpriv variable was added at the start of the function but
> only used inside of an #ifdef:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c: In function 'mlx5e_route_lookup_ipv6':
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:1549:25: error: unused variable 'uplink_rpriv' [-Werror=unused-variable]
> 
> This moves the declaration into that #ifdef as well.
> 
> Fixes: 5ed99fb421d4 ("net/mlx5e: Move ethernet representors data into separate struct")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.

Please make it clear which tree you are targetting in your Subject lines
in the future.  This should have been "[PATCH net-next] ...".
