From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 00/11] Expanding raw packet capabilities
Date: Wed, 18 Jan 2017 15:39:53 +0200
Message-ID: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find the following patchset from Noa.

This series unifies all existing raw packet capabilities under a new
field in ib_device_attr named raw_packet_caps. This field is defined
by the ib_raw_packet_caps enum. Such change makes it easier to report
those capabilities back to the user.

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

Thanks,
	Noa
---

This patchset was generated against commit
f502d834950a ("net/mlx5: Activate support for 4K UARs") and it applies
cleanly on k.o/for-4.11 branch.

Available in the "topic/raw_packet_caps" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/raw_packet_caps

Noa Osherovich (11):
  IB/core: Expose vlan offloads capabilities
  IB/core: Enable WQ creation and modification with cvlan offload
  IB/core: Enable QP creation with cvlan offload
  IB/core: Add scatter FCS flag to use in WQ creation
  IB/uverbs: Expose vlan offloads capabilities
  IB/uverbs: Enable WQ creation and modification with cvlan offload
  IB/uverbs: Enable QP creation with cvlan offload
  IB/mlx5: Expose vlan offloads capabilities
  IB/mlx5: Enable WQ creation and modification with cvlan offload
  IB/mlx5: Enable QP creation with cvlan offload
  IB/mlx5: Support creation of a WQ with scatter FCS offload

 drivers/infiniband/core/uverbs_cmd.c | 18 +++++++++++--
 drivers/infiniband/hw/mlx5/main.c    | 14 ++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++++
 drivers/infiniband/hw/mlx5/qp.c      | 50 ++++++++++++++++++++++++++++++++++--
 include/rdma/ib_verbs.h              | 29 +++++++++++++++++++--
 include/uapi/rdma/ib_user_verbs.h    |  6 ++++-
 6 files changed, 114 insertions(+), 9 deletions(-)

--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
