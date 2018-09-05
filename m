From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5e: Make function
 mlx5i_grp_sw_update_stats() static
Date: Wed, 05 Sep 2018 08:06:45 -0700 (PDT)
Message-ID: <20180905.080645.298013872228567967.davem@davemloft.net>
References: <1536146162-132732-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1536146162-132732-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: weiyongjun1@huawei.com
Cc: saeedm@mellanox.com, leon@kernel.org, jgg@ziepe.ca, ogerlitz@mellanox.com, tariqt@mellanox.com, ferasda@mellanox.com, valex@mellanox.com, erezsh@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 5 Sep 2018 11:16:02 +0000

> Fixes the following sparse warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c:119:6: warning:
>  symbol 'mlx5i_grp_sw_update_stats' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
