From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 0/6] IB/uverbs: check request parameters
Date: Mon,  4 May 2015 15:00:46 +0200
Message-ID: <cover.1430743694.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find a patchset against uverbs to improve the checks done
on uverbs request parameters. This patchset in an extract of a
previous patchset sent some times ago[1].

I've provided some explanation of the issues partialy addressed
by this patchset in a previous message[2].

As we're now addressing overflows, I think it's time to apply
this patchset.

Changes since v0 [3]
- updated against v4.1-rc2
- incorporated patches to add check on response buffer using
  access_ok()

[1] "[PATCH 00/22] infiniband: improve userspace input check"

http://marc.info/?i=cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for v3.13"

http://marc.info/?i=1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
http://mid.gmane.org/1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org

[3] "[PATCH 0/4] IB/uverbs: check request parameters"

http://marc.info/?i=cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
http://mid.gmane.org/cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (6):
  IB/uverbs: check userspace input buffer size
  IB/uverbs: check userspace output buffer size
  IB/uverbs: check userspace output buffer size in ib_uverbs_poll_cq()
  IB/uverbs: subtract command header from input size
  IB/uverbs: move cast from u64 to void __user pointer to its own
    variable
  IB/uverbs: check access to userspace response buffer

 drivers/infiniband/core/uverbs_cmd.c         | 449 +++++++++++++++++++++------
 drivers/infiniband/core/uverbs_main.c        |  29 +-
 drivers/infiniband/hw/mlx5/cq.c              |   6 +-
 drivers/infiniband/hw/mlx5/main.c            |   2 +-
 drivers/infiniband/hw/mlx5/srq.c             |   6 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   2 +-
 6 files changed, 382 insertions(+), 112 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
