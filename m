From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3] net/mlx5e: Delete unneeded function argument
Date: Thu, 16 Aug 2018 12:28:22 -0700 (PDT)
Message-ID: <20180816.122822.242831640603681624.davem@davemloft.net>
References: <20180816090220.4537-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180816090220.4537-1-yuval.shaia@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yuval.shaia@oracle.com
Cc: saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Yuval Shaia <yuval.shaia@oracle.com>
Date: Thu, 16 Aug 2018 12:02:20 +0300

> priv argument is not used by the function, delete it.
> 
> Fixes: a89842811ea98 ("net/mlx5e: Merge per priority stats groups")
> Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
> v1 -> v2:
> 	* Remove blank line as pointed by Leon.
> 
> v2 -> v3:
> 	* Change prefix to mlx5e

Applied, thank you.
