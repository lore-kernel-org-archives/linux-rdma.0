From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH net-next] net/mlx4: Mark expected switch fall-through
Date: Wed, 23 Jan 2019 12:09:07 -0600
Message-ID: <e27972ea-dc6a-569d-638f-293067c95059@embeddedor.com>
References: <20190123080511.GA32528@embeddedor>
 <20190123.090803.438719975498577995.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190123.090803.438719975498577995.davem@davemloft.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 1/23/19 11:08 AM, David Miller wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Date: Wed, 23 Jan 2019 02:05:11 -0600
> 
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> This patch fixes the following warning:
>>
>> drivers/net/ethernet/mellanox/mlx4/eq.c: In function ¡mlx4_eq_int¢:
>> drivers/net/ethernet/mellanox/mlx4/mlx4.h:219:5: warning: this statement may fall through [-Wimplicit-fallthrough=]
>>   if (mlx4_debug_level)      \
>>      ^
>> drivers/net/ethernet/mellanox/mlx4/eq.c:558:4: note: in expansion of macro ¡mlx4_dbg¢
>>     mlx4_dbg(dev, "%s: MLX4_EVENT_TYPE_SRQ_LIMIT. srq_no=0x%x, eq 0x%x\n",
>>     ^~~~~~~~
>> drivers/net/ethernet/mellanox/mlx4/eq.c:561:3: note: here
>>    case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
>>    ^~~~
>>
>> Warning level 3 was used: -Wimplicit-fallthrough=3
>>
>> This patch is part of the ongoing efforts to enabling
>> -Wimplicit-fallthrough.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Applied.
> 

Thank you both, Tariq and David.

--
Gustavo
