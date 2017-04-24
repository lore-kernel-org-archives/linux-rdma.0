From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Core fixes and cleanup
Date: Mon, 24 Apr 2017 12:09:39 -0400
Message-ID: <1493050179.3041.34.camel@redhat.com>
References: <20170319085557.6023-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170319085557.6023-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-03-19 at 10:55 +0200, Leon Romanovsky wrote:
> Hi Doug,
> 
> Please find below three patches for IB/core and this series
> are based on v4.11-rc2.
> 
> Thanks
> 
> Jack Morgenstein (1):
>   IB/core: Fix sysfs registration error flow
> 
> Leon Romanovsky (1):
>   IB/umem: Drop hugetlb variable and VMA allocation
> 
> Parav Pandit (1):
>   IB/core: Fix kernel crash during fail to initialize device
> 
>  drivers/infiniband/core/device.c          | 33 ++++++++++++++++++++-
> ----------
>  drivers/infiniband/core/sysfs.c           |  2 +-
>  drivers/infiniband/core/umem.c            | 23 ++-------------------
>  drivers/infiniband/core/umem_odp.c        |  1 -
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  6 +-----
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c  |  1 -
>  include/rdma/ib_umem.h                    |  1 -
>  8 files changed, 27 insertions(+), 42 deletions(-)

Series, minus the patch that would break Intel's driver, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
