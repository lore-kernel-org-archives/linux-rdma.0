From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Date: Wed, 29 May 2019 11:17:19 +0000
Message-ID: <20190529111715.GW4633@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190429083453.16654-14-leon@kernel.org>
Content-Language: en-US
Content-ID: <C36CC7CBBA39D44A8811B00646FF6939@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
>
> Since a QP can only be bound to one counter, then if it is bound to a
> separate counter, for backward compatibility purpose, the statistic
> value must be:
> * stat of default counter
> + stat of all running allocated counters
> + stat of all deallocated counters (history stats)
>
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/counters.c | 99 +++++++++++++++++++++++++++++-
>  drivers/infiniband/core/device.c   |  8 ++-
>  drivers/infiniband/core/sysfs.c    | 10 ++-
>  include/rdma/rdma_counter.h        |  5 +-
>  4 files changed, 113 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core=
/counters.c
> index 36cd9eca1e46..f598b1cdb241 100644
> --- a/drivers/infiniband/core/counters.c
> +++ b/drivers/infiniband/core/counters.c
> @@ -146,6 +146,20 @@ static int __rdma_counter_bind_qp(struct rdma_counte=
r *counter,
>  	return ret;
>  }
>
> +static void counter_history_stat_update(const struct rdma_counter *count=
er)
> +{
> +	struct ib_device *dev =3D counter->device;
> +	struct rdma_port_counter *port_counter;
> +	int i;
> +
> +	port_counter =3D &dev->port_data[counter->port].port_counter;
> +	if (!port_counter->hstats)
> +		return;
> +
> +	for (i =3D 0; i < counter->stats->num_counters; i++)
> +		port_counter->hstats->value[i] +=3D counter->stats->value[i];
> +}
> +
>  static int __rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
>  {
>  	struct rdma_counter *counter =3D qp->counter;
> @@ -285,8 +299,10 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool fo=
rce)
>  		return ret;
>
>  	rdma_restrack_put(&counter->res);
> -	if (atomic_dec_and_test(&counter->usecnt))
> +	if (atomic_dec_and_test(&counter->usecnt)) {
> +		counter_history_stat_update(counter);
>  		rdma_counter_dealloc(counter);
> +	}
>
>  	return 0;
>  }
> @@ -307,21 +323,98 @@ int rdma_counter_query_stats(struct rdma_counter *c=
ounter)
>  	return ret;
>  }
>
> -void rdma_counter_init(struct ib_device *dev)
> +static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
> +					   u8 port, u32 index)
> +{
> +	struct rdma_restrack_entry *res;
> +	struct rdma_restrack_root *rt;
> +	struct rdma_counter *counter;
> +	unsigned long id =3D 0;
> +	u64 sum =3D 0;
> +
> +	rt =3D &dev->res[RDMA_RESTRACK_COUNTER];
> +	xa_lock(&rt->xa);
> +	xa_for_each(&rt->xa, id, res) {
> +		if (!rdma_restrack_get(res))
> +			continue;
> +
> +		counter =3D container_of(res, struct rdma_counter, res);
> +		if ((counter->device !=3D dev) || (counter->port !=3D port))
> +			goto next;
> +
> +		if (rdma_counter_query_stats(counter))
> +			goto next;
> +
> +		sum +=3D counter->stats->value[index];
> +next:
> +		rdma_restrack_put(res);
> +	}
> +
> +	xa_unlock(&rt->xa);
> +	return sum;
> +}
> +
> +/**
> + * rdma_counter_get_hwstat_value() - Get the sum value of all counters o=
n a
> + *   specific port, including the running ones and history data
> + */
> +u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 in=
dex)
> +{
> +	struct rdma_port_counter *port_counter;
> +	u64 sum;
> +
> +	if (!rdma_is_port_valid(dev, port))
> +		return -EINVAL;
> +
> +	port_counter =3D &dev->port_data[port].port_counter;
> +	if (index >=3D port_counter->hstats->num_counters)
> +		return -EINVAL;
> +
> +	sum =3D get_running_counters_hwstat_sum(dev, port, index);
> +	sum +=3D port_counter->hstats->value[index];
> +
> +	return sum;

This function is wrong, it can't return negative value (error) while
return type is declared as u64.

> +}
> +
> +int rdma_counter_init(struct ib_device *dev)
>  {
>  	struct rdma_port_counter *port_counter;
>  	u32 port;
>
>  	if (!dev->ops.alloc_hw_stats)
> -		return;
> +		return 0;
>
>  	rdma_for_each_port(dev, port) {
>  		port_counter =3D &dev->port_data[port].port_counter;
>  		port_counter->mode.mode =3D RDMA_COUNTER_MODE_NONE;
>  		mutex_init(&port_counter->lock);
> +
> +		port_counter->hstats =3D dev->ops.alloc_hw_stats(dev, port);
> +		if (!port_counter->hstats)
> +			goto fail;
>  	}
> +
> +	return 0;
> +
> +fail:
> +	rdma_for_each_port(dev, port) {
> +		port_counter =3D &dev->port_data[port].port_counter;
> +		kfree(port_counter->hstats);
> +	}
> +
> +	return -ENOMEM;
>  }
>
>  void rdma_counter_cleanup(struct ib_device *dev)
>  {
> +	struct rdma_port_counter *port_counter;
> +	u32 port;
> +
> +	if (!dev->ops.alloc_hw_stats)
> +		return;
> +
> +	rdma_for_each_port(dev, port) {
> +		port_counter =3D &dev->port_data[port].port_counter;
> +		kfree(port_counter->hstats);
> +	}
>  }
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index c56ffc61ab1e..8ae4906a60e7 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1255,7 +1255,11 @@ int ib_register_device(struct ib_device *device, c=
onst char *name)
>  		goto dev_cleanup;
>  	}
>
> -	rdma_counter_init(device);
> +	ret =3D rdma_counter_init(device);
> +	if (ret) {
> +		dev_warn(&device->dev, "Couldn't initialize counter\n");
> +		goto sysfs_cleanup;
> +	}
>
>  	ret =3D enable_device_and_get(device);
>  	if (ret) {
> @@ -1283,6 +1287,8 @@ int ib_register_device(struct ib_device *device, co=
nst char *name)
>
>  	return 0;
>
> +sysfs_cleanup:
> +	ib_device_unregister_sysfs(device);
>  dev_cleanup:
>  	device_del(&device->dev);
>  cg_cleanup:
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sy=
sfs.c
> index 2fe89754e592..8d1cf1bbb5f5 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -43,6 +43,7 @@
>  #include <rdma/ib_mad.h>
>  #include <rdma/ib_pma.h>
>  #include <rdma/ib_cache.h>
> +#include <rdma/rdma_counter.h>
>
>  struct ib_port;
>
> @@ -795,9 +796,12 @@ static int update_hw_stats(struct ib_device *dev, st=
ruct rdma_hw_stats *stats,
>  	return 0;
>  }
>
> -static ssize_t print_hw_stat(struct rdma_hw_stats *stats, int index, cha=
r *buf)
> +static ssize_t print_hw_stat(struct ib_device *dev, int port_num,
> +			     struct rdma_hw_stats *stats, int index, char *buf)
>  {
> -	return sprintf(buf, "%llu\n", stats->value[index]);
> +	u64 v =3D rdma_counter_get_hwstat_value(dev, port_num, index);
> +
> +	return sprintf(buf, "%llu\n", stats->value[index] + v);
>  }
>
>  static ssize_t show_hw_stats(struct kobject *kobj, struct attribute *att=
r,
> @@ -823,7 +827,7 @@ static ssize_t show_hw_stats(struct kobject *kobj, st=
ruct attribute *attr,
>  	ret =3D update_hw_stats(dev, stats, hsa->port_num, hsa->index);
>  	if (ret)
>  		goto unlock;
> -	ret =3D print_hw_stat(stats, hsa->index, buf);
> +	ret =3D print_hw_stat(dev, hsa->port_num, stats, hsa->index, buf);
>  unlock:
>  	mutex_unlock(&stats->lock);
>
> diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
> index 4bc62909a638..5ad86ae67cc5 100644
> --- a/include/rdma/rdma_counter.h
> +++ b/include/rdma/rdma_counter.h
> @@ -27,6 +27,7 @@ struct rdma_counter_mode {
>
>  struct rdma_port_counter {
>  	struct rdma_counter_mode mode;
> +	struct rdma_hw_stats *hstats;
>  	struct mutex lock;
>  };
>
> @@ -41,13 +42,13 @@ struct rdma_counter {
>  	u8				port;
>  };
>
> -void rdma_counter_init(struct ib_device *dev);
> +int rdma_counter_init(struct ib_device *dev);
>  void rdma_counter_cleanup(struct ib_device *dev);
>  int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
>  			       bool on, enum rdma_nl_counter_mask mask);
>  int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
>  int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);
> -
>  int rdma_counter_query_stats(struct rdma_counter *counter);
> +u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 in=
dex);
>
>  #endif /* _RDMA_COUNTER_H_ */
> --
> 2.20.1
>
