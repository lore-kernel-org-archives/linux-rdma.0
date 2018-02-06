From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rfc 1/5] irq-am: Introduce library implementing generic
 adaptive moderation
Date: Tue, 6 Feb 2018 09:43:43 +0200
Message-ID: <CAJ3xEMhcQLL+QiqtLNtPrRcZEGSspipAoX5C_ERVwv1p=vAMHw@mail.gmail.com>
References: <20180205220316.30236-1-sagi@grimberg.me> <20180205220316.30236-2-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-2-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Tal Gilboa <talgi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 6, 2018 at 12:03 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> irq-am library helps I/O devices implement interrupt moderation in
> an adaptive fashion, based on online stats.
>
> The consumer can initialize an irq-am context with a callback that
> performs the device specific moderation programming and also the number
> of am (adaptive moderation) levels which are also, abstracted and allows
> for device specific tuning.
>
> The irq-am code will sample once every nr_events and will check for significant
> change in workload characteristics (completions per second, events per second)
> and if it detects one, will perform an am level update(called a step).
>
> The irq-am code  assumes that the am levels are sorted in an increasing order when
> the lowest level corresponds to the optimum latency tuning (short time and low
> completion-count) and gradually increasing towards the throughput optimum tuning
> (longer time and higher completion-count). So there is a trend and tuning direction
> tracked by the moderator. When the moderator collects sufficient statistics (also
> controlled by the consumer defining nr_events), it compares the current stats with the
> previous stats and if a significant changed was observed in the load, the moderator
> attempts to increment/decrement its current level (step) and schedules a program
> dispatch work.
>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  include/linux/irq-am.h | 116 +++++++++++++++++++++++++++++++

Talking to Tal, it seems that this is what landed in upstream as
include/linux/net_dim.h
and can have few adjustments for you, I suggest you take a look
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
