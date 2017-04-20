From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/hfi1: Fine-tuning for three function
 implementations
Date: Thu, 20 Apr 2017 16:29:51 -0400
Message-ID: <1492720191.3041.10.camel@redhat.com>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8a997282-09c7-0f9f-645e-d7c6e8c79e67-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-02-10 at 22:00 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Fri, 10 Feb 2017 21:53:21 +0100
> 
> A few update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (5):
>   Use kcalloc() in hfi1_user_exp_rcv_init()
>   Use kcalloc() in hfi1_user_sdma_alloc_queues()
>   Adjust another size determination in hfi1_user_sdma_alloc_queues()
>   Use memdup_user() rather than duplicating its implementation in
> hfi1_user_sdma_process_request()
>   Improve another size determination in
> hfi1_user_sdma_process_request()
> 
>  drivers/infiniband/hw/hfi1/user_exp_rcv.c |  5 +++--
>  drivers/infiniband/hw/hfi1/user_sdma.c    | 35 +++++++++++++++----
> ------------
>  2 files changed, 20 insertions(+), 20 deletions(-)

I took 4 of the 5, leaving out the one that was addressed separately by
an Intel patch.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
