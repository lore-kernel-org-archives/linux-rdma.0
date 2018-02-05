From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 04/24] ibtrs: client: private header with client structs
 and functions
Date: Mon, 5 Feb 2018 12:59:56 +0200
Message-ID: <ed312357-d43f-3a2a-52bc-f2708072126f@grimberg.me>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-5-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-5-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roman,


> +struct ibtrs_clt_io_req {
> +	struct list_head        list;
> +	struct ibtrs_iu		*iu;
> +	struct scatterlist	*sglist; /* list holding user data */
> +	unsigned int		sg_cnt;
> +	unsigned int		sg_size;
> +	unsigned int		data_len;
> +	unsigned int		usr_len;
> +	void			*priv;
> +	bool			in_use;
> +	struct ibtrs_clt_con	*con;
> +	union {
> +		struct ib_pool_fmr	**fmr_list;
> +		struct ibtrs_fr_desc	**fr_list;
> +	};

We are pretty much stuck with fmrs for legacy devices, it has
no future support plans, please don't add new dependencies
on it. Its already hard enough to get rid of it.

> +	void			*map_page;
> +	struct ibtrs_tag	*tag;

Can I ask why do you need another tag that is not the request
tag?

> +	u16			nmdesc;
> +	enum dma_data_direction dir;
> +	ibtrs_conf_fn		*conf;
> +	unsigned long		start_time;
> +};
> +

> +static inline struct ibtrs_clt_con *to_clt_con(struct ibtrs_con *c)
> +{
> +	if (unlikely(!c))
> +		return NULL;
> +
> +	return container_of(c, struct ibtrs_clt_con, c);
> +}
> +
> +static inline struct ibtrs_clt_sess *to_clt_sess(struct ibtrs_sess *s)
> +{
> +	if (unlikely(!s))
> +		return NULL;
> +
> +	return container_of(s, struct ibtrs_clt_sess, s);
> +}

Seems a bit awkward that container_of wrappers check pointer validity...

> +/**
> + * list_next_or_null_rr - get next list element in round-robin fashion.
> + * @pos:     entry, starting cursor.
> + * @head:    head of the list to examine. This list must have at least one
> + *           element, namely @pos.
> + * @member:  name of the list_head structure within typeof(*pos).
> + *
> + * Important to understand that @pos is a list entry, which can be already
> + * removed using list_del_rcu(), so if @head has become empty NULL will be
> + * returned. Otherwise next element is returned in round-robin fashion.
> + */
> +#define list_next_or_null_rcu_rr(pos, head, member) ({			\
> +	typeof(pos) ________next = NULL;				\
> +									\
> +	if (!list_empty(head))						\
> +		________next = (pos)->member.next != (head) ?		\
> +			list_entry_rcu((pos)->member.next,		\
> +				       typeof(*pos), member) :		\
> +			list_entry_rcu((pos)->member.next->next,	\
> +				       typeof(*pos), member);		\
> +	________next;							\
> +})

Why is this local to your driver?

> +
> +/* See ibtrs-log.h */
> +#define TYPES_TO_SESSNAME(obj)						\
> +	LIST(CASE(obj, struct ibtrs_clt_sess *, s.sessname),		\
> +	     CASE(obj, struct ibtrs_clt *, sessname))
> +
> +#define TAG_SIZE(clt) (sizeof(struct ibtrs_tag) + (clt)->pdu_sz)
> +#define GET_TAG(clt, idx) ((clt)->tags + TAG_SIZE(clt) * idx)

Still don't understand why this is even needed..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
