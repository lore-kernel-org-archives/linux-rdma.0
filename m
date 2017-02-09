From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 02/10] Remove uses of htonll
Date: Thu, 9 Feb 2017 16:23:52 -0600
Message-ID: <049a01d28323$31cae440$9560acc0$@opengridcomputing.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com> <1486677212-3188-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH rdma-core 02/10] Remove uses of htonll
> 
> Done via
> 
> $ git ls-files | xargs sed -i -e 's/htonll/htobe64/g'
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/include/acm_mad.h       | 84
+++++++++++++++++++++----------------------
>  ibacm/prov/acmp/src/acmp.c    | 10 +++---
>  ibacm/src/acm.c               |  6 ++--
>  providers/cxgb3/cxio_wr.h     |  2 +-
>  providers/cxgb3/qp.c          | 12 +++----
>  providers/cxgb4/t4.h          |  2 +-
>  providers/mlx4/qp.c           | 12 +++----
>  providers/mlx4/srq.c          |  2 +-
>  providers/mlx5/qp.c           | 24 ++++++-------
>  providers/mlx5/srq.c          |  2 +-
>  providers/mthca/qp.c          | 34 +++++++++---------
>  providers/mthca/srq.c         |  4 +--
>  providers/qedr/qelr_verbs.c   |  2 +-
>  srp_daemon/srp_daemon.c       | 16 ++++-----
>  srp_daemon/srp_handle_traps.c |  4 +--
>  15 files changed, 108 insertions(+), 108 deletions(-)

cxgb* parts look fine.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
