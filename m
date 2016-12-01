From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] ibverbs: Allow vendor data response in
 create_ah command
Date: Thu, 1 Dec 2016 09:00:58 -0700
Message-ID: <20161201160058.GA22216@obsidianresearch.com>
References: <1480602353-8600-1-git-send-email-yishaih@mellanox.com>
 <1480602353-8600-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480602353-8600-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 01, 2016 at 04:25:52PM +0200, Yishai Hadas wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Let caller pass response buffer and response size to ibv_cmd_create_ah
> to enable kernel driver to return some private vendor data.
> 
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  libibverbs/cmd.c                | 11 ++++++-----
>  libibverbs/driver.h             |  4 +++-
>  providers/hfi1verbs/verbs.c     |  4 +++-
>  providers/ipathverbs/verbs.c    |  4 +++-
>  providers/ocrdma/ocrdma_verbs.c |  4 +++-
>  providers/rxe/rxe.c             |  4 +++-
>  6 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
> index 06a017b..eaf7164 100644
> +++ b/libibverbs/cmd.c
> @@ -1492,12 +1492,13 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
>  }
>  
>  int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
> -		      struct ibv_ah_attr *attr)
> +		      struct ibv_ah_attr *attr,
> +		      struct ibv_create_ah_resp *resp,
> +		      size_t resp_size)

NAK without changing the name of this function..

We need to decide if we want to have comapt for ibv_cmd_ driver facing
entry points, or discard that idea now that we only have one tree.

In this case it would be easy to provide two symbol versions for this
change so maybe that is what you should do..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
