From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RFC 0/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 21:02:40 +0300
Message-ID: <CAF9gx6JgWCfR+KJGdsHzn8uC+12EMm7rPoZb0TESpfU6eP3PWw@mail.gmail.com>
References: <541C27BF.6070609@acm.org>
	<541C27F7.1020509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <541C27F7.1020509@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-rdma@vger.kernel.org

On 9/19/2014 3:56 PM, Bart Van Assche wrote:
> [PATCH 1/8] blk-mq: Use all available hardware queues
>
> Suppose that a system has two CPU sockets, three cores per socket,
> that it does not support hyperthreading and that four hardware
> queues are provided by a block driver. With the current algorithm
> this will lead to the following assignment of CPU cores to hardware
> queues:
>
>    HWQ 0: 0 1
>    HWQ 1: 2 3
>    HWQ 2: 4 5
>    HWQ 3: (none)
>
> This patch changes the queue assignment into:
>
>    HWQ 0: 0 1
>    HWQ 1: 2
>    HWQ 2: 3 4
>    HWQ 3: 5
>
> In other words, this patch has the following three effects:
> - All four hardware queues are used instead of only three.
> - CPU cores are spread more evenly over hardware queues. For the
>    above example the range of the number of CPU cores associated
>    with a single HWQ is reduced from [0..2] to [1..2].
> - If the number of HWQ's is a multiple of the number of CPU sockets
>    it is now guaranteed that all CPU cores associated with a single
>    HWQ reside on the same CPU socket.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@canonical.com>
> ---
>   block/blk-mq-cpumap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 1065d7c..8e56455 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -17,7 +17,7 @@
>   static int cpu_to_queue_index(unsigned int nr_cpus, unsigned int nr_queues,
>        const int cpu)
>   {
> - return cpu / ((nr_cpus + nr_queues - 1) / nr_queues);
> + return cpu * nr_queues / nr_cpus;
>   }
>
>   static int get_first_sibling(unsigned int cpu)
>

Seems reasonable enough.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
