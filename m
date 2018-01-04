From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 05/28] IB/srpt: Disable RDMA access by the initiator
Date: Wed, 3 Jan 2018 20:12:02 -0700
Message-ID: <20180104031202.GA20938@ziepe.ca>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
 <20180103213938.11664-6-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103213938.11664-6-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 01:39:15PM -0800, Bart Van Assche wrote:
> With the SRP protocol all RDMA operations are initiated by the target.
> Since no RDMA operations are initiated by the initiator, do not grant
> the initiator permission to submit RDMA reads or writes to the target.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 8a1bd354b1cc..7c4249038004 100644
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1013,8 +1013,7 @@ static int srpt_init_ch_qp(struct srpt_rdma_ch *ch, struct ib_qp *qp)
>  		return -ENOMEM;
>  
>  	attr->qp_state = IB_QPS_INIT;
> -	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
> -	    IB_ACCESS_REMOTE_WRITE;
> +	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE;
>  	attr->port_num = ch->sport->port;
>  	attr->pkey_index = 0;

Applied to for-rc thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
