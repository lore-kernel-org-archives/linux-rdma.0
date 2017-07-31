From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-rc 01/14] RDMA/(core,ulp): Convert register/unregister
 event handler to be void
Date: Mon, 31 Jul 2017 11:24:13 -0400
Message-ID: <1501514653.3009.6.camel@redhat.com>
References: <20170731070924.7193-1-leon@kernel.org>
         <20170731070924.7193-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The functions ib_register_event_handler() and
> ib_register_event_handler() always returned success and they can't
> fail.
> 
> Let's convert those functions to be void and remove redundant checks.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c                 | 23 ++++++++-------
> --------
>  drivers/infiniband/core/device.c                |  8 ++------
>  drivers/infiniband/core/sa_query.c              |  3 +--
>  drivers/infiniband/core/uverbs_main.c           | 13 +------------
>  drivers/infiniband/ulp/ipoib/ipoib_main.c       | 10 +---------
>  drivers/infiniband/ulp/iser/iser_verbs.c        |  6 ++----
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  7 +------
>  drivers/infiniband/ulp/srpt/ib_srpt.c           |  5 ++---
>  include/rdma/ib_verbs.h                         |  4 ++--
>  9 files changed, 20 insertions(+), 59 deletions(-)

Unless this fixes a build warning or an actual bug, this is not -rc
material.  You are putting a lot of stuff in -rc pull requests because
"they are simple one line changes" or "it's a cleanup".  That's not
what -rc is for.  It's for fixes, be they build fixes or run time
fixes.  Please split your pull requests appropriately and resubmit.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
