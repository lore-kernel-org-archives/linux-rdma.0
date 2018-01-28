From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] IB/cxgb3: remove cxio_dbg.c
Date: Sun, 28 Jan 2018 14:09:03 -0700
Message-ID: <20180128210903.GL23869@ziepe.ca>
References: <1517152289-25052-1-git-send-email-clabbe@baylibre.com>
 <1517156662.765.10.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517156662.765.10.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Corentin Labbe <clabbe-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 08:24:22AM -0800, Joe Perches wrote:
> On Sun, 2018-01-28 at 15:11 +0000, Corentin Labbe wrote:
> > cxio_dbg.c is uncompiled since commit 2b540355cd2f ("RDMA/cxgb3: cleanups")
> > 10 years after, we could remove it.
> 
> OK, now you could remove the prototypes and probably
> CONFIG_INFINIBAND_CXGB3_DEBUG too.
> 
> There is a DEBUG test and many uses of pr_debug
> that would have modified behavior.
> 
> The pr_debug uses would only be emitted via a
> dynamic_debug enable and the #ifdef DEBUG is
> probably not necessary or useful as it guards
> a BUG_ON.
> 
>  drivers/infiniband/hw/cxgb3/Kconfig    | 9 ---------
>  drivers/infiniband/hw/cxgb3/Makefile   | 2 --
>  drivers/infiniband/hw/cxgb3/cxio_hal.h | 9 ---------
>  drivers/infiniband/hw/cxgb3/iwch_cq.c  | 7 -------
>  4 files changed, 27 deletions(-)

Yes, can you resend the patch with Joe's hunks as well?

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
