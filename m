From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma_cm: avoid assigning an IS_ERR value to cm id
 pointer in CMA id object
Date: Mon, 18 Jul 2011 16:35:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302E6B9@ORSMSX101.amr.corp.intel.com>
References: <201107141058.29879.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237302E14C@ORSMSX101.amr.corp.intel.com>
 <201107171346.48065.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201107171346.48065.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Avoid assigning an IS_ERR value to the cm id pointer in the cma_id object.
> This fixes a few anomalies in the error flow, and eliminates the need to
> test for the IS_ERR value every time we wish to determine if the cma_id object
> has a cm device associated with it.
> 
> Also, eliminate the now-unnecessary procedure cma_has_cm_dev (we can check
> directly
> for the existence of the device pointer -- for a non-NULL check, makes no
> difference
> if it is the iwarp or the ib pointer).
> 
> Finally, I suggest a few code changes here to improve coding consistency.
> 
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> 
> ---
> Sean,
> Here is the patch I said I would submit to you.
> I got rid of the cma_has_cm_dev() procedure, but if you think that it should
> be kept,
> but simply do the ib-pointer check only (to keep ib out of the rdma level),
> that is OK with me.

Thanks for doing this.  The patch looks good to me with one nit:

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index b6a33b3..85ce489 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c

> @@ -2577,7 +2579,7 @@ static int cma_connect_ib(struct rdma_id_private
> *id_priv,
> 
>  	ret = ib_send_cm_req(id_priv->cm_id.ib, &req);
>  out:
> -	if (ret && !IS_ERR(id_priv->cm_id.ib)) {
> +	if (ret && !IS_ERR(id)) {
>  		ib_destroy_cm_id(id_priv->cm_id.ib);

I would change the above line to ib_destroy_cm_id(id) to align the destroy call with the if statement.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
