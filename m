From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE loopback
 traffic
Date: Sat, 27 Apr 2019 05:49:15 +0000
Message-ID: <20190427054913.GE6705@mtr-leonro.mtl.com>
References: <20190426215732.29761-1-saeedm@mellanox.com>
 <20190426215732.29761-10-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190426215732.29761-10-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <8D6EA8322FE210488A7410B959647C46@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 26, 2019 at 09:58:23PM +0000, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
>
> When in switchdev mode, we would like to treat loopback RoCE
> traffic (on eswitch manager) as RDMA and not as regular
> Ethernet traffic
> In order to enable it we add flow steering rule that forward RoCE
> loopback traffic to the HW RoCE filter (by adding allow rule).
> In addition we add RoCE address in GID index 0, which will be
> set in the RoCE loopback packet.
>
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../mellanox/mlx5/core/eswitch_offloads.c     |   9 +
>  .../net/ethernet/mellanox/mlx5/core/rdma.c    | 181 ++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/rdma.h    |  20 ++
>  include/linux/mlx5/driver.h                   |   7 +
>  5 files changed, 218 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.h
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/n=
et/ethernet/mellanox/mlx5/core/Makefile
> index 1a16f6d73cbc..5f0be9b36a04 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> @@ -35,7 +35,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)     +=3D en_rep.o en_t=
c.o en/tc_tun.o lib/port_tu
>  #
>  # Core extra
>  #
> -mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch_offloads.o ecp=
f.o
> +mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch_offloads.o ecp=
f.o rdma.o
>  mlx5_core-$(CONFIG_MLX5_MPFS)      +=3D lib/mpfs.o
>  mlx5_core-$(CONFIG_VXLAN)          +=3D lib/vxlan.o
>  mlx5_core-$(CONFIG_PTP_1588_CLOCK) +=3D lib/clock.o
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 6c8a17ca236e..4b48bb98981e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -37,6 +37,7 @@
>  #include <linux/mlx5/fs.h>
>  #include "mlx5_core.h"
>  #include "eswitch.h"
> +#include "rdma.h"
>  #include "en.h"
>  #include "fs_core.h"
>  #include "lib/devcom.h"
> @@ -1713,6 +1714,13 @@ int esw_offloads_init(struct mlx5_eswitch *esw, in=
t vf_nvports,
>  		esw->host_info.num_vfs =3D vf_nvports;
>  	}
>
> +	err =3D mlx5_rdma_enable_roce(esw->dev);
> +	if (err) {
> +		esw_debug(esw->dev, "Failed to enable RoCE, err: %d\n",
> +			  err);

You are already printing errors in all flows of mlx5_rdma_enable_roce(),
there is no need in extra debug print.

> +		err =3D 0;

If you are not interested in return value, better to declare function as vo=
id.

> +	}
> +
>  	return 0;
>
>  err_reps:
> @@ -1751,6 +1759,7 @@ void esw_offloads_cleanup(struct mlx5_eswitch *esw)
>  		num_vfs =3D esw->dev->priv.sriov.num_vfs;
>  	}
>
> +	mlx5_rdma_disable_roce(esw->dev);
>  	esw_offloads_devcom_cleanup(esw);
>  	esw_offloads_unload_all_reps(esw, num_vfs);
>  	esw_offloads_steering_cleanup(esw);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net=
/ethernet/mellanox/mlx5/core/rdma.c
> new file mode 100644
> index 000000000000..f6c5e4f91aa8
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
> @@ -0,0 +1,181 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/* Copyright (c) 2019 Mellanox Technologies */
> +
> +#include <linux/mlx5/vport.h>
> +#include <rdma/ib_verbs.h>
> +#include <net/addrconf.h>
> +
> +#include "lib/mlx5.h"
> +#include "eswitch.h"
> +#include "fs_core.h"
> +
> +void mlx5_rdma_disable_roce_steering(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_core_roce *roce =3D &dev->priv.roce;
> +
> +	if (IS_ERR_OR_NULL(roce->ft))

roce->ft shouldn't be error, or NULL or proper pointer.

> +		return;
> +
> +	mlx5_del_flow_rules(roce->allow_rule);
> +	mlx5_destroy_flow_group(roce->fg);
> +	mlx5_destroy_flow_table(roce->ft);
> +}
> +
> +int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
> +{
> +	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
> +	struct mlx5_core_roce *roce =3D &dev->priv.roce;
> +	struct mlx5_flow_handle *flow_rule =3D NULL;
> +	struct mlx5_flow_table_attr ft_attr =3D {};
> +	struct mlx5_flow_namespace *ns =3D NULL;
> +	struct mlx5_flow_act flow_act =3D {0};

{0} -> {}

> +	struct mlx5_flow_spec *spec;
> +	struct mlx5_flow_table *ft;
> +	struct mlx5_flow_group *fg;
> +	void *match_criteria;
> +	u32 *flow_group_in;
> +	void *misc;
> +	int err;
> +
> +	if (!(MLX5_CAP_FLOWTABLE_RDMA_RX(dev, ft_support) &&
> +	      MLX5_CAP_FLOWTABLE_RDMA_RX(dev, table_miss_action_domain)))
> +		return -EOPNOTSUPP;
> +
> +	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
> +	if (!flow_group_in)
> +		return -ENOMEM;
> +	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
> +	if (!spec) {
> +		kvfree(flow_group_in);
> +		return -ENOMEM;
> +	}
> +
> +	ns =3D mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_RDMA_RX);
> +	if (!ns) {
> +		mlx5_core_err(dev, "Failed to get RDMA RX namespace");
> +		err =3D -EOPNOTSUPP;
> +		goto free;
> +	}
> +
> +	ft_attr.max_fte =3D 1;
> +	ft =3D mlx5_create_flow_table(ns, &ft_attr);
> +	if (IS_ERR(ft)) {
> +		mlx5_core_err(dev, "Failed to create RDMA RX flow table");
> +		err =3D PTR_ERR(ft);
> +		goto free;
> +	}
> +
> +	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
> +		 MLX5_MATCH_MISC_PARAMETERS);
> +	match_criteria =3D MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
> +				      match_criteria);
> +	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
> +			 misc_parameters.source_port);
> +
> +	fg =3D mlx5_create_flow_group(ft, flow_group_in);
> +	if (IS_ERR(fg)) {
> +		err =3D PTR_ERR(fg);
> +		mlx5_core_err(dev, "Failed to create RDMA RX flow group err(%d)\n", er=
r);
> +		goto destroy_flow_table;
> +	}
> +
> +	spec->match_criteria_enable =3D MLX5_MATCH_MISC_PARAMETERS;
> +	misc =3D MLX5_ADDR_OF(fte_match_param, spec->match_value,
> +			    misc_parameters);
> +	MLX5_SET(fte_match_set_misc, misc, source_port,
> +		 dev->priv.eswitch->manager_vport);
> +	misc =3D MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> +			    misc_parameters);
> +	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
> +
> +	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_ALLOW;
> +	flow_rule =3D mlx5_add_flow_rules(ft, spec, &flow_act, NULL, 0);
> +	if (IS_ERR(flow_rule)) {
> +		err =3D PTR_ERR(flow_rule);
> +		mlx5_core_err(dev, "Failed to add RoCE allow rule, err=3D%d\n",
> +			      err);
> +		goto destroy_flow_group;
> +	}
> +
> +	kvfree(spec);
> +	kvfree(flow_group_in);
> +	roce->ft =3D ft;
> +	roce->fg =3D fg;
> +	roce->allow_rule =3D flow_rule;
> +
> +	return 0;
> +
> +destroy_flow_table:
> +	mlx5_destroy_flow_table(ft);
> +destroy_flow_group:
> +	mlx5_destroy_flow_group(fg);
> +free:
> +	kvfree(spec);
> +	kvfree(flow_group_in);
> +	return err;
> +}
> +
> +static void mlx5_rdma_del_roce_addr(struct mlx5_core_dev *dev)
> +{
> +	mlx5_core_roce_gid_set(dev, 0, 0, 0,
> +			       NULL, NULL, false, 0, 0);
> +}
> +
> +static void mlx5_rdma_make_default_gid(struct mlx5_core_dev *dev, union =
ib_gid *gid)
> +{
> +	u8 hw_id[ETH_ALEN];
> +
> +	mlx5_query_nic_vport_mac_address(dev, 0, hw_id);
> +	gid->global.subnet_prefix =3D cpu_to_be64(0xfe80000000000000LL);
> +	addrconf_addr_eui48(&gid->raw[8], hw_id);
> +}
> +
> +static int mlx5_rdma_add_roce_addr(struct mlx5_core_dev *dev)
> +{
> +	union ib_gid gid;
> +	u8 mac[ETH_ALEN];
> +
> +	mlx5_rdma_make_default_gid(dev, &gid);
> +	return mlx5_core_roce_gid_set(dev, 0,
> +				      MLX5_ROCE_VERSION_1,
> +				      0, gid.raw, mac,
> +				      false, 0, 1);
> +}
> +
> +void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev)
> +{
> +	mlx5_rdma_disable_roce_steering(dev);
> +	mlx5_rdma_del_roce_addr(dev);
> +	mlx5_nic_vport_disable_roce(dev);
> +}
> +
> +int mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
> +{
> +	int err;
> +
> +	err =3D mlx5_nic_vport_enable_roce(dev);
> +	if (err) {
> +		mlx5_core_err(dev, "Failed to enable RoCE: %d\n", err);
> +		return err;
> +	}
> +
> +	err =3D mlx5_rdma_add_roce_addr(dev);
> +	if (err) {
> +		mlx5_core_err(dev, "Failed to add RoCE address: %d\n", err);
> +		goto disable_roce;
> +	}
> +
> +	err =3D mlx5_rdma_enable_roce_steering(dev);
> +	if (err) {
> +		mlx5_core_err(dev, "Failed to enable RoCE steering: %d\n", err);
> +		goto del_roce_addr;
> +	}
> +
> +	return 0;
> +
> +del_roce_addr:
> +	mlx5_rdma_del_roce_addr(dev);
> +disable_roce:
> +	mlx5_nic_vport_disable_roce(dev);
> +	return err;
> +}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.h b/drivers/net=
/ethernet/mellanox/mlx5/core/rdma.h
> new file mode 100644
> index 000000000000..3d9e76c3d42f
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> +/* Copyright (c) 2019 Mellanox Technologies. */
> +
> +#ifndef __MLX5_RDMA_H__
> +#define __MLX5_RDMA_H__
> +
> +#include "mlx5_core.h"
> +
> +#ifdef CONFIG_MLX5_ESWITCH
> +
> +int mlx5_rdma_enable_roce(struct mlx5_core_dev *dev);
> +void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev);
> +
> +#else /* CONFIG_MLX5_ESWITCH */
> +
> +static inline int mlx5_rdma_enable_roce(struct mlx5_core_dev *dev) { ret=
urn 0; }
> +static inline void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev) {}
> +
> +#endif /* CONFIG_MLX5_ESWITCH */
> +#endif /* __MLX5_RDMA_H__ */
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index 582a9680b182..7fa95270dd59 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -512,6 +512,12 @@ struct mlx5_rl_table {
>  	struct mlx5_rl_entry   *rl_entry;
>  };
>
> +struct mlx5_core_roce {
> +	struct mlx5_flow_table *ft;
> +	struct mlx5_flow_group *fg;
> +	struct mlx5_flow_handle *allow_rule;
> +};
> +
>  struct mlx5_priv {
>  	struct mlx5_eq_table	*eq_table;
>
> @@ -565,6 +571,7 @@ struct mlx5_priv {
>  	struct mlx5_lag		*lag;
>  	struct mlx5_devcom	*devcom;
>  	unsigned long		pci_dev_data;
> +	struct mlx5_core_roce	roce;
>  	struct mlx5_fc_stats		fc_stats;
>  	struct mlx5_rl_table            rl_table;
>
> --
> 2.20.1
>
