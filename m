From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Fix 4.4 IB merge window regressions
Date: Mon, 30 Nov 2015 13:05:19 -0500
Message-ID: <20151130180519.GA9201@phlsvsds.ph.intel.com>
References: <20151130143326.24060.35941.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151130143326.24060.35941.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 30, 2015 at 09:34:15AM -0500, Mike Marciniszyn wrote:
> This two patch series fixes regressions for qib and hfi1
> introduced in the 4.4 merge window.
> 
> These are critical for 4.4 and for rebasing the qib/hfi1
> refactoring.

Doug, Greg,

It should also be noted that without this change to uverbs_cmd the hfi1 driver
is at least partially (ib_write_bw test) broken in staging-next.

Greg, if Linus pulls these from Doug into rc4 will you pull them into
staging-next?

Ira

> 
> ---
> 
> Ira Weiny (1):
>       IB/qib: Fix qib_mr structure
> 
> Mike Marciniszyn (1):
>       IB/core: correct issue with sge copyin corrupting wr
> 
> 
>  drivers/infiniband/core/uverbs_cmd.c  |   15 ++++++++++-----
>  drivers/infiniband/hw/qib/qib_verbs.h |    2 +-
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> -- 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
