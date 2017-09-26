From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Tue, 26 Sep 2017 07:08:37 -0700
Message-ID: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are the other two patches for opa_vnic. This adds a debugfs interface and
that is why I'm sending it as a separate series apart from the rest of our
submissions. The goal is to support view/modify of the VESW port config.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Niranjana Vishwanathapura (2):
      IB/opa_vnic: Add debugfs support to OPA VNIC
      IB/opa_vnic: Support adding OPA VNIC vports through debug interface


 drivers/infiniband/ulp/opa_vnic/Makefile           |    1 
 drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c |  667 ++++++++++++++++++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h |   70 ++
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |   36 +
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |   47 +
 5 files changed, 789 insertions(+), 32 deletions(-)
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c
 create mode 100644 drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
