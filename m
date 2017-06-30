From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/3] IB/IPoIB/core/drivers: patches for rc/next
Date: Fri, 30 Jun 2017 13:14:28 -0700
Message-ID: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are three more patches. The first two we are fine with going into -next,
however the third is the patch Niranjana mentioned yesterday that would
be good to get into the last RC if the train hasn't left the station yet.

These have not been through zero-day but have been submitted. Niranjana's patch
is pretty straight forward and I don't foresee obscure build issues. So given
the time crunch for the slightest chance at 4.12 I'm taking a calculated risk
and sending. The patch applies ontop of our 4.12 patches cleanly. Builds and
tests in our environment.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.13

---

Bartlomiej Dudek (1):
      IB/hfi1: Check return values from PCI config API calls

Mike Marciniszyn (1):
      IB/iser: Handle lack of memory management extensions correctly

Niranjana Vishwanathapura (1):
      IB/core,opa_vnic,hfi1,mlx5: Properly free rdma_netdev


 drivers/infiniband/hw/hfi1/chip.c                 |   22 ++
 drivers/infiniband/hw/hfi1/hfi.h                  |    2 
 drivers/infiniband/hw/hfi1/pcie.c                 |  238 +++++++++++++++++----
 drivers/infiniband/hw/hfi1/verbs.c                |    1 
 drivers/infiniband/hw/hfi1/vnic.h                 |    1 
 drivers/infiniband/hw/hfi1/vnic_main.c            |   19 +-
 drivers/infiniband/hw/mlx5/main.c                 |   24 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c         |    8 -
 drivers/infiniband/ulp/iser/iser_verbs.c          |   10 +
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |    8 -
 include/rdma/ib_verbs.h                           |    6 -
 11 files changed, 260 insertions(+), 79 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
