From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join flags
Date: Sun, 3 Jul 2016 16:46:23 +0300
Message-ID: <CAJ3xEMjqkn09zFXZ5Fj3wvtM3GSa=vzgTuuVoAFENToa4Zh4uw@mail.gmail.com>
References: <1467550074-24061-1-git-send-email-leon@kernel.org> <1467550074-24061-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467550074-24061-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Added UCMA and CMA support for multicast join flags. Flags are
> passed using UCMA CM join command previously reserved fields.
> Currently supporting two join flags indicating two different
> multicast JoinStates:

[...]

>    ETH: When Send Only Full Member is requested no IGMP join
>         will be sent.

what's the use case for the ETH side of things?

>  drivers/infiniband/core/cma.c    | 98 +++++++++++++++++++++++++++++++++++++---
>  drivers/infiniband/core/ucma.c   | 18 ++++++--
>  include/rdma/ib_sa.h             |  5 ++
>  include/rdma/rdma_cm.h           |  4 +-
>  include/uapi/rdma/rdma_user_cm.h |  9 +++-
>  5 files changed, 122 insertions(+), 12 deletions(-)


For the ease/robustness of review for UAPI changes, we have a long
time common practice
to break things like this one to IB core kernel only patch, and one
that deals the user-space
facing things (e.g here ucma.c and rdma_user_cm.h), please do that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
