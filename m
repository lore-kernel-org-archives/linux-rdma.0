From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/3] IB/hfi1,core: Driver updates for 12/22/2017
Date: Fri, 22 Dec 2017 08:45:35 -0800
Message-ID: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

This includes a patch that Jason requsted, keeping the extended LID a consistent
size in the kernel and changing it at the UAPI boundary. There is another 16B
cleanup/improvement type patch from Don and an enhancement to our qp stats. I
know this stat is ridiculously complicated to read and it's doubtful I'll take
any other patches that make this worse, we are going to have to come up with 
something else. Plan to talk to Leon about adding this kind of stuff to the
rdma tool.

See also:
https://github.com/ddalessa/kernel/tree/for-4.16
---

Don Hiatt (2):
      IB/core: Use rdma_cap_opa_mad to check for OPA
      IB/hfi1: Change slid arg in ingress_pkey_table_fail to 32bit

Michael J. Ruhl (1):
      IB/hfi1: Add RQ/SRQ information to QP stats


 drivers/infiniband/core/user_mad.c |    3 +--
 drivers/infiniband/hw/hfi1/hfi.h   |    2 +-
 drivers/infiniband/hw/hfi1/mad.c   |    6 +-----
 drivers/infiniband/hw/hfi1/qp.c    |   10 ++++++++--
 4 files changed, 11 insertions(+), 10 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
