From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 2/4] cxgb3: Convert PDBG to pr_debug
Date: Thu, 9 Feb 2017 16:35:30 -0600
Message-ID: <04ca01d28324$d1a99960$74fccc20$@opengridcomputing.com>
References: <cover.1486678686.git.joe@perches.com> <41a74ceecd35cf2f38e2a1a1a394c7718547deb6.1486678686.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <41a74ceecd35cf2f38e2a1a1a394c7718547deb6.1486678686.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Joe Perches' <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 2/4] cxgb3: Convert PDBG to pr_debug
> 
> Using the normal mechanism, not an indirected one, is clearer.
> 
> Miscellanea:
> 
> o Coalesce formats
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_dbg.c      |  35 ++---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c      | 174 ++++++++++++------------
>  drivers/infiniband/hw/cxgb3/cxio_hal.h      |   2 -
>  drivers/infiniband/hw/cxgb3/cxio_resource.c |  20 +--
>  drivers/infiniband/hw/cxgb3/iwch.c          |   6 +-
>  drivers/infiniband/hw/cxgb3/iwch_cm.c       | 203
++++++++++++++--------------
>  drivers/infiniband/hw/cxgb3/iwch_cm.h       |  18 +--
>  drivers/infiniband/hw/cxgb3/iwch_cq.c       |  14 +-
>  drivers/infiniband/hw/cxgb3/iwch_ev.c       |  15 +-
>  drivers/infiniband/hw/cxgb3/iwch_mem.c      |   2 +-
>  drivers/infiniband/hw/cxgb3/iwch_provider.c | 101 +++++++-------
>  drivers/infiniband/hw/cxgb3/iwch_provider.h |   9 +-
>  drivers/infiniband/hw/cxgb3/iwch_qp.c       |  60 ++++----
>  13 files changed, 329 insertions(+), 330 deletions(-)
> 

Looks good (and thanks).

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
