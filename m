From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] net/mlx5e: Remove redundant assignment
Date: Mon, 18 Mar 2019 12:35:51 -0500
Message-ID: <6cef0a46-d408-4b79-88ca-6c7da2538abf@embeddedor.com>
References: <20190302193933.GA13467@embeddedor.com>
 <da1f1300-20f4-2929-078b-71ac1772a933@mellanox.com>
 <5e256a0f-ef58-4b23-8d7f-08a6148782e6@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5e256a0f-ef58-4b23-8d7f-08a6148782e6@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eli Britstein <elibr@mellanox.com>, Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

Friendly ping:

Who can take this?

Thanks
--
Gustavo

On 3/3/19 11:31 AM, Eli Britstein wrote:
> Reviewed-by: Eli Britstein <elibr@mellanox.com>
> 
> On 3/3/2019 5:20 PM, Roi Dayan wrote:
>>
>> On 02/03/2019 21:39, Gustavo A. R. Silva wrote:
>>> Remove redundant assignment to tun_entropy->enabled.
>>>
>>> Addesses-Coverity-ID: 1477328 ("Unused value")
>>> Fixes: 97417f6182f8 ("net/mlx5e: Fix GRE key by controlling port tunnel entropy calculation")
>> the commit doesn't fix any real issue but is more of a cleanup.
>> so I'm not sure if fixes line is relevant or not.
>> beside that looks ok.
>>
>> Reviewed-by: Roi Dayan <roid@mellanox.com>
>>
>>
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>> ---
>>>   drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c | 6 ++----
>>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
>>> index 40f4a19b1ce1..be69c1d7941a 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
>>> @@ -80,10 +80,8 @@ void mlx5_init_port_tun_entropy(struct mlx5_tun_entropy *tun_entropy,
>>>   	mlx5_query_port_tun_entropy(mdev, &entropy_flags);
>>>   	tun_entropy->num_enabling_entries = 0;
>>>   	tun_entropy->num_disabling_entries = 0;
>>> -	tun_entropy->enabled = entropy_flags.calc_enabled;
>>> -	tun_entropy->enabled =
>>> -		(entropy_flags.calc_supported) ?
>>> -		entropy_flags.calc_enabled : true;
>>> +	tun_entropy->enabled = entropy_flags.calc_supported ?
>>> +			       entropy_flags.calc_enabled : true;
>>>   }
>>>   
>>>   static int mlx5_set_entropy(struct mlx5_tun_entropy *tun_entropy,
>>>
