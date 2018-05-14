From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx5: Use 'kvfree()' for memory allocated by
 'kvzalloc()'
Date: Mon, 14 May 2018 14:56:42 -0400 (EDT)
Message-ID: <20180514.145642.989041199343505570.davem@davemloft.net>
References: <20180512170925.23690-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180512170925.23690-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: christophe.jaillet@wanadoo.fr
Cc: saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 12 May 2018 19:09:25 +0200

> 'out' is allocated with 'kvzalloc()'. 'kvfree()' must be used to free it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Saeed, I assume I will see this in one of your forthcoming pull
requests.

Thanks.
