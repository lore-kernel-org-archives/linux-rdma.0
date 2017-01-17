From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] iw_cxgb4: Guard against null cm_id in dump_ep/qp
Date: Tue, 17 Jan 2017 09:54:08 -0600
Message-ID: <06fe01d270d9$f0275790$d07606b0$@opengridcomputing.com>
References: <1483369573-9604-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483369573-9604-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ganesh Goudar' <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Endpoints that are aborting can have already dereferenced the
> cm_id and set ep->com.cm_id to NULL.  So guard against that in
> dump_ep() and dump_qp().
> 
> Also create a common function for setting up ip address pointers
> since the same logic is needed in several places.
> 
> Based on the original work of Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 133 ++++++++++++++++++++++-------
> ------
>  1 file changed, 84 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c
> b/drivers/infiniband/hw/cxgb4/device.c
> index 516b0ae..1c61b49 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -214,6 +214,52 @@ static const struct file_operations
> wr_log_debugfs_fops = {
>  	.write   = wr_log_clear,
>  };
> 
> +static struct sockaddr_in zero_sin = {
> +	.sin_family = AF_INET,
> +};
> +
> +static struct sockaddr_in6 zero_sin6 = {
> +	.sin6_family = AF_INET6,
> +};
> +
> +static void set_ep_sin_addrs(struct c4iw_ep *ep,
> +			     struct sockaddr_in **lsin,
> +			     struct sockaddr_in **rsin,
> +			     struct sockaddr_in **m_lsin,
> +			     struct sockaddr_in **m_rsin)
> +{
> +	struct iw_cm_id *id = ep->com.cm_id;
> +
> +	*lsin = (struct sockaddr_in *)&ep->com.local_addr;
> +	*rsin = (struct sockaddr_in *)&ep->com.remote_addr;
> +	if (id) {
> +		*m_lsin = (struct sockaddr_in *)&id->local_addr;
> +		*m_rsin = (struct sockaddr_in *)&id->remote_addr;

The above two should be using id->m_local_addr and id->m_remote_addr.

> +	} else {
> +		*m_lsin = &zero_sin;
> +		*m_rsin = &zero_sin;
> +	}
> +}
> +
> +static void set_ep_sin6_addrs(struct c4iw_ep *ep,
> +			      struct sockaddr_in6 **lsin6,
> +			      struct sockaddr_in6 **rsin6,
> +			      struct sockaddr_in6 **m_lsin6,
> +			      struct sockaddr_in6 **m_rsin6)
> +{
> +	struct iw_cm_id *id = ep->com.cm_id;
> +
> +	*lsin6 = (struct sockaddr_in6 *)&ep->com.local_addr;
> +	*rsin6 = (struct sockaddr_in6 *)&ep->com.remote_addr;
> +	if (id) {
> +		*m_lsin6 = (struct sockaddr_in6 *)&id->local_addr;
> +		*m_rsin6 = (struct sockaddr_in6 *)&id->remote_addr;

Same thing here.


Other than that, this looks good.  Please repost a V2 and add my Reviewed-by
tag.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
