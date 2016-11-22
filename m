From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 02/11] IB/core: Change port_attr.sm_lid from 16 to 32
 bits
Date: Tue, 22 Nov 2016 13:57:17 -0700
Message-ID: <20161122205717.GA6484@obsidianresearch.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-3-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479843532-47496-3-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2016 at 02:38:43PM -0500, Dasaratharaman Chandramouli wrote:
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -958,7 +958,7 @@ static void update_sm_ah(struct work_struct *work)
>  		pr_err("Couldn't find index for default PKey\n");
>  
>  	memset(&ah_attr, 0, sizeof ah_attr);
> -	ah_attr.dlid     = port_attr.sm_lid;
> +	ah_attr.dlid     = (u16)port_attr.sm_lid;

Why are we dropping bits here?

> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -514,7 +514,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
>  	if (ret)
>  		goto err_query_port;
>  
> -	sport->sm_lid = port_attr.sm_lid;
> +	sport->sm_lid = (u16)port_attr.sm_lid;
>  	sport->lid = port_attr.lid;

And here..

> +#if !defined(OPA_ADDR_H)
> +#define OPA_ADDR_H

I don't think we need a header file for this.

> +#define OPA_TO_IB_UCAST_LID(x)	(((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
> +				 ? 0 : x)

static inline function please.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
