From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 35/37] add rxe_sample.c
Date: Sun, 7 Aug 2011 10:08:18 +0200
Message-ID: <CAO+b5-pO1DQoX+MsbPjE17ZD1qPttax=T-3usaXuh2AzSXXsew@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.865806162@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.865806162-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> module that implements a soft IB device using ib_rxe in loopback.
> +MODULE_DESCRIPTION("RDMA transport over Converged Enhanced Ethernet");

That's the same description as for the ib_rxe_net kernel module, so
one of the two probably should be updated.

> +MODULE_LICENSE("Dual BSD/GPL");
> +
> +static __be64 node_guid(struct rxe_dev *rxe)
> +{
> +	return cpu_to_be64(0x3333333333333333ULL);
> +}

In the OUI part of the above EUI-64 identifier the "M" (multicast) and
L ("locally administered") bits are set. I'm not sure that's fine.
Also, has it been considered to use __constant_cpu_to_be64() instead
of cpu_to_be64() ?

> +static __be64 port_guid(struct rxe_dev *rxe, unsigned int port_num)
> +{
> +	return cpu_to_be64(0x4444444444444444ULL);
> +}

Same remark here about __constant_cpu_to_be64().

> +/*
> + * the ofed core requires that we provide a valid device
> + * object for registration
> + */
> +static struct class *my_class;
> +static struct device *my_dev;

Probably the above comment should be updated since this driver is
being submitted for inclusion in the mainline Linux kernel ?

> +	if (av->attr.ah_flags & IB_AH_GRH)
> +		pkt->mask	|= RXE_GRH_MASK;

Please use a space instead of a tab before "|=".

> +static struct rxe_dev *rxe_sample;
> +
> +static int rxe_sample_add(void)
> +{
> +	int err;
> +	struct rxe_port *port;
> +
> +	rxe_sample = (struct rxe_dev *)ib_alloc_device(sizeof(*rxe_sample));
> +	if (!rxe_sample) {
> +		err = -ENOMEM;
> +		goto err1;
> +	}

Since calling rxe_sample_add() twice in a row is an error a check for
that condition might be appropriate, e.g. by inserting a
WARN_ON(rxe_sample) before the allocation.

> +static void rxe_sample_remove(void)
> +{
> +	if (!rxe_sample)
> +		goto done;
> +
> +	rxe_remove(rxe_sample);
> +
> +	pr_info("rxe_sample: removed %s\n",
> +		rxe_sample->ib_dev.name);
> +done:
> +	return;
> +}

Setting rxe_sample to NULL after the rxe_remove() call can be a help
to catch potential dangling pointer dereferences.

> +
> +static int __init rxe_sample_init(void)
> +{
> +	int err;
> +
> +	rxe_crc_disable = 1;
> +
> +	my_class = class_create(THIS_MODULE, "foo");
> +	my_dev = device_create(my_class, NULL, 0, NULL, "bar");
> +
> +	err = rxe_sample_add();
> +	return err;
> +}

Sorry, but it's not clear to me why a new class has to be created this
sample driver. Also, one should be aware that class and device names
are globally visible and hence should be meaningful - names like "foo"
and "bar" are not acceptable.

# find /sys -name foo -o -name bar
/sys/devices/virtual/foo
/sys/devices/virtual/foo/bar
/sys/class/foo
/sys/class/foo/bar

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
