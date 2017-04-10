From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH v2] nvme-rdma: support devices with queue size < 32
Date: Mon, 10 Apr 2017 17:21:51 +0200 (CEST)
Message-ID: <797792283.363211909.1491837711341.JavaMail.zimbra@kalray.eu>
References: <1519881025.363156294.1491837154312.JavaMail.zimbra@kalray.eu> <20170410151657.GA15173@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410151657.GA15173-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> +static inline nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
>> +{
>> +       int sig_limit;
>> +
>> +       /* We signal completion every queue depth/2 and also
>> +        * handle the case of possible device with queue_depth=1,
>> +        * where we would need to signal every message.
>> +        */
>> +       sig_limit = max(queue->queue_size / 2, 1);
>> +       return (++queue->sig_count % sig_limit) == 0;
>> +}
> 
> I would love if we could do this at the ib_qp level.  I also know
> you found a real bug and we want it fixed ASAP, so maybe for now
> we should merge this one:
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> and then do the generic version.  Marta, do you want to tackle the
> generic version or should I look into this once I get a little time.

I can look if I can do the same thing at the ib_qp level. It would be
great to have other people feedback on this one before it is merged.
We're testing this one now and we can see what I can do in a week or
so? Fine for you?

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
