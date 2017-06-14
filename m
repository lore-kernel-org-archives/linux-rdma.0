From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/5] Fixes for IPoIB flows
Date: Wed, 14 Jun 2017 15:20:07 -0400
Message-ID: <1497468007.7171.258.camel@redhat.com>
References: <20170614065909.23650-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614065909.23650-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-06-14 at 09:59 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> There are 5 small patches from Alex and Feras for IPoIB flows.
> 
> Thanks
> 
> Alex Vesker (4):
>   IB/ipoib: Fix memory leaks for child interfaces priv
>   IB/ipoib: Limit call to free rdma_netdev for capable devices
>   IB/ipoib: Delete napi in device uninit default
>   IB/ipoib: Fix access to un-initialized napi struct
> 
> Feras Daoud (1):
>   IB/ipoib: Fix memory leak in create child syscall
> 
>  drivers/infiniband/hw/mlx5/main.c         |  6 ++++--
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |  1 -
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 +++++++++++++--
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 11 +++++++----
>  4 files changed, 24 insertions(+), 9 deletions(-)

Thanks, series applied.  We are close to done with -rc fixes I hope,
yes?

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
