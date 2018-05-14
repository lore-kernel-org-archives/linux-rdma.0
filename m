From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] net/mlx5: Use 'kvfree()' for memory allocated by
 'kvzalloc()'
Date: Mon, 14 May 2018 21:37:38 +0200
Message-ID: <72339a77-1740-e081-06bc-8295687f80b8@wanadoo.fr>
References: <20180512170925.23690-1-christophe.jaillet@wanadoo.fr>
 <20180514.145642.989041199343505570.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514.145642.989041199343505570.davem@davemloft.net>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Le 14/05/2018 à 20:56, David Miller a écrit :
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Date: Sat, 12 May 2018 19:09:25 +0200
> 
>> 'out' is allocated with 'kvzalloc()'. 'kvfree()' must be used to free it.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Saeed, I assume I will see this in one of your forthcoming pull
> requests.
> 
> Thanks.
> 

I've send a v2 with additional 'kvfree()' fixes.

CJ
