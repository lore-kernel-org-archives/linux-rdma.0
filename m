From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus)
Date: Fri, 7 Oct 2016 18:24:14 -0400
Message-ID: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cf462aA152La3qhs2GCOBrdFvLRORNrtB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cf462aA152La3qhs2GCOBrdFvLRORNrtB
Content-Type: multipart/mixed; boundary="DQdxsRGsKI2pqGP95qHmEkVD0LXWM7mNi";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus)

--DQdxsRGsKI2pqGP95qHmEkVD0LXWM7mNi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the second pull request and it is the main pull request for the
rdma stack this release.  The pull request looks larger than it will end
up being when you take it.  At the early stage of 4.9 development,
Mellanox submitted 30 patches to both DaveM's tree and mine, and we both
pulled them from Leon's tree so we had identical git hashes and the
patches will simply fall away when you pull from my tree since you've
already pulled DaveM's tree.  But, my git request-pull macro can't
separate that out, so they show up in the pull request but won't make it
through the final merge.

There are three conflicts in this merge (that don't automatically resolve=
):

1) cxgb4 - keep the head version in your tree, my tree and the common
ancestor were prior to a refactoring in your tree that moved uld_attach
from cxgb4_main.c to cxgb4_uld.c

2) mlx4 - Keep both additions in fw.c, and pick one addition to be 36
and one to be 37 in device.h (which is which is not important).  I asked
Leon why this happened since we've done really well lately at avoiding
all Mellanox conflicts like this, and his response is that two patches
were submitted during the last rc cycles and Mellanox had expected one
to go into for-next and the other to go into -rc (one went to Dave and
one to me).  Instead, we swapped and the one they thought would go into
-rc went into -next and vice versa.  That overlooked that when
submitting their 4.9 patches, and it resulted in this oversight.

Aside from these issues, the merge should be clean.  The code has been
through 0day and I had it tagged for linux-next testing for a couple
days, but the changes to pull the rxe patches out and move them mean
that whatever linux-next testing had been done is no longer completely
valid.  I've done manual merge testing to compensate.

Here's the boilerplate (with the 30 extra commit messages and the
diffstat from those commits):

The following changes since commit c1346a7e70b5be7f01cc1f64a7e3aefb80d48a=
d7:

  Revert "l2tp: Refactor the codes with existing macros instead of
literal number" (2016-08-21 15:50:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 2937f375751922ffce9ef1d5fa84491840b0c8e0:

  staging/lustre: Disable InfiniBand support (2016-10-07 16:54:41 -0400)

----------------------------------------------------------------
Merge of primary rdma-core code for 4.9

- Updates to mlx5
- Updates to mlx4 (two conflicts, both minor and easily resolved)
- Updates to iw_cxgb4 (one conflict, not so obvious to resolve, proper
  resolution is to keep the code in cxgb4_main.c as it is in Linus'
  tree as attach_uld was refactored and moved into cxgb4_uld.c)
- Improvements to uAPI (moved vendor specific API elements to uAPI area)
- Add hns-roce driver and hns and hns-roce ACPI reset support
- Conversion of all rdma code away from deprecated
  create_singlethread_workqueue
- Security improvement: remove unsafe ib_get_dma_mr (breaks lustre in
  staging)

----------------------------------------------------------------
Alex Vesker (3):
      net/mlx5: Modify RQ bitmask from mlx5 ifc
      IB/mlx5: Refactor raw packet QP modify function
      IB/mlx5: Add port counter support for raw packet QP

Artemy Kovalyov (1):
      net/mlx5: Update struct mlx5_ifc_xrqc_bits

Aviv Heller (14):
      net/mlx5: Add HW interfaces used by LAG
      net/mlx5: Implement RoCE LAG feature
      net/mlx5: Get RoCE netdev
      net/mlx5e: Avoid port remapping of mlx5e netdev TISes
      net/mlx5: LAG and SRIOV cannot be used together
      net/mlx5: LAG demux flow table support
      net/mlx5: Add LAG flow steering namespace
      net/mlx5: Vport LAG creation support
      net/mlx5: Configure IB devices according to LAG state
      IB/mlx5: Port events in RoCE now rely on netdev events
      IB/mlx5: Merge vports flow steering during LAG
      IB/mlx5: Port status track LAG master, when LAG is active
      IB/mlx5: Set unique device name on LAG
      IB/mlx5: LAG QP load balancing

Bart Van Assche (3):
      IB/core: Improve ib_map_mr_sg() documentation
      IB/srp: Remove an unused argument
      IB/srp: Fix infinite loop when FMR sg[0].offset !=3D 0

Bhaktipriya Shridhar (22):
      IB/sa : Remove deprecated create_singlethread_workqueue
      IB/mad: Remove deprecated create_singlethread_workqueue
      IB/multicast: Remove deprecated create_singlethread_workqueue
      IB/ucma: Remove deprecated create_singlethread_workqueue
      IB/cma: Remove deprecated create_singlethread_workqueue
      IB/addr: Remove deprecated create_singlethread_workqueue
      IB/iwcm: Remove deprecated create_singlethread_workqueue
      iw_cxgb3: Remove deprecated create_singlethread_workqueue
      IB/qib: Remove deprecated create_singlethread_workqueue
      iw_cxgb4: Remove deprecated create_singlethread_workqueue
      IB/mthca: Remove deprecated create_singlethread_workqueue
      i40iw_main: Remove deprecated create_singlethread_workqueue
      i40iw_cm: Remove deprecated create_singlethread_workqueue
      IB/mlx5: Remove deprecated create_singlethread_workqueue
      IB/mlx5/odp: Remove deprecated create_singlethread_workqueue
      IB/mlx4: Remove deprecated create_singlethread_workqueue
      IB/mlx4/mad: Remove deprecated create_singlethread_workqueue
      IB/mlx4/mcg: Remove deprecated create_singlethread_workqueue
      IB/nes: Remove deprecated create_singlethread_workqueue
      IB/ipoib: Remove deprecated create_singlethread_workqueue
      IB/ipoib_verbs: Remove deprecated create_singlethread_workqueue
      IB/mlx4/alias_GUID: Remove deprecated create_singlethread_workqueue=


Christoph Hellwig (6):
      IB/core: rename pd->local_mr to pd->__internal_mr
      IB/core: add support to create a unsafe global rkey to ib_create_pd=

      IB/iser: use IB_PD_UNSAFE_GLOBAL_RKEY
      IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
      nvme-rdma: use IB_PD_UNSAFE_GLOBAL_RKEY
      IB/core: remove ib_get_dma_mr

Doug Ledford (5):
      Merge tag 'shared-for-4.9-1' of
git://git.kernel.org/.../leon/linux-rdma into mlx5-shared
      Merge tag 'shared-for-4.9-2' of
git://git.kernel.org/.../leon/linux-rdma into mlx5-shared
      Merge branch 'mlx5-shared' into k.o/for-4.9
      Merge branch 'hns-roce' into k.o/for-4.9
      staging/lustre: Disable InfiniBand support

Hadar Hen Zion (2):
      net/mlx5: Enable setting minimum inline header mode for VFs
      net/mlx5: Update mlx5_ifc.h for vxlan encap/decap

Ilya Lesokhin (1):
      net/mlx5: Introduce alloc_encap and dealloc_encap commands

Jack Morgenstein (1):
      IB/mlx4: Fix possible vl/sl field mismatch in LRH header in QP1
packets

Leon Romanovsky (7):
      IB/mlx5: Move and decouple user vendor structures
      IB/cxgb3: Move user vendor structures
      IB/cxgb4: Move user vendor structures
      IB/mlx4: Move user vendor structures
      IB/ocrdma: Move user vendor structures
      IB/nes: Move user vendor structures
      IB/mthca: Move user vendor structures

Maor Gottlieb (14):
      net/mlx5: Introduce sniffer steering hardware capabilities
      net/mlx5: Add sniffer namespaces
      IB/mlx5: Fix steering resource leak
      IB/mlx5: Save flow table priority handler instead of index
      IB/mlx5: Fix coverity warning
      IB/mlx5: Increase flow table reference count in create rule
      IB/mlx5: Add sniffer support to steering
      IB/mlx4: Add validation to flow specifications parsing
      IB/mlx5: Add validation to flow specifications parsing
      IB/uverbs: Add support to extend flow steering specifications
      IB/uverbs: Add more fields to IPv4 flow specification
      IB/core: Add more fields to IPv6 flow specification
      IB/mlx5: Add support in TOS and protocol to flow steering
      IB/mlx5: Add support of more IPv6 fields to flow steering

Noa Osherovich (2):
      net/mlx5: Expose mlx5e_link_mode
      net/mlx5: Separate query_port_proto_oper for IB and EN

Saeed Mahameed (12):
      net/mlx5: Init/Teardown hca commands via mlx5 ifc
      net/mlx5: Access register and MAD IFC commands via mlx5 ifc
      net/mlx5: PD and UAR commands via mlx5 ifc
      net/mlx5: MCG commands via mlx5 ifc
      net/mlx5: Pages management commands via mlx5 ifc
      net/mlx5: EQ commands via mlx5 ifc
      {net,IB}/mlx5: CQ commands via mlx5 ifc
      {net,IB}/mlx5: MKey/PSV commands via mlx5 ifc
      {net,IB}/mlx5: QP/XRCD commands via mlx5 ifc
      {net,IB}/mlx5: Modify QP commands via mlx5 ifc
      net/mlx5: Unify and improve command interface
      net/mlx5: Improve driver log messages

Salil (2):
      net: hns: Add support of ACPI to HNS driver RoCE Reset function
      IB/hns: Add support of ACPI to the Hisilicon RoCE driver

Steve Wise (3):
      IB/core: correctly handle rdma_rw_init_mrs() failure
      cxgb4: advertise support for FR_NSMR_TPTE_WR
      iw_cxgb4: add fast-path for small REG_MR operations

Wei Yongjun (1):
      IB/hns: Fix return value check in hns_roce_get_cfg()

Yishai Hadas (4):
      IB/core: Expose RSS related capabilities
      IB/uverbs: Expose RSS related capabilities
      IB/mlx5: Expose RSS related capabilities
      IB/mlx5: Track asynchronous events on a receive work queue

Yuval Shaia (1):
      IB/{core,hw}: Add constant for node_desc

kernel-6AxghH7DbtA@public.gmane.org (1):
      ipoib: Make ipoib_warn ratelimited

oulijun (4):
      devicetree: bindings: IB: Add binding document for Hisilicon RoCE
      IB/hns: Add driver files for hns RoCE driver
      IB/hns: Kconfig and Makefile for RoCE module
      MAINTAINERS: Add maintainers for Hisilicon RoCE driver

 .../bindings/infiniband/hisilicon-hns-roce.txt     |  107 +
 MAINTAINERS                                        |   14 +
 drivers/infiniband/Kconfig                         |    1 +
 drivers/infiniband/core/addr.c                     |    2 +-
 drivers/infiniband/core/cma.c                      |    2 +-
 drivers/infiniband/core/iwcm.c                     |    2 +-
 drivers/infiniband/core/mad.c                      |    4 +-
 drivers/infiniband/core/multicast.c                |    2 +-
 drivers/infiniband/core/sa_query.c                 |    2 +-
 drivers/infiniband/core/sysfs.c                    |    2 +-
 drivers/infiniband/core/ucma.c                     |    3 +-
 drivers/infiniband/core/uverbs_cmd.c               |  121 +-
 drivers/infiniband/core/verbs.c                    |   77 +-
 drivers/infiniband/hw/Makefile                     |    1 +
 drivers/infiniband/hw/cxgb3/iwch.c                 |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    3 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    2 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |   17 +
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |    2 +-
 drivers/infiniband/hw/cxgb4/provider.c             |    1 +
 drivers/infiniband/hw/cxgb4/qp.c                   |   67 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |    4 +-
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h          |   12 +
 drivers/infiniband/hw/hfi1/verbs.c                 |    3 +-
 drivers/infiniband/hw/hns/Kconfig                  |   10 +
 drivers/infiniband/hw/hns/Makefile                 |    8 +
 drivers/infiniband/hw/hns/hns_roce_ah.c            |  128 +
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |  257 ++
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |  368 +++
 drivers/infiniband/hw/hns/hns_roce_cmd.h           |   80 +
 drivers/infiniband/hw/hns/hns_roce_common.h        |  325 +++
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  446 ++++
 drivers/infiniband/hw/hns/hns_roce_device.h        |  734 +++++
 drivers/infiniband/hw/hns/hns_roce_eq.c            |  762 ++++++
 drivers/infiniband/hw/hns/hns_roce_eq.h            |  130 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  476 ++++
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  131 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         | 2800
++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h         |  981 +++++++
 drivers/infiniband/hw/hns/hns_roce_main.c          | 1142 ++++++++
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  614 +++++
 drivers/infiniband/hw/hns/hns_roce_pd.c            |  144 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  855 ++++++
 drivers/infiniband/hw/hns/hns_roce_user.h          |   53 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |    7 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |    2 +-
 drivers/infiniband/hw/mlx4/cq.c                    |    2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   73 +-
 drivers/infiniband/hw/mlx4/main.c                  |  147 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |    4 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    7 +
 drivers/infiniband/hw/mlx4/qp.c                    |   25 +-
 drivers/infiniband/hw/mlx4/srq.c                   |    2 +-
 drivers/infiniband/hw/mlx5/cq.c                    |  111 +-
 drivers/infiniband/hw/mlx5/mad.c                   |    2 +-
 drivers/infiniband/hw/mlx5/main.c                  |  404 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   52 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  187 +-
 drivers/infiniband/hw/mlx5/odp.c                   |    4 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  347 ++-
 drivers/infiniband/hw/mlx5/srq.c                   |    1 -
 drivers/infiniband/hw/mthca/mthca_catas.c          |    2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c            |    3 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |    7 +-
 drivers/infiniband/hw/nes/nes.h                    |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |    3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |    2 +-
 drivers/infiniband/hw/qib/qib_init.c               |    4 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |    1 -
 drivers/infiniband/ulp/iser/iser_memory.c          |    6 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   22 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   56 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |    3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    7 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    2 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   17 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |   47 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h |    9 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   53 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.h |    3 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_reg.h  |    4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  273 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  109 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   50 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   34 -
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   23 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   55 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   80 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   98 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  232 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  118 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   43 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  602 +++++
 drivers/net/ethernet/mellanox/mlx5/core/mad.c      |   41 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  145 +-
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c      |   72 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   44 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  189 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  156 +-
 drivers/net/ethernet/mellanox/mlx5/core/pd.c       |   61 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  181 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  299 ++-
 drivers/net/ethernet/mellanox/mlx5/core/rl.c       |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/srq.c      |   49 +-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c |  183 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |   67 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   94 +-
 drivers/net/ethernet/mellanox/mlx5/core/vxlan.c    |   29 +-
 drivers/nvme/host/rdma.c                           |   25 +-
 drivers/nvme/target/rdma.c                         |    2 +-
 drivers/staging/lustre/lnet/Kconfig                |    1 +
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    2 +-
 include/linux/mlx4/device.h                        |   13 +-
 include/linux/mlx5/cq.h                            |    6 +-
 include/linux/mlx5/device.h                        |  441 +--
 include/linux/mlx5/driver.h                        |   31 +-
 include/linux/mlx5/fs.h                            |    6 +
 include/linux/mlx5/mlx5_ifc.h                      |  297 ++-
 include/linux/mlx5/port.h                          |   40 +-
 include/linux/mlx5/qp.h                            |  128 +-
 include/linux/mlx5/vport.h                         |    2 +
 include/rdma/ib_verbs.h                            |   81 +-
 include/uapi/rdma/Kbuild                           |    7 +
 .../iwch_user.h =3D> include/uapi/rdma/cxgb3-abi.h   |    8 +-
 .../cxgb4/user.h =3D> include/uapi/rdma/cxgb4-abi.h  |   11 +-
 include/uapi/rdma/ib_user_verbs.h                  |   27 +-
 .../hw/mlx4/user.h =3D> include/uapi/rdma/mlx4-abi.h |    6 +-
 .../hw/mlx5/user.h =3D> include/uapi/rdma/mlx5-abi.h |   52 +-
 include/uapi/rdma/mthca-abi.h                      |  111 +
 .../nes/nes_user.h =3D> include/uapi/rdma/nes-abi.h  |    6 +-
 .../ocrdma_abi.h =3D> include/uapi/rdma/ocrdma-abi.h |  138 +-
 net/9p/trans_rdma.c                                |    2 +-
 net/rds/ib.c                                       |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    2 +-
 net/sunrpc/xprtrdma/verbs.c                        |    2 +-
 154 files changed, 14583 insertions(+), 2824 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
 create mode 100644 drivers/infiniband/hw/hns/Kconfig
 create mode 100644 drivers/infiniband/hw/hns/Makefile
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_ah.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_alloc.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_cmd.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_cmd.h
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_common.h
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_cq.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_device.h
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_eq.h
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hem.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hem.h
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v1.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v1.h
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_main.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_mr.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_pd.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_qp.c
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_user.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag.c
 rename drivers/infiniband/hw/cxgb3/iwch_user.h =3D>
include/uapi/rdma/cxgb3-abi.h (95%)
 rename drivers/infiniband/hw/cxgb4/user.h =3D>
include/uapi/rdma/cxgb4-abi.h (94%)
 rename drivers/infiniband/hw/mlx4/user.h =3D>
include/uapi/rdma/mlx4-abi.h (97%)
 rename drivers/infiniband/hw/mlx5/user.h =3D>
include/uapi/rdma/mlx5-abi.h (83%)
 create mode 100644 include/uapi/rdma/mthca-abi.h
 rename drivers/infiniband/hw/nes/nes_user.h =3D>
include/uapi/rdma/nes-abi.h (97%)
 rename drivers/infiniband/hw/ocrdma/ocrdma_abi.h =3D>
include/uapi/rdma/ocrdma-abi.h (64%)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--DQdxsRGsKI2pqGP95qHmEkVD0LXWM7mNi--

--cf462aA152La3qhs2GCOBrdFvLRORNrtB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX+CCOAAoJELgmozMOVy/dyNEQAIlqo+CxMbfaQV6ujpL2nuO/
tHkr7CHzDIaKmJYf927gPV+lUTKOF8ZwCsZYjymqXtQlkvLRXy1P/ubWJdeJnBsR
g25S4stNP+s5YJb1qy7VJpvhsWjH4J/BXkGVxbQGSJ7D2S+VsIo4B2Cugb8hh6Vr
QXmMbCdPXTCU1S7jGz22UoIqJlCQCPe/fSzx33l+5dFK572NAmgHSXfuDdSR+xpk
IO102tEzN8W/jylr1R/CLTqsg898NzU7QaN1hxkfRwj1g9omnGgV6AdaBo4fDK5N
ZxIh90BEHpYZuUKzGlqPKXmixwvABzWF9p4leNkq/loYubaP89ymn1aI7/qvfnyd
58nywNEyUB68vnZPtsLpxyDDsGQdUJ5kqSydtSx/QgRn6Wd8UGgGFsw0NQ54I/XA
E2W3n2E0ICsQo9EWsVwxafq+4/vz25nQhEbDDmJytRJLdPSTefW2K5saPgpZU+7J
tXj1dOcVniTmc52JmTfiXYi45H6eS1JAV0QBMO52OVLwWs9U8nC9aTujyKty6e2m
Edw/T3i+lj2xI+yaEZyNpKl1vlp5hpWfBuUIrl8m/OzgH/ROQor9k4RbXEOMaHUP
EQFopfkzjbsrtGHx3QGxIEqld4a1teky3qi4fjOoaN6q68Eiz1h6QnBwuzAaiWcg
F70qD5mZB+HKa/MA2Zob
=8/wh
-----END PGP SIGNATURE-----

--cf462aA152La3qhs2GCOBrdFvLRORNrtB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
