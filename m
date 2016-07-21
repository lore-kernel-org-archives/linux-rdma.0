From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] IB/mlx4: Add sysfs entry for VF node_guid
Date: Thu, 21 Jul 2016 08:12:11 -0700
Message-ID: <7129f7b7-1e33-c170-7ab7-56ab5e22ff48@oracle.com>
References: <1469093572-6793-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469093572-6793-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/21/2016 2:32 AM, Yuval Shaia wrote:
> Adding sysfs entries to read/write VF's Node GUID.
> This abbility will enable sys-admin to configure node GUID for VFs the same
> way it is done for VF's port GUIDs.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
This is inline with port GUID for paravirtualized HCAs and seems
reasonable to me.

>  drivers/infiniband/hw/mlx4/sysfs.c |   72 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 72 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
> index 69fb5ba..6fc4366 100644
> --- a/drivers/infiniband/hw/mlx4/sysfs.c
> +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> @@ -371,6 +371,7 @@ struct mlx4_port {
>  	struct attribute_group gid_group;
>  	struct device_attribute	enable_smi_admin;
>  	struct device_attribute	smi_enabled;
> +	struct device_attribute	node_guid;
>  	int		       slave;
>  	u8                     port_num;
>  };
> @@ -620,6 +621,7 @@ static int add_vf_smi_entries(struct mlx4_port *p)
>  		sysfs_remove_file(&p->kobj, &p->smi_enabled.attr);
>  		return ret;
>  	}
> +
Stray change.

>  	return 0;
>  }
>
> @@ -635,6 +637,69 @@ static void remove_vf_smi_entries(struct mlx4_port *p)
>  	sysfs_remove_file(&p->kobj, &p->enable_smi_admin.attr);
>  }
>
> +static ssize_t sysfs_show_node_guid(struct device *dev,
> +				    struct device_attribute *attr,
> +				    char *buf)
> +{
> +	struct mlx4_port *p = container_of(attr, struct mlx4_port, node_guid);
> +	ssize_t len = 0;
> +	__be64 guid = mlx4_get_slave_node_guid(p->dev->dev, p->slave);
> +
> +	len = sprintf(buf, "slave %d 0x%llx\n", p->slave, be64_to_cpu(guid));
> +
> +	return len;
> +}
> +
> +static ssize_t sysfs_store_node_guid(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct mlx4_port *p = container_of(attr, struct mlx4_port, node_guid);
> +	__be64 guid;
> +
Shouldn't we check only master can set this up ?

> +	if (sscanf(buf, "0x%llx", &guid) != 1)
> +		return -EINVAL;
> +
> +	mlx4_put_slave_node_guid(p->dev->dev, p->slave, cpu_to_be64(guid));
> +
> +	return count;
> +}
> +
> +static int add_vf_admin_guid_entry(struct mlx4_port *p)
> +{
> +	int is_eth = rdma_port_get_link_layer(&p->dev->ib_dev, p->port_num) ==
> +		     IB_LINK_LAYER_ETHERNET;
> +	int ret;
> +
> +	/* do not display entries if eth transport, or if master */
> +	if (is_eth || p->slave == mlx4_master_func_num(p->dev->dev))
> +		return 0;
> +
> +	sysfs_attr_init(&p->node_guid.attr);
> +	p->node_guid.show = sysfs_show_node_guid;
> +	p->node_guid.store = sysfs_store_node_guid;
> +	p->node_guid.attr.name = "node_guid";
> +	p->node_guid.attr.mode = 0644;
> +	ret = sysfs_create_file(&p->kobj, &p->node_guid.attr);
> +	if (ret) {
> +		pr_err("failed to create sysfs entry for node_guid\n");
Use existing driver macro or append print with "mlx4_core:"
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void remove_vf_node_guid_entry(struct mlx4_port *p)
> +{
> +	int is_eth = rdma_port_get_link_layer(&p->dev->ib_dev, p->port_num) ==
> +			IB_LINK_LAYER_ETHERNET;
> +
> +	if (is_eth || p->slave == mlx4_master_func_num(p->dev->dev))
> +		return;
> +
> +	sysfs_remove_file(&p->kobj, &p->node_guid.attr);
> +}
> +
>  static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
>  {
>  	struct mlx4_port *p;
> @@ -686,6 +751,10 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
>  	if (ret)
>  		goto err_free_gid;
>
> +	ret = add_vf_admin_guid_entry(p);
> +	if (ret)
> +		goto err_free_gid;
> +
>  	list_add_tail(&p->kobj.entry, &dev->pkeys.pkey_port_list[slave]);
>  	return 0;
>
> @@ -743,6 +812,7 @@ static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
>  		if (err)
>  			goto err_add;
>  	}
> +
Stray change.

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
