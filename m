From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 01/17] IB/mad: Remove debug prints after allocation failure
Date: Thu, 15 Dec 2016 22:43:09 -0500
Message-ID: <20161216034308.GB12582@phlsvsds.ph.intel.com>
References: <1478184265-9620-1-git-send-email-leon@kernel.org> <1478184265-9620-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478184265-9620-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 03, 2016 at 04:44:09PM +0200, Leon Romanovsky wrote:
> The prints after [k|v][m|z|c]alloc() functions are not needed,
> because in case of failure, allocator will print their internal
> error prints anyway.
> 
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/mad.c | 40 ++++++----------------------------------
>  1 file changed, 6 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 40cbd6b..dadce12 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -816,7 +816,6 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>  	local = kmalloc(sizeof *local, GFP_ATOMIC);
>  	if (!local) {
>  		ret = -ENOMEM;
> -		dev_err(&device->dev, "No memory for ib_mad_local_private\n");
>  		goto out;
>  	}
>  	local->mad_priv = NULL;
> @@ -824,7 +823,6 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>  	mad_priv = alloc_mad_private(mad_size, GFP_ATOMIC);
>  	if (!mad_priv) {
>  		ret = -ENOMEM;
> -		dev_err(&device->dev, "No memory for local response MAD\n");
>  		kfree(local);
>  		goto out;
>  	}
> @@ -947,9 +945,6 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
>  	for (left = send_buf->data_len + pad; left > 0; left -= seg_size) {
>  		seg = kmalloc(sizeof (*seg) + seg_size, gfp_mask);
>  		if (!seg) {
> -			dev_err(&send_buf->mad_agent->device->dev,
> -				"alloc_send_rmpp_segs: RMPP mem alloc failed for len %zd, gfp %#x\n",
> -				sizeof (*seg) + seg_size, gfp_mask);
>  			free_send_rmpp_list(send_wr);
>  			return -ENOMEM;
>  		}
> @@ -1362,12 +1357,7 @@ static int allocate_method_table(struct ib_mad_mgmt_method_table **method)
>  {
>  	/* Allocate management method table */
>  	*method = kzalloc(sizeof **method, GFP_ATOMIC);
> -	if (!*method) {
> -		pr_err("No memory for ib_mad_mgmt_method_table\n");
> -		return -ENOMEM;
> -	}
> -
> -	return 0;
> +	return (*method) ? 0 : (-ENOMEM);
>  }
>  
>  /*
> @@ -1458,8 +1448,6 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
>  		/* Allocate management class table for "new" class version */
>  		*class = kzalloc(sizeof **class, GFP_ATOMIC);
>  		if (!*class) {
> -			dev_err(&agent_priv->agent.device->dev,
> -				"No memory for ib_mad_mgmt_class_table\n");
>  			ret = -ENOMEM;
>  			goto error1;
>  		}
> @@ -1524,22 +1512,16 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
>  	if (!*vendor_table) {
>  		/* Allocate mgmt vendor class table for "new" class version */
>  		vendor = kzalloc(sizeof *vendor, GFP_ATOMIC);
> -		if (!vendor) {
> -			dev_err(&agent_priv->agent.device->dev,
> -				"No memory for ib_mad_mgmt_vendor_class_table\n");
> +		if (!vendor)
>  			goto error1;
> -		}
>  
>  		*vendor_table = vendor;
>  	}
>  	if (!(*vendor_table)->vendor_class[vclass]) {
>  		/* Allocate table for this management vendor class */
>  		vendor_class = kzalloc(sizeof *vendor_class, GFP_ATOMIC);
> -		if (!vendor_class) {
> -			dev_err(&agent_priv->agent.device->dev,
> -				"No memory for ib_mad_mgmt_vendor_class\n");
> +		if (!vendor_class)
>  			goto error2;
> -		}
>  
>  		(*vendor_table)->vendor_class[vclass] = vendor_class;
>  	}
> @@ -2238,11 +2220,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  
>  	mad_size = recv->mad_size;
>  	response = alloc_mad_private(mad_size, GFP_KERNEL);
> -	if (!response) {
> -		dev_err(&port_priv->device->dev,
> -			"%s: no memory for response buffer\n", __func__);
> +	if (!response)
>  		goto out;
> -	}
>  
>  	if (rdma_cap_ib_switch(port_priv->device))
>  		port_num = wc->port_num;
> @@ -2869,8 +2848,6 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
>  			mad_priv = alloc_mad_private(port_mad_size(qp_info->port_priv),
>  						     GFP_ATOMIC);
>  			if (!mad_priv) {
> -				dev_err(&qp_info->port_priv->device->dev,
> -					"No memory for receive buffer\n");
>  				ret = -ENOMEM;
>  				break;
>  			}
> @@ -2961,11 +2938,8 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
>  	u16 pkey_index;
>  
>  	attr = kmalloc(sizeof *attr, GFP_KERNEL);
> -	if (!attr) {
> -		dev_err(&port_priv->device->dev,
> -			"Couldn't kmalloc ib_qp_attr\n");
> +	if (!attr)
>  		return -ENOMEM;
> -	}
>  
>  	ret = ib_find_pkey(port_priv->device, port_priv->port_num,
>  			   IB_DEFAULT_PKEY_FULL, &pkey_index);
> @@ -3135,10 +3109,8 @@ static int ib_mad_port_open(struct ib_device *device,
>  
>  	/* Create new device info */
>  	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
> -	if (!port_priv) {
> -		dev_err(&device->dev, "No memory for ib_mad_port_private\n");
> +	if (!port_priv)
>  		return -ENOMEM;
> -	}
>  
>  	port_priv->device = device;
>  	port_priv->port_num = port_num;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
