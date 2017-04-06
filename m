From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/qib: Fine-tuning for four function implementations
Date: Wed, 5 Apr 2017 20:37:50 -0400
Message-ID: <300e66f1-7a27-8e6f-7ee0-f4998e22b78f@intel.com>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c16b18ac-287f-5faf-b79a-c86e2adfa22c-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/05/2017 09:50 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Wed, 5 Apr 2017 15:34:32 +0200
>
> A few update suggestions were taken into account
> from static source code analysis.
>
> Markus Elfring (5):
>   Use kcalloc() in qib_init_iba7322_funcs()
>   Use kmalloc_array() in qib_init_7322_variables()
>   Use kcalloc() in qib_alloc_devdata()
>   Use kcalloc() in qib_init_pportdata()
>   Adjust two size determinations in qib_init_pportdata()
>
>  drivers/infiniband/hw/qib/qib_iba7322.c | 20 ++++++++++++--------
>  drivers/infiniband/hw/qib/qib_init.c    | 27 +++++++++++++--------------
>  2 files changed, 25 insertions(+), 22 deletions(-)
>

Doug,

I haven't reviewed these in detail yet but seems be along the lines of 
the patchset you decided not to take for cxgb [1]. I recommend not 
picking this up either. If something in here catches our eye Mike or I 
one will Ack it.

[1] http://marc.info/?l=linux-rdma&m=149141638506039&w=2

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
