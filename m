From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] net/mlx5e/core/en_fs: fix pointer dereference after
 free in mlx5e_execute_l2_action
Date: Wed, 08 Nov 2017 14:55:24 -0600
Message-ID: <20171108145524.Horde.qBgeASzuP9wiJwg7Cl-J620@gator4166.hostgator.com>
References: <20171105035453.GA10908@embeddedor.com>
 <20171108.110000.1557345961530017114.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108.110000.1557345961530017114.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: saeedm@mellanox.com, matanb@mellanox.com, leonro@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Quoting David Miller <davem@davemloft.net>:

> From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
> Date: Sat, 4 Nov 2017 22:54:53 -0500
>
>> hn is being kfree'd in mlx5e_del_l2_from_hash and then dereferenced
>> by accessing hn->ai.addr
>>
>> Fix this by copying the MAC address into a local variable for its safe use
>> in all possible execution paths within function mlx5e_execute_l2_action.
>>
>> Addresses-Coverity-ID: 1417789
>> Fixes: eeb66cdb6826 ("net/mlx5: Separate between E-Switch and MPFS")
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>
> Applied and queued up for -stable, thanks.

Awesome. Thanks!

--
Gustavo A. R. Silva
