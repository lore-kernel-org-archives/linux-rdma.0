From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next] IB/mlx5: Support congestion related counters
Date: Thu, 6 Apr 2017 20:08:58 +0000
Message-ID: <VI1PR0502MB3008908CE9C534131AB0A1F1D10D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170329030032.4434-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329030032.4434-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

For some reason older version of this patch is being posted. My bad.

Patchwork state is shows as new for this patch, so I guess it's not merged =
yet.
If you have not merged this, please drop this patch.
I am sending v1 version of it.

Parav

> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Tuesday, March 28, 2017 10:01 PM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH rdma-next] IB/mlx5: Support congestion related counters
>=20
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patch adds support to query the congestion related hardware counters
> through new command and links them with other hw counters being
> available in hw_counters sysfs location.
>=20
> In order to reuse existing infrastructure it renames related q_counter da=
ta
> structures to more generic counters to reflect q_counters and congestion
> counters and maybe some other counters in the future.
>=20
> New hardware counters:
>  * rp_cnps_handled - CNP packets handled by the reaction point
>  * rp_cpns_ignored - CNP packets ignored by the reaction point
>  * np_cnps_sent    - CNP packets sent by notification point to respond to
>                      CE marked RoCE packets
>  * np_ecn_marked_roce_packets - CE marked RoCE packets received by
>                                 notification point
>=20
> It also avoids returning ENOSYS which is specific for invalid system call=
 and
> produces the following checkpatch.pl warning.
>=20
> WARNING: ENOSYS means 'invalid syscall nr' and nothing else
> +		return -ENOSYS;
>=20
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/cmd.c     |  11 +++
>  drivers/infiniband/hw/mlx5/cmd.h     |   2 +
>  drivers/infiniband/hw/mlx5/main.c    | 171 ++++++++++++++++++++++++--
> ---------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |   7 +-
>  drivers/infiniband/hw/mlx5/qp.c      |   7 +-
>  include/linux/mlx5/mlx5_ifc.h        |  18 ++--
>  6 files changed, 149 insertions(+), 67 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/cmd.c
> b/drivers/infiniband/hw/mlx5/cmd.c
> index cdc2d3017da7..18d5e1db93ed 100644
> --- a/drivers/infiniband/hw/mlx5/cmd.c
> +++ b/drivers/infiniband/hw/mlx5/cmd.c
> @@ -46,3 +46,14 @@ int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev,
> u32 *null_mkey)
>  				      null_mkey);
>  	return err;
>  }
> +
> +int mlx5_cmd_query_cong_counter(struct mlx5_core_dev *dev,
> +				bool reset, void *out, int out_size) {
> +	u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] =3D { };
> +
> +	MLX5_SET(query_cong_statistics_in, in, opcode,
> +		 MLX5_CMD_OP_QUERY_CONG_STATISTICS);
> +	MLX5_SET(query_cong_statistics_in, in, clear, reset);
> +	return mlx5_cmd_exec(dev, in, sizeof(in), out, out_size); }
> diff --git a/drivers/infiniband/hw/mlx5/cmd.h
> b/drivers/infiniband/hw/mlx5/cmd.h
> index 7ca8a7b6434d..fa09228193a6 100644
> --- a/drivers/infiniband/hw/mlx5/cmd.h
> +++ b/drivers/infiniband/hw/mlx5/cmd.h
> @@ -37,4 +37,6 @@
>  #include <linux/mlx5/driver.h>
>=20
>  int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
> +int mlx5_cmd_query_cong_counter(struct mlx5_core_dev *dev,
> +				bool reset, void *out, int out_size);
>  #endif /* MLX5_IB_CMD_H */
> diff --git a/drivers/infiniband/hw/mlx5/main.c
> b/drivers/infiniband/hw/mlx5/main.c
> index 4dc0a8785fe0..def740e8a243 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -57,6 +57,7 @@
>  #include <linux/mlx5/fs.h>
>  #include <linux/mlx5/vport.h>
>  #include "mlx5_ib.h"
> +#include "cmd.h"
>=20
>  #define DRIVER_NAME "mlx5_ib"
>  #define DRIVER_VERSION "2.2-1"
> @@ -3133,7 +3134,7 @@ static void mlx5_disable_eth(struct mlx5_ib_dev
> *dev)
>  		mlx5_nic_vport_disable_roce(dev->mdev);
>  }
>=20
> -struct mlx5_ib_q_counter {
> +struct mlx5_ib_counter {
>  	const char *name;
>  	size_t offset;
>  };
> @@ -3141,18 +3142,18 @@ struct mlx5_ib_q_counter {
>  #define INIT_Q_COUNTER(_name)		\
>  	{ .name =3D #_name, .offset =3D
> MLX5_BYTE_OFF(query_q_counter_out, _name)}
>=20
> -static const struct mlx5_ib_q_counter basic_q_cnts[] =3D {
> +static const struct mlx5_ib_counter basic_q_cnts[] =3D {
>  	INIT_Q_COUNTER(rx_write_requests),
>  	INIT_Q_COUNTER(rx_read_requests),
>  	INIT_Q_COUNTER(rx_atomic_requests),
>  	INIT_Q_COUNTER(out_of_buffer),
>  };
>=20
> -static const struct mlx5_ib_q_counter out_of_seq_q_cnts[] =3D {
> +static const struct mlx5_ib_counter out_of_seq_q_cnts[] =3D {
>  	INIT_Q_COUNTER(out_of_sequence),
>  };
>=20
> -static const struct mlx5_ib_q_counter retrans_q_cnts[] =3D {
> +static const struct mlx5_ib_counter retrans_q_cnts[] =3D {
>  	INIT_Q_COUNTER(duplicate_request),
>  	INIT_Q_COUNTER(rnr_nak_retry_err),
>  	INIT_Q_COUNTER(packet_seq_err),
> @@ -3160,22 +3161,31 @@ static const struct mlx5_ib_q_counter
> retrans_q_cnts[] =3D {
>  	INIT_Q_COUNTER(local_ack_timeout_err),
>  };
>=20
> -static void mlx5_ib_dealloc_q_counters(struct mlx5_ib_dev *dev)
> +#define INIT_CONG_COUNTER(_name)		\
> +	{ .name =3D #_name, .offset =3D	\
> +		MLX5_BYTE_OFF(query_cong_statistics_out, _name ##
> _high)}
> +
> +static const struct mlx5_ib_counter cong_cnts[] =3D {
> +	INIT_CONG_COUNTER(rp_cnp_ignored),
> +	INIT_CONG_COUNTER(rp_cnp_handled),
> +	INIT_CONG_COUNTER(np_ecn_marked_roce_packets),
> +	INIT_CONG_COUNTER(np_cnps_sent),
> +};
> +
> +static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
>  {
>  	unsigned int i;
>=20
>  	for (i =3D 0; i < dev->num_ports; i++) {
>  		mlx5_core_dealloc_q_counter(dev->mdev,
> -					    dev->port[i].q_cnts.set_id);
> -		kfree(dev->port[i].q_cnts.names);
> -		kfree(dev->port[i].q_cnts.offsets);
> +					    dev->port[i].cnts.set_id);
> +		kfree(dev->port[i].cnts.names);
> +		kfree(dev->port[i].cnts.offsets);
>  	}
>  }
>=20
> -static int __mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev,
> -				      const char ***names,
> -				      size_t **offsets,
> -				      u32 *num)
> +static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
> +				    struct mlx5_ib_counters *cnts)
>  {
>  	u32 num_counters;
>=20
> @@ -3186,27 +3196,32 @@ static int __mlx5_ib_alloc_q_counters(struct
> mlx5_ib_dev *dev,
>=20
>  	if (MLX5_CAP_GEN(dev->mdev, retransmission_q_counters))
>  		num_counters +=3D ARRAY_SIZE(retrans_q_cnts);
> +	cnts->num_q_counters =3D num_counters;
>=20
> -	*names =3D kcalloc(num_counters, sizeof(**names), GFP_KERNEL);
> -	if (!*names)
> +	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
> +		cnts->num_cong_counters =3D ARRAY_SIZE(cong_cnts);
> +		num_counters +=3D ARRAY_SIZE(cong_cnts);
> +	}
> +
> +	cnts->names =3D kcalloc(num_counters, sizeof(cnts->names),
> GFP_KERNEL);
> +	if (!cnts->names)
>  		return -ENOMEM;
>=20
> -	*offsets =3D kcalloc(num_counters, sizeof(**offsets), GFP_KERNEL);
> -	if (!*offsets)
> +	cnts->offsets =3D kcalloc(num_counters,
> +				sizeof(cnts->offsets), GFP_KERNEL);
> +	if (!cnts->offsets)
>  		goto err_names;
>=20
> -	*num =3D num_counters;
> -
>  	return 0;
>=20
>  err_names:
> -	kfree(*names);
> +	kfree(cnts->names);
>  	return -ENOMEM;
>  }
>=20
> -static void mlx5_ib_fill_q_counters(struct mlx5_ib_dev *dev,
> -				    const char **names,
> -				    size_t *offsets)
> +static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
> +				  const char **names,
> +				  size_t *offsets)
>  {
>  	int i;
>  	int j =3D 0;
> @@ -3229,9 +3244,16 @@ static void mlx5_ib_fill_q_counters(struct
> mlx5_ib_dev *dev,
>  			offsets[j] =3D retrans_q_cnts[i].offset;
>  		}
>  	}
> +
> +	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
> +		for (i =3D 0; i < ARRAY_SIZE(cong_cnts); i++, j++) {
> +			names[j] =3D cong_cnts[i].name;
> +			offsets[j] =3D cong_cnts[i].offset;
> +		}
> +	}
>  }
>=20
> -static int mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev)
> +static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
>  {
>  	int i;
>  	int ret;
> @@ -3240,7 +3262,7 @@ static int mlx5_ib_alloc_q_counters(struct
> mlx5_ib_dev *dev)
>  		struct mlx5_ib_port *port =3D &dev->port[i];
>=20
>  		ret =3D mlx5_core_alloc_q_counter(dev->mdev,
> -						&port->q_cnts.set_id);
> +						&port->cnts.set_id);
>  		if (ret) {
>  			mlx5_ib_warn(dev,
>  				     "couldn't allocate queue counter for port
> %d, err %d\n", @@ -3248,15 +3270,12 @@ static int
> mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev)
>  			goto dealloc_counters;
>  		}
>=20
> -		ret =3D __mlx5_ib_alloc_q_counters(dev,
> -						 &port->q_cnts.names,
> -						 &port->q_cnts.offsets,
> -						 &port-
> >q_cnts.num_counters);
> +		ret =3D __mlx5_ib_alloc_counters(dev, &port->cnts);
>  		if (ret)
>  			goto dealloc_counters;
>=20
> -		mlx5_ib_fill_q_counters(dev, port->q_cnts.names,
> -					port->q_cnts.offsets);
> +		mlx5_ib_fill_counters(dev, port->cnts.names,
> +				      port->cnts.offsets);
>  	}
>=20
>  	return 0;
> @@ -3264,7 +3283,7 @@ static int mlx5_ib_alloc_q_counters(struct
> mlx5_ib_dev *dev)
>  dealloc_counters:
>  	while (--i >=3D 0)
>  		mlx5_core_dealloc_q_counter(dev->mdev,
> -					    dev->port[i].q_cnts.set_id);
> +					    dev->port[i].cnts.set_id);
>=20
>  	return ret;
>  }
> @@ -3279,44 +3298,92 @@ static struct rdma_hw_stats
> *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
>  	if (port_num =3D=3D 0)
>  		return NULL;
>=20
> -	return rdma_alloc_hw_stats_struct(port->q_cnts.names,
> -					  port->q_cnts.num_counters,
> +	return rdma_alloc_hw_stats_struct(port->cnts.names,
> +					  port->cnts.num_q_counters +
> +					  port->cnts.num_cong_counters,
>=20
> RDMA_HW_STATS_DEFAULT_LIFESPAN);  }
>=20
> -static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
> -				struct rdma_hw_stats *stats,
> -				u8 port_num, int index)
> +static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
> +				    struct mlx5_ib_port *port,
> +				    struct rdma_hw_stats *stats)
>  {
> -	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
> -	struct mlx5_ib_port *port =3D &dev->port[port_num - 1];
>  	int outlen =3D MLX5_ST_SZ_BYTES(query_q_counter_out);
>  	void *out;
>  	__be32 val;
> -	int ret;
> -	int i;
> -
> -	if (!stats)
> -		return -ENOSYS;
> +	int ret, i;
>=20
>  	out =3D mlx5_vzalloc(outlen);
>  	if (!out)
>  		return -ENOMEM;
>=20
>  	ret =3D mlx5_core_query_q_counter(dev->mdev,
> -					port->q_cnts.set_id, 0,
> +					port->cnts.set_id, 0,
>  					out, outlen);
>  	if (ret)
>  		goto free;
>=20
> -	for (i =3D 0; i < port->q_cnts.num_counters; i++) {
> -		val =3D *(__be32 *)(out + port->q_cnts.offsets[i]);
> +	for (i =3D 0; i < port->cnts.num_q_counters; i++) {
> +		val =3D *(__be32 *)(out + port->cnts.offsets[i]);
>  		stats->value[i] =3D (u64)be32_to_cpu(val);
>  	}
>=20
>  free:
>  	kvfree(out);
> -	return port->q_cnts.num_counters;
> +	return ret;
> +}
> +
> +static int mlx5_ib_query_cong_counters(struct mlx5_ib_dev *dev,
> +				       struct mlx5_ib_port *port,
> +				       struct rdma_hw_stats *stats) {
> +	int outlen =3D MLX5_ST_SZ_BYTES(query_cong_statistics_out);
> +	void *out;
> +	int ret, i, offset =3D port->cnts.num_q_counters - 1;
> +
> +	out =3D mlx5_vzalloc(outlen);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	ret =3D mlx5_cmd_query_cong_counter(dev->mdev, false, out,
> outlen);
> +	if (ret)
> +		goto free;
> +
> +	for (i =3D 0; i < port->cnts.num_cong_counters; i++) {
> +		stats->value[i + offset] =3D
> +			be64_to_cpup((__be64 *)(out +
> +				     port->cnts.offsets[i + offset]));
> +	}
> +
> +free:
> +	kvfree(out);
> +	return ret;
> +}
> +
> +static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
> +				struct rdma_hw_stats *stats,
> +				u8 port_num, int index)
> +{
> +	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
> +	struct mlx5_ib_port *port =3D &dev->port[port_num - 1];
> +	int ret, num_counters;
> +
> +	if (!stats)
> +		return -EINVAL;
> +
> +	ret =3D mlx5_ib_query_q_counters(dev, port, stats);
> +	if (ret)
> +		return ret;
> +	num_counters =3D port->cnts.num_q_counters;
> +
> +	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
> +		ret =3D mlx5_ib_query_cong_counters(dev, port, stats);
> +		if (ret)
> +			return ret;
> +		num_counters +=3D port->cnts.num_cong_counters;
> +	}
> +
> +	return num_counters;
>  }
>=20
>  static void *mlx5_ib_add(struct mlx5_core_dev *mdev) @@ -3523,14
> +3590,14 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
>  		goto err_rsrc;
>=20
>  	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
> -		err =3D mlx5_ib_alloc_q_counters(dev);
> +		err =3D mlx5_ib_alloc_counters(dev);
>  		if (err)
>  			goto err_odp;
>  	}
>=20
>  	dev->mdev->priv.uar =3D mlx5_get_uars_page(dev->mdev);
>  	if (!dev->mdev->priv.uar)
> -		goto err_q_cnt;
> +		goto err_cnt;
>=20
>  	err =3D mlx5_alloc_bfreg(dev->mdev, &dev->bfreg, false, false);
>  	if (err)
> @@ -3574,9 +3641,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev
> *mdev)
>  err_uar_page:
>  	mlx5_put_uars_page(dev->mdev, dev->mdev->priv.uar);
>=20
> -err_q_cnt:
> +err_cnt:
>  	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
> -		mlx5_ib_dealloc_q_counters(dev);
> +		mlx5_ib_dealloc_counters(dev);
>=20
>  err_odp:
>  	mlx5_ib_odp_remove_one(dev);
> @@ -3610,7 +3677,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev
> *mdev, void *context)
>  	mlx5_free_bfreg(dev->mdev, &dev->bfreg);
>  	mlx5_put_uars_page(dev->mdev, mdev->priv.uar);
>  	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
> -		mlx5_ib_dealloc_q_counters(dev);
> +		mlx5_ib_dealloc_counters(dev);
>  	destroy_umrc_res(dev);
>  	mlx5_ib_odp_remove_one(dev);
>  	destroy_dev_resources(&dev->devr);
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 3cd064b5f0bf..7f1221cb6a50 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -595,15 +595,16 @@ struct mlx5_ib_resources {
>  	struct mutex	mutex;
>  };
>=20
> -struct mlx5_ib_q_counters {
> +struct mlx5_ib_counters {
>  	const char **names;
>  	size_t *offsets;
> -	u32 num_counters;
> +	u32 num_q_counters;
> +	u32 num_cong_counters;
>  	u16 set_id;
>  };
>=20
>  struct mlx5_ib_port {
> -	struct mlx5_ib_q_counters q_cnts;
> +	struct mlx5_ib_counters cnts;
>  };
>=20
>  struct mlx5_roce {
> diff --git a/drivers/infiniband/hw/mlx5/qp.c
> b/drivers/infiniband/hw/mlx5/qp.c index ad8a2638e339..74a4696b4833
> 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2798,7 +2798,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
>  			       qp->port) - 1;
>  		mibport =3D &dev->port[port_num];
>  		context->qp_counter_set_usr_page |=3D
> -			cpu_to_be32((u32)(mibport->q_cnts.set_id) << 24);
> +			cpu_to_be32((u32)(mibport->cnts.set_id) << 24);
>  	}
>=20
>  	if (!ibqp->uobject && cur_state =3D=3D IB_QPS_RESET && new_state =3D=3D
> IB_QPS_INIT) @@ -2826,7 +2826,7 @@ static int
> __mlx5_ib_modify_qp(struct ib_qp *ibqp,
>=20
>  		raw_qp_param.operation =3D op;
>  		if (cur_state =3D=3D IB_QPS_RESET && new_state =3D=3D
> IB_QPS_INIT) {
> -			raw_qp_param.rq_q_ctr_id =3D mibport-
> >q_cnts.set_id;
> +			raw_qp_param.rq_q_ctr_id =3D mibport->cnts.set_id;
>  			raw_qp_param.set_mask |=3D
> MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID;
>  		}
>=20
> @@ -4964,7 +4964,8 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct
> ib_wq_attr *wq_attr,
>  		if (MLX5_CAP_GEN(dev->mdev,
> modify_rq_counter_set_id)) {
>  			MLX5_SET64(modify_rq_in, in, modify_bitmask,
>=20
> MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
> -			MLX5_SET(rqc, rqc, counter_set_id, dev->port-
> >q_cnts.set_id);
> +			MLX5_SET(rqc, rqc, counter_set_id,
> +				 dev->port->cnts.set_id);
>  		} else
>  			pr_info_once("%s: Receive WQ counters are not
> supported on current FW\n",
>  				     dev->ib_dev.name);
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.=
h
> index 838242697541..fa22a8f2ad27 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -4623,17 +4623,17 @@ struct mlx5_ifc_query_cong_statistics_out_bits {
>=20
>  	u8         reserved_at_40[0x40];
>=20
> -	u8         cur_flows[0x20];
> +	u8         rp_cur_flows[0x20];
>=20
>  	u8         sum_flows[0x20];
>=20
> -	u8         cnp_ignored_high[0x20];
> +	u8         rp_cnp_ignored_high[0x20];
>=20
> -	u8         cnp_ignored_low[0x20];
> +	u8         rp_cnp_ignored_low[0x20];
>=20
> -	u8         cnp_handled_high[0x20];
> +	u8         rp_cnp_handled_high[0x20];
>=20
> -	u8         cnp_handled_low[0x20];
> +	u8         rp_cnp_handled_low[0x20];
>=20
>  	u8         reserved_at_140[0x100];
>=20
> @@ -4643,13 +4643,13 @@ struct mlx5_ifc_query_cong_statistics_out_bits {
>=20
>  	u8         accumulators_period[0x20];
>=20
> -	u8         ecn_marked_roce_packets_high[0x20];
> +	u8         np_ecn_marked_roce_packets_high[0x20];
>=20
> -	u8         ecn_marked_roce_packets_low[0x20];
> +	u8         np_ecn_marked_roce_packets_low[0x20];
>=20
> -	u8         cnps_sent_high[0x20];
> +	u8         np_cnps_sent_high[0x20];
>=20
> -	u8         cnps_sent_low[0x20];
> +	u8         np_cnps_sent_low[0x20];
>=20
>  	u8         reserved_at_320[0x560];
>  };
> --
> 2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
