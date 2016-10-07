From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/17] Fixes, flattening and packaging
Date: Fri, 7 Oct 2016 17:05:51 +0300
Message-ID: <20161007140551.GT9282@leon.nu>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lpUp1egui7PDlNtH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--lpUp1egui7PDlNtH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 06, 2016 at 02:51:26PM -0600, Jason Gunthorpe wrote:
> This is mostly a grab bag of the finished work left in my tree:
>
>  - Missed items for the last merge
>  - Fix a few mistakes in the earlier patches and build system
>  - Final rename of directories to make the tree shallower (eg eliminate src/, add providers/)
>  - RPM and DEB packaging

Jason,
Can you please add all patches from ML too to this pull request, so they
apply cleanly?

Thanks.

>
> See
>
> https://github.com/linux-rdma/rdma-core/pull/13
>
> Jason Gunthorpe (17):
>   Update Intel lists in MAINTAINERS
>   Update COPYING to reflect recent cxgb4 merge
>   Update comment in cxbg* drivers
>   Remove missed auto* related files
>   rdmacm: Drop SONAME in rspreload
>   umad: Use symlinks instead of a NROFF .so directive
>   verbs: Remove -fno-strict-aliasing
>   Move providers into providers/
>   iwpmd: Flatten iwpmd/src into iwpmd/
>   srp_deamon: Flatten srp_daemon/src,etc into srp_daemon/
>   ibcm: Flatten libibcm/src,include into libibcm/
>   umad: Flatten libibumad/src,include into libibumad/
>   verbs: Flatten libibverbs/src,include into libibverbs/
>   rdmacm: Flatten librdmacm/src,include into librdmacm/
>   Combined RPM Spec file
>   srp_daemon: Add the debian initscripts as an option
>   Debian Packaging
>
>  CMakeLists.txt                                     |  41 ++-
>  COPYING.md                                         |   7 +-
>  Documentation/versioning.md                        |  20 ++
>  MAINTAINERS                                        |  26 +-
>  buildlib/ninja-wrapper                             |  16 ++
>  debian/changelog                                   |   5 +
>  debian/compat                                      |   1 +
>  debian/control                                     | 299 +++++++++++++++++++++
>  debian/ibacm.install                               |  10 +
>  debian/ibverbs-providers.install                   |   7 +
>  debian/ibverbs-utils.install                       |  16 ++
>  debian/iwpmd.install                               |   7 +
>  debian/libibcm-dev.install                         |   3 +
>  debian/libibcm1.install                            |   1 +
>  debian/libibcm1.symbols                            |  23 ++
>  debian/libibumad-dev.install                       |   3 +
>  debian/libibumad3.install                          |   2 +
>  debian/libibumad3.symbols                          |  38 +++
>  debian/libibverbs-dev.install                      |  12 +
>  debian/libibverbs1.install                         |   1 +
>  debian/libibverbs1.postinst                        |  10 +
>  debian/libibverbs1.symbols                         | 134 +++++++++
>  debian/librdmacm-dev.install                       |  57 ++++
>  debian/librdmacm1.install                          |   2 +
>  debian/librdmacm1.symbols                          |  64 +++++
>  debian/rdmacm-utils.install                        |  24 ++
>  debian/rules                                       |  99 +++++++
>  debian/srptools.default                            |  14 +
>  debian/srptools.init                               |  89 ++++++
>  debian/srptools.install                            |   8 +
>  iwpmd/CMakeLists.txt                               |  17 ++
>  iwpmd/{src => }/iwarp_pm.h                         |   0
>  iwpmd/{src => }/iwarp_pm_common.c                  |   0
>  iwpmd/{src => }/iwarp_pm_helper.c                  |   0
>  iwpmd/{src => }/iwarp_pm_server.c                  |   0
>  iwpmd/{src => }/iwpm_netlink.h                     |   0
>  iwpmd/src/.dirstamp                                |   0
>  iwpmd/src/CMakeLists.txt                           |  16 --
>  libcxgb4/COPYING                                   |  29 --
>  libibcm/{src => }/CMakeLists.txt                   |   4 +-
>  libibcm/{src => }/cm.c                             |   0
>  libibcm/{include/infiniband => }/cm.h              |   0
>  libibcm/{include/infiniband => }/cm_abi.h          |   0
>  libibcm/{src => }/libibcm.map                      |   0
>  libibumad/CMakeLists.txt                           |  16 ++
>  libibumad/gen_chlog.sh                             |  67 -----
>  libibumad/{src => }/libibumad.map                  |   0
>  libibumad/libibumad.ver                            |   9 -
>  libibumad/man/CMakeLists.txt                       |   8 +-
>  libibumad/man/umad_attribute_str.3                 |   3 -
>  libibumad/man/umad_mad_status_str.3                |   3 -
>  libibumad/man/umad_method_str.3                    |   3 -
>  libibumad/src/CMakeLists.txt                       |  16 --
>  libibumad/{src => }/sysfs.c                        |   0
>  libibumad/{src => }/umad.c                         |   0
>  libibumad/{include/infiniband => }/umad.h          |   0
>  libibumad/{include/infiniband => }/umad_cm.h       |   0
>  libibumad/{include/infiniband => }/umad_sa.h       |   0
>  libibumad/{include/infiniband => }/umad_sm.h       |   0
>  libibumad/{src => }/umad_str.c                     |   0
>  libibumad/{include/infiniband => }/umad_str.h      |   0
>  libibumad/{include/infiniband => }/umad_types.h    |   0
>  libibverbs/{src => }/CMakeLists.txt                |  18 +-
>  libibverbs/{include/infiniband => }/arch.h         |   0
>  libibverbs/{src => }/cmd.c                         |   0
>  libibverbs/{src => }/compat-1_0.c                  |   0
>  libibverbs/{src => }/device.c                      |   0
>  libibverbs/{include/infiniband => }/driver.h       |   0
>  libibverbs/{src => }/enum_strs.c                   |   0
>  libibverbs/examples/CMakeLists.txt                 |   2 -
>  libibverbs/examples/pingpong.c                     |   9 +-
>  libibverbs/{src => }/ibverbs.h                     |   0
>  libibverbs/{src => }/init.c                        |   0
>  libibverbs/{include/infiniband => }/kern-abi.h     |   0
>  libibverbs/{src => }/libibverbs.map                |   0
>  libibverbs/{src => }/marshall.c                    |   0
>  libibverbs/{include/infiniband => }/marshall.h     |   0
>  libibverbs/{src => }/memory.c                      |   0
>  libibverbs/{src => }/neigh.c                       |   0
>  libibverbs/{src => }/neigh.h                       |   0
>  libibverbs/{src => }/nl1_compat.h                  |   0
>  libibverbs/{include/infiniband => }/opcode.h       |   0
>  libibverbs/{include/infiniband => }/sa-kern-abi.h  |   0
>  libibverbs/{include/infiniband => }/sa.h           |   0
>  libibverbs/{src => }/sysfs.c                       |   0
>  libibverbs/{src => }/verbs.c                       |   0
>  libibverbs/{include/infiniband => }/verbs.h        |   0
>  libipathverbs/src/CMakeLists.txt                   |   4 -
>  librdmacm/{src => }/CMakeLists.txt                 |  14 +-
>  librdmacm/{src => }/acm.c                          |   0
>  librdmacm/{src => }/addrinfo.c                     |   0
>  librdmacm/{src => }/cma.c                          |   0
>  librdmacm/{src => }/cma.h                          |   0
>  librdmacm/{include/infiniband => }/ib.h            |   0
>  librdmacm/{src => }/indexer.c                      |   0
>  librdmacm/{src => }/indexer.h                      |   0
>  librdmacm/{src => }/librdmacm.map                  |   0
>  librdmacm/{src => }/librspreload.map               |   0
>  librdmacm/{src => }/preload.c                      |   0
>  librdmacm/{include/rdma => }/rdma_cma.h            |   0
>  librdmacm/{include/rdma => }/rdma_cma_abi.h        |   0
>  librdmacm/{include/rdma => }/rdma_verbs.h          |   0
>  librdmacm/{src => }/rsocket.c                      |   0
>  librdmacm/{include/rdma => }/rsocket.h             |   0
>  librxe/src/CMakeLists.txt                          |   3 -
>  {libcxgb3/src => providers/cxgb3}/CMakeLists.txt   |   0
>  {libcxgb3/src => providers/cxgb3}/cq.c             |   0
>  {libcxgb3/src => providers/cxgb3}/cxio_wr.h        |   3 +-
>  .../src => providers/cxgb3}/firmware_exports.h     |   0
>  {libcxgb3/src => providers/cxgb3}/iwch-abi.h       |   0
>  {libcxgb3/src => providers/cxgb3}/iwch.c           |   0
>  {libcxgb3/src => providers/cxgb3}/iwch.h           |   0
>  {libcxgb3/src => providers/cxgb3}/qp.c             |   0
>  {libcxgb3/src => providers/cxgb3}/verbs.c          |   0
>  {libcxgb4/src => providers/cxgb4}/CMakeLists.txt   |   0
>  {libcxgb4/src => providers/cxgb4}/cq.c             |   0
>  {libcxgb4/src => providers/cxgb4}/cxgb4-abi.h      |   0
>  {libcxgb4/src => providers/cxgb4}/dev.c            |   0
>  {libcxgb4/src => providers/cxgb4}/libcxgb4.h       |   0
>  {libcxgb4/src => providers/cxgb4}/qp.c             |   0
>  {libcxgb4/src => providers/cxgb4}/t4.h             |   3 +-
>  {libcxgb4/src => providers/cxgb4}/t4_chip_type.h   |   0
>  {libcxgb4/src => providers/cxgb4}/t4_pci_id_tbl.h  |   0
>  {libcxgb4/src => providers/cxgb4}/t4_regs.h        |   0
>  {libcxgb4/src => providers/cxgb4}/t4fw_api.h       |   0
>  {libcxgb4/src => providers/cxgb4}/t4fw_ri_api.h    |   0
>  {libcxgb4/src => providers/cxgb4}/verbs.c          |   0
>  .../src => providers/hfi1verbs}/CMakeLists.txt     |   0
>  .../src => providers/hfi1verbs}/hfi-abi.h          |   0
>  .../src => providers/hfi1verbs}/hfiverbs.c         |   0
>  .../src => providers/hfi1verbs}/hfiverbs.h         |   0
>  {libhfi1verbs/src => providers/hfi1verbs}/verbs.c  |   0
>  {libi40iw/src => providers/i40iw}/CMakeLists.txt   |   0
>  {libi40iw/src => providers/i40iw}/i40e_devids.h    |   0
>  {libi40iw/src => providers/i40iw}/i40iw-abi.h      |   0
>  {libi40iw/src => providers/i40iw}/i40iw_d.h        |   0
>  {libi40iw/src => providers/i40iw}/i40iw_osdep.h    |   0
>  {libi40iw/src => providers/i40iw}/i40iw_register.h |   0
>  {libi40iw/src => providers/i40iw}/i40iw_status.h   |   0
>  {libi40iw/src => providers/i40iw}/i40iw_uk.c       |   0
>  {libi40iw/src => providers/i40iw}/i40iw_umain.c    |   0
>  {libi40iw/src => providers/i40iw}/i40iw_umain.h    |   0
>  {libi40iw/src => providers/i40iw}/i40iw_user.h     |   0
>  {libi40iw/src => providers/i40iw}/i40iw_uverbs.c   |   0
>  .../ipathverbs}/CMakeLists.txt                     |   5 +
>  {libipathverbs => providers/ipathverbs}/COPYING    |   0
>  .../ipathverbs}/dracut_check                       |   0
>  .../ipathverbs}/dracut_install                     |   0
>  .../ipathverbs}/dracut_kmod                        |   0
>  .../src => providers/ipathverbs}/ipath-abi.h       |   0
>  .../src => providers/ipathverbs}/ipathverbs.c      |   0
>  .../src => providers/ipathverbs}/ipathverbs.h      |   0
>  .../ipathverbs}/truescale-serdes.cmds              |   0
>  .../ipathverbs}/truescale.conf.in                  |   0
>  .../src => providers/ipathverbs}/verbs.c           |   0
>  {libmlx4/src => providers/mlx4}/CMakeLists.txt     |   0
>  {libmlx4 => providers/mlx4}/COPYING                |   0
>  {libmlx4/src => providers/mlx4}/buf.c              |   0
>  {libmlx4/src => providers/mlx4}/cq.c               |   0
>  {libmlx4/src => providers/mlx4}/dbrec.c            |   0
>  {libmlx4/src => providers/mlx4}/doorbell.h         |   0
>  {libmlx4/src => providers/mlx4}/mlx4-abi.h         |   0
>  {libmlx4/src => providers/mlx4}/mlx4.c             |   0
>  {libmlx4/src => providers/mlx4}/mlx4.h             |   0
>  {libmlx4/src => providers/mlx4}/mmio.h             |   0
>  {libmlx4/src => providers/mlx4}/qp.c               |   0
>  {libmlx4/src => providers/mlx4}/srq.c              |   0
>  {libmlx4/src => providers/mlx4}/verbs.c            |   0
>  {libmlx4/src => providers/mlx4}/wqe.h              |   0
>  {libmlx5/src => providers/mlx5}/CMakeLists.txt     |   0
>  {libmlx5/src => providers/mlx5}/bitmap.h           |   0
>  {libmlx5/src => providers/mlx5}/buf.c              |   0
>  {libmlx5/src => providers/mlx5}/cq.c               |   0
>  {libmlx5/src => providers/mlx5}/dbrec.c            |   0
>  {libmlx5/src => providers/mlx5}/doorbell.h         |   0
>  {libmlx5/src => providers/mlx5}/mlx5-abi.h         |   0
>  {libmlx5/src => providers/mlx5}/mlx5.c             |   0
>  {libmlx5/src => providers/mlx5}/mlx5.h             |   0
>  {libmlx5/src => providers/mlx5}/qp.c               |   0
>  {libmlx5/src => providers/mlx5}/srq.c              |   0
>  {libmlx5/src => providers/mlx5}/verbs.c            |   0
>  {libmlx5/src => providers/mlx5}/wqe.h              |   0
>  {libmthca/src => providers/mthca}/CMakeLists.txt   |   0
>  {libmthca/src => providers/mthca}/ah.c             |   0
>  {libmthca/src => providers/mthca}/buf.c            |   0
>  {libmthca/src => providers/mthca}/cq.c             |   0
>  {libmthca/src => providers/mthca}/doorbell.h       |   0
>  {libmthca/src => providers/mthca}/memfree.c        |   0
>  {libmthca/src => providers/mthca}/mthca-abi.h      |   0
>  {libmthca/src => providers/mthca}/mthca.c          |   0
>  {libmthca/src => providers/mthca}/mthca.h          |   0
>  {libmthca/src => providers/mthca}/qp.c             |   0
>  {libmthca/src => providers/mthca}/srq.c            |   0
>  {libmthca/src => providers/mthca}/verbs.c          |   0
>  {libmthca/src => providers/mthca}/wqe.h            |   0
>  {libnes/src => providers/nes}/CMakeLists.txt       |   0
>  {libnes/src => providers/nes}/nes-abi.h            |   0
>  {libnes/src => providers/nes}/nes_umain.c          |   0
>  {libnes/src => providers/nes}/nes_umain.h          |   0
>  {libnes/src => providers/nes}/nes_uverbs.c         |   0
>  {libocrdma/src => providers/ocrdma}/CMakeLists.txt |   0
>  {libocrdma => providers/ocrdma}/Changelog          |   0
>  {libocrdma/src => providers/ocrdma}/ocrdma_abi.h   |   0
>  {libocrdma/src => providers/ocrdma}/ocrdma_main.c  |   0
>  {libocrdma/src => providers/ocrdma}/ocrdma_main.h  |   0
>  {libocrdma/src => providers/ocrdma}/ocrdma_verbs.c |   0
>  {librxe => providers/rxe}/CMakeLists.txt           |   3 +
>  {librxe => providers/rxe}/man/CMakeLists.txt       |   0
>  {librxe => providers/rxe}/man/rxe.7                |   0
>  {librxe => providers/rxe}/man/rxe_cfg.8            |   0
>  {librxe/src => providers/rxe}/rxe-abi.h            |   0
>  {librxe/src => providers/rxe}/rxe.c                |   0
>  {librxe/src => providers/rxe}/rxe.h                |   0
>  {librxe => providers/rxe}/rxe_cfg                  |   0
>  {librxe/src => providers/rxe}/rxe_queue.h          |   0
>  rdma-core.spec                                     | 123 +++++++++
>  srp_daemon/CMakeLists.txt                          |  50 ++++
>  srp_daemon/{man => }/ibsrpdm.1                     |   0
>  srp_daemon/{srp_daemon => }/logrotate-srp_daemon   |   0
>  srp_daemon/man/CMakeLists.txt                      |   4 -
>  .../{srp_daemon => }/rsyslog-srp_daemon.conf       |   0
>  srp_daemon/{man => }/srp_daemon.1.in               |   0
>  srp_daemon/{srp_daemon => }/srp_daemon.c           |   0
>  srp_daemon/{srp_daemon => }/srp_daemon.conf        |   0
>  srp_daemon/{srp_daemon => }/srp_daemon.h           |   0
>  srp_daemon/{srp_daemon => }/srp_daemon.sh.in       |   0
>  srp_daemon/srp_daemon/CMakeLists.txt               |  34 ---
>  srp_daemon/{srp_daemon => }/srp_handle_traps.c     |   0
>  srp_daemon/{srp_daemon => }/srp_ib_types.h         |   0
>  srp_daemon/{srp_daemon => }/srp_sync.c             |   0
>  srp_daemon/{srp_daemon => }/srpd.in                |   0
>  231 files changed, 1243 insertions(+), 262 deletions(-)
>  create mode 100644 buildlib/ninja-wrapper
>  create mode 100644 debian/changelog
>  create mode 100644 debian/compat
>  create mode 100644 debian/control
>  create mode 100644 debian/ibacm.install
>  create mode 100644 debian/ibverbs-providers.install
>  create mode 100644 debian/ibverbs-utils.install
>  create mode 100644 debian/iwpmd.install
>  create mode 100644 debian/libibcm-dev.install
>  create mode 100644 debian/libibcm1.install
>  create mode 100644 debian/libibcm1.symbols
>  create mode 100644 debian/libibumad-dev.install
>  create mode 100644 debian/libibumad3.install
>  create mode 100644 debian/libibumad3.symbols
>  create mode 100644 debian/libibverbs-dev.install
>  create mode 100644 debian/libibverbs1.install
>  create mode 100644 debian/libibverbs1.postinst
>  create mode 100644 debian/libibverbs1.symbols
>  create mode 100644 debian/librdmacm-dev.install
>  create mode 100644 debian/librdmacm1.install
>  create mode 100644 debian/librdmacm1.symbols
>  create mode 100644 debian/rdmacm-utils.install
>  create mode 100755 debian/rules
>  create mode 100644 debian/srptools.default
>  create mode 100644 debian/srptools.init
>  create mode 100644 debian/srptools.install
>  rename iwpmd/{src => }/iwarp_pm.h (100%)
>  rename iwpmd/{src => }/iwarp_pm_common.c (100%)
>  rename iwpmd/{src => }/iwarp_pm_helper.c (100%)
>  rename iwpmd/{src => }/iwarp_pm_server.c (100%)
>  rename iwpmd/{src => }/iwpm_netlink.h (100%)
>  delete mode 100644 iwpmd/src/.dirstamp
>  delete mode 100644 iwpmd/src/CMakeLists.txt
>  delete mode 100644 libcxgb4/COPYING
>  rename libibcm/{src => }/CMakeLists.txt (74%)
>  rename libibcm/{src => }/cm.c (100%)
>  rename libibcm/{include/infiniband => }/cm.h (100%)
>  rename libibcm/{include/infiniband => }/cm_abi.h (100%)
>  rename libibcm/{src => }/libibcm.map (100%)
>  create mode 100644 libibumad/CMakeLists.txt
>  delete mode 100755 libibumad/gen_chlog.sh
>  rename libibumad/{src => }/libibumad.map (100%)
>  delete mode 100644 libibumad/libibumad.ver
>  delete mode 100644 libibumad/man/umad_attribute_str.3
>  delete mode 100644 libibumad/man/umad_mad_status_str.3
>  delete mode 100644 libibumad/man/umad_method_str.3
>  delete mode 100644 libibumad/src/CMakeLists.txt
>  rename libibumad/{src => }/sysfs.c (100%)
>  rename libibumad/{src => }/umad.c (100%)
>  rename libibumad/{include/infiniband => }/umad.h (100%)
>  rename libibumad/{include/infiniband => }/umad_cm.h (100%)
>  rename libibumad/{include/infiniband => }/umad_sa.h (100%)
>  rename libibumad/{include/infiniband => }/umad_sm.h (100%)
>  rename libibumad/{src => }/umad_str.c (100%)
>  rename libibumad/{include/infiniband => }/umad_str.h (100%)
>  rename libibumad/{include/infiniband => }/umad_types.h (100%)
>  rename libibverbs/{src => }/CMakeLists.txt (56%)
>  rename libibverbs/{include/infiniband => }/arch.h (100%)
>  rename libibverbs/{src => }/cmd.c (100%)
>  rename libibverbs/{src => }/compat-1_0.c (100%)
>  rename libibverbs/{src => }/device.c (100%)
>  rename libibverbs/{include/infiniband => }/driver.h (100%)
>  rename libibverbs/{src => }/enum_strs.c (100%)
>  rename libibverbs/{src => }/ibverbs.h (100%)
>  rename libibverbs/{src => }/init.c (100%)
>  rename libibverbs/{include/infiniband => }/kern-abi.h (100%)
>  rename libibverbs/{src => }/libibverbs.map (100%)
>  rename libibverbs/{src => }/marshall.c (100%)
>  rename libibverbs/{include/infiniband => }/marshall.h (100%)
>  rename libibverbs/{src => }/memory.c (100%)
>  rename libibverbs/{src => }/neigh.c (100%)
>  rename libibverbs/{src => }/neigh.h (100%)
>  rename libibverbs/{src => }/nl1_compat.h (100%)
>  rename libibverbs/{include/infiniband => }/opcode.h (100%)
>  rename libibverbs/{include/infiniband => }/sa-kern-abi.h (100%)
>  rename libibverbs/{include/infiniband => }/sa.h (100%)
>  rename libibverbs/{src => }/sysfs.c (100%)
>  rename libibverbs/{src => }/verbs.c (100%)
>  rename libibverbs/{include/infiniband => }/verbs.h (100%)
>  delete mode 100644 libipathverbs/src/CMakeLists.txt
>  rename librdmacm/{src => }/CMakeLists.txt (81%)
>  rename librdmacm/{src => }/acm.c (100%)
>  rename librdmacm/{src => }/addrinfo.c (100%)
>  rename librdmacm/{src => }/cma.c (100%)
>  rename librdmacm/{src => }/cma.h (100%)
>  rename librdmacm/{include/infiniband => }/ib.h (100%)
>  rename librdmacm/{src => }/indexer.c (100%)
>  rename librdmacm/{src => }/indexer.h (100%)
>  rename librdmacm/{src => }/librdmacm.map (100%)
>  rename librdmacm/{src => }/librspreload.map (100%)
>  rename librdmacm/{src => }/preload.c (100%)
>  rename librdmacm/{include/rdma => }/rdma_cma.h (100%)
>  rename librdmacm/{include/rdma => }/rdma_cma_abi.h (100%)
>  rename librdmacm/{include/rdma => }/rdma_verbs.h (100%)
>  rename librdmacm/{src => }/rsocket.c (100%)
>  rename librdmacm/{include/rdma => }/rsocket.h (100%)
>  delete mode 100644 librxe/src/CMakeLists.txt
>  rename {libcxgb3/src => providers/cxgb3}/CMakeLists.txt (100%)
>  rename {libcxgb3/src => providers/cxgb3}/cq.c (100%)
>  rename {libcxgb3/src => providers/cxgb3}/cxio_wr.h (99%)
>  rename {libcxgb3/src => providers/cxgb3}/firmware_exports.h (100%)
>  rename {libcxgb3/src => providers/cxgb3}/iwch-abi.h (100%)
>  rename {libcxgb3/src => providers/cxgb3}/iwch.c (100%)
>  rename {libcxgb3/src => providers/cxgb3}/iwch.h (100%)
>  rename {libcxgb3/src => providers/cxgb3}/qp.c (100%)
>  rename {libcxgb3/src => providers/cxgb3}/verbs.c (100%)
>  rename {libcxgb4/src => providers/cxgb4}/CMakeLists.txt (100%)
>  rename {libcxgb4/src => providers/cxgb4}/cq.c (100%)
>  rename {libcxgb4/src => providers/cxgb4}/cxgb4-abi.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/dev.c (100%)
>  rename {libcxgb4/src => providers/cxgb4}/libcxgb4.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/qp.c (100%)
>  rename {libcxgb4/src => providers/cxgb4}/t4.h (99%)
>  rename {libcxgb4/src => providers/cxgb4}/t4_chip_type.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/t4_pci_id_tbl.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/t4_regs.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/t4fw_api.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/t4fw_ri_api.h (100%)
>  rename {libcxgb4/src => providers/cxgb4}/verbs.c (100%)
>  rename {libhfi1verbs/src => providers/hfi1verbs}/CMakeLists.txt (100%)
>  rename {libhfi1verbs/src => providers/hfi1verbs}/hfi-abi.h (100%)
>  rename {libhfi1verbs/src => providers/hfi1verbs}/hfiverbs.c (100%)
>  rename {libhfi1verbs/src => providers/hfi1verbs}/hfiverbs.h (100%)
>  rename {libhfi1verbs/src => providers/hfi1verbs}/verbs.c (100%)
>  rename {libi40iw/src => providers/i40iw}/CMakeLists.txt (100%)
>  rename {libi40iw/src => providers/i40iw}/i40e_devids.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw-abi.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_d.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_osdep.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_register.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_status.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_uk.c (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_umain.c (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_umain.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_user.h (100%)
>  rename {libi40iw/src => providers/i40iw}/i40iw_uverbs.c (100%)
>  rename {libipathverbs => providers/ipathverbs}/CMakeLists.txt (84%)
>  rename {libipathverbs => providers/ipathverbs}/COPYING (100%)
>  rename {libipathverbs => providers/ipathverbs}/dracut_check (100%)
>  rename {libipathverbs => providers/ipathverbs}/dracut_install (100%)
>  rename {libipathverbs => providers/ipathverbs}/dracut_kmod (100%)
>  rename {libipathverbs/src => providers/ipathverbs}/ipath-abi.h (100%)
>  rename {libipathverbs/src => providers/ipathverbs}/ipathverbs.c (100%)
>  rename {libipathverbs/src => providers/ipathverbs}/ipathverbs.h (100%)
>  rename {libipathverbs => providers/ipathverbs}/truescale-serdes.cmds (100%)
>  rename {libipathverbs => providers/ipathverbs}/truescale.conf.in (100%)
>  rename {libipathverbs/src => providers/ipathverbs}/verbs.c (100%)
>  rename {libmlx4/src => providers/mlx4}/CMakeLists.txt (100%)
>  rename {libmlx4 => providers/mlx4}/COPYING (100%)
>  rename {libmlx4/src => providers/mlx4}/buf.c (100%)
>  rename {libmlx4/src => providers/mlx4}/cq.c (100%)
>  rename {libmlx4/src => providers/mlx4}/dbrec.c (100%)
>  rename {libmlx4/src => providers/mlx4}/doorbell.h (100%)
>  rename {libmlx4/src => providers/mlx4}/mlx4-abi.h (100%)
>  rename {libmlx4/src => providers/mlx4}/mlx4.c (100%)
>  rename {libmlx4/src => providers/mlx4}/mlx4.h (100%)
>  rename {libmlx4/src => providers/mlx4}/mmio.h (100%)
>  rename {libmlx4/src => providers/mlx4}/qp.c (100%)
>  rename {libmlx4/src => providers/mlx4}/srq.c (100%)
>  rename {libmlx4/src => providers/mlx4}/verbs.c (100%)
>  rename {libmlx4/src => providers/mlx4}/wqe.h (100%)
>  rename {libmlx5/src => providers/mlx5}/CMakeLists.txt (100%)
>  rename {libmlx5/src => providers/mlx5}/bitmap.h (100%)
>  rename {libmlx5/src => providers/mlx5}/buf.c (100%)
>  rename {libmlx5/src => providers/mlx5}/cq.c (100%)
>  rename {libmlx5/src => providers/mlx5}/dbrec.c (100%)
>  rename {libmlx5/src => providers/mlx5}/doorbell.h (100%)
>  rename {libmlx5/src => providers/mlx5}/mlx5-abi.h (100%)
>  rename {libmlx5/src => providers/mlx5}/mlx5.c (100%)
>  rename {libmlx5/src => providers/mlx5}/mlx5.h (100%)
>  rename {libmlx5/src => providers/mlx5}/qp.c (100%)
>  rename {libmlx5/src => providers/mlx5}/srq.c (100%)
>  rename {libmlx5/src => providers/mlx5}/verbs.c (100%)
>  rename {libmlx5/src => providers/mlx5}/wqe.h (100%)
>  rename {libmthca/src => providers/mthca}/CMakeLists.txt (100%)
>  rename {libmthca/src => providers/mthca}/ah.c (100%)
>  rename {libmthca/src => providers/mthca}/buf.c (100%)
>  rename {libmthca/src => providers/mthca}/cq.c (100%)
>  rename {libmthca/src => providers/mthca}/doorbell.h (100%)
>  rename {libmthca/src => providers/mthca}/memfree.c (100%)
>  rename {libmthca/src => providers/mthca}/mthca-abi.h (100%)
>  rename {libmthca/src => providers/mthca}/mthca.c (100%)
>  rename {libmthca/src => providers/mthca}/mthca.h (100%)
>  rename {libmthca/src => providers/mthca}/qp.c (100%)
>  rename {libmthca/src => providers/mthca}/srq.c (100%)
>  rename {libmthca/src => providers/mthca}/verbs.c (100%)
>  rename {libmthca/src => providers/mthca}/wqe.h (100%)
>  rename {libnes/src => providers/nes}/CMakeLists.txt (100%)
>  rename {libnes/src => providers/nes}/nes-abi.h (100%)
>  rename {libnes/src => providers/nes}/nes_umain.c (100%)
>  rename {libnes/src => providers/nes}/nes_umain.h (100%)
>  rename {libnes/src => providers/nes}/nes_uverbs.c (100%)
>  rename {libocrdma/src => providers/ocrdma}/CMakeLists.txt (100%)
>  rename {libocrdma => providers/ocrdma}/Changelog (100%)
>  rename {libocrdma/src => providers/ocrdma}/ocrdma_abi.h (100%)
>  rename {libocrdma/src => providers/ocrdma}/ocrdma_main.c (100%)
>  rename {libocrdma/src => providers/ocrdma}/ocrdma_main.h (100%)
>  rename {libocrdma/src => providers/ocrdma}/ocrdma_verbs.c (100%)
>  rename {librxe => providers/rxe}/CMakeLists.txt (84%)
>  rename {librxe => providers/rxe}/man/CMakeLists.txt (100%)
>  rename {librxe => providers/rxe}/man/rxe.7 (100%)
>  rename {librxe => providers/rxe}/man/rxe_cfg.8 (100%)
>  rename {librxe/src => providers/rxe}/rxe-abi.h (100%)
>  rename {librxe/src => providers/rxe}/rxe.c (100%)
>  rename {librxe/src => providers/rxe}/rxe.h (100%)
>  rename {librxe => providers/rxe}/rxe_cfg (100%)
>  rename {librxe/src => providers/rxe}/rxe_queue.h (100%)
>  create mode 100644 rdma-core.spec
>  create mode 100644 srp_daemon/CMakeLists.txt
>  rename srp_daemon/{man => }/ibsrpdm.1 (100%)
>  rename srp_daemon/{srp_daemon => }/logrotate-srp_daemon (100%)
>  delete mode 100644 srp_daemon/man/CMakeLists.txt
>  rename srp_daemon/{srp_daemon => }/rsyslog-srp_daemon.conf (100%)
>  rename srp_daemon/{man => }/srp_daemon.1.in (100%)
>  rename srp_daemon/{srp_daemon => }/srp_daemon.c (100%)
>  rename srp_daemon/{srp_daemon => }/srp_daemon.conf (100%)
>  rename srp_daemon/{srp_daemon => }/srp_daemon.h (100%)
>  rename srp_daemon/{srp_daemon => }/srp_daemon.sh.in (100%)
>  delete mode 100644 srp_daemon/srp_daemon/CMakeLists.txt
>  rename srp_daemon/{srp_daemon => }/srp_handle_traps.c (100%)
>  rename srp_daemon/{srp_daemon => }/srp_ib_types.h (100%)
>  rename srp_daemon/{srp_daemon => }/srp_sync.c (100%)
>  rename srp_daemon/{srp_daemon => }/srpd.in (100%)
>
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--lpUp1egui7PDlNtH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX96u/AAoJEORje4g2clin9Q8P/3ovuK/kjty2moGUhbQAZo7+
2tdQR8zwtAJQZNMgqU7i961xT/y+SmFf4pziAG7VBPM/uu7HebrHeS4A8aFZcjJ5
rMS3JsVisJFAibArdVfVpVtbEXq6+RjfS0DF987dsDcimU84AqW6VY+RSUbsL88C
jGXQuaqK0ZxiwzYuQe48aHP729P0vOXdz2ZxDrB9YfyI7+KTl8Mxrz+JZr17H98o
m/adt7MgYSH5CcDAN1upSfaCuq+cV1WLdmEUaTSvNk/inNRDmS7uISYXUqWwrTGW
hzdLItZjriQX/nVZhgo+w+cMmVrBSBTHshDDrFm3plxCw8ccfQQmWlHEXVa2KkHg
z6dbeWH+jFxfbMcMFPjpPwskZUSctmfaqyyyjf9z3TDyW1RfaYvns+X3RkMg9AcW
Zstw5Dvjtr1RIpdPDjlf/DAqTPfO50hyjfS2FJ651AzNvFuSOCQaNnanB1D+CPFc
kfYZ7lhguq9QnyLwuxpCX8V/stBebw1C28mu4NZ7Rxg9eKbC63O1nktqFB47/0D7
3rSdxs+VoUearJETKRez1x2UYPZ2eBbTMKRS5p9bf1O3UOyKXOQLgr+qFIAihnTA
EhZnr++LH0K9GhH9ZrXn8JHaUNX9QYwgC98IDYpCZaaSudbSMjgiKgI1bhfqEtU4
7SVQeWuZP/zMgKSSSifZ
=E1Hx
-----END PGP SIGNATURE-----

--lpUp1egui7PDlNtH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
