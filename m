From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH][next] net/mlx5: add missing void argument to function
 mlx5_devlink_alloc
Date: Tue, 18 Jun 2019 22:30:23 -0400 (EDT)
Message-ID: <20190618.223023.244389297657538568.davem@davemloft.net>
References: <20190618151510.18672-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618151510.18672-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: colin.king@canonical.com
Cc: saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 18 Jun 2019 16:15:10 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Function mlx5_devlink_alloc is missing a void argument, add it
> to clean up the non-ANSI function declaration.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
