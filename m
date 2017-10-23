From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/7] IB/hfi1: Driver fixes for 10/23/2017
Date: Mon, 23 Oct 2017 06:05:34 -0700
Message-ID: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Another round of fixes. These are all pretty minor. Mike M added some more
tx opcode stats to debugfs, similar to what we did for the rx side.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.15

---

Kamenee Arumugam (1):
      IB/hfi1: Don't modify num_user_contexts module parameter

Michael J. Ruhl (1):
      IB/hfi1: Race condition between user notification and driver state

Mike Marciniszyn (3):
      IB/hfi1: Add tx_opcode_stats like the opcode_stats
      IB/hfi1: Insure int mask for in-kernel receive contexts is clear
      IB/hfi1: Take advantage of kvzalloc_node in sdma initialization

Patel Jay P (1):
      Ib/hfi1: Return actual operational VLs in port info query

Sebastian Sanchez (1):
      IB/hfi1: Validate PKEY for incoming GSI MAD packets


 drivers/infiniband/hw/hfi1/chip.c    |   93 ++++++++++++++++++++++++----------
 drivers/infiniband/hw/hfi1/debugfs.c |   56 ++++++++++++++++++--
 drivers/infiniband/hw/hfi1/hfi.h     |    6 +-
 drivers/infiniband/hw/hfi1/init.c    |    7 +++
 drivers/infiniband/hw/hfi1/intr.c    |   14 +++++
 drivers/infiniband/hw/hfi1/mad.c     |   86 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/sdma.c    |    9 +--
 drivers/infiniband/hw/hfi1/verbs.c   |   24 +++++++++
 8 files changed, 248 insertions(+), 47 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
