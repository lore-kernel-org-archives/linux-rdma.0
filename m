From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 0/2] RDMA/vmw_pvrdma: Add RoCEv2 support
Date: Thu, 24 Aug 2017 17:36:35 -0400
Message-ID: <1503610595.78641.64.camel@redhat.com>
References: <cover.1503468979.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1503468979.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-22 at 23:18 -0700, Adit Ranadive wrote:
> Hi Doug,
> 
> These are a set of patches to add RoCEv2 support for the VMware
> PVRDMA
> driver as well as exposing some device caps. Please add these to your
> 4.14 queue.
> 
> Thanks,
> Adit
> ---
> Changes v0 -> v1:
>  - Consolidated the version macros.
>  - Added macros to check for compatibility.
>  - Squashed a previous patch #3 into patch #2.
>  - Removed an unused function.
>  - Updated tag lines correctly.
> ---
> Adit Ranadive (1):
>   RDMA/vmw_pvrdma: Update device query parameters and port caps
> 
> Bryan Tan (1):
>   RDMA/vmw_pvrdma: Add RoCEv2 support
> 
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  2 ++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 37
> +++++++++++++++++++++--
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 36 +++++++++--
> -----------
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c    |  7 +++++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |  9 ++++++
>  5 files changed, 68 insertions(+), 23 deletions(-)

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
