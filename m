From: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] usnix: correctly handle kzalloc return value
Date: Mon, 19 Oct 2015 11:24:32 -0500
Message-ID: <20151019162431.GA42659@DGOODELL-M-F02A.cisco.com>
References: <1445108816-7616-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445108816-7616-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 17, 2015 at 07:06:56PM +0000, Insu Yun wrote:
> Since kzalloc returns memory address, not error code,
> it should be checked whether it is null or not. 
> 
> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

The subject says "usnix" where it should say "usnic".  Otherwise:

Reviewed-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

If you have more of these fixes for drivers/infiniband/hw/usnic/, you
can send them all through just Doug Ledford and linux-rdma@, no need to
copy all of linux-kernel@.  You can also CC me instead of Upinder, whose
email bounces at this point, though I will see your patches sent to
linux-rdma@ even if I'm not explicitly CC-ed.  The patch to update
MAINTAINERS for usnic has been submitted but hasn't yet percolated
somewhere you would have seen it:

https://patchwork.kernel.org/patch/7410421/

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
