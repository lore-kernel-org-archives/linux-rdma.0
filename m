From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH rfc 04/10] block: Add a non-selective polling interface
Date: Fri, 10 Mar 2017 12:04:12 +0900
Message-ID: <c5ef3bd9-42dc-53c9-d2f7-2e49399f7a8d@wdc.com>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-5-git-send-email-sagi@grimberg.me>
 <83713ef7-168d-e1f6-8220-b7d6264ea29a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <83713ef7-168d-e1f6-8220-b7d6264ea29a@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/9/17 22:44, Johannes Thumshirn wrote:
> On 03/09/2017 02:16 PM, Sagi Grimberg wrote:
>> For a server/target appliance mode where we don't
>> necessarily care about specific IOs but rather want
>> to poll opportunisticly, it is useful to have a
>> non-selective polling interface.
>>
>> Expose a blk_poll_batch for a batched blkdev polling
>> interface so our nvme target (and others) can use.
>>
>> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>> ---
>>  block/blk-mq.c         | 14 ++++++++++++++
>>  include/linux/blk-mq.h |  2 ++
>>  include/linux/blkdev.h |  1 +
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index b2fd175e84d7..1962785b571a 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2911,6 +2911,20 @@ bool blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
>>  }
>>  EXPORT_SYMBOL_GPL(blk_mq_poll);
>>  
>> +int blk_mq_poll_batch(struct request_queue *q, unsigned int batch)
>> +{
>> +	struct blk_mq_hw_ctx *hctx;
>> +
>> +	if (!q->mq_ops || !q->mq_ops->poll_batch)
>> +		return 0;
>> +
>> +	hctx = blk_mq_map_queue(q, smp_processor_id());
>> +	return q->mq_ops->poll_batch(hctx, batch);
>> +}
>> +EXPORT_SYMBOL_GPL(blk_mq_poll_batch);
>> +
>> +
>> +
> 
> Quite some additional newlines and I'm not really fond of the
> ->poll_batch() name. It's a bit confusing with ->poll() and we also have
> irq_poll(). But the only thing that would come to my mind is
> complete_batch() which "races" with ->complete().

What about ->check_completions()? After all, that is what both ->poll()
and ->poll_batch do but with a different stop condition, no ?
So it would also be easy to merge the two: both tag and batch are
unsigned int which could be called "cookie", and add a flag to tell how
to interpret it (as a tag or a batch limit).
e.g. something like:

+typedef int (check_completions_fn)(struct blk_mq_hw_ctx *,
		enum blk_mq_check_flags, /* flag (TAG or BATCH) */
		unsigned int); /* Target tag or batch limit */

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
