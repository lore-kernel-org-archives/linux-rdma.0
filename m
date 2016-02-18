From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 0/8] staging/rdma/hfi1,IB/rdmavt: Misc bug fixes
Date: Thu, 18 Feb 2016 22:39:23 +0200
Message-ID: <20160218203923.GH30450@leon.nu>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 18, 2016 at 11:11:48AM -0800, Dennis Dalessandro wrote:
> These patches fix a few issues in the hfi1 driver as well as a 0-day build error
> that was caught on my public GitHub tree.
> 
> Patch series applies on the recent "checkpatch fixes" series for hfi1. It can
> also be seen on GitHub at: https://github.com/ddalessa/kernel/tree/for-4.6.
> 
> ---
> 
> Dean Luick (5):
>       staging/rdma/hfi1: Fix xmit discard error weight
>       staging/rdma/hfi1: Fix debugfs access race
>       staging/rdma/hfi1: Disclose more information when i2c fails
>       staging/rdma/hfi1: Guard i2c access against cp
>       staging/rdma/hfi1: Fix counter read for cp
> 
> Easwar Hariharan (1):
>       staging/rdma/hfi1: Cleanup comments and logs in PHY code
> 
> Mike Marciniszyn (2):
>       staging/rdma/hfi1: fix 0-day syntax error
>       IB/rdamvt: fix cross build with rdmavt

For future submissions, can you be more consistent with capital letter
at the beginning of subject line?

Thanks.

> 
> 
>  drivers/infiniband/sw/rdmavt/vt.c   |    2 +
>  drivers/staging/rdma/hfi1/chip.c    |   67 +++++++++++++++++------------------
>  drivers/staging/rdma/hfi1/chip.h    |    6 +--
>  drivers/staging/rdma/hfi1/debugfs.c |   39 +++++++++++++-------
>  drivers/staging/rdma/hfi1/init.c    |    9 +++--
>  drivers/staging/rdma/hfi1/qsfp.c    |   46 +++++++++++-------------
>  drivers/staging/rdma/hfi1/sdma.c    |    6 ++-
>  7 files changed, 91 insertions(+), 84 deletions(-)
> 
> -- 
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
