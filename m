From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] IB/rdmavt: Finish adding core verbs support
Date: Wed, 03 Feb 2016 14:14:25 -0800
Message-ID: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add the rest of the core verbs support to rdmavt. This includes query/modify
port as well as get_port_immutable and query quid. SRQ functionality is also
added as is support for memory affinity.

his patch series applies on the previously posted "staging/rdma/hfi1: Add
rdmavt support to hfi1" and can be seen in context at:
https://github.com/ddalessa/kernel/tree/for-4.6

---

Dennis Dalessandro (2):
      IB/rdmavt: Clean up distinction between port number and index
      IB/rdmavt: Add query gid support.

Harish Chegondi (1):
      IB/rdmavt: Add support for query_port, modify_port and get_port_immutable

Ira Weiny (2):
      IB/rdmavt: Add hardware driver send work request check
      IB/rdmavt: Properly pass gfp to hw driver function

Jubin John (1):
      IB/rdmavt: Add srq functionality to rdmavt

Mitko Haralanov (1):
      IB/rdmavt: Add Mem affinity support


 drivers/infiniband/sw/rdmavt/mad.c  |    8 +
 drivers/infiniband/sw/rdmavt/mad.h  |    2 
 drivers/infiniband/sw/rdmavt/mmap.c |    2 
 drivers/infiniband/sw/rdmavt/mr.c   |    2 
 drivers/infiniband/sw/rdmavt/qp.c   |   80 +++++++++--
 drivers/infiniband/sw/rdmavt/srq.c  |  257 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/sw/rdmavt/srq.h  |    1 
 drivers/infiniband/sw/rdmavt/vt.c   |  125 ++++++++++++-----
 drivers/infiniband/sw/rdmavt/vt.h   |   12 ++
 include/rdma/rdma_vt.h              |   17 ++
 10 files changed, 441 insertions(+), 65 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
