From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] net/mlx5: Fix use-after-free
Date: Fri, 23 Mar 2018 13:06:19 -0400 (EDT)
Message-ID: <20180323.130619.2053176034900779506.davem@davemloft.net>
References: <20180322184456.GA22259@embeddedgus>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322184456.GA22259@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com
Cc: yuval.shaia@oracle.com, ilant@mellanox.com, borisp@mellanox.com, saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Thu, 22 Mar 2018 13:44:56 -0500

> _rule_ is being freed and then dereferenced by accessing rule->ctx
> 
> Fix this by copying the value returned by PTR_ERR(rule->ctx) into a local
> variable for its safe use after freeing _rule_
> 
> Addresses-Coverity-ID: 1466041 ("Read from pointer after free")
> Fixes: 05564d0ae075 ("net/mlx5: Add flow-steering commands for FPGA IPSec implementation")
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> Changes in v2:
>  - Use a short subject prefix as suggested by Yuval Shaia.
>  - Add Yuval's Reviewed-by.

Applied to net-next.

Thank you.
