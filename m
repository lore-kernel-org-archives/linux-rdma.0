From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] net/mlx5e: Fix uninitialized variable
Date: Wed, 1 Aug 2018 12:19:46 -0500
Message-ID: <59441d71-aa91-8b0a-a5e2-7ae86ed20e93@embeddedor.com>
References: <20180731142157.GA24066@embeddedor.com>
 <20180801.093824.692154182807362672.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180801.093824.692154182807362672.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: tariqt@mellanox.com, saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 08/01/2018 11:38 AM, David Miller wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Date: Tue, 31 Jul 2018 09:21:57 -0500
> 
>> There is a potential execution path in which variable *err* is returned
>> without being properly initialized previously.
>>
>> Fix this by initializing variable *err* to 0.
>>
>> Addresses-Coverity-ID: 1472116 ("Uninitialized scalar variable")
>> Fixes: 0ec13877ce95 ("net/mlx5e: Gather all XDP pre-requisite checks in a single function")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Applied to net-next.
> 

David,

Sorry I failed to tag this patch for net-next. I got a bit confused, once based on the logs,
the usual committer for this driver is Saeed Mahameed; not you. So, I wasn't quite sure about
how to proceed.

Thanks
