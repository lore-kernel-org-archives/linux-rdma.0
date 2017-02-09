From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 03/10] Remove uses of ntohll
Date: Thu, 9 Feb 2017 16:24:42 -0600
Message-ID: <049c01d28323$4f844c10$ee8ce430$@opengridcomputing.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com> <1486677212-3188-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH rdma-core 03/10] Remove uses of ntohll
> 
> Done via
> 
> $ git ls-files | xargs sed -i -e 's/ntohll/be64toh/g'
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/prov/acmp/src/acmp.c |  2 +-
>  providers/cxgb4/dev.c      |  4 ++--
>  providers/cxgb4/t4.h       |  2 +-
>  providers/mlx5/cq.c        |  2 +-
>  providers/mlx5/qp.c        |  4 ++--
>  providers/mlx5/srq.c       |  2 +-
>  srp_daemon/srp_daemon.c    | 26 +++++++++++++-------------
>  7 files changed, 21 insertions(+), 21 deletions(-)
> 

cxgb* parts look fine.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
