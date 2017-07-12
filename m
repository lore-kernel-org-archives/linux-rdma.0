From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v7 for-4.13 6/7] block: Add rdma affinity based queue
 mapping helper
Date: Wed, 12 Jul 2017 13:36:19 +0300
Message-ID: <70eeee7c-f227-4471-5eb9-492f77f7e8cf@grimberg.me>
References: <1499671054-23899-1-git-send-email-sagi@grimberg.me>
 <1499671054-23899-7-git-send-email-sagi@grimberg.me>
 <1499811219.2586.45.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499811219.2586.45.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> +int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
>> +		struct ib_device *dev, int first_vec)
>> +{
>> +	const struct cpumask *mask;
>> +	unsigned int queue, cpu;
>> +
>> +	if (set->nr_hw_queues > dev->num_comp_vectors)
>> +		goto fallback;
> 
> Should this perhaps have been "if (first_vec + set->nr_hw_queues >
> dev->num_comp_vectors)"? Additionally, since the return value of
> ib_get_vector_affinity() is tested inside the loop, can this test be left out?

I guess it can...

>> +	return 0;
>> +fallback:
>> +	return blk_mq_map_queues(set);
> 
> If you have to repost this patch, please insert a blank line above the
> "fallback" label.

Will do, thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
