From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5e: fix error return code in
 mlx5e_alloc_rq()
Date: Tue, 05 Jun 2018 10:20:57 -0400 (EDT)
Message-ID: <20180605.102057.1833899340780364135.davem@davemloft.net>
References: <1528166576-55047-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1528166576-55047-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: weiyongjun1@huawei.com
Cc: saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Tue, 5 Jun 2018 02:42:56 +0000

> Fix to return error code -ENOMEM from the kvzalloc_node() error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue memory scheme")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
