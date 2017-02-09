From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/4] cxgb4: Convert PDBG to pr_debug
Date: Thu, 9 Feb 2017 16:37:05 -0600
Message-ID: <04ce01d28325$0a3dda20$1eb98e60$@opengridcomputing.com>
References: <cover.1486678686.git.joe@perches.com> <747edc68212781296de30dd2b4e63711240da7a9.1486678686.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <747edc68212781296de30dd2b4e63711240da7a9.1486678686.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Joe Perches' <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH 4/4] cxgb4: Convert PDBG to pr_debug
> 
> Use a more typical logging style.
> 
> Miscellanea:
> 
> o Obsolete the c4iw_debug module parameter
> o Coalesce formats
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c       | 303
+++++++++++++++++----------------
>  drivers/infiniband/hw/cxgb4/cq.c       |  71 ++++----
>  drivers/infiniband/hw/cxgb4/device.c   |  58 +++----
>  drivers/infiniband/hw/cxgb4/ev.c       |  29 ++--
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  44 +++--
>  drivers/infiniband/hw/cxgb4/mem.c      |  28 +--
>  drivers/infiniband/hw/cxgb4/provider.c |  38 ++---
>  drivers/infiniband/hw/cxgb4/qp.c       |  91 +++++-----
>  drivers/infiniband/hw/cxgb4/resource.c |  46 ++---
>  drivers/infiniband/hw/cxgb4/t4.h       |  22 +--
>  10 files changed, 368 insertions(+), 362 deletions(-)


Looks good (and thanks).

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
