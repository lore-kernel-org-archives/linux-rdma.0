From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 18:08:31 +0300
Message-ID: <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <79901165.5342369.1493805915415.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, samuel jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> +static inline bool nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
> +{
> +       int v, old;
> +
> +       v = atomic_read(&queue->sig_count);
> +       while (1) {
> +               if (v > 1) {
> +                       old = atomic_cmpxchg(&queue->sig_count, v, v - 1);
> +                       if (old == v)
> +                               return false;
> +               } else {
> +                       int new_count;
> +
> +                       new_count = nvme_rdma_init_sig_count(queue->queue_size);
> +                       old = atomic_cmpxchg(&queue->sig_count, v, new_count);
> +                       if (old == v)
> +                               return true;
> +               }
> +               v = old;
> +       }
> +}
> +

Ugh, no...

How about just do:

	if (atomic_inc_return(queue->sig_count) % queue->sig_limit)
		return true;
	return false;

where
	queue->sig_limit = max(queue->queue_size / 2, 1);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
