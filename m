From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] net/mlx4: fix spelling mistake: "Inrerface" ->
 "Interface"
Date: Tue, 22 May 2018 16:23:44 +0100
Message-ID: <297abbee-1f5c-6159-e559-44d83ddfb7ff@canonical.com>
References: <20180522083728.5874-1-colin.king@canonical.com>
 <77704a43-2b78-e88b-04b9-9a2623e8b5fb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <77704a43-2b78-e88b-04b9-9a2623e8b5fb@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 22/05/18 16:21, Tariq Toukan wrote:
> 
> 
> On 22/05/2018 11:37 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Trivial fix to spelling mistake in mlx4_dbg debug message
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/intf.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c
>> b/drivers/net/ethernet/mellanox/mlx4/intf.c
>> index 2edcce98ab2d..6bd4103265d2 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/intf.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
>> @@ -172,7 +172,7 @@ int mlx4_do_bond(struct mlx4_dev *dev, bool enable)
>>           list_add_tail(&dev_ctx->list, &priv->ctx_list);
>>           spin_unlock_irqrestore(&priv->ctx_lock, flags);
>>   -        mlx4_dbg(dev, "Inrerface for protocol %d restarted with
>> when bonded mode is %s\n",
>> +        mlx4_dbg(dev, "Interface for protocol %d restarted with when
>> bonded mode is %s\n",
> 
> Thanks Colin.
> I think there's one more thing to fix here.
> It is redundant to say "with when", it was probably done by mistake.
> Let's rephrase, maybe this way?
> 
> restarted with bonded mode %s

Sounds like a good idea, do you want me to send V2 of the patch with
this fix?

> 
>>                dev_ctx->intf->protocol, enable ?
>>                "enabled" : "disabled");
>>       }
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
