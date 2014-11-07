From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 6/6] ib/mlx5: change default node description processing
Date: Fri, 07 Nov 2014 07:17:49 -0500
Message-ID: <545CB86D.6010105@dev.mellanox.co.il>
References: <1414713021-12175-1-git-send-email-ira.weiny@intel.com> <1414713021-12175-7-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414713021-12175-7-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/30/2014 7:50 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Change the default node description string to IB_DEFAULT_ND_FORMAT
> Use ib_build_node_desc to dynamically map this string to set Node Description
> in FW
> 
> Reviewed-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Michael Heinz <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> ---
>  drivers/infiniband/hw/mlx5/main.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index a244317..a8bf1de 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -424,11 +424,12 @@ static int mlx5_ib_modify_device(struct ib_device *ibdev, int mask,
>  	if (!(mask & IB_DEVICE_MODIFY_NODE_DESC))
>  		return 0;
>  
> +	ib_build_node_desc(in.desc, props->node_desc, 64, ibdev);

Nit: Should this be IB_DEVICE_DESC_MAX rather than 64 ?

-- Hal

> +
>  	/*
>  	 * If possible, pass node desc to FW, so it can generate
>  	 * a 144 trap.  If cmd fails, just ignore.
>  	 */
> -	memcpy(&in, props->node_desc, 64);
>  	err = mlx5_core_access_reg(dev->mdev, &in, sizeof(in), &out,
>  				   sizeof(out), MLX5_REG_NODE_DESC, 0, 1);
>  	if (err)
> @@ -806,20 +807,18 @@ static int init_node_data(struct mlx5_ib_dev *dev)
>  	struct ib_smp *in_mad  = NULL;
>  	struct ib_smp *out_mad = NULL;
>  	int err = -ENOMEM;
> +	struct ib_device_modify props;
>  
>  	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
>  	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
>  	if (!in_mad || !out_mad)
>  		goto out;
>  
> -	init_query_mad(in_mad);
> -	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
> +	snprintf(props.node_desc, sizeof(props.node_desc)-1, "%s",
> +		 IB_DEFAULT_ND_FORMAT);
> +	mlx5_ib_modify_device(&dev->ib_dev, IB_DEVICE_MODIFY_NODE_DESC, &props);
>  
> -	err = mlx5_MAD_IFC(dev, 1, 1, 1, NULL, NULL, in_mad, out_mad);
> -	if (err)
> -		goto out;
> -
> -	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
> +	init_query_mad(in_mad);
>  
>  	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
