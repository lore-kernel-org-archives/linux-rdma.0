From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 0/2] InfiniBand-iSER: Refactoring for two function
 implementations
Date: Sun, 27 Dec 2015 14:43:23 +0200
Message-ID: <20151227124323.GF8501@leon.nu>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567FDB4E.2040000@users.sourceforge.net>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <567FDB4E.2040000-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 27, 2015 at 01:36:30PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sun, 27 Dec 2015 13:12:10 +0100
> Subject: [PATCH 0/2] InfiniBand-iSER: Refactoring for two function implementations
Just a note for the future submissions (no need to respin), we are using
different subject line: InfiniBand-iSER: --> IB/iser:

> 
> I suggest to return directly instead of using the jump label "err"
> in two functions (which are working without clean-up there).
> 
> Markus Elfring (2):
>   One jump label less in iser_reg_sig_mr()
>   One jump label less in isert_reg_sig_mr()
> 
>  drivers/infiniband/ulp/iser/iser_memory.c | 5 ++---
>  drivers/infiniband/ulp/isert/ib_isert.c   | 7 +++----
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> -- 
> 2.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
