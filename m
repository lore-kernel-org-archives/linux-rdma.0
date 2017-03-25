From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/vmw_pvrdma updates for 4.11
Date: Fri, 24 Mar 2017 20:54:01 -0400
Message-ID: <1490403241.2404.29.camel@redhat.com>
References: <cover.1487812849.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1487812849.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-02-22 at 17:22 -0800, Adit Ranadive wrote:
> Hi Doug,
> 
> Here are some minor updates we had for the VMware PVRDMA driver.
> These
> apply cleanly to your k.o/for-4.11 branch.
> 
> Thanks,
> Adit
> 
> Adit Ranadive (2):
>   RDMA/vmw_pvrdma: Cleanup unused variables
>   RDMA/vmw_pvrdma: Dont hardcode QP header page
> 
> Aditya Sarwade (1):
>   RDMA/vmw_pvrdma: Activate device on ethernet link up
> 
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  3 ++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |  2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 17 ++++++---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c      | 42 ++++++++++---
> ----------
>  4 files changed, 35 insertions(+), 29 deletions(-)

Thanks, series applied for -rc.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
