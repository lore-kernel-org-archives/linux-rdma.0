From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Mon, 15 Aug 2011 15:24:41 +0200
Message-ID: <CAO+b5-r3UtgnyfhyaodHQTj_xB5d2MQkZ8kRbrpZ1hF_0W1ONw@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.761358826@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.761358826-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +static int rxe_query_port(struct ib_device *dev,
> +			  u8 port_num, struct ib_port_attr *attr)
> +{
> +	struct rxe_dev *rxe = to_rdev(dev);
> +	struct rxe_port *port;
> +
> +	if (unlikely(port_num < 1 || port_num > rxe->num_ports)) {
> +		pr_warn("invalid port_number %d\n", port_num);
> +		goto err1;
> +	}
> +
> +	port = &rxe->port[port_num - 1];
> +
> +	*attr = port->attr;
> +	return 0;
> +
> +err1:
> +	return -EINVAL;
> +}

The pr_warn() statement in the above function looks to me like an
example of how pr_warn() should not be used: the message it generates
won't allow a user to find out which subsystem generated that message.
I suggest either to leave out that pr_warn() statement entirely or to
convert it into a pr_debug() statement and to use an appropriate
prefix, e.g. via pr_fmt().

> +static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
> +{
> +	int err;
> +	struct rxe_dev *rxe = to_rdev(ibpd->device);
> +	struct rxe_pd *pd = to_rpd(ibpd);
> +	struct rxe_ah *ah;
> +
> +	err = rxe_av_chk_attr(rxe, attr);
> +	if (err)
> +		goto err1;
> +
> +	ah = rxe_alloc(&rxe->ah_pool);
> +	if (!ah) {
> +		err = -ENOMEM;
> +		goto err1;
> +	}
> +
> +	rxe_add_ref(pd);
> +	ah->pd = pd;
> +
> +	err = rxe_av_from_attr(rxe, attr->port_num, &ah->av, attr);
> +	if (err)
> +		goto err2;
> +
> +	return &ah->ibah;
> +
> +err2:
> +	rxe_drop_ref(pd);
> +	rxe_drop_ref(ah);
> +err1:
> +	return ERR_PTR(err);
> +}

I'm not sure that using a variable with the name "err" and labels with
names "err1" and "err2" is a good idea with regard to readability.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
