From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Thu, 23 Mar 2017 15:00:42 +0100
Message-ID: <20170323140042.GA30536@lst.de>
References: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1315914765.312051621.1490259849534.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 23, 2017 at 10:04:09AM +0100, Marta Rybczynska wrote:
> In the case of small NVMe-oF queue size (<32) we may enter
> a deadlock caused by the fact that the IB completions aren't sent
> waiting for 32 and the send queue will fill up.
> 
> The error is seen as (using mlx5):
> [ 2048.693355] mlx5_0:mlx5_ib_post_send:3765:(pid 7273):
> [ 2048.693360] nvme nvme1: nvme_rdma_post_send failed with error code -12
> 
> The patch doesn't change the behaviour for remote devices with
> larger queues.

Thanks, this looks useful.  But wouldn't it be better to do something
like queue_size divided by 2 or 4 to get a better refill latency?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
