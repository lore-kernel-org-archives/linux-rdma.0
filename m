From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] IB/IPoIB/core/drivers: patches for rc/next
Date: Mon, 31 Jul 2017 15:04:08 -0400
Message-ID: <1501527848.2725.2.camel@redhat.com>
References: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170630201236.5213.72919.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-06-30 at 13:14 -0700, Dennis Dalessandro wrote:
> Hi Doug,
> 
> Here are three more patches. The first two we are fine with going
> into -next,
> however the third is the patch Niranjana mentioned yesterday that
> would
> be good to get into the last RC if the train hasn't left the station
> yet.

Hi Denny,

This pull is a bit confusing, but I figured it out.  I had already
grabbed patch #1 from a previous time that you submitted the same patch
(I know this because it still has the spelling error in the subject,
and made it into Linus' tree with that spelling error, whereas the
subject spelling is corrected in this submission).  So, #1 is done, and
#3 was done too (I fixed it up to resolve the crash Leon referenced). 
So, that only leaves #2 undone.  Adding it to -next right now.

> These have not been through zero-day but have been submitted.
> Niranjana's patch
> is pretty straight forward and I don't foresee obscure build issues.
> So given
> the time crunch for the slightest chance at 4.12 I'm taking a
> calculated risk
> and sending. The patch applies ontop of our 4.12 patches cleanly.
> Builds and
> tests in our environment.
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.13
> 
> ---
> 
> Bartlomiej Dudek (1):
>       IB/hfi1: Check return values from PCI config API calls
> 
> Mike Marciniszyn (1):
>       IB/iser: Handle lack of memory management extensions correctly
> 
> Niranjana Vishwanathapura (1):
>       IB/core,opa_vnic,hfi1,mlx5: Properly free rdma_netdev
> 
> 
>  drivers/infiniband/hw/hfi1/chip.c                 |   22 ++
>  drivers/infiniband/hw/hfi1/hfi.h                  |    2 
>  drivers/infiniband/hw/hfi1/pcie.c                 |  238
> +++++++++++++++++----
>  drivers/infiniband/hw/hfi1/verbs.c                |    1 
>  drivers/infiniband/hw/hfi1/vnic.h                 |    1 
>  drivers/infiniband/hw/hfi1/vnic_main.c            |   19 +-
>  drivers/infiniband/hw/mlx5/main.c                 |   24 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c         |    8 -
>  drivers/infiniband/ulp/iser/iser_verbs.c          |   10 +
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |    8 -
>  include/rdma/ib_verbs.h                           |    6 -
>  11 files changed, 260 insertions(+), 79 deletions(-)
> 
> --
> -Denny
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
