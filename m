From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Sat, 7 Nov 2015 01:35:44 -0500
Message-ID: <563D9BC0.6010609@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4Rba0HDL0rbTWwlB9R9W6ENJjfBGnqh9K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4Rba0HDL0rbTWwlB9R9W6ENJjfBGnqh9K
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is my initial round of 4.4 merge window patches.  There are a few
other things I wish to get in for 4.4 that aren't in this pull, as this
represents what has gone through merge/build/run testing and not what is
the last few items for which testing is not yet complete.

The following changes since commit 9ffecb10283508260936b96022d4ee43a7798b=
4c:

  Linux 4.3-rc3 (2015-09-27 07:50:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to db7489e07669073970358b6cacf6a9dd8dc9275e:

  IB/core, cma: Make __attribute_const__ declarations sparse-friendly
(2015-10-3
0 17:57:49 -0400)

----------------------------------------------------------------
Initial 4.4 merge window submission

- "Checksum offload support in user space" enablement
- Misc cxgb4 fixes, add T6 support
- Misc usnic fixes
- 32 bit build warning fixes
- Misc ocrdma fixes
- Multicast loopback prevention extension
- Extend the GID cache to store and return attributes of GIDs
- Misc iSER updates
- iSER clustering update
- Network NameSpace support for rdma CM
- Work Request cleanup series
- New Memory Registration API

----------------------------------------------------------------
Arnd Bergmann (2):
      RDMA/cxgb4: re-fix 32-bit build warning
      IB/core: avoid 32-bit warning

Bart Van Assche (3):
      IB/iser: Remove an unused variable
      iser-target: Remove an unused variable
      IB/core, cma: Make __attribute_const__ declarations sparse-friendly=


Bodong Wang (2):
      IB/core: Add support of checksum capability reporting for RC and RA=
W
      IB/mlx4: Report checksum offload cap for RAW QP when query device

Christoph Hellwig (2):
      IB: split struct ib_send_wr
      IB: remove xrc_remote_srq_num from struct ib_send_wr

Christoph Lameter (2):
      IB/ipoib: Expire sendonly multicast joins
      IB/ipoib: For sendonly join free the multicast group on leave

Chuck Lever (1):
      xprtrdma: Replace global lkey with lkey local to PD

Dave Goodell \(dgoodell\) (1):
      MAINTAINERS: update usnic maintainer contacts

Devesh Sharma (1):
      RDMA/ocrdma: Prevent CQ-Doorbell floods

Doron Tsur (2):
      IB/core: Fix memory corruption in ib_cache_gid_set_default_gid
      IB/cm: Fix rb-tree duplicate free and use-after-free

Doug Ledford (6):
      Merge tag 'v4.3-rc2' into k.o/for-4.3-v1
      IB/ipoib: Make sendonly multicast joins create the mcast group
      IB/ipoib: increase the max mcast backlog queue
      Merge branch 'k.o/for-4.3-v1' into k.o/for-4.4
      Merge branch 'wr-cleanup' of
git://git.infradead.org/users/hch/rdma into w
r-cleanup
      Merge branch 'wr-cleanup' into k.o/for-4.4

Eran Ben Elisha (5):
      IB/core: Extend ib_uverbs_create_qp
      IB/core: Allow setting create flags in QP init attribute
      IB/mlx4: Add IB counters table
      IB/mlx4: Add counter based implementation for QP multicast
loopback block
      IB/mlx4: Add support for blocking multicast loopback QP creation
user flag

Geliang Tang (1):
      IB/iser: fix a comment typo

Guy Shapiro (3):
      IB/addr: Pass network namespace as a parameter
      IB/cma: Add support for network namespaces
      IB/ucma: Take the network namespace from the process

Haggai Eran (4):
      IB/cma: Accept connection without a valid netdev on RoCE
      IB/cma: Potential NULL dereference in cma_id_from_event
      IB/cma: Use inner P_Key to determine netdev
      IB/cma: Separate port allocation to network namespaces

Hal Rosenstock (1):
      ib_pack.h: Fix commentary IBA reference for CNP in IB opcode enum

Hariprasad S (6):
      iw_cxgb4: detect fatal errors while creating listening filters
      iw_cxgb4: pass the ord/ird in connect reply events
      iw_cxgb4: fix misuse of ep->ord for minimum ird calculation
      iw_cxgb4: reverse the ord/ird in the ESTABLISHED upcall
      cxgb4: T6 adapter lld support for iw_cxgb4 driver
      iw_cxgb4: Adds support for T6 adapter

Insu Yun (2):
      usnic: correctly check failed allocation
      usnic: correctly handle kzalloc return value

Jeff Squyres (1):
      usnic: add missing clauses to BSD license

Maor Gottlieb (2):
      net/mlx4_core: Add support for filtering multicast loopback
      net/mlx4_en: Implement mcast loopback prevention for ETH qps

Matan Barak (11):
      IB/core: Fix use after free of ifa
      IB/core: Add netdev and gid attributes paramteres to cache
      IB/core: Expose and rename ib_find_cached_gid_by_port cache API
      IB/core: Add netdev to path record
      IB/cm: cm_init_av_by_path should find a GID by its netdevice
      IB/cma: cma_validate_port should verify the port and netdevice
      IB/cache: Add ib_find_gid_by_filter cache API
      IB/core: Use GID table in AH creation and dmac resolution
      IB/cm: Remove the usage of smac and vid of qp_attr and cm_av
      IB/core: Remove smac and vlan id from qp_attr and ah_attr
      IB/core: Remove smac and vlan id from path record

Naga Irrinki (1):
      RDMA/ocrdma: Check resource ids received in Async CQE

Sagi Grimberg (34):
      IB/iser: Add module parameter for always register memory
      IB/mlx5: Remove support for IB_DEVICE_LOCAL_DMA_LKEY
      IB/mlx5: Remove pa_lkey usages
      xprtrdma: Don't require LOCAL_DMA_LKEY support for fastreg
      IB/iser: set block queue_virt_boundary
      IB/iser: Enable SG clustering
      IB/core: Introduce new fast registration API
      IB/mlx5: Remove dead fmr code
      IB/mlx5: Support the new memory registration API
      IB/mlx4: Support the new memory registration API
      RDMA/ocrdma: Support the new memory registration API
      RDMA/cxgb3: Support the new memory registration API
      iw_cxgb4: Support the new memory registration API
      IB/qib: Support the new memory registration API
      RDMA/nes: Support the new memory registration API
      IB/iser: Port to new fast registration API
      iser-target: Port to new memory registration API
      xprtrdma: Port to new memory registration API
      svcrdma: Port to new memory registration API
      RDS/IW: Convert to new memory registration API
      IB/srp: Split srp_map_sg
      IB/srp: Convert to new registration API
      IB/srp: Remove srp_finish_mapping
      IB/srp: Dont allocate a page vector when using fast_reg
      IB/mlx5: Remove old FRWR API support
      IB/mlx4: Remove old FRWR API support
      RDMA/ocrdma: Remove old FRWR API
      RDMA/cxgb3: Remove old FRWR API
      iw_cxgb4: Remove old FRWR API
      IB/qib: Remove old FRWR API
      RDMA/nes: Remove old FRWR API
      IB/hfi1: Remove fast registration from the code
      IB/ipath: Remove fast registration from the code
      IB/core: Remove old fast registration API

Sasha Levin (1):
      IB/ucma: check workqueue allocation before usage

Selvin Xavier (3):
      RDMA/ocrdma: Cleanup unused device list and rcu variables
      RDMA/ocrdma: Avoid a possible crash in ocrdma_rem_port_stats
      RDMA/ocrdma: Bump up ocrdma version number to 11.0.0.0

 MAINTAINERS                                        |   5 +-
 drivers/infiniband/core/addr.c                     |  20 +-
 drivers/infiniband/core/agent.c                    |   2 +-
 drivers/infiniband/core/cache.c                    | 114 +++++-
 drivers/infiniband/core/cm.c                       |  50 +--
 drivers/infiniband/core/cma.c                      | 233 ++++++++----
 drivers/infiniband/core/core_priv.h                |   9 +-
 drivers/infiniband/core/device.c                   |  19 +-
 drivers/infiniband/core/mad.c                      |  42 +--
 drivers/infiniband/core/mad_priv.h                 |   2 +-
 drivers/infiniband/core/multicast.c                |   3 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |  35 +-
 drivers/infiniband/core/sa_query.c                 |  19 +-
 drivers/infiniband/core/sysfs.c                    |   2 +-
 drivers/infiniband/core/ucma.c                     |  12 +-
 drivers/infiniband/core/uverbs.h                   |   1 +
 drivers/infiniband/core/uverbs_cmd.c               | 402
++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c              |   1 +
 drivers/infiniband/core/uverbs_marshall.c          |   4 +-
 drivers/infiniband/core/verbs.c                    | 295 ++++++++++-----=

 drivers/infiniband/hw/cxgb3/iwch_cq.c              |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  39 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h        |   2 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |  43 +--
 drivers/infiniband/hw/cxgb4/cm.c                   | 331 ++++++++++-----=
--
 drivers/infiniband/hw/cxgb4/cq.c                   |   2 +-
 drivers/infiniband/hw/cxgb4/device.c               |  10 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |  25 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  63 ++--
 drivers/infiniband/hw/cxgb4/provider.c             |   5 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  73 ++--
 drivers/infiniband/hw/cxgb4/t4.h                   |   5 +-
 drivers/infiniband/hw/mlx4/ah.c                    |  17 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |  91 +++--
 drivers/infiniband/hw/mlx4/main.c                  |  75 +++-
 drivers/infiniband/hw/mlx4/mcg.c                   |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  37 +-
 drivers/infiniband/hw/mlx4/mr.c                    | 169 +++++----
 drivers/infiniband/hw/mlx4/qp.c                    | 330 +++++++++++----=
--
 drivers/infiniband/hw/mlx5/cq.c                    |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |  70 +---
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  56 +--
 drivers/infiniband/hw/mlx5/mr.c                    | 187 ++++++----
 drivers/infiniband/hw/mlx5/qp.c                    | 231 ++++++------
 drivers/infiniband/hw/mthca/mthca_av.c             |   2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c             |  84 ++---
 drivers/infiniband/hw/nes/nes_hw.h                 |   6 -
 drivers/infiniband/hw/nes/nes_verbs.c              | 170 ++++-----
 drivers/infiniband/hw/nes/nes_verbs.h              |   4 +
 drivers/infiniband/hw/ocrdma/ocrdma.h              |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |  22 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |  60 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  19 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        | 184 +++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |   7 +-
 drivers/infiniband/hw/qib/qib_keys.c               |  41 ++-
 drivers/infiniband/hw/qib/qib_mr.c                 |  46 +--
 drivers/infiniband/hw/qib/qib_qp.c                 |   2 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |  38 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |  20 +-
 drivers/infiniband/hw/qib/qib_uc.c                 |   4 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |  20 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |  29 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |  19 +-
 drivers/infiniband/hw/usnic/usnic.h                |  21 +-
 drivers/infiniband/hw/usnic/usnic_abi.h            |  21 +-
 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h |  21 +-
 drivers/infiniband/hw/usnic/usnic_common_util.h    |  21 +-
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |  21 +-
 drivers/infiniband/hw/usnic/usnic_debugfs.h        |  21 +-
 drivers/infiniband/hw/usnic/usnic_fwd.c            |  21 +-
 drivers/infiniband/hw/usnic/usnic_fwd.h            |  21 +-
 drivers/infiniband/hw/usnic/usnic_ib.h             |  21 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  30 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |  29 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      |  21 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |  21 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h       |  21 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  21 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |  21 +-
 drivers/infiniband/hw/usnic/usnic_log.h            |  21 +-
 drivers/infiniband/hw/usnic/usnic_transport.c      |  21 +-
 drivers/infiniband/hw/usnic/usnic_transport.h      |  21 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.h           |  21 +-
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c |  21 +-
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.h |  21 +-
 drivers/infiniband/hw/usnic/usnic_vnic.c           |  21 +-
 drivers/infiniband/hw/usnic/usnic_vnic.h           |  21 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   9 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  22 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  24 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  32 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   6 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  25 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |  26 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |  51 +--
 drivers/infiniband/ulp/iser/iser_memory.c          | 386
+++-----------------
 drivers/infiniband/ulp/iser/iser_verbs.c           |  41 +--
 drivers/infiniband/ulp/isert/ib_isert.c            | 269 +++++---------
 drivers/infiniband/ulp/isert/ib_isert.h            |   8 +-
 drivers/infiniband/ulp/srp/ib_srp.c                | 262 ++++++++------
 drivers/infiniband/ulp/srp/ib_srp.h                |  11 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  35 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |  41 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  22 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_chip_type.h  |  85 +++++
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  48 +++
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |  22 ++
 drivers/net/ethernet/mellanox/mlx4/en_resources.c  |  25 ++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   6 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   3 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  19 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  22 --
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |   6 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  35 +-
 drivers/staging/rdma/amso1100/c2_qp.c              |   8 +-
 drivers/staging/rdma/ehca/ehca_reqs.c              |  53 +--
 drivers/staging/rdma/hfi1/keys.c                   |  55 ---
 drivers/staging/rdma/hfi1/mr.c                     |  33 +-
 drivers/staging/rdma/hfi1/qp.c                     |   2 +-
 drivers/staging/rdma/hfi1/rc.c                     |  24 +-
 drivers/staging/rdma/hfi1/ruc.c                    |  18 +-
 drivers/staging/rdma/hfi1/uc.c                     |   4 +-
 drivers/staging/rdma/hfi1/ud.c                     |  20 +-
 drivers/staging/rdma/hfi1/verbs.c                  |  26 +-
 drivers/staging/rdma/hfi1/verbs.h                  |  14 +-
 drivers/staging/rdma/ipath/ipath_rc.c              |  24 +-
 drivers/staging/rdma/ipath/ipath_ruc.c             |  16 +-
 drivers/staging/rdma/ipath/ipath_uc.c              |   4 +-
 drivers/staging/rdma/ipath/ipath_ud.c              |  26 +-
 drivers/staging/rdma/ipath/ipath_verbs.c           |  17 +-
 drivers/staging/rdma/ipath/ipath_verbs.h           |   8 +-
 include/linux/mlx4/device.h                        |   2 +
 include/linux/mlx4/qp.h                            |  24 +-
 include/linux/mlx5/device.h                        |  11 -
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/sunrpc/svc_rdma.h                    |   6 +-
 include/rdma/ib_addr.h                             |  18 +-
 include/rdma/ib_cache.h                            |  40 +-
 include/rdma/ib_pack.h                             |   2 +-
 include/rdma/ib_sa.h                               |  12 +-
 include/rdma/ib_verbs.h                            | 222 +++++++-----
 include/rdma/rdma_cm.h                             |   8 +-
 include/uapi/rdma/ib_user_verbs.h                  |  26 ++
 net/9p/trans_rdma.c                                |   4 +-
 net/rds/ib.c                                       |   2 +-
 net/rds/ib.h                                       |   6 +-
 net/rds/ib_cm.c                                    |   2 +-
 net/rds/ib_send.c                                  |  71 ++--
 net/rds/iw.c                                       |   2 +-
 net/rds/iw.h                                       |   9 +-
 net/rds/iw_cm.c                                    |   2 +-
 net/rds/iw_rdma.c                                  | 129 +++----
 net/rds/iw_send.c                                  | 154 ++++----
 net/rds/rdma_transport.c                           |   4 +-
 net/sunrpc/xprtrdma/fmr_ops.c                      |  19 -
 net/sunrpc/xprtrdma/frwr_ops.c                     | 124 ++++---
 net/sunrpc/xprtrdma/physical_ops.c                 |  10 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            | 122 ++++---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |  18 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  38 +-
 net/sunrpc/xprtrdma/verbs.c                        |  13 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   4 +-
 169 files changed, 4195 insertions(+), 3287 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/t4_chip_type.h



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4Rba0HDL0rbTWwlB9R9W6ENJjfBGnqh9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWPZvAAAoJELgmozMOVy/dRGUP/i0i4oj7ROUU3oJkv7i1kOI7
Fv6ipq7rBjKmojw/52vH2l2ELBXHw8GNM1QsFQDIVVLr/eGEyU7sKASvV0myJ/H9
QVNlFdKSGWZTH0CYXsubUs12LnKVkUAXP3cKHYEzA2zfugCIFnwDg9HdghA+pu/c
cjrulFGnSDUBoxbpMSBO8fiatPMZC37o8JmB6hoYvrAL0foEN5rCX50qX0Zdvbfo
XHsGzef6HaIi+G7XW2Bvbi5b62C0XeRFyV8Tn357shu5PzKv+08zg+tq8zwqQLdE
ZrMjSHIXQtKcZIicWWFDz6aEVjQjMWfS0rnHpSK7iVN724Xy8i6yjP/tlzYvf43U
6nj8iz0EAqnfdti9oNnu0dkFAQ/SNUrXruNKBJxRuYI1k39lkU4DfBZSGBLhZdeI
MCR0Zt4346qUc8GDM+TQiGvMtsE2cFj/LD2nxMlmnxDPgJ/+2oLdTVDVvjDY1HHU
YRh7DEZzR6aXrMipXFS5Qel96p/FO0Ey0QrMyHcv+Vl4D1iPL718ROkli8AiwR5a
EUGCQQUwZISTPs1JsvitIw/jaZZea6XUvV0eWf6ru/+tydr3DL3YS4u0jyq9tpUJ
GqilIeeXSNmu72B7teykhUqbrHq3+NTTPj+WUtA1g76h57emkMylZA/zXY8not7f
pgeNr2J+kpbsgX91nNAO
=stgz
-----END PGP SIGNATURE-----

--4Rba0HDL0rbTWwlB9R9W6ENJjfBGnqh9K--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
