From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v4 for-4.13 2/6] mlx5: move affinity hints assignments to
 generic code
Date: Wed, 7 Jun 2017 12:56:12 +0300
Message-ID: <1f762580-f958-5bf5-b0aa-7b67b9c98990@grimberg.me>
References: <1496814868-22070-1-git-send-email-sagi@grimberg.me>
 <1496814868-22070-3-git-send-email-sagi@grimberg.me>
 <20170607082200.GB24774@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170607082200.GB24774-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>   
>> @@ -1730,7 +1725,8 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
>>   	c->mdev     = priv->mdev;
>>   	c->tstamp   = &priv->tstamp;
>>   	c->ix       = ix;
>> -	c->cpu      = cpu;
>> +	c->cpu      = cpumask_first(pci_irq_get_affinity(priv->mdev->pdev,
>> +			MLX5_EQ_VEC_COMP_BASE + ix));
> 
> ->cpu is only used to call cpu_to_node on it.  So remove it and switch
> the users to
> 
> 	pci_irq_get_node(priv->mdev->pdev)
> 
> instead.

I started with this, but its not exactly correct, channel cpu is used to
construct the xps cpumask, see: mlx5e_activate_channel()
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
