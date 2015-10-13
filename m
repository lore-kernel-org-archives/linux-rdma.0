From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/2] iser bounce buffering cleanup
Date: Tue, 13 Oct 2015 19:12:57 +0300
Message-ID: <1444752779-15842-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Up until now, iser used bounce buffering to mitigate the
RDMA alignment limitations. Since kernel 4.3, the block layer
can reliably guarantee that SG lists won't contain gaps
(page alignment is not met) if a driver set a virt_boundary.

The block layer will:
- refuse merges if bios are not aligned to the virtual boundary
- split bios/requests that are not aligned to the virtual boundary
- or, bounce buffer SG_IOs that are not aligned to the virtual boundary 

Thus, we can drop the bounce buffering logic in the iser driver.

Also, the second patch enables SG clustering as iser fully supports it.

This should be applied before the New memory registration
API patch set.

Changes from v1:
- Change logs

Changes from v0:
- Added Reviewed-by tags
- Fixed patch (1) title

Sagi Grimberg (2):
  iser: set block queue_virt_boundary
  IB/iser: Enable SG clustering

 drivers/infiniband/ulp/iser/iscsi_iser.c     |  14 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   7 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |  51 +----
 drivers/infiniband/ulp/iser/iser_memory.c    | 274 ---------------------------
 4 files changed, 19 insertions(+), 327 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
