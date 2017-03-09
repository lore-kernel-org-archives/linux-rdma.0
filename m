From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH rfc 04/10] block: Add a non-selective polling interface
Date: Thu, 9 Mar 2017 14:44:48 +0100
Message-ID: <83713ef7-168d-e1f6-8220-b7d6264ea29a@suse.de>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-5-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-5-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/09/2017 02:16 PM, Sagi Grimberg wrote:
> For a server/target appliance mode where we don't
> necessarily care about specific IOs but rather want
> to poll opportunisticly, it is useful to have a
> non-selective polling interface.
> 
> Expose a blk_poll_batch for a batched blkdev polling
> interface so our nvme target (and others) can use.
> 
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  block/blk-mq.c         | 14 ++++++++++++++
>  include/linux/blk-mq.h |  2 ++
>  include/linux/blkdev.h |  1 +
>  3 files changed, 17 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b2fd175e84d7..1962785b571a 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2911,6 +2911,20 @@ bool blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_poll);
>  
> +int blk_mq_poll_batch(struct request_queue *q, unsigned int batch)
> +{
> +	struct blk_mq_hw_ctx *hctx;
> +
> +	if (!q->mq_ops || !q->mq_ops->poll_batch)
> +		return 0;
> +
> +	hctx = blk_mq_map_queue(q, smp_processor_id());
> +	return q->mq_ops->poll_batch(hctx, batch);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_poll_batch);
> +
> +
> +

Quite some additional newlines and I'm not really fond of the
->poll_batch() name. It's a bit confusing with ->poll() and we also have
irq_poll(). But the only thing that would come to my mind is
complete_batch() which "races" with ->complete().

Otherwise looks OK,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
