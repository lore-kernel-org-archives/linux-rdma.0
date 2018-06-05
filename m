From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5e: Make function
 mlx5e_change_rep_mtu() static
Date: Tue, 05 Jun 2018 10:20:03 -0400 (EDT)
Message-ID: <20180605.102003.937168132047996557.davem@davemloft.net>
References: <1528166565-54828-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1528166565-54828-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: weiyongjun1@huawei.com
Cc: saeedm@mellanox.com, leon@kernel.org, adin@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Tue, 5 Jun 2018 02:42:45 +0000

> Fixes the following sparse warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:903:5: warning:
>  symbol 'mlx5e_change_rep_mtu' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
