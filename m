From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add padding to get proper end alignment
 of ibv_reg_mr_resp
Date: Thu, 1 Sep 2016 10:42:16 -0600
Message-ID: <20160901164216.GB6479@obsidianresearch.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
 <1472713193-22397-3-git-send-email-knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472713193-22397-3-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 08:59:52AM +0200, Knut Omang wrote:
> The user/kernel level API requires all parameter blocks to be
> 64 bit end aligned.
> 
> Also clean up some valgrind/memory initialization issues.
> 
> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>  include/infiniband/kern-abi.h | 1 +
>  src/cmd.c                     | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
> index f70fa44..8bdeef5 100644
> +++ b/include/infiniband/kern-abi.h
> @@ -367,6 +367,7 @@ struct ibv_reg_mr_resp {
>  	__u32 mr_handle;
>  	__u32 lkey;
>  	__u32 rkey;
> +	__u32 reserved;
>  };

This structure is a copy of include/uapi/rdma/ib_user_verbs.h, so you
need to start with a kernel patch proposing this change.

We will eventually get rid of kern-abi.h and use ib_user_verbs.h at some
point.

Maybe elaborate on why this is OK and doesn't break anything in that
patch..

> -	(void) VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
> +	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);

Why the (void)?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
