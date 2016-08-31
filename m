From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/7] Introduce Work Queue object and its verbs
Date: Wed, 31 Aug 2016 09:57:16 +0300
Message-ID: <778f70c0-d5e8-030f-8e47-3d16772e2faf@grimberg.me>
References: <1472569796-26162-1-git-send-email-yishaih@mellanox.com>
 <1472569796-26162-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472569796-26162-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +/*
> + * Work Queue. QP can be created without internal WQs "packaged" inside it,
> + * this QP can be configured to use "external" WQ object as its
> + * receive/send queue.
> + * WQ associated (many to one) with Completion Queue it owns WQ properties
> + * (PD, WQ size etc).
> + * WQ of type IBV_WQT_RQ:
> + * - Contains receive WQEs, in this case its PD serves as scatter as well.
> + * - Exposes post receive function to be used to post a list of work
> + *   requests (WRs) to its receive queue.
> + */
> +struct ibv_wq {
> +	struct ibv_context     *context;
> +	void		       *wq_context;
> +	struct	ibv_pd	       *pd;
> +	struct	ibv_cq	       *cq;
> +	uint32_t		wq_num;
> +	uint32_t		handle;
> +	enum ibv_wq_state       state;
> +	enum ibv_wq_type	wq_type;
> +	int (*post_recv)(struct ibv_wq *current,
> +			 struct ibv_recv_wr *recv_wr,
> +			 struct ibv_recv_wr **bad_recv_wr);

What was the reason not to go with the normal ibv_context_ops callout
scheme?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
