From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto" configuration
 mode support
Date: Sun, 30 Jun 2019 00:32:08 +0000
Message-ID: <20190630003200.GA7173@mellanox.com>
References: <20190618172625.13432-1-leon@kernel.org>
 <20190618172625.13432-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618172625.13432-7-leon@kernel.org>
Content-Language: en-US
Content-ID: <3B0F99AFCC5F4B44A12EFD058D50D00C@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 08:26:14PM +0300, Leon Romanovsky wrote:

> +/**
> + * rdma_counter_bind_qp_auto - Check and bind the QP to a counter base o=
n
> + *   the auto-mode rule
> + */
> +int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
> +{
> +	struct rdma_port_counter *port_counter;
> +	struct ib_device *dev =3D qp->device;
> +	struct rdma_counter *counter;
> +	int ret;
> +
> +	if (!rdma_is_port_valid(dev, port))
> +		return -EINVAL;
> +
> +	port_counter =3D &dev->port_data[port].port_counter;
> +	if (port_counter->mode.mode !=3D RDMA_COUNTER_MODE_AUTO)
> +		return 0;
> +
> +	counter =3D rdma_get_counter_auto_mode(qp, port);
> +	if (counter) {
> +		ret =3D __rdma_counter_bind_qp(counter, qp);
> +		if (ret) {
> +			rdma_restrack_put(&counter->res);
> +			return ret;
> +		}
> +		kref_get(&counter->kref);

The counter is left in the xarray while the kref is zero, this
kref_get is wrong..

Using two kref like things at the same time is a bad idea, the
'rdma_get_counter_auto_mode' should return the kref held, not the
restrack get. The restrack_del doesn't happen as long as the kref is
positive, so we don't need the retrack thing here..

> +	} else {
> +		counter =3D rdma_counter_alloc(dev, port, RDMA_COUNTER_MODE_AUTO);
> +		if (!counter)
> +			return -ENOMEM;
> +
> +		auto_mode_init_counter(counter, qp, port_counter->mode.mask);
> +
> +		ret =3D __rdma_counter_bind_qp(counter, qp);
> +		if (ret)
> +			goto err_bind;
> +
> +		rdma_counter_res_add(counter, qp);
> +		if (!rdma_restrack_get(&counter->res)) {
> +			ret =3D -EINVAL;
> +			goto err_get;
> +		}

and this shouldn't be needed as the kref is inited to 1 by the
rdma_counter_alloc..

> +	}
> +
> +	return 0;
> +
> +err_get:
> +	 __rdma_counter_unbind_qp(qp);
> +	__rdma_counter_dealloc(counter);
> +err_bind:
> +	rdma_counter_free(counter);
> +	return ret;
> +}

And then all this error unwind and all the twisty __ functions should
just be a single kref_put and the release should handle everything.

Jason
