From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 31/37] add rxe.c
Date: Sat, 20 Aug 2011 17:12:24 +0200
Message-ID: <CAO+b5-onUSYDcSdsJpehDSkUsga76hWwwXpEd8mu3H9kEx_U6Q@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.666252623@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.666252623-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +int rxe_fast_comp = 2;
> +module_param_named(fast_comp, rxe_fast_comp, int, 0644);
> +MODULE_PARM_DESC(fast_comp, "fast path call to completer "
> +		 "(0=no, 1=no int context, 2=any context)");
> +
> +int rxe_fast_resp = 2;
> +module_param_named(fast_resp, rxe_fast_resp, int, 0644);
> +MODULE_PARM_DESC(fast_resp, "enable fast path call to responder "
> +		 "(0=no, 1=no int context, 2=any context)");
> +
> +int rxe_fast_req = 2;
> +module_param_named(fast_req, rxe_fast_req, int, 0644);
> +MODULE_PARM_DESC(fast_req, "enable fast path call to requester "
> +		 "(0=no, 1=no int context, 2=any context)");
> +
> +int rxe_fast_arb = 2;
> +module_param_named(fast_arb, rxe_fast_arb, int, 0644);
> +MODULE_PARM_DESC(fast_arb, "enable fast path call to arbiter "
> +		 "(0=no, 1=no int context, 2=any context)");

The ib_rxe kernel module has an impressive number of module
parameters. I have been wondering whether it's possible to reduce that
number somewhat. As an example, is it necessary that all four kernel
module parameters mentioned above can be configured individually ? As
far as I can see the only purpose of these parameters is to make it
possible to move processing of certain events from interrupt to
tasklet or process context. How about using one kernel module
parameter for that purpose instead of four ?

> +/* initialize port state, note IB convention
> +   that HCA ports are always numbered from 1 */
> +static int rxe_init_ports(struct rxe_dev *rxe)
> +{
> +	int err;
> +	unsigned int port_num;
> +	struct rxe_port *port;
> +
> +	rxe->port = kcalloc(rxe->num_ports, sizeof(struct rxe_port),
> +			    GFP_KERNEL);
> +	if (!rxe->port)
> +		return -ENOMEM;
> +
> +	for (port_num = 1; port_num <= rxe->num_ports; port_num++) {
> +		port = &rxe->port[port_num - 1];
> +
> +		rxe_init_port_param(rxe, port_num);
> +
> +		if (!port->attr.pkey_tbl_len) {
> +			err = -EINVAL;
> +			goto err1;
> +		}
> +
> +		port->pkey_tbl = kcalloc(port->attr.pkey_tbl_len,
> +					 sizeof(*port->pkey_tbl), GFP_KERNEL);
> +		if (!port->pkey_tbl) {
> +			err = -ENOMEM;
> +			goto err1;
> +		}
> +
> +		port->pkey_tbl[0] = 0xffff;
> +
> +		if (!port->attr.gid_tbl_len) {
> +			kfree(port->pkey_tbl);
> +			err = -EINVAL;
> +			goto err1;
> +		}
> +
> +		port->guid_tbl = kcalloc(port->attr.gid_tbl_len,
> +					 sizeof(*port->guid_tbl), GFP_KERNEL);
> +		if (!port->guid_tbl) {
> +			kfree(port->pkey_tbl);
> +			err = -ENOMEM;
> +			goto err1;
> +		}
> +
> +		port->guid_tbl[0] = rxe->ifc_ops->port_guid(rxe, port_num);
> +
> +		spin_lock_init(&port->port_lock);
> +	}
> +
> +	return 0;
> +
> +err1:
> +	while (--port_num >= 1) {
> +		port = &rxe->port[port_num - 1];
> +		kfree(port->pkey_tbl);
> +		kfree(port->guid_tbl);
> +	}
> +
> +	kfree(rxe->port);
> +	return err;
> +}

Same remark here about the "err" variable and the "err1" label - that
seems confusing to me.

> +int rxe_set_mtu(struct rxe_dev *rxe, unsigned int ndev_mtu,
> +		unsigned int port_num)
> +{
> +	struct rxe_port *port = &rxe->port[port_num - 1];
> +	enum rxe_mtu mtu;
> +
> +	mtu = eth_mtu_int_to_enum(ndev_mtu);
> +	if (!mtu)
> +		return -EINVAL;
> +
> +	/* Set the port mtu to min(feasible, preferred) */
> +	mtu = min_t(enum rxe_mtu, mtu, rxe->pref_mtu);
> +
> +	port->attr.active_mtu = (enum ib_mtu __force)mtu;
> +	port->mtu_cap = rxe_mtu_enum_to_int(mtu);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(rxe_set_mtu);

Sorry, but using the datatype "enum rxe_mtu" for an MTU doesn't make
sense to me. Shouldn't that be "int" instead ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
