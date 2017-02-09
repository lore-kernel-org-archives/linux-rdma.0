From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/4] cxgb4: Use more common logging style
Date: Thu, 9 Feb 2017 16:36:28 -0600
Message-ID: <04cc01d28324$f45bbd80$dd133880$@opengridcomputing.com>
References: <cover.1486678686.git.joe@perches.com> <d054cd530aeef452c7c252504f7d4d6ebba31ae3.1486678686.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d054cd530aeef452c7c252504f7d4d6ebba31ae3.1486678686.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Joe Perches' <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Convert printks to pr_<level>
> 
> Miscellanea:
> 
> o Coalesce formats
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c       | 84
+++++++++++++++-------------------
>  drivers/infiniband/hw/cxgb4/cq.c       |  8 ++--
>  drivers/infiniband/hw/cxgb4/device.c   | 83 ++++++++++++++-------------------
>  drivers/infiniband/hw/cxgb4/ev.c       | 10 ++--
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  6 +++
>  drivers/infiniband/hw/cxgb4/mem.c      |  6 +--
>  drivers/infiniband/hw/cxgb4/provider.c |  4 +-
>  drivers/infiniband/hw/cxgb4/qp.c       |  5 +-
>  drivers/infiniband/hw/cxgb4/resource.c | 18 +++-----
>  drivers/infiniband/hw/cxgb4/t4.h       |  2 +-
>  10 files changed, 97 insertions(+), 129 deletions(-)
>

Looks good (and thanks).

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
