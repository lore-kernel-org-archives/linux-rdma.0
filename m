From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V9 libmlx4 0/2] Add extension and XRC QP support
Date: Tue, 6 Aug 2013 18:03:16 +0300
Message-ID: <CAJZOPZJ9gr=4Z-9XK0JRcojsXEwzXV9Hn+1h-vcu3fcvbWxM-Q@mail.gmail.com>
References: <1375369555-11416-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375369555-11416-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 1, 2013 at 6:05 PM, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Extend XRC support to user space. Because XRC requires
> new verbs and extensions to existing verbs, we first implement the
> infra-structure changes needed to support verbs extensions matching to
> libibverbs scheme, later XRC support is built on top of that infrastructure.

Hi Roland,

Well, its been quite a while since Sean's initial post back on
November 2011 of libibverbs extensions + XRC support plus the
accompanying libmlx4 patches.

And here we are now on this warmish August of 2013 with this series
which is signed by Sean/Yishai/Tzahi && acked (extensions part) by
Jason.

Could you finally-long-lastish post some comments on how you see this?
any bugs or flames you find here, is this going to be accepted? when?

Or.

> Changes from V8:
> Patch 1:
> to_mdev - moved to use container_of
> fixed comment to use verbs_set_ctx_op
> - Jason Gunthorpe pointed to give his ack for that patch after above changes.
>
> Changes from V7:
> Adapted code to use the new helper macro verbs_set_ctx_op from V8 of libibverbs.
>
> Changes from V6:
> Adapted to latest master branch.
> Bug fixes, details in relevant patches.
>
> Sean Hefty (1):
>   Add support for XRC QPs
>
> Yishai Hadas (1):
>   Infra-structure changes to support verbs extensions
>
>  src/buf.c      |    6 +-
>  src/cq.c       |   42 ++++++++---
>  src/mlx4-abi.h |    6 ++
>  src/mlx4.c     |   80 +++++++++++---------
>  src/mlx4.h     |   69 ++++++++++++++++--
>  src/qp.c       |   39 ++++++----
>  src/srq.c      |  153 ++++++++++++++++++++++++++++++++++++++
>  src/verbs.c    |  224
> +++++++++++++++++++++++++++++++++++++++++--------------
>  8 files changed, 492 insertions(+), 127 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
