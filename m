From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/6] ib/mthca: change default node description processing
Date: Fri, 07 Nov 2014 07:17:39 -0500
Message-ID: <545CB863.3040607@dev.mellanox.co.il>
References: <1414713021-12175-1-git-send-email-ira.weiny@intel.com> <1414713021-12175-5-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414713021-12175-5-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/30/2014 7:50 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Change the default node description string to IB_DEFAULT_ND_FORMAT
> Use ib_build_node_desc to dynamically map this string when queried
> 
> Reviewed-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Michael Heinz <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> ---
>  drivers/infiniband/hw/mthca/mthca_mad.c      |  3 ++-
>  drivers/infiniband/hw/mthca/mthca_provider.c | 12 +++---------
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
> index 8881fa3..2c15359 100644
> --- a/drivers/infiniband/hw/mthca/mthca_mad.c
> +++ b/drivers/infiniband/hw/mthca/mthca_mad.c
> @@ -153,7 +153,8 @@ static void node_desc_override(struct ib_device *dev,
>  	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
>  	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
>  		mutex_lock(&to_mdev(dev)->cap_mask_mutex);
> -		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
> +		ib_build_node_desc(((struct ib_smp *)mad)->data, dev->node_desc,
> +				   64, dev);

Nit: Should this be IB_DEVICE_DESC_MAX rather than 64 ?

-- Hal

>  		mutex_unlock(&to_mdev(dev)->cap_mask_mutex);
>  	}
>  }
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
> index 415f8e1..c8e3d23 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -1217,16 +1217,10 @@ static int mthca_init_node_data(struct mthca_dev *dev)
>  	if (!in_mad || !out_mad)
>  		goto out;
>  
> -	init_query_mad(in_mad);
> -	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
> -
> -	err = mthca_MAD_IFC(dev, 1, 1,
> -			    1, NULL, NULL, in_mad, out_mad);
> -	if (err)
> -		goto out;
> -
> -	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
> +	snprintf(dev->ib_dev.node_desc, sizeof(dev->ib_dev.node_desc)-1, "%s",
> +		 IB_DEFAULT_ND_FORMAT);
>  
> +	init_query_mad(in_mad);
>  	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
>  
>  	err = mthca_MAD_IFC(dev, 1, 1,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
