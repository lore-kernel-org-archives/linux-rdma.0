From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH] net/mlx5e: Fix trailing semicolon
Date: Wed, 17 Jan 2018 17:35:34 -0800
Message-ID: <83660c44-23d3-152c-4752-630d08ac5f0a@mellanox.com>
References: <20180117120915.18837-1-luisbg@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117120915.18837-1-luisbg@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@kernel.org>, linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, "David S . Miller" <davem@davemloft.net>, Alex Vesker <valex@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 01/17/2018 04:09 AM, Luis de Bethencourt wrote:
> The trailing semicolon is an empty statement that does no operation.
> Removing it since it doesn't do anything.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>

Looks Good, Thanks Luis.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
