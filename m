From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 0/6] IB/hfi1, qib, cm,
 sa: Last set for 4.15 merge window
Date: Tue, 14 Nov 2017 04:34:08 -0800
Message-ID: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Sokolowski <jan.sokolowski@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is the latest set of patches I have that we'd like to land in 4.15. There
are some driver fixes, including a qib that is marked as stable. We also have
a CM and SA patch thrown in the mix.

As always patches available for browsing at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Dennis Dalessandro (1):
      IB/hfi1: Initialize bth1 in 16B rc ack builder

Don Hiatt (2):
      IB/hfi1: Mask the path bits with the LMC for 16B RC Acks
      IB/CM: Change sgid to IB GID when handling CM request

Jan Sokolowski (1):
      IB/hfi1: Use 4096 for default active MTU in query_qp

Mike Marciniszyn (1):
      IB/qib: Fix comparison error with qperf compare/swap test

Venkata Sandeep Dhanalakota (1):
      IB/SA: Check dlid before SA agent queries for ClassPortInfo


 drivers/infiniband/core/cm.c       |   38 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/sa_query.c |   10 +++++++++
 drivers/infiniband/hw/hfi1/rc.c    |   10 +++++----
 drivers/infiniband/hw/hfi1/verbs.c |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c |    6 +++---
 5 files changed, 55 insertions(+), 11 deletions(-)
