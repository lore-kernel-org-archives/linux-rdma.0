From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Thu, 23 Mar 2017 15:36:58 +0100 (CET)
Message-ID: <277345557.313693033.1490279818647.JavaMail.zimbra@kalray.eu>
References: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu> <20170323140042.GA30536@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170323140042.GA30536-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Mail original -----
> On Thu, Mar 23, 2017 at 10:04:09AM +0100, Marta Rybczynska wrote:
>> In the case of small NVMe-oF queue size (<32) we may enter
>> a deadlock caused by the fact that the IB completions aren't sent
>> waiting for 32 and the send queue will fill up.
>> 
>> The error is seen as (using mlx5):
>> [ 2048.693355] mlx5_0:mlx5_ib_post_send:3765:(pid 7273):
>> [ 2048.693360] nvme nvme1: nvme_rdma_post_send failed with error code -12
>> 
>> The patch doesn't change the behaviour for remote devices with
>> larger queues.
> 
> Thanks, this looks useful.  But wouldn't it be better to do something
> like queue_size divided by 2 or 4 to get a better refill latency?

That's an interesting question. The max number of requests is already at 3 or 4 times
of the queue size because of different message types (see Sam's original
message in 'NVMe RDMA driver: CX4 send queue fills up when nvme queue depth is low').
I guess it would have inflence on configs with bigger latency.

I would like to have Sagi's view on this as he's the one who has changed that
part in the iSER initiator in 6df5a128f0fde6315a44e80b30412997147f5efd

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
