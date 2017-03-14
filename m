From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/7] Expanding raw packet capabilities
Date: Tue, 14 Mar 2017 13:15:36 +0200
Message-ID: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Noa is the complementary user space part
of the kernel code that was merged into 4.11.

This series unifies all existing raw packet capabilities under a new
field in ibv_device_attr_ex named raw_packet_caps. This field is defined
by the ibv_raw_packet_caps enum.

The existing IP csum and scatter FCS capabilities were added to the
enum and a new capability was introduced - cvlan stripping offload.

Cvlan stripping is the device's capability to remove the cvlan from
an incoming raw packet and provide the data in the matching work
completion.

This series also:
- Allows creation of WQ and raw Ethernet QP with cvlan stripping capability.
  This is done by setting the IBV_WQ_FLAGS_CVLAN_STRIPPING bit of the
  create_flags field in ibv_wq_init_attr struct.
- Allows setting and unsetting of cvlan stripping capability for an existing WQ.
  This is done by setting the following fields of the ibv_wq_attr struct:
    - Setting IBV_WQ_ATTR_FLAGS bit of the attr_mask field.
    - Setting the IBV_RAW_PACKET_CAP_CVLAN_STRIPPING bit of the
      flags_mask field.
    - Either setting or unsetting the IBV_RAW_PACKET_CAP_CVLAN_STRIPPING
      bit of the flags field.
- Allows creation of WQ with scatter FCS offload.
  This is done by setting the IBV_WQ_FLAGS_SCATTER_FCS bit of the
  create_flags field in ibv_wq_init_attr struct.
- Allows reading the cvlan data from ibv_cq_ex by an extra read function
  named ibv_wc_read_cvlan.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/96

Noa Osherovich (7):
  ibverbs: Report raw packet caps as part of query device
  ibverbs: Allow creation and modification of WQ with cvlan offload
  ibverbs: Allow creation of QP with cvlan stripping offload
  ibverbs: Add an option to poll cvlan value from a CQ
  mlx5: Add read_cvlan support
  ibverbs: Update man pages to include cvlan offloads options
  ibverbs: Add support for scatter FCS ability in WQ

 libibverbs/cmd.c                     | 29 ++++++++++++++++++++++++++++-
 libibverbs/examples/devinfo.c        | 14 ++++++++++++++
 libibverbs/kern-abi.h                |  6 +++++-
 libibverbs/man/ibv_create_cq_ex.3    |  9 +++++++--
 libibverbs/man/ibv_create_wq.3       | 10 ++++++++++
 libibverbs/man/ibv_modify_wq.3       |  2 ++
 libibverbs/man/ibv_query_device_ex.3 |  1 +
 libibverbs/verbs.h                   | 35 +++++++++++++++++++++++++++++++----
 providers/mlx5/cq.c                  |  9 +++++++++
 providers/mlx5/verbs.c               |  3 ++-
 10 files changed, 109 insertions(+), 9 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
