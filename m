From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-rc 01/14] RDMA/(core,ulp): Convert register/unregister
 event handler to be void
Date: Mon, 31 Jul 2017 09:03:12 -0400
Message-ID: <67e53715-1346-c969-b59a-ca4494d3b7c4@intel.com>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/31/2017 3:09 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The functions ib_register_event_handler() and
> ib_register_event_handler() always returned success and they can't fail.
> 
> Let's convert those functions to be void and remove redundant checks.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/cache.c                 | 23 ++++++++---------------
>   drivers/infiniband/core/device.c                |  8 ++------
>   drivers/infiniband/core/sa_query.c              |  3 +--
>   drivers/infiniband/core/uverbs_main.c           | 13 +------------
>   drivers/infiniband/ulp/ipoib/ipoib_main.c       | 10 +---------
>   drivers/infiniband/ulp/iser/iser_verbs.c        |  6 ++----
>   drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  7 +------
>   drivers/infiniband/ulp/srpt/ib_srpt.c           |  5 ++---
>   include/rdma/ib_verbs.h                         |  4 ++--
>   9 files changed, 20 insertions(+), 59 deletions(-)

I think you mean "... and ib_unregister_event_handler()". Also maybe 
mention a couple words about this lets us clean up some of the goto stuff.

Otherwise:

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
