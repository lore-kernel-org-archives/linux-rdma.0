From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net/mlx5e: fix high stack usage
Date: Fri, 2 Nov 2018 14:39:11 -0700
Message-ID: <2727f37b-1742-5532-317e-3be8a984266b@gmail.com>
References: <20181102153316.1492515-1-arnd@arndb.de>
 <9f214f12ec89020ceb14c1aec25b3a0d968507aa.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9f214f12ec89020ceb14c1aec25b3a0d968507aa.camel@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "davem@davemloft.net" <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>, "leon@kernel.org" <leon@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Eran Ben Elisha <eranbe@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>, Kamal Heib <kamalh@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 11/02/2018 02:05 PM, Saeed Mahameed wrote:
 
> temp will be mem copied to priv->stats.sw at the end,
> memcpy(&priv->stats.sw, &s, sizeof(s)); 
> 
> one other way to solve this as suggested by Andrew, is to get rid of
> the temp var and make it point directly to priv->stats.sw 
> 

What about concurrency ?

This temp variable is there to make sure concurrent readers of stats might
not see mangle data (because another 'reader' just did a memset() and is doing the folding)


mlx5e_get_stats() can definitely be run at the same time by multiple threads.
