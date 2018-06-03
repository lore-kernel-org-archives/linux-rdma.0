From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5: Make function
 mlx5_fpga_tls_send_teardown_cmd() static
Date: Sun, 03 Jun 2018 10:36:56 -0400 (EDT)
Message-ID: <20180603.103656.143543894098036180.davem@davemloft.net>
References: <1527733872-149077-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527733872-149077-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: weiyongjun1@huawei.com
Cc: borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org, ilyal@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Thu, 31 May 2018 02:31:12 +0000

> Fixes the following sparse warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c:199:6: warning:
>  symbol 'mlx5_fpga_tls_send_teardown_cmd' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
