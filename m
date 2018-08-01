From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx5e: Fix uninitialized variable
Date: Wed, 01 Aug 2018 09:38:24 -0700 (PDT)
Message-ID: <20180801.093824.692154182807362672.davem@davemloft.net>
References: <20180731142157.GA24066@embeddedor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731142157.GA24066@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com
Cc: tariqt@mellanox.com, saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 31 Jul 2018 09:21:57 -0500

> There is a potential execution path in which variable *err* is returned
> without being properly initialized previously.
> 
> Fix this by initializing variable *err* to 0.
> 
> Addresses-Coverity-ID: 1472116 ("Uninitialized scalar variable")
> Fixes: 0ec13877ce95 ("net/mlx5e: Gather all XDP pre-requisite checks in a single function")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied to net-next.
