From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v5 for-4.13 3/7] mlx5: move affinity hints assignments to
 generic code
Date: Sun, 18 Jun 2017 11:02:17 +0300
Message-ID: <21343c26-9b7a-de53-6e4f-ffd98189717e@grimberg.me>
References: <1497533594-11579-1-git-send-email-sagi@grimberg.me>
 <1497533594-11579-4-git-send-email-sagi@grimberg.me>
 <20170616094746.GB12547@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616094746.GB12547-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>   	rq->mpwqe.info = kzalloc_node(wq_sz * sizeof(*rq->mpwqe.info),
>> -				      GFP_KERNEL, cpu_to_node(c->cpu));
>> +					GFP_KERNEL, node);
> 
> Why the reindenting?

Heh, no good reason, I'm just a tabs person...

Although I might consider converting :)
https://www.theregister.co.uk/2017/06/16/spaces_vs_tabs/

> 
>>   	/* We allocate more than mtt_sz as we will align the pointer */
>> -	rq->mpwqe.mtt_no_align = kzalloc_node(mtt_alloc * wq_sz, GFP_KERNEL,
>> -					cpu_to_node(c->cpu));
>> +	rq->mpwqe.mtt_no_align = kzalloc_node(mtt_alloc * wq_sz,
>> +					GFP_KERNEL, node);
> 
> Or the moving of GFP_KERNEL to the next line here?

I'll respin...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
