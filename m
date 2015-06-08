From: Devesh Sharma <devesh.sharma@avagotech.com>
Subject: Re: [PATCH] RDMA/ocrdma: fix double free on pd
Date: Mon, 8 Jun 2015 11:22:57 +0530
Message-ID: <CANjDDBhggAEgQf5g3yWPw2A03dmnFBGQETiZtMQrMqmOVsv2LQ@mail.gmail.com>
References: <1433515647-28059-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433515647-28059-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Selvin Xavier <selvin.xavier@emulex.com>, Devesh Sharma <devesh.sharma@emulex.com>, Mitesh Ahuja <mitesh.ahuja@emulex.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma@avagotech.com>

On Fri, Jun 5, 2015 at 8:17 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> A reorganisation of the PD allocation and deallocation in commit
> 9ba1377daa ("RDMA/ocrdma: Move PD resource management to driver.")
> introduced a double free on pd, as detected by static analysis by
> smatch:
>
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:682 ocrdma_alloc_pd()
>   error: double free of 'pd'^
>
> The original call to ocrdma_mbx_dealloc_pd() (which does not kfree
> pd) was replaced with a call to _ocrdma_dealloc_pd() (which does
> kfree pd).  The kfree following this call causes the double free,
> so just remove it to fix the problem.
>
> Fixes: 9ba1377daa ("RDMA/ocrdma: Move PD resource management to driver.")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 9dcb660..219f212 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -679,7 +679,6 @@ err:
>                 ocrdma_release_ucontext_pd(uctx);
>         } else {
>                 status = _ocrdma_dealloc_pd(dev, pd);
> -               kfree(pd);
>         }
>  exit:
>         return ERR_PTR(status);
> --
> 2.1.4
>
