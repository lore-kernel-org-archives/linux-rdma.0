From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/mlx4: Configure device to work in RoCEv2
Date: Tue, 29 Dec 2015 16:37:36 +0200
Message-ID: <56829AB0.3080805@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
 <1451395447-5198-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 3:24 PM, Matan Barak wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Some mlx4 adapters are RoCEv2 capable. To enable this feature some
> hardware configuration is required. This is
>
> 1. Set port general parameters
> 2. Configure the outgoing UDP destination port
> 3. Configure the QP that work with RoCEv2
>
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx4/main.c         | 19 ++++++++++++++---
>   drivers/infiniband/hw/mlx4/qp.c           | 35 ++++++++++++++++++++++++++++---
>   drivers/net/ethernet/mellanox/mlx4/fw.c   | 16 +++++++++++++-
>   drivers/net/ethernet/mellanox/mlx4/mlx4.h |  7 +++++--
>   drivers/net/ethernet/mellanox/mlx4/port.c |  8 +++++++
>   drivers/net/ethernet/mellanox/mlx4/qp.c   | 28 +++++++++++++++++++++++++
>   include/linux/mlx4/device.h               |  1 +
>   include/linux/mlx4/qp.h                   | 15 +++++++++++--
>   include/rdma/ib_verbs.h                   |  2 ++
>   9 files changed, 120 insertions(+), 11 deletions(-)

Better put (please do...) functionality which is plain mlx4 corish (such 
as new/modified FW commands, new SW/FW fields of structs and such) into 
mlx4_core patch.

>
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 988fa33..44e5699 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -384,6 +384,7 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
>   	int i;
>   	int ret;
>   	unsigned long flags;
> +	struct ib_gid_attr attr;
>   
>   	if (port_num > MLX4_MAX_PORTS)
>   		return -EINVAL;
> @@ -394,10 +395,13 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
>   	if (!rdma_cap_roce_gid_table(&ibdev->ib_dev, port_num))
>   		return index;
>   
> -	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, NULL);
> +	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, &attr);
>   	if (ret)
>   		return ret;
>   
> +	if (attr.ndev)
> +		dev_put(attr.ndev);
> +
>   	if (!memcmp(&gid, &zgid, sizeof(gid)))
>   		return -EINVAL;
>   
> @@ -405,7 +409,8 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
>   	port_gid_table = &iboe->gids[port_num - 1];
>   
>   	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i)
> -		if (!memcmp(&port_gid_table->gids[i].gid, &gid, sizeof(gid))) {
> +		if (!memcmp(&port_gid_table->gids[i].gid, &gid, sizeof(gid)) &&
> +		    attr.gid_type == port_gid_table->gids[i].gid_type) {
>   			ctx = port_gid_table->gids[i].ctx;
>   			break;
>   		}
> @@ -2481,7 +2486,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>   	if (mlx4_ib_init_sriov(ibdev))
>   		goto err_mad;
>   
> -	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) {
> +	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE ||
> +	    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
>   		if (!iboe->nb.notifier_call) {
>   			iboe->nb.notifier_call = mlx4_ib_netdev_event;
>   			err = register_netdevice_notifier(&iboe->nb);
> @@ -2490,6 +2496,13 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>   				goto err_notif;
>   			}
>   		}
> +		if (!mlx4_is_slave(dev) &&
> +		    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
> +			err = mlx4_config_roce_v2_port(dev, ROCE_V2_UDP_DPORT);
> +			if (err) {
> +				goto err_notif;
> +			}
> +		}
>   	}
>   
>   	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 8d28059..c0dee79 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -1508,6 +1508,24 @@ static int create_qp_lb_counter(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
>   	return 0;
>   }
>   
> +enum {
> +	MLX4_QPC_ROCE_MODE_1 = 0,
> +	MLX4_QPC_ROCE_MODE_2 = 2,
> +	MLX4_QPC_ROCE_MODE_MAX = 0xff
> +};
> +
> +static u8 gid_type_to_qpc(enum ib_gid_type gid_type)
> +{
> +	switch (gid_type) {
> +	case IB_GID_TYPE_ROCE:
> +		return MLX4_QPC_ROCE_MODE_1;
> +	case IB_GID_TYPE_ROCE_UDP_ENCAP:
> +		return MLX4_QPC_ROCE_MODE_2;
> +	default:
> +		return MLX4_QPC_ROCE_MODE_MAX;
> +	}
> +}
> +
>   static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
>   			       const struct ib_qp_attr *attr, int attr_mask,
>   			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
> @@ -1651,9 +1669,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
>   		u16 vlan = 0xffff;
>   		u8 smac[ETH_ALEN];
>   		int status = 0;
> +		int is_eth = rdma_cap_eth_ah(&dev->ib_dev, port_num) &&
> +			attr->ah_attr.ah_flags & IB_AH_GRH;
>   
> -		if (rdma_cap_eth_ah(&dev->ib_dev, port_num) &&
> -		    attr->ah_attr.ah_flags & IB_AH_GRH) {
> +		if (is_eth && attr->ah_attr.ah_flags & IB_AH_GRH) {
>   			int index = attr->ah_attr.grh.sgid_index;
>   
>   			status = ib_get_cached_gid(ibqp->device, port_num,
> @@ -1675,6 +1694,16 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
>   
>   		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
>   			   MLX4_QP_OPTPAR_SCHED_QUEUE);
> +
> +		if (is_eth &&
> +		    (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR)) {
> +			u8 qpc_roce_mode = gid_type_to_qpc(gid_attr.gid_type);
> +
> +			if (qpc_roce_mode == MLX4_QPC_ROCE_MODE_MAX)
> +				goto out;
> +			context->rlkey_roce_mode |= (qpc_roce_mode << 6);
> +		}
> +
>   	}
>   
>   	if (attr_mask & IB_QP_TIMEOUT) {
> @@ -1846,7 +1875,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
>   		sqd_event = 0;
>   
>   	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
> -		context->rlkey |= (1 << 4);
> +		context->rlkey_roce_mode |= (1 << 4);
>   
>   	/*
>   	 * Before passing a kernel QP to the HW, make sure that the
> diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
> index bdd6822..c8a0c3f 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/fw.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
> @@ -2232,7 +2232,8 @@ struct mlx4_config_dev {
>   	__be32	rsvd1[3];
>   	__be16	vxlan_udp_dport;
>   	__be16	rsvd2;
> -	__be32	rsvd3;
> +	__be16  roce_v2_entropy;
> +	__be16  roce_v2_udp_dport;
>   	__be32	roce_flags;
>   	__be32	rsvd4[25];
>   	__be16	rsvd5;
> @@ -2241,6 +2242,7 @@ struct mlx4_config_dev {
>   };
>   
>   #define MLX4_VXLAN_UDP_DPORT (1 << 0)
> +#define MLX4_ROCE_V2_UDP_DPORT BIT(3)
>   #define MLX4_DISABLE_RX_PORT BIT(18)
>   
>   static int mlx4_CONFIG_DEV_set(struct mlx4_dev *dev, struct mlx4_config_dev *config_dev)
> @@ -2358,6 +2360,18 @@ int mlx4_disable_rx_port_check(struct mlx4_dev *dev, bool dis)
>   	return mlx4_CONFIG_DEV_set(dev, &config_dev);
>   }
>   
> +int mlx4_config_roce_v2_port(struct mlx4_dev *dev, u16 udp_port)
> +{
> +	struct mlx4_config_dev config_dev;
> +
> +	memset(&config_dev, 0, sizeof(config_dev));
> +	config_dev.update_flags    = cpu_to_be32(MLX4_ROCE_V2_UDP_DPORT);
> +	config_dev.roce_v2_udp_dport = cpu_to_be16(udp_port);
> +
> +	return mlx4_CONFIG_DEV_set(dev, &config_dev);
> +}
> +EXPORT_SYMBOL_GPL(mlx4_config_roce_v2_port);

I didn't see a patch to the resource tracker, did you make sure that VFs 
can't attempt to configure the UDP port?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
