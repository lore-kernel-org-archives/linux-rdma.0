From: David Miller <davem@davemloft.net>
Subject: Re: [patch net-next] net/mlx4_en: fix a condition
Date: Mon, 06 Feb 2017 12:01:14 -0500 (EST)
Message-ID: <20170206.120114.1158013558292422641.davem@davemloft.net>
References: <20170203095459.GA5704@mwanda>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170203095459.GA5704@mwanda>
Sender: netdev-owner@vger.kernel.org
To: dan.carpenter@oracle.com
Cc: yishaih@mellanox.com, shakerd@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 3 Feb 2017 12:54:59 +0300

> There is a "||" vs "|" typo here so we test 0x1 instead of 0x6.
> 
> Fixes: 1f8176f7352a ("net/mlx4_en: Check the enabling pptx/pprx flags in SET_PORT wrapper flow")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
