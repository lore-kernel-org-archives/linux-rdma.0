From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Add packet pacing support for IB verbs
Date: Sun, 28 Aug 2016 14:27:08 +0300
Message-ID: <1472383631-3494-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When sending from a 10G host to a 1G host, it is easy to overrun the receiver,
leading to packet loss and traffic backing off. Similar problems occur when
a 10G host sends data to a sub-10G virtual circuit, or a 40G host sending
to a 10G host. Packet pacing could control packet injection rate and reduces
network congestion to maximize throughput & minimize network latency.

Packet pacing is a rate limiting and shaping for a QP (SQ for RAW QP), set
and change the rate is done by modifying QP. This series of patch made the
following high level changes:
 1. Report rate limit capabilities through user data. Reported capabilities
    include: The maximum and minimum rate limit in kbps supported by packet
    pacing; Bitmap showing which QP types are supported by packet pacing
    operation.
 2. Extend modify QP interface for growing attributes. Add rate limit support
    to the extended interface.
 3. Enable mlx5-based hardware to be able to update the rate limit for
    RAW QP packet.

Available in the "topic/packet_pacing" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/packet_pacing

Thanks,
  Bodong & Leon

Bodong Wang (3):
  IB/mlx5: Report mlx5 packet pacing capabilities when querying device
  IB/core: Support rate limit for packet pacing
  IB/uverbs: Extend modify_qp and support packet pacing

 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 178 +++++++++++++++++++++-------------
 drivers/infiniband/core/uverbs_main.c |   1 +
 drivers/infiniband/core/verbs.c       |   2 +
 drivers/infiniband/hw/mlx5/main.c     |  12 +++
 drivers/infiniband/hw/mlx5/user.h     |  13 +++
 include/rdma/ib_verbs.h               |   2 +
 include/uapi/rdma/ib_user_verbs.h     |  12 +++
 8 files changed, 152 insertions(+), 69 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
