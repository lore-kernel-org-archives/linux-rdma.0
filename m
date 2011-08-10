From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 28/37] add rxe_arbiter.c
Date: Wed, 10 Aug 2011 20:46:38 +0200
Message-ID: <CAO+b5-p=++ofCDj4ZB_PS9LiT5bcHsJiYDW8EL_2OrrzqjZmhg@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.515453123@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.515453123-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +int rxe_arbiter(void *arg)
> +{
> +	int err;
> +	unsigned long flags;
> +	struct rxe_dev *rxe = (struct rxe_dev *)arg;
> +	struct sk_buff *skb;
> +	struct list_head *qpl;
> +	struct rxe_qp *qp;
> +
> +	/* get the next qp's send queue */
> +	spin_lock_irqsave(&rxe->arbiter.list_lock, flags);
> +	if (list_empty(&rxe->arbiter.qp_list)) {
> +		spin_unlock_irqrestore(&rxe->arbiter.list_lock, flags);
> +		return 1;
> +	}
> +
> +	qpl = rxe->arbiter.qp_list.next;
> +	list_del_init(qpl);
> +	qp = list_entry(qpl, struct rxe_qp, arbiter_list);
> +	spin_unlock_irqrestore(&rxe->arbiter.list_lock, flags);

Is there a reason why the list_first_entry() macro hasn't been used in
the above code ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
