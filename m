From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 02/12] blk-mq: Add blk_mq_unique_tag()
Date: Sun, 19 Oct 2014 19:14:32 +0300
Message-ID: <5443E368.8040807@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E493.9030304@acm.org> <20141011110841.GA9593@infradead.org> <543B99B2.1010307@acm.org> <20141013101554.GA29876@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20141013101554.GA29876@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 10/13/2014 1:15 PM, Christoph Hellwig wrote:
> On Mon, Oct 13, 2014 at 11:21:54AM +0200, Bart Van Assche wrote:
>> With the approach for block layer tag management proposed in this patch
>> series SCSI LLDs no longer need to call this function. This means that the
>> blk_mq_build_unique_tag() function can be eliminated by inlining it into
>> blk_mq_unique_tag(). Would you like me to rework this patch accordingly ?
>
> Yes, please.
>

With this bit you can add:

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
