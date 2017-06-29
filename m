From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Fix OPA_VNIC issues with debug kernel
Date: Thu, 29 Jun 2017 14:02:34 -0400
Message-ID: <1498759354.2783.0.camel@redhat.com>
References: <1497468882-19161-1-git-send-email-niranjana.vishwanathapura@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497468882-19161-1-git-send-email-niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-06-14 at 12:34 -0700, Vishwanathapura, Niranjana wrote:
> Hi Doug,
> Here are couple OPA_VNIC bug fixes.
> As OPA_VNIC is alredy included for 4.12, it would be great
> to get them into the RC release.
> 
> Thanks,
> Niranjana
> 
> Vishwanathapura, Niranjana (2):
>   IB/opa_vnic: Use GFP_ATOMIC while sending trap
>   IB/opa_vnic: Use spinlock instead of mutex for stats_lock
> 
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c    | 4 ++--
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h   | 2 +-
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c     | 8 +++-----
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c       | 2 +-
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c | 8 ++++----
>  5 files changed, 11 insertions(+), 13 deletions(-)

I've pulled these in for what I expect to be my final -rc submission. 
Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
