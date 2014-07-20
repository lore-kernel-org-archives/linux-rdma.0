From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] IB/uverbs: check request parameters
Date: Sun, 20 Jul 2014 21:51:08 +0200
Message-ID: <cover.1405884453.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find a patchset against uverbs to improve the checks done
on uverbs request parameters. This patchset in an extract of a
previous patchset sent some times ago[1].

I've tried to make the commit messages more explanatory so that
the patches will gain more attention.

I've provided some explanation of the issues partialy addressed
by this patchset in a previous message[2].

I intend to send more patches to address the issues, probably
in 3 more patchset: ucm, ucma and udata.

[1] "[PATCH 00/22] infiniband: improve userspace input check"

http://marc.info/?i=cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for v3.13"

http://marc.info/?i=1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org

Yann Droneaud (4):
  IB/uverbs: check userspace input buffer size
  IB/uverbs: check userspace output buffer size
  IB/uverbs: check userspace output buffer size in ib_uverbs_poll_cq()
  IB/uverbs: subtract command header from input size

 drivers/infiniband/core/uverbs_cmd.c         | 132 +++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c        |  18 +++-
 drivers/infiniband/hw/mlx5/cq.c              |   6 +-
 drivers/infiniband/hw/mlx5/main.c            |   2 +-
 drivers/infiniband/hw/mlx5/srq.c             |   6 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   2 +-
 6 files changed, 151 insertions(+), 15 deletions(-)

-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
