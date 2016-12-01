From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 0/4] Add packet pacing support for IB verbs
Date: Thu,  1 Dec 2016 13:43:12 +0200
Message-ID: <1480592596-20126-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Packet pacing is a feature to control packet injection rate in
arbitrary rates. One typical use case is for streaming vendors to
control the bandwidth of different customers based on service coverage.

Packet pacing is a rate limiting and shaping for a QP (SQ for RAW QP),
set and change the rate is done by modifying QP. This series of patch
made the following high level changes:

1. Report rate limit capabilities through user data. Reported
   capabilities include: The maximum and minimum rate limit in kbps
   supported by packet pacing; Bitmap showing which QP types are
   supported by packet pacing operation.
2. Extend modify QP interface for growing attributes. Add rate limit
   support to the extended interface.
3. Enable mlx5-based hardware to be able to update the rate limit for
   RAW QP packet.

Rate limit could also be achieved by using path record data(static_rate),
however, compare to packet pacing, the drawbacks are:

- The rate field is only u8, and uses IB standard rate enumerations.
  Users have very limited options. Packet pacing supports arbitrary
  rates with a resolution of 1kbps.
- Path record data doesn't apply to Raw Ethernet QPs, because these are
  not 1:1 connected as RC, nor use address handles as UD.

The rate_limit configuration came from the application like required BW
for the streaming and not from the fabric (SM). Both of these features
are limiting the rate but coming from a different entities and required
separate fields. The actual limit should be the minimum of both of them
(if both features apply).

This patch series depend on the following patches:

Add port counter support for raw packet QP
[1] http://www.spinics.net/lists/linux-rdma/msg39607.html

Available in the "topic/packet_pacing" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/packet_pacing

Thanks.

Changes from V0:

1. New bit masks IB_USER_LEGACY_LAST_QP_ATTR_MASK and
   IB_USER_LAST_QP_ATTR_MASK are added to detect non-supported masks for
   legacy/ex commands.
2. The ib_uverbs_ex_modify_qp should call uhw rather than ucore at the end.

Bodong Wang (4):
  IB/mlx5: Report mlx5 packet pacing capabilities when querying device
  IB/core: Support rate limit for packet pacing
  IB/uverbs: Extend modify_qp and support packet pacing
  IB/mlx5: Update the rate limit according to user setting for RAW QP

 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 192 ++++++++++++++++++++++------------
 drivers/infiniband/core/uverbs_main.c |   1 +
 drivers/infiniband/core/verbs.c       |   2 +
 drivers/infiniband/hw/mlx5/main.c     |  16 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |   1 +
 drivers/infiniband/hw/mlx5/qp.c       |  74 +++++++++++--
 include/rdma/ib_verbs.h               |   2 +
 include/uapi/rdma/ib_user_verbs.h     |  21 ++++
 include/uapi/rdma/mlx5-abi.h          |  13 +++
 10 files changed, 245 insertions(+), 78 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
