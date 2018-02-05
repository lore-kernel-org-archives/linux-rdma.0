From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 05/24] ibtrs: client: main functionality
Date: Mon, 5 Feb 2018 14:27:34 +0100
Message-ID: <CAJrWOzD0YXWGCpR+BTOAJ7HhuVG_cjuomBK7vpGeTYu3H+DE4w@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-6-roman.penyaev@profitbricks.com> <1517590473.2675.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517590473.2675.21.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "hch@infradead.org" <hch@infradead.org>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 2, 2018 at 5:54 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2018-02-02 at 15:08 +0100, Roman Pen wrote:
>> +static inline struct ibtrs_tag *
>> +__ibtrs_get_tag(struct ibtrs_clt *clt, enum ibtrs_clt_con_type con_type)
>> +{
>> +     size_t max_depth = clt->queue_depth;
>> +     struct ibtrs_tag *tag;
>> +     int cpu, bit;
>> +
>> +     cpu = get_cpu();
>> +     do {
>> +             bit = find_first_zero_bit(clt->tags_map, max_depth);
>> +             if (unlikely(bit >= max_depth)) {
>> +                     put_cpu();
>> +                     return NULL;
>> +             }
>> +
>> +     } while (unlikely(test_and_set_bit_lock(bit, clt->tags_map)));
>> +     put_cpu();
>> +
>> +     tag = GET_TAG(clt, bit);
>> +     WARN_ON(tag->mem_id != bit);
>> +     tag->cpu_id = cpu;
>> +     tag->con_type = con_type;
>> +
>> +     return tag;
>> +}
>> +
>> +static inline void __ibtrs_put_tag(struct ibtrs_clt *clt,
>> +                                struct ibtrs_tag *tag)
>> +{
>> +     clear_bit_unlock(tag->mem_id, clt->tags_map);
>> +}
>> +
>> +struct ibtrs_tag *ibtrs_clt_get_tag(struct ibtrs_clt *clt,
>> +                                 enum ibtrs_clt_con_type con_type,
>> +                                 int can_wait)
>> +{
>> +     struct ibtrs_tag *tag;
>> +     DEFINE_WAIT(wait);
>> +
>> +     tag = __ibtrs_get_tag(clt, con_type);
>> +     if (likely(tag) || !can_wait)
>> +             return tag;
>> +
>> +     do {
>> +             prepare_to_wait(&clt->tags_wait, &wait, TASK_UNINTERRUPTIBLE);
>> +             tag = __ibtrs_get_tag(clt, con_type);
>> +             if (likely(tag))
>> +                     break;
>> +
>> +             io_schedule();
>> +     } while (1);
>> +
>> +     finish_wait(&clt->tags_wait, &wait);
>> +
>> +     return tag;
>> +}
>> +EXPORT_SYMBOL(ibtrs_clt_get_tag);
>> +
>> +void ibtrs_clt_put_tag(struct ibtrs_clt *clt, struct ibtrs_tag *tag)
>> +{
>> +     if (WARN_ON(!test_bit(tag->mem_id, clt->tags_map)))
>> +             return;
>> +
>> +     __ibtrs_put_tag(clt, tag);
>> +
>> +     /*
>> +      * Putting a tag is a barrier, so we will observe
>> +      * new entry in the wait list, no worries.
>> +      */
>> +     if (waitqueue_active(&clt->tags_wait))
>> +             wake_up(&clt->tags_wait);
>> +}
>> +EXPORT_SYMBOL(ibtrs_clt_put_tag);
>
> Do these functions have any advantage over the code in lib/sbitmap.c? If not,
> please call the sbitmap functions instead of adding an additional tag allocator.

Indeed, seems sbitmap can be reused.

But tags is a part of IBTRS, and is not related to block device at all.  One
IBTRS connection (session) handles many block devices (or any IO producers).
With a tag you get a free slot of a buffer where you can read/write, so once
you've allocated a tag you won't sleep on IO path inside a library.  Also tag
helps a lot on IO fail-over to another connection (multipath implementation,
which is also a part of the transport library, not a block device), where you
simply reuse the same buffer slot (with a tag in your hands) forwarding IO to
another RDMA connection.

--
Roman
