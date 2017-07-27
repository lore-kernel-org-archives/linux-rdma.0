From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-rc 11/11] IB/ipoib: Notify on modify QP failure only when
 relevant
Date: Thu, 27 Jul 2017 10:59:14 -0400
Message-ID: <33e3467e-2011-ac32-6f95-3a8e9b19cfe0@intel.com>
References: <20170726181232.7363-1-leon@kernel.org>
 <20170726181232.7363-12-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-12-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/26/2017 2:12 PM, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Modify QP can fail and it can be acceptable, like when moving from RST to
> ERR state, all the rest are not acceptable and a message to the log
> should be printed.
> 
> The current code prints on all failures and many messages like:
> "Failed to modify QP to ERROR state" appear, even when supported by the
> state machine of the QP object.
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ib.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 02eda1f53a67..2e075377242e 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -711,6 +711,27 @@ static int recvs_pending(struct net_device *dev)
>   	return pending;
>   }
>   
> +static void check_qp_movement_and_print(struct ipoib_dev_priv *priv,
> +					struct ib_qp *qp,
> +					enum ib_qp_state new_state)
> +{
> +	struct ib_qp_attr qp_attr;
> +	struct ib_qp_init_attr query_init_attr;
> +	int ret;
> +
> +	ret = ib_query_qp(qp, &qp_attr, IB_QP_STATE, &query_init_attr);
> +	if (ret) {
> +		ipoib_warn(priv, "%s: Failed to query QP\n", __func__);
> +		return;
> +	}
> +	/* print according to the new-state and the previous state.*/
> +	if (new_state == IB_QPS_ERR && qp_attr.qp_state == IB_QPS_RESET)
> +		ipoib_dbg(priv, "Failed modify QP, IB_QPS_RESET to IB_QPS_ERR, acceptable\n");
> +	else
> +		ipoib_warn(priv, "Failed to modify QP to state: %d from state: %d\n",
> +			   new_state, qp_attr.qp_state);
> +}

So debug message instead of warn. I can live with that.

> +
>   int ipoib_ib_dev_stop_default(struct net_device *dev)
>   {
>   	struct ipoib_dev_priv *priv = ipoib_priv(dev);
> @@ -730,7 +751,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
>   	 */
>   	qp_attr.qp_state = IB_QPS_ERR;
>   	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
> -		ipoib_warn(priv, "Failed to modify QP to ERROR state\n");
> +		check_qp_movement_and_print(priv, priv->qp, IB_QPS_ERR);
>   
>   	/* Wait for all sends and receives to complete */
>   	begin = jiffies;
> 

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
