From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add new call ibv_cmd_create_ah_ex which
 supports extra parameters
Date: Thu, 1 Sep 2016 10:49:39 -0600
Message-ID: <20160901164939.GD6479@obsidianresearch.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
 <1472713193-22397-2-git-send-email-knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472713193-22397-2-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 08:59:51AM +0200, Knut Omang wrote:
> +++ b/src/libibverbs.map
> @@ -64,6 +64,7 @@ IBVERBS_1.0 {
>  		ibv_cmd_post_recv;
>  		ibv_cmd_post_srq_recv;
>  		ibv_cmd_create_ah;
> +		ibv_cmd_create_ah_ex;

I should also point out that this is not the proper way to use symbol
versions. Typically one would tag new symbols with the version number
of the release that introduces them, and not just keep re-using 1.0

I know we haven't been doing that, but perhaps we should start.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
