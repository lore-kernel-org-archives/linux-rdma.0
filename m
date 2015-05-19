From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH V2 for-4.1 0/9] ocrdma bug fixes
Date: Tue, 19 May 2015 11:32:31 +0530
Message-ID: <1432015360-15447-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Incorporated review comments from Doug Ledford

Changes from V1:

*	Fixing the memory leak in the error case for PD alloc range failure
*	Dropping the minor feature enhancement patch to add CQ statistics 
	from this series 
*	Droping the patch to return success for destroy verbs, as this can
	cause issues if the FW tries to DMA data after the host frees the
	resources
 
Devesh Sharma (3):
  RDMA/ocrdma: Report EQ full fatal error
  RDMA/ocrdma: Fix QP state transition in destroy_qp
  RDMA/ocrdma: Use VID 0 if PFC is enabled and vlan is not configured

Mitesh Ahuja (3):
  RDMA/ocrdma: Fix the request length for RDMA_QUERY_QP mailbox command
    to FW.
  RDMA/ocrdma: Prevent allocation of DPP PDs if FW doesnt support it
  RDMA/ocrdma: Fix dmac resolution for link local address

Naga Irrinki (1):
  RDMA/ocrdma: Fail connection for MTU lesser than 512

Selvin Xavier (2):
  RDMA/ocrdma: Fix EQ destroy failure during driver unload
  RDMA/ocrdma: Update ocrdma version number

 drivers/infiniband/hw/ocrdma/ocrdma.h       |  4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 12 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 83 +++++++++++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  9 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 12 +++--
 5 files changed, 79 insertions(+), 41 deletions(-)

-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
