From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] net/mlx5/core/fpga/ipsec: Fix use-after-free
Date: Thu, 22 Mar 2018 13:37:29 -0500
Message-ID: <b19ec4fc-03fa-385f-a9d6-40b9d7b42830@embeddedor.com>
References: <20180322180342.GA18505@embeddedgus>
 <20180322183225.GA24009@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322183225.GA24009@yuvallap>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: Ilan Tayari <ilant@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Yuval,

On 03/22/2018 01:32 PM, Yuval Shaia wrote:
> On Thu, Mar 22, 2018 at 01:03:42PM -0500, Gustavo A. R. Silva wrote:
>> _rule_ is being freed and then dereferenced by accessing rule->ctx
>>
>> Fix this by copying the value returned by PTR_ERR(rule->ctx) into a local
>> variable for its safe use after freeing _rule_
>>
>> Addresses-Coverity-ID: 1466041 ("Read from pointer after free")
>> Fixes: 05564d0ae075 ("net/mlx5: Add flow-steering commands for FPGA IPSec implementation")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Prefix should not be that long, a short one as this is enough.
> 

Yeah. Actually, I was suspicious about it.

> net/mlx5: Fix use-after-free
> 
> Besides that - lgtm.
> 
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> 

I'll send v2 with a short prefix and add your Reviewed-by.

Thanks for the feedback.
--
Gustavo
