From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v4 0/6] nvme-rdma device removal fixes
Date: Thu, 1 Sep 2016 09:12:59 -0700
Message-ID: <cover.1472746379.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series addresses several problems when shutting down a nvme-rdma
host when its controllers are attempting to reconnect to a target that
is no longer reachable.

To tickle these bugs:

1) attach over iw_cxgb4 to 10 devices on a target.
2) 'ifconfig down' the target's interface
3) wait for keep-alive to fire and begin reconnecting (~15-20 seconds)
4) do one of these on the host:
   - rmmod iw_cxgb4
   - reboot
   - reboot -f

Doug/Sagi, the first 2 iw_cxgb4 patches are included here because they're
needed for the testing.  While I've also submitted them to linux-rdma,
perhaps Sagi can merge them in nvmf-4.8-rc?  If that is acceptable
with everyone.

Patch series:

1/6 iw_cxgb4: call dev_put() on l2t allocation failure
2/6 iw_cxgb4: block module unload until all ep resources are released
3/6 nvme_rdma: keep a ref on the ctrl during delete/flush
4/6 nvme-rdma: destroy nvme queue rdma resources on connect failure
5/6 nvme-rdma: add DELETING queue flag
6/6 nvme-rdma: use ib_client API to detect device removal

Changes since v3:

- removed WIP/RFC tag

- fixed a bug in patch 4 where a rdma reject from the target causes a
double free of the ib queue and cm_id.

- remove noisy pr_info()s in patch 6

- kref_get -> kref_get_unless_zero in nvme_rdma_del_ctrl() of patch 3

- add reviewed-by tags

Changes since v2:

- refactor/simplify the remove_one function.

- nvme-rdma module remove function doesn't need to explicitly
remove the controllers; they will be removed as part of
ib_client unregister.

- removed forward declarations.

Changes since v1:

- the big change was patch 6 rewrite - use client_ib API to handle
device removal instead of rdma_cm device removal events.

- tweaked patch 5 to avoid bisect issues

- small code rework on patch 3 based on Christoph's suggestion

- clear_bit() -> !test_and_clear_bit() in patch 4 (Christoph's comment)

- add reviewed-by tags.

---

Sagi Grimberg (1):
  nvme-rdma: add DELETING queue flag

Steve Wise (5):
  iw_cxgb4: call dev_put() on l2t allocation failure
  iw_cxgb4: block module unload until all ep resources are released
  nvme_rdma: keep a ref on the ctrl during delete/flush
  nvme-rdma: destroy nvme queue rdma resources on connect failure
  nvme-rdma: use ib_client API to detect device removal

 drivers/infiniband/hw/cxgb4/cm.c       |   6 +-
 drivers/infiniband/hw/cxgb4/device.c   |   5 ++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   1 +
 drivers/nvme/host/rdma.c               | 136 ++++++++++++++++-----------------
 4 files changed, 76 insertions(+), 72 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
