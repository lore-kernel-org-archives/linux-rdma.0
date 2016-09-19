From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Sun, 18 Sep 2016 21:01:22 -0600
Message-ID: <20160919030122.GA23152@obsidianresearch.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
 <5cc0157c0f05701d8cb1334e6ee11e1e7be6fa24.1474063039.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5cc0157c0f05701d8cb1334e6ee11e1e7be6fa24.1474063039.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 17, 2016 at 05:59:11AM +0200, Knut Omang wrote:
> @@ -118,5 +118,9 @@ IBVERBS_1.1 {
>  		ibv_cmd_create_qp_ex2;
>  		ibv_cmd_open_qp;
>  		ibv_cmd_rereg_mr;
> +};
>  
> +IBVERBS_1.3 {
> +	global:
> +		ibv_cmd_create_ah_ex;
>  } IBVERBS_1.0;

This will probably end up being 1.4, and the 'tree' structure is
wrong, do not move this line:

>  } IBVERBS_1.0;

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
