From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 04/24] ibtrs: client: private header with client structs
 and functions
Date: Tue, 6 Feb 2018 13:23:04 +0100
Message-ID: <CAJrWOzAy+uFSjtJedmd04rufaRjvBaQg9GqFEz++4GSeapkgFA@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-5-roman.penyaev@profitbricks.com> <ed312357-d43f-3a2a-52bc-f2708072126f@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ed312357-d43f-3a2a-52bc-f2708072126f@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On Mon, Feb 5, 2018 at 11:59 AM, Sagi Grimberg <sagi@grimberg.me> wrote:
> Hi Roman,
>
>
>> +struct ibtrs_clt_io_req {
>> +       struct list_head        list;
>> +       struct ibtrs_iu         *iu;
>> +       struct scatterlist      *sglist; /* list holding user data */
>> +       unsigned int            sg_cnt;
>> +       unsigned int            sg_size;
>> +       unsigned int            data_len;
>> +       unsigned int            usr_len;
>> +       void                    *priv;
>> +       bool                    in_use;
>> +       struct ibtrs_clt_con    *con;
>> +       union {
>> +               struct ib_pool_fmr      **fmr_list;
>> +               struct ibtrs_fr_desc    **fr_list;
>> +       };
>
>
> We are pretty much stuck with fmrs for legacy devices, it has
> no future support plans, please don't add new dependencies
> on it. Its already hard enough to get rid of it.

Got it, we have a plan to get rid of fmr.  But as I remember our
internal tests: fr is slower.  The question: why that can be
according to your experience?  I will retest, but still that is
interesting to know.

>> +       void                    *map_page;
>> +       struct ibtrs_tag        *tag;
>
>
> Can I ask why do you need another tag that is not the request
> tag?

Once I responded already, the summary is the following:

1. Indeed mq supports tags sharing, but only between hw queues, not
globally, so for us that means tags->nr_hw_queues = 1, which kills
performance.

2. We need tags sharing in the transport library, which should not
be tightly coupled with block device.


>> +       u16                     nmdesc;
>> +       enum dma_data_direction dir;
>> +       ibtrs_conf_fn           *conf;
>> +       unsigned long           start_time;
>> +};
>> +
>
>
>> +static inline struct ibtrs_clt_con *to_clt_con(struct ibtrs_con *c)
>> +{
>> +       if (unlikely(!c))
>> +               return NULL;
>> +
>> +       return container_of(c, struct ibtrs_clt_con, c);
>> +}
>> +
>> +static inline struct ibtrs_clt_sess *to_clt_sess(struct ibtrs_sess *s)
>> +{
>> +       if (unlikely(!s))
>> +               return NULL;
>> +
>> +       return container_of(s, struct ibtrs_clt_sess, s);
>> +}
>
>
> Seems a bit awkward that container_of wrappers check pointer validity...

That can be fixed, frankly, I don't remember code paths where I
implicitly rely on that returned null: session or connection are
always expected as valid pointers.

>> +/**
>> + * list_next_or_null_rr - get next list element in round-robin fashion.
>> + * @pos:     entry, starting cursor.
>> + * @head:    head of the list to examine. This list must have at least
>> one
>> + *           element, namely @pos.
>> + * @member:  name of the list_head structure within typeof(*pos).
>> + *
>> + * Important to understand that @pos is a list entry, which can be
>> already
>> + * removed using list_del_rcu(), so if @head has become empty NULL will
>> be
>> + * returned. Otherwise next element is returned in round-robin fashion.
>> + */
>> +#define list_next_or_null_rcu_rr(pos, head, member) ({                 \
>> +       typeof(pos) ________next = NULL;                                \
>> +                                                                       \
>> +       if (!list_empty(head))                                          \
>> +               ________next = (pos)->member.next != (head) ?           \
>> +                       list_entry_rcu((pos)->member.next,              \
>> +                                      typeof(*pos), member) :          \
>> +                       list_entry_rcu((pos)->member.next->next,        \
>> +                                      typeof(*pos), member);           \
>> +       ________next;                                                   \
>> +})
>
>
> Why is this local to your driver?

Yeah, of course I can try to extend list.h

>> +
>> +/* See ibtrs-log.h */
>> +#define TYPES_TO_SESSNAME(obj)                                         \
>> +       LIST(CASE(obj, struct ibtrs_clt_sess *, s.sessname),            \
>> +            CASE(obj, struct ibtrs_clt *, sessname))
>> +
>> +#define TAG_SIZE(clt) (sizeof(struct ibtrs_tag) + (clt)->pdu_sz)
>> +#define GET_TAG(clt, idx) ((clt)->tags + TAG_SIZE(clt) * idx)
>
>
> Still don't understand why this is even needed..

--
Roman
