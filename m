From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rfc 04/10] block: Add a non-selective polling interface
Date: Mon, 13 Mar 2017 10:26:36 +0200
Message-ID: <c04d071e-ae33-d1cd-973d-b8c52f768c3b@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-5-git-send-email-sagi@grimberg.me>
 <83713ef7-168d-e1f6-8220-b7d6264ea29a@suse.de>
 <c5ef3bd9-42dc-53c9-d2f7-2e49399f7a8d@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c5ef3bd9-42dc-53c9-d2f7-2e49399f7a8d@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>> Quite some additional newlines and I'm not really fond of the
>> ->poll_batch() name. It's a bit confusing with ->poll() and we also have
>> irq_poll(). But the only thing that would come to my mind is
>> complete_batch() which "races" with ->complete().
>
> What about ->check_completions()? After all, that is what both ->poll()
> and ->poll_batch do but with a different stop condition, no ?
> So it would also be easy to merge the two: both tag and batch are
> unsigned int which could be called "cookie", and add a flag to tell how
> to interpret it (as a tag or a batch limit).
> e.g. something like:
>
> +typedef int (check_completions_fn)(struct blk_mq_hw_ctx *,
> 		enum blk_mq_check_flags, /* flag (TAG or BATCH) */
> 		unsigned int); /* Target tag or batch limit */
>

I'd rather not to unite poll/poll_batch, but if this is something
that people want I can definitely do it.
