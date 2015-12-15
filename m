From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH RESEND] infiniband:core:Add needed error path in
 cm_init_av_by_path
Date: Tue, 15 Dec 2015 17:38:34 +0100
Message-ID: <5670420A.7040202@profitbricks.com>
References: <1450194724-7107-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450194724-7107-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/15/2015 04:52 PM, Nicholas Krause wrote:
> This adds a needed error path in the function, cm_init_av_by_path
> after the call to ib_init_ah_from_path in order to avoid incorrectly
> accessing the path pointer of structure type ib_sa_path_rec if this
> function call fails to complete its intended work successfully by
> returning a error code.
> 
> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 0a26dd6..e9b36ea 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -383,8 +383,11 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
>  		return ret;
>  
>  	av->port = port;
> -	ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
> -			     &av->ah_attr);
> +	ret = ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
> +				   &av->ah_attr);

..Just wondering what if the transport don't require GRH?
eg inside the same subnet?

The hop_limit is only suggest that the package allowed to be
routed, not have to, correct?

Regards,
Michael Wang

> +	if (ret)
> +		return ret;
> +
>  	av->timeout = path->packet_life_time + 1;
>  
>  	return 0;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
