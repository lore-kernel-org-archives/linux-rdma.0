From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 0/7] IB/opa_vnic: Fixes for RC
Date: Tue, 26 Sep 2017 06:43:41 -0700
Message-ID: <20170926134250.11429.58329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Continuing with our 4.14 rc material here is a series dedicated to vnic. These
are pretty minor. If you'd rather wait and push off to for-next and put into
4.15 that's OK as well. I do have a 2 patch series coming up that does add new
functionality so I'll submit that against for-next specifically.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.14

---

Niranjana Vishwanathapura (6):
      IB/opa_vnic: Mark unused Ethernet MTU fields as reserved
      IB/opa_vnic: Set POD value for Ethernet MTU
      IB/opa_vnic: Allow reset of MAC address
      IB/opa_vnic: Properly return the total MACs in UC MAC list
      IB/opa_vnic: Properly set vesw port status
      IB/opa_vnic: Add routing control information

Scott Franco (1):
      IB/opa_vnic: Properly clear Mac Table Digest


 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   42 ++++++++++++++++++-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h   |   22 ++++++++--
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    7 ++-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c  |   44 ++++++++++++++------
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |    1 
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |   22 +++++-----
 6 files changed, 103 insertions(+), 35 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
