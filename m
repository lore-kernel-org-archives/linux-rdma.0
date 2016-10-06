From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 08/17] Move providers into providers/
Date: Thu,  6 Oct 2016 14:51:34 -0600
Message-ID: <1475787103-13283-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER for
        ib_qib.ko" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Also
 - Flatten the src/ directory into the root
 - Drop the 'lib' prefix. These are plugins, not true libraries

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                                     | 26 ++++++++++------------
 MAINTAINERS                                        | 22 +++++++++---------
 libipathverbs/src/CMakeLists.txt                   |  4 ----
 librxe/src/CMakeLists.txt                          |  3 ---
 {libcxgb3/src => providers/cxgb3}/CMakeLists.txt   |  0
 {libcxgb3/src => providers/cxgb3}/cq.c             |  0
 {libcxgb3/src => providers/cxgb3}/cxio_wr.h        |  0
 .../src => providers/cxgb3}/firmware_exports.h     |  0
 {libcxgb3/src => providers/cxgb3}/iwch-abi.h       |  0
 {libcxgb3/src => providers/cxgb3}/iwch.c           |  0
 {libcxgb3/src => providers/cxgb3}/iwch.h           |  0
 {libcxgb3/src => providers/cxgb3}/qp.c             |  0
 {libcxgb3/src => providers/cxgb3}/verbs.c          |  0
 {libcxgb4/src => providers/cxgb4}/CMakeLists.txt   |  0
 {libcxgb4/src => providers/cxgb4}/cq.c             |  0
 {libcxgb4/src => providers/cxgb4}/cxgb4-abi.h      |  0
 {libcxgb4/src => providers/cxgb4}/dev.c            |  0
 {libcxgb4/src => providers/cxgb4}/libcxgb4.h       |  0
 {libcxgb4/src => providers/cxgb4}/qp.c             |  0
 {libcxgb4/src => providers/cxgb4}/t4.h             |  0
 {libcxgb4/src => providers/cxgb4}/t4_chip_type.h   |  0
 {libcxgb4/src => providers/cxgb4}/t4_pci_id_tbl.h  |  0
 {libcxgb4/src => providers/cxgb4}/t4_regs.h        |  0
 {libcxgb4/src => providers/cxgb4}/t4fw_api.h       |  0
 {libcxgb4/src => providers/cxgb4}/t4fw_ri_api.h    |  0
 {libcxgb4/src => providers/cxgb4}/verbs.c          |  0
 .../src => providers/hfi1verbs}/CMakeLists.txt     |  0
 .../src => providers/hfi1verbs}/hfi-abi.h          |  0
 .../src => providers/hfi1verbs}/hfiverbs.c         |  0
 .../src => providers/hfi1verbs}/hfiverbs.h         |  0
 {libhfi1verbs/src => providers/hfi1verbs}/verbs.c  |  0
 {libi40iw/src => providers/i40iw}/CMakeLists.txt   |  0
 {libi40iw/src => providers/i40iw}/i40e_devids.h    |  0
 {libi40iw/src => providers/i40iw}/i40iw-abi.h      |  0
 {libi40iw/src => providers/i40iw}/i40iw_d.h        |  0
 {libi40iw/src => providers/i40iw}/i40iw_osdep.h    |  0
 {libi40iw/src => providers/i40iw}/i40iw_register.h |  0
 {libi40iw/src => providers/i40iw}/i40iw_status.h   |  0
 {libi40iw/src => providers/i40iw}/i40iw_uk.c       |  0
 {libi40iw/src => providers/i40iw}/i40iw_umain.c    |  0
 {libi40iw/src => providers/i40iw}/i40iw_umain.h    |  0
 {libi40iw/src => providers/i40iw}/i40iw_user.h     |  0
 {libi40iw/src => providers/i40iw}/i40iw_uverbs.c   |  0
 .../ipathverbs}/CMakeLists.txt                     |  5 +++++
 {libipathverbs => providers/ipathverbs}/COPYING    |  0
 .../ipathverbs}/dracut_check                       |  0
 .../ipathverbs}/dracut_install                     |  0
 .../ipathverbs}/dracut_kmod                        |  0
 .../src => providers/ipathverbs}/ipath-abi.h       |  0
 .../src => providers/ipathverbs}/ipathverbs.c      |  0
 .../src => providers/ipathverbs}/ipathverbs.h      |  0
 .../ipathverbs}/truescale-serdes.cmds              |  0
 .../ipathverbs}/truescale.conf.in                  |  0
 .../src => providers/ipathverbs}/verbs.c           |  0
 {libmlx4/src => providers/mlx4}/CMakeLists.txt     |  0
 {libmlx4 => providers/mlx4}/COPYING                |  0
 {libmlx4/src => providers/mlx4}/buf.c              |  0
 {libmlx4/src => providers/mlx4}/cq.c               |  0
 {libmlx4/src => providers/mlx4}/dbrec.c            |  0
 {libmlx4/src => providers/mlx4}/doorbell.h         |  0
 {libmlx4/src => providers/mlx4}/mlx4-abi.h         |  0
 {libmlx4/src => providers/mlx4}/mlx4.c             |  0
 {libmlx4/src => providers/mlx4}/mlx4.h             |  0
 {libmlx4/src => providers/mlx4}/mmio.h             |  0
 {libmlx4/src => providers/mlx4}/qp.c               |  0
 {libmlx4/src => providers/mlx4}/srq.c              |  0
 {libmlx4/src => providers/mlx4}/verbs.c            |  0
 {libmlx4/src => providers/mlx4}/wqe.h              |  0
 {libmlx5/src => providers/mlx5}/CMakeLists.txt     |  0
 {libmlx5/src => providers/mlx5}/bitmap.h           |  0
 {libmlx5/src => providers/mlx5}/buf.c              |  0
 {libmlx5/src => providers/mlx5}/cq.c               |  0
 {libmlx5/src => providers/mlx5}/dbrec.c            |  0
 {libmlx5/src => providers/mlx5}/doorbell.h         |  0
 {libmlx5/src => providers/mlx5}/mlx5-abi.h         |  0
 {libmlx5/src => providers/mlx5}/mlx5.c             |  0
 {libmlx5/src => providers/mlx5}/mlx5.h             |  0
 {libmlx5/src => providers/mlx5}/qp.c               |  0
 {libmlx5/src => providers/mlx5}/srq.c              |  0
 {libmlx5/src => providers/mlx5}/verbs.c            |  0
 {libmlx5/src => providers/mlx5}/wqe.h              |  0
 {libmthca/src => providers/mthca}/CMakeLists.txt   |  0
 {libmthca/src => providers/mthca}/ah.c             |  0
 {libmthca/src => providers/mthca}/buf.c            |  0
 {libmthca/src => providers/mthca}/cq.c             |  0
 {libmthca/src => providers/mthca}/doorbell.h       |  0
 {libmthca/src => providers/mthca}/memfree.c        |  0
 {libmthca/src => providers/mthca}/mthca-abi.h      |  0
 {libmthca/src => providers/mthca}/mthca.c          |  0
 {libmthca/src => providers/mthca}/mthca.h          |  0
 {libmthca/src => providers/mthca}/qp.c             |  0
 {libmthca/src => providers/mthca}/srq.c            |  0
 {libmthca/src => providers/mthca}/verbs.c          |  0
 {libmthca/src => providers/mthca}/wqe.h            |  0
 {libnes/src => providers/nes}/CMakeLists.txt       |  0
 {libnes/src => providers/nes}/nes-abi.h            |  0
 {libnes/src => providers/nes}/nes_umain.c          |  0
 {libnes/src => providers/nes}/nes_umain.h          |  0
 {libnes/src => providers/nes}/nes_uverbs.c         |  0
 {libocrdma/src => providers/ocrdma}/CMakeLists.txt |  0
 {libocrdma => providers/ocrdma}/Changelog          |  0
 {libocrdma/src => providers/ocrdma}/ocrdma_abi.h   |  0
 {libocrdma/src => providers/ocrdma}/ocrdma_main.c  |  0
 {libocrdma/src => providers/ocrdma}/ocrdma_main.h  |  0
 {libocrdma/src => providers/ocrdma}/ocrdma_verbs.c |  0
 {librxe => providers/rxe}/CMakeLists.txt           |  3 +++
 {librxe => providers/rxe}/man/CMakeLists.txt       |  0
 {librxe => providers/rxe}/man/rxe.7                |  0
 {librxe => providers/rxe}/man/rxe_cfg.8            |  0
 {librxe/src => providers/rxe}/rxe-abi.h            |  0
 {librxe/src => providers/rxe}/rxe.c                |  0
 {librxe/src => providers/rxe}/rxe.h                |  0
 {librxe => providers/rxe}/rxe_cfg                  |  0
 {librxe/src => providers/rxe}/rxe_queue.h          |  0
 114 files changed, 31 insertions(+), 32 deletions(-)
 delete mode 100644 libipathverbs/src/CMakeLists.txt
 delete mode 100644 librxe/src/CMakeLists.txt
 rename {libcxgb3/src => providers/cxgb3}/CMakeLists.txt (100%)
 rename {libcxgb3/src => providers/cxgb3}/cq.c (100%)
 rename {libcxgb3/src => providers/cxgb3}/cxio_wr.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/firmware_exports.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/iwch-abi.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/iwch.c (100%)
 rename {libcxgb3/src => providers/cxgb3}/iwch.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/qp.c (100%)
 rename {libcxgb3/src => providers/cxgb3}/verbs.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/CMakeLists.txt (100%)
 rename {libcxgb4/src => providers/cxgb4}/cq.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/cxgb4-abi.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/dev.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/libcxgb4.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/qp.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4_chip_type.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4_pci_id_tbl.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4_regs.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4fw_api.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4fw_ri_api.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/verbs.c (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/CMakeLists.txt (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/hfi-abi.h (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/hfiverbs.c (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/hfiverbs.h (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/verbs.c (100%)
 rename {libi40iw/src => providers/i40iw}/CMakeLists.txt (100%)
 rename {libi40iw/src => providers/i40iw}/i40e_devids.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw-abi.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_d.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_osdep.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_register.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_status.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_uk.c (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_umain.c (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_umain.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_user.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_uverbs.c (100%)
 rename {libipathverbs => providers/ipathverbs}/CMakeLists.txt (84%)
 rename {libipathverbs => providers/ipathverbs}/COPYING (100%)
 rename {libipathverbs => providers/ipathverbs}/dracut_check (100%)
 rename {libipathverbs => providers/ipathverbs}/dracut_install (100%)
 rename {libipathverbs => providers/ipathverbs}/dracut_kmod (100%)
 rename {libipathverbs/src => providers/ipathverbs}/ipath-abi.h (100%)
 rename {libipathverbs/src => providers/ipathverbs}/ipathverbs.c (100%)
 rename {libipathverbs/src => providers/ipathverbs}/ipathverbs.h (100%)
 rename {libipathverbs => providers/ipathverbs}/truescale-serdes.cmds (100%)
 rename {libipathverbs => providers/ipathverbs}/truescale.conf.in (100%)
 rename {libipathverbs/src => providers/ipathverbs}/verbs.c (100%)
 rename {libmlx4/src => providers/mlx4}/CMakeLists.txt (100%)
 rename {libmlx4 => providers/mlx4}/COPYING (100%)
 rename {libmlx4/src => providers/mlx4}/buf.c (100%)
 rename {libmlx4/src => providers/mlx4}/cq.c (100%)
 rename {libmlx4/src => providers/mlx4}/dbrec.c (100%)
 rename {libmlx4/src => providers/mlx4}/doorbell.h (100%)
 rename {libmlx4/src => providers/mlx4}/mlx4-abi.h (100%)
 rename {libmlx4/src => providers/mlx4}/mlx4.c (100%)
 rename {libmlx4/src => providers/mlx4}/mlx4.h (100%)
 rename {libmlx4/src => providers/mlx4}/mmio.h (100%)
 rename {libmlx4/src => providers/mlx4}/qp.c (100%)
 rename {libmlx4/src => providers/mlx4}/srq.c (100%)
 rename {libmlx4/src => providers/mlx4}/verbs.c (100%)
 rename {libmlx4/src => providers/mlx4}/wqe.h (100%)
 rename {libmlx5/src => providers/mlx5}/CMakeLists.txt (100%)
 rename {libmlx5/src => providers/mlx5}/bitmap.h (100%)
 rename {libmlx5/src => providers/mlx5}/buf.c (100%)
 rename {libmlx5/src => providers/mlx5}/cq.c (100%)
 rename {libmlx5/src => providers/mlx5}/dbrec.c (100%)
 rename {libmlx5/src => providers/mlx5}/doorbell.h (100%)
 rename {libmlx5/src => providers/mlx5}/mlx5-abi.h (100%)
 rename {libmlx5/src => providers/mlx5}/mlx5.c (100%)
 rename {libmlx5/src => providers/mlx5}/mlx5.h (100%)
 rename {libmlx5/src => providers/mlx5}/qp.c (100%)
 rename {libmlx5/src => providers/mlx5}/srq.c (100%)
 rename {libmlx5/src => providers/mlx5}/verbs.c (100%)
 rename {libmlx5/src => providers/mlx5}/wqe.h (100%)
 rename {libmthca/src => providers/mthca}/CMakeLists.txt (100%)
 rename {libmthca/src => providers/mthca}/ah.c (100%)
 rename {libmthca/src => providers/mthca}/buf.c (100%)
 rename {libmthca/src => providers/mthca}/cq.c (100%)
 rename {libmthca/src => providers/mthca}/doorbell.h (100%)
 rename {libmthca/src => providers/mthca}/memfree.c (100%)
 rename {libmthca/src => providers/mthca}/mthca-abi.h (100%)
 rename {libmthca/src => providers/mthca}/mthca.c (100%)
 rename {libmthca/src => providers/mthca}/mthca.h (100%)
 rename {libmthca/src => providers/mthca}/qp.c (100%)
 rename {libmthca/src => providers/mthca}/srq.c (100%)
 rename {libmthca/src => providers/mthca}/verbs.c (100%)
 rename {libmthca/src => providers/mthca}/wqe.h (100%)
 rename {libnes/src => providers/nes}/CMakeLists.txt (100%)
 rename {libnes/src => providers/nes}/nes-abi.h (100%)
 rename {libnes/src => providers/nes}/nes_umain.c (100%)
 rename {libnes/src => providers/nes}/nes_umain.h (100%)
 rename {libnes/src => providers/nes}/nes_uverbs.c (100%)
 rename {libocrdma/src => providers/ocrdma}/CMakeLists.txt (100%)
 rename {libocrdma => providers/ocrdma}/Changelog (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_abi.h (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_main.c (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_main.h (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_verbs.c (100%)
 rename {librxe => providers/rxe}/CMakeLists.txt (84%)
 rename {librxe => providers/rxe}/man/CMakeLists.txt (100%)
 rename {librxe => providers/rxe}/man/rxe.7 (100%)
 rename {librxe => providers/rxe}/man/rxe_cfg.8 (100%)
 rename {librxe/src => providers/rxe}/rxe-abi.h (100%)
 rename {librxe/src => providers/rxe}/rxe.c (100%)
 rename {librxe/src => providers/rxe}/rxe.h (100%)
 rename {librxe => providers/rxe}/rxe_cfg (100%)
 rename {librxe/src => providers/rxe}/rxe_queue.h (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a6fc092d7994..45a857085832 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -260,20 +260,18 @@ add_subdirectory(librdmacm/man)
 add_subdirectory(libibcm/src)
 
 # Providers
-add_subdirectory(libcxgb3/src)
-add_subdirectory(libcxgb4/src)
-add_subdirectory(libhfi1verbs/src)
-add_subdirectory(libi40iw/src)
-add_subdirectory(libipathverbs/src)
-add_subdirectory(libipathverbs/)
-add_subdirectory(libmlx4/src)
-add_subdirectory(libmlx5/src)
-add_subdirectory(libmthca/src)
-add_subdirectory(libnes/src)
-add_subdirectory(libocrdma/src)
-add_subdirectory(librxe/src)
-add_subdirectory(librxe/man)
-add_subdirectory(librxe/)
+add_subdirectory(providers/cxgb3)
+add_subdirectory(providers/cxgb4)
+add_subdirectory(providers/hfi1verbs)
+add_subdirectory(providers/i40iw)
+add_subdirectory(providers/ipathverbs)
+add_subdirectory(providers/mlx4)
+add_subdirectory(providers/mlx5)
+add_subdirectory(providers/mthca)
+add_subdirectory(providers/nes)
+add_subdirectory(providers/ocrdma)
+add_subdirectory(providers/rxe)
+add_subdirectory(providers/rxe/man)
 
 # Binaries
 add_subdirectory(ibacm)
diff --git a/MAINTAINERS b/MAINTAINERS
index c7587596f5ee..e4f3554ea46a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -43,24 +43,24 @@ F:	buildlib/
 CXGB3 USERSPACE PROVIDER (for iw_cxgb3.ko)
 M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 S:	Supported
-F:	libcxgb3/
+F:	providers/cxgb3/
 
 CXGB4 USERSPACE PROVIDER (for iw_cxgb4.ko)
 M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 S:	Supported
-F:	libcxgb4/
+F:	providers/cxgb4/
 
 HF1 USERSPACE PROVIDER (for hf1.ko)
 M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 M:	Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 S:	Supported
 L:	intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org (moderated for non-subscribers)
-F:	libhfi1verbs/
+F:	providers/hfi1verbs/
 
 I40IW USERSPACE PROVIDER (for i40iw.ko)
 M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 S:	Supported
-F:	libi40iw/
+F:	providers/i40iw/
 
 RDMA Communication Manager Assistant (for librdmacm.so)
 M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
@@ -72,7 +72,7 @@ M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 M:	Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 L:	infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 S:	Supported
-F:	libipathverbs/
+F:	providers/ipathverbs/
 
 IWARP PORT MAPPER DAEMON (for iwarp kernel providers)
 M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
@@ -112,35 +112,35 @@ MLX4 USERSPACE PROVIDER (for mlx4_ib.ko)
 M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 H:	Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
 S:	Supported
-F:	libmlx4/
+F:	providers/mlx4/
 
 MLX5 USERSPACE PROVIDER (for mlx5_ib.ko)
 M:	Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 H:	Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 S:	Supported
-F:	libmlx5/
+F:	providers/mlx5/
 
 MTHCA USERSPACE PROVIDER (for ib_mthca.ko)
 M:	Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 H:	Michael S. Tsirkin <mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
 H:	Roland Dreier <roland-nF87da4h5whBDgjK7y7TUQ@public.gmane.org>
 S:	Supported
-F:	libmthca/
+F:	providers/mthca/
 
 NES USERSPACE PROVIDER (for iw_nes.ko)
 M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 S:	Supported
-F:	libnes/
+F:	providers/nes/
 
 OCRDMA USERSPACE PROVIDER (for ocrdma.ko)
 M:	Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 S:	Supported
-F:	libocrdma/
+F:	providers/ocrdma/
 
 RXE SOFT ROCEE USERSPACE PROVIDER (for rdma_rxe.ko)
 M:	Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 S:	Supported
-F:	librxe/
+F:	providers/rxe/
 
 SRP DAEMON (for ib_srp.ko)
 M:	Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
diff --git a/libipathverbs/src/CMakeLists.txt b/libipathverbs/src/CMakeLists.txt
deleted file mode 100644
index 20924fda7900..000000000000
diff --git a/librxe/src/CMakeLists.txt b/librxe/src/CMakeLists.txt
deleted file mode 100644
index d8f3265176e4..000000000000
diff --git a/libcxgb3/src/CMakeLists.txt b/providers/cxgb3/CMakeLists.txt
similarity index 100%
rename from libcxgb3/src/CMakeLists.txt
rename to providers/cxgb3/CMakeLists.txt
diff --git a/libcxgb3/src/cq.c b/providers/cxgb3/cq.c
similarity index 100%
rename from libcxgb3/src/cq.c
rename to providers/cxgb3/cq.c
diff --git a/libcxgb3/src/cxio_wr.h b/providers/cxgb3/cxio_wr.h
similarity index 100%
rename from libcxgb3/src/cxio_wr.h
rename to providers/cxgb3/cxio_wr.h
diff --git a/libcxgb3/src/firmware_exports.h b/providers/cxgb3/firmware_exports.h
similarity index 100%
rename from libcxgb3/src/firmware_exports.h
rename to providers/cxgb3/firmware_exports.h
diff --git a/libcxgb3/src/iwch-abi.h b/providers/cxgb3/iwch-abi.h
similarity index 100%
rename from libcxgb3/src/iwch-abi.h
rename to providers/cxgb3/iwch-abi.h
diff --git a/libcxgb3/src/iwch.c b/providers/cxgb3/iwch.c
similarity index 100%
rename from libcxgb3/src/iwch.c
rename to providers/cxgb3/iwch.c
diff --git a/libcxgb3/src/iwch.h b/providers/cxgb3/iwch.h
similarity index 100%
rename from libcxgb3/src/iwch.h
rename to providers/cxgb3/iwch.h
diff --git a/libcxgb3/src/qp.c b/providers/cxgb3/qp.c
similarity index 100%
rename from libcxgb3/src/qp.c
rename to providers/cxgb3/qp.c
diff --git a/libcxgb3/src/verbs.c b/providers/cxgb3/verbs.c
similarity index 100%
rename from libcxgb3/src/verbs.c
rename to providers/cxgb3/verbs.c
diff --git a/libcxgb4/src/CMakeLists.txt b/providers/cxgb4/CMakeLists.txt
similarity index 100%
rename from libcxgb4/src/CMakeLists.txt
rename to providers/cxgb4/CMakeLists.txt
diff --git a/libcxgb4/src/cq.c b/providers/cxgb4/cq.c
similarity index 100%
rename from libcxgb4/src/cq.c
rename to providers/cxgb4/cq.c
diff --git a/libcxgb4/src/cxgb4-abi.h b/providers/cxgb4/cxgb4-abi.h
similarity index 100%
rename from libcxgb4/src/cxgb4-abi.h
rename to providers/cxgb4/cxgb4-abi.h
diff --git a/libcxgb4/src/dev.c b/providers/cxgb4/dev.c
similarity index 100%
rename from libcxgb4/src/dev.c
rename to providers/cxgb4/dev.c
diff --git a/libcxgb4/src/libcxgb4.h b/providers/cxgb4/libcxgb4.h
similarity index 100%
rename from libcxgb4/src/libcxgb4.h
rename to providers/cxgb4/libcxgb4.h
diff --git a/libcxgb4/src/qp.c b/providers/cxgb4/qp.c
similarity index 100%
rename from libcxgb4/src/qp.c
rename to providers/cxgb4/qp.c
diff --git a/libcxgb4/src/t4.h b/providers/cxgb4/t4.h
similarity index 100%
rename from libcxgb4/src/t4.h
rename to providers/cxgb4/t4.h
diff --git a/libcxgb4/src/t4_chip_type.h b/providers/cxgb4/t4_chip_type.h
similarity index 100%
rename from libcxgb4/src/t4_chip_type.h
rename to providers/cxgb4/t4_chip_type.h
diff --git a/libcxgb4/src/t4_pci_id_tbl.h b/providers/cxgb4/t4_pci_id_tbl.h
similarity index 100%
rename from libcxgb4/src/t4_pci_id_tbl.h
rename to providers/cxgb4/t4_pci_id_tbl.h
diff --git a/libcxgb4/src/t4_regs.h b/providers/cxgb4/t4_regs.h
similarity index 100%
rename from libcxgb4/src/t4_regs.h
rename to providers/cxgb4/t4_regs.h
diff --git a/libcxgb4/src/t4fw_api.h b/providers/cxgb4/t4fw_api.h
similarity index 100%
rename from libcxgb4/src/t4fw_api.h
rename to providers/cxgb4/t4fw_api.h
diff --git a/libcxgb4/src/t4fw_ri_api.h b/providers/cxgb4/t4fw_ri_api.h
similarity index 100%
rename from libcxgb4/src/t4fw_ri_api.h
rename to providers/cxgb4/t4fw_ri_api.h
diff --git a/libcxgb4/src/verbs.c b/providers/cxgb4/verbs.c
similarity index 100%
rename from libcxgb4/src/verbs.c
rename to providers/cxgb4/verbs.c
diff --git a/libhfi1verbs/src/CMakeLists.txt b/providers/hfi1verbs/CMakeLists.txt
similarity index 100%
rename from libhfi1verbs/src/CMakeLists.txt
rename to providers/hfi1verbs/CMakeLists.txt
diff --git a/libhfi1verbs/src/hfi-abi.h b/providers/hfi1verbs/hfi-abi.h
similarity index 100%
rename from libhfi1verbs/src/hfi-abi.h
rename to providers/hfi1verbs/hfi-abi.h
diff --git a/libhfi1verbs/src/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
similarity index 100%
rename from libhfi1verbs/src/hfiverbs.c
rename to providers/hfi1verbs/hfiverbs.c
diff --git a/libhfi1verbs/src/hfiverbs.h b/providers/hfi1verbs/hfiverbs.h
similarity index 100%
rename from libhfi1verbs/src/hfiverbs.h
rename to providers/hfi1verbs/hfiverbs.h
diff --git a/libhfi1verbs/src/verbs.c b/providers/hfi1verbs/verbs.c
similarity index 100%
rename from libhfi1verbs/src/verbs.c
rename to providers/hfi1verbs/verbs.c
diff --git a/libi40iw/src/CMakeLists.txt b/providers/i40iw/CMakeLists.txt
similarity index 100%
rename from libi40iw/src/CMakeLists.txt
rename to providers/i40iw/CMakeLists.txt
diff --git a/libi40iw/src/i40e_devids.h b/providers/i40iw/i40e_devids.h
similarity index 100%
rename from libi40iw/src/i40e_devids.h
rename to providers/i40iw/i40e_devids.h
diff --git a/libi40iw/src/i40iw-abi.h b/providers/i40iw/i40iw-abi.h
similarity index 100%
rename from libi40iw/src/i40iw-abi.h
rename to providers/i40iw/i40iw-abi.h
diff --git a/libi40iw/src/i40iw_d.h b/providers/i40iw/i40iw_d.h
similarity index 100%
rename from libi40iw/src/i40iw_d.h
rename to providers/i40iw/i40iw_d.h
diff --git a/libi40iw/src/i40iw_osdep.h b/providers/i40iw/i40iw_osdep.h
similarity index 100%
rename from libi40iw/src/i40iw_osdep.h
rename to providers/i40iw/i40iw_osdep.h
diff --git a/libi40iw/src/i40iw_register.h b/providers/i40iw/i40iw_register.h
similarity index 100%
rename from libi40iw/src/i40iw_register.h
rename to providers/i40iw/i40iw_register.h
diff --git a/libi40iw/src/i40iw_status.h b/providers/i40iw/i40iw_status.h
similarity index 100%
rename from libi40iw/src/i40iw_status.h
rename to providers/i40iw/i40iw_status.h
diff --git a/libi40iw/src/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
similarity index 100%
rename from libi40iw/src/i40iw_uk.c
rename to providers/i40iw/i40iw_uk.c
diff --git a/libi40iw/src/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
similarity index 100%
rename from libi40iw/src/i40iw_umain.c
rename to providers/i40iw/i40iw_umain.c
diff --git a/libi40iw/src/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
similarity index 100%
rename from libi40iw/src/i40iw_umain.h
rename to providers/i40iw/i40iw_umain.h
diff --git a/libi40iw/src/i40iw_user.h b/providers/i40iw/i40iw_user.h
similarity index 100%
rename from libi40iw/src/i40iw_user.h
rename to providers/i40iw/i40iw_user.h
diff --git a/libi40iw/src/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
similarity index 100%
rename from libi40iw/src/i40iw_uverbs.c
rename to providers/i40iw/i40iw_uverbs.c
diff --git a/libipathverbs/CMakeLists.txt b/providers/ipathverbs/CMakeLists.txt
similarity index 84%
rename from libipathverbs/CMakeLists.txt
rename to providers/ipathverbs/CMakeLists.txt
index bde405d0d776..9031b86d0461 100644
--- a/libipathverbs/CMakeLists.txt
+++ b/providers/ipathverbs/CMakeLists.txt
@@ -1,3 +1,8 @@
+rdma_provider(ipathverbs
+  ipathverbs.c
+  verbs.c
+  )
+
 rdma_subst_install(FILES "truescale.conf.in"
   DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/modprobe.d/"
   RENAME "truescale.conf")
diff --git a/libipathverbs/COPYING b/providers/ipathverbs/COPYING
similarity index 100%
rename from libipathverbs/COPYING
rename to providers/ipathverbs/COPYING
diff --git a/libipathverbs/dracut_check b/providers/ipathverbs/dracut_check
similarity index 100%
rename from libipathverbs/dracut_check
rename to providers/ipathverbs/dracut_check
diff --git a/libipathverbs/dracut_install b/providers/ipathverbs/dracut_install
similarity index 100%
rename from libipathverbs/dracut_install
rename to providers/ipathverbs/dracut_install
diff --git a/libipathverbs/dracut_kmod b/providers/ipathverbs/dracut_kmod
similarity index 100%
rename from libipathverbs/dracut_kmod
rename to providers/ipathverbs/dracut_kmod
diff --git a/libipathverbs/src/ipath-abi.h b/providers/ipathverbs/ipath-abi.h
similarity index 100%
rename from libipathverbs/src/ipath-abi.h
rename to providers/ipathverbs/ipath-abi.h
diff --git a/libipathverbs/src/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
similarity index 100%
rename from libipathverbs/src/ipathverbs.c
rename to providers/ipathverbs/ipathverbs.c
diff --git a/libipathverbs/src/ipathverbs.h b/providers/ipathverbs/ipathverbs.h
similarity index 100%
rename from libipathverbs/src/ipathverbs.h
rename to providers/ipathverbs/ipathverbs.h
diff --git a/libipathverbs/truescale-serdes.cmds b/providers/ipathverbs/truescale-serdes.cmds
similarity index 100%
rename from libipathverbs/truescale-serdes.cmds
rename to providers/ipathverbs/truescale-serdes.cmds
diff --git a/libipathverbs/truescale.conf.in b/providers/ipathverbs/truescale.conf.in
similarity index 100%
rename from libipathverbs/truescale.conf.in
rename to providers/ipathverbs/truescale.conf.in
diff --git a/libipathverbs/src/verbs.c b/providers/ipathverbs/verbs.c
similarity index 100%
rename from libipathverbs/src/verbs.c
rename to providers/ipathverbs/verbs.c
diff --git a/libmlx4/src/CMakeLists.txt b/providers/mlx4/CMakeLists.txt
similarity index 100%
rename from libmlx4/src/CMakeLists.txt
rename to providers/mlx4/CMakeLists.txt
diff --git a/libmlx4/COPYING b/providers/mlx4/COPYING
similarity index 100%
rename from libmlx4/COPYING
rename to providers/mlx4/COPYING
diff --git a/libmlx4/src/buf.c b/providers/mlx4/buf.c
similarity index 100%
rename from libmlx4/src/buf.c
rename to providers/mlx4/buf.c
diff --git a/libmlx4/src/cq.c b/providers/mlx4/cq.c
similarity index 100%
rename from libmlx4/src/cq.c
rename to providers/mlx4/cq.c
diff --git a/libmlx4/src/dbrec.c b/providers/mlx4/dbrec.c
similarity index 100%
rename from libmlx4/src/dbrec.c
rename to providers/mlx4/dbrec.c
diff --git a/libmlx4/src/doorbell.h b/providers/mlx4/doorbell.h
similarity index 100%
rename from libmlx4/src/doorbell.h
rename to providers/mlx4/doorbell.h
diff --git a/libmlx4/src/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
similarity index 100%
rename from libmlx4/src/mlx4-abi.h
rename to providers/mlx4/mlx4-abi.h
diff --git a/libmlx4/src/mlx4.c b/providers/mlx4/mlx4.c
similarity index 100%
rename from libmlx4/src/mlx4.c
rename to providers/mlx4/mlx4.c
diff --git a/libmlx4/src/mlx4.h b/providers/mlx4/mlx4.h
similarity index 100%
rename from libmlx4/src/mlx4.h
rename to providers/mlx4/mlx4.h
diff --git a/libmlx4/src/mmio.h b/providers/mlx4/mmio.h
similarity index 100%
rename from libmlx4/src/mmio.h
rename to providers/mlx4/mmio.h
diff --git a/libmlx4/src/qp.c b/providers/mlx4/qp.c
similarity index 100%
rename from libmlx4/src/qp.c
rename to providers/mlx4/qp.c
diff --git a/libmlx4/src/srq.c b/providers/mlx4/srq.c
similarity index 100%
rename from libmlx4/src/srq.c
rename to providers/mlx4/srq.c
diff --git a/libmlx4/src/verbs.c b/providers/mlx4/verbs.c
similarity index 100%
rename from libmlx4/src/verbs.c
rename to providers/mlx4/verbs.c
diff --git a/libmlx4/src/wqe.h b/providers/mlx4/wqe.h
similarity index 100%
rename from libmlx4/src/wqe.h
rename to providers/mlx4/wqe.h
diff --git a/libmlx5/src/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
similarity index 100%
rename from libmlx5/src/CMakeLists.txt
rename to providers/mlx5/CMakeLists.txt
diff --git a/libmlx5/src/bitmap.h b/providers/mlx5/bitmap.h
similarity index 100%
rename from libmlx5/src/bitmap.h
rename to providers/mlx5/bitmap.h
diff --git a/libmlx5/src/buf.c b/providers/mlx5/buf.c
similarity index 100%
rename from libmlx5/src/buf.c
rename to providers/mlx5/buf.c
diff --git a/libmlx5/src/cq.c b/providers/mlx5/cq.c
similarity index 100%
rename from libmlx5/src/cq.c
rename to providers/mlx5/cq.c
diff --git a/libmlx5/src/dbrec.c b/providers/mlx5/dbrec.c
similarity index 100%
rename from libmlx5/src/dbrec.c
rename to providers/mlx5/dbrec.c
diff --git a/libmlx5/src/doorbell.h b/providers/mlx5/doorbell.h
similarity index 100%
rename from libmlx5/src/doorbell.h
rename to providers/mlx5/doorbell.h
diff --git a/libmlx5/src/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
similarity index 100%
rename from libmlx5/src/mlx5-abi.h
rename to providers/mlx5/mlx5-abi.h
diff --git a/libmlx5/src/mlx5.c b/providers/mlx5/mlx5.c
similarity index 100%
rename from libmlx5/src/mlx5.c
rename to providers/mlx5/mlx5.c
diff --git a/libmlx5/src/mlx5.h b/providers/mlx5/mlx5.h
similarity index 100%
rename from libmlx5/src/mlx5.h
rename to providers/mlx5/mlx5.h
diff --git a/libmlx5/src/qp.c b/providers/mlx5/qp.c
similarity index 100%
rename from libmlx5/src/qp.c
rename to providers/mlx5/qp.c
diff --git a/libmlx5/src/srq.c b/providers/mlx5/srq.c
similarity index 100%
rename from libmlx5/src/srq.c
rename to providers/mlx5/srq.c
diff --git a/libmlx5/src/verbs.c b/providers/mlx5/verbs.c
similarity index 100%
rename from libmlx5/src/verbs.c
rename to providers/mlx5/verbs.c
diff --git a/libmlx5/src/wqe.h b/providers/mlx5/wqe.h
similarity index 100%
rename from libmlx5/src/wqe.h
rename to providers/mlx5/wqe.h
diff --git a/libmthca/src/CMakeLists.txt b/providers/mthca/CMakeLists.txt
similarity index 100%
rename from libmthca/src/CMakeLists.txt
rename to providers/mthca/CMakeLists.txt
diff --git a/libmthca/src/ah.c b/providers/mthca/ah.c
similarity index 100%
rename from libmthca/src/ah.c
rename to providers/mthca/ah.c
diff --git a/libmthca/src/buf.c b/providers/mthca/buf.c
similarity index 100%
rename from libmthca/src/buf.c
rename to providers/mthca/buf.c
diff --git a/libmthca/src/cq.c b/providers/mthca/cq.c
similarity index 100%
rename from libmthca/src/cq.c
rename to providers/mthca/cq.c
diff --git a/libmthca/src/doorbell.h b/providers/mthca/doorbell.h
similarity index 100%
rename from libmthca/src/doorbell.h
rename to providers/mthca/doorbell.h
diff --git a/libmthca/src/memfree.c b/providers/mthca/memfree.c
similarity index 100%
rename from libmthca/src/memfree.c
rename to providers/mthca/memfree.c
diff --git a/libmthca/src/mthca-abi.h b/providers/mthca/mthca-abi.h
similarity index 100%
rename from libmthca/src/mthca-abi.h
rename to providers/mthca/mthca-abi.h
diff --git a/libmthca/src/mthca.c b/providers/mthca/mthca.c
similarity index 100%
rename from libmthca/src/mthca.c
rename to providers/mthca/mthca.c
diff --git a/libmthca/src/mthca.h b/providers/mthca/mthca.h
similarity index 100%
rename from libmthca/src/mthca.h
rename to providers/mthca/mthca.h
diff --git a/libmthca/src/qp.c b/providers/mthca/qp.c
similarity index 100%
rename from libmthca/src/qp.c
rename to providers/mthca/qp.c
diff --git a/libmthca/src/srq.c b/providers/mthca/srq.c
similarity index 100%
rename from libmthca/src/srq.c
rename to providers/mthca/srq.c
diff --git a/libmthca/src/verbs.c b/providers/mthca/verbs.c
similarity index 100%
rename from libmthca/src/verbs.c
rename to providers/mthca/verbs.c
diff --git a/libmthca/src/wqe.h b/providers/mthca/wqe.h
similarity index 100%
rename from libmthca/src/wqe.h
rename to providers/mthca/wqe.h
diff --git a/libnes/src/CMakeLists.txt b/providers/nes/CMakeLists.txt
similarity index 100%
rename from libnes/src/CMakeLists.txt
rename to providers/nes/CMakeLists.txt
diff --git a/libnes/src/nes-abi.h b/providers/nes/nes-abi.h
similarity index 100%
rename from libnes/src/nes-abi.h
rename to providers/nes/nes-abi.h
diff --git a/libnes/src/nes_umain.c b/providers/nes/nes_umain.c
similarity index 100%
rename from libnes/src/nes_umain.c
rename to providers/nes/nes_umain.c
diff --git a/libnes/src/nes_umain.h b/providers/nes/nes_umain.h
similarity index 100%
rename from libnes/src/nes_umain.h
rename to providers/nes/nes_umain.h
diff --git a/libnes/src/nes_uverbs.c b/providers/nes/nes_uverbs.c
similarity index 100%
rename from libnes/src/nes_uverbs.c
rename to providers/nes/nes_uverbs.c
diff --git a/libocrdma/src/CMakeLists.txt b/providers/ocrdma/CMakeLists.txt
similarity index 100%
rename from libocrdma/src/CMakeLists.txt
rename to providers/ocrdma/CMakeLists.txt
diff --git a/libocrdma/Changelog b/providers/ocrdma/Changelog
similarity index 100%
rename from libocrdma/Changelog
rename to providers/ocrdma/Changelog
diff --git a/libocrdma/src/ocrdma_abi.h b/providers/ocrdma/ocrdma_abi.h
similarity index 100%
rename from libocrdma/src/ocrdma_abi.h
rename to providers/ocrdma/ocrdma_abi.h
diff --git a/libocrdma/src/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
similarity index 100%
rename from libocrdma/src/ocrdma_main.c
rename to providers/ocrdma/ocrdma_main.c
diff --git a/libocrdma/src/ocrdma_main.h b/providers/ocrdma/ocrdma_main.h
similarity index 100%
rename from libocrdma/src/ocrdma_main.h
rename to providers/ocrdma/ocrdma_main.h
diff --git a/libocrdma/src/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
similarity index 100%
rename from libocrdma/src/ocrdma_verbs.c
rename to providers/ocrdma/ocrdma_verbs.c
diff --git a/librxe/CMakeLists.txt b/providers/rxe/CMakeLists.txt
similarity index 84%
rename from librxe/CMakeLists.txt
rename to providers/rxe/CMakeLists.txt
index 3652ab3d56a5..79946c4d4953 100644
--- a/librxe/CMakeLists.txt
+++ b/providers/rxe/CMakeLists.txt
@@ -1,3 +1,6 @@
+rdma_provider(rxe
+  rxe.c
+  )
 install(FILES rxe_cfg
   DESTINATION "${CMAKE_INSTALL_BINDIR}"
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE
diff --git a/librxe/man/CMakeLists.txt b/providers/rxe/man/CMakeLists.txt
similarity index 100%
rename from librxe/man/CMakeLists.txt
rename to providers/rxe/man/CMakeLists.txt
diff --git a/librxe/man/rxe.7 b/providers/rxe/man/rxe.7
similarity index 100%
rename from librxe/man/rxe.7
rename to providers/rxe/man/rxe.7
diff --git a/librxe/man/rxe_cfg.8 b/providers/rxe/man/rxe_cfg.8
similarity index 100%
rename from librxe/man/rxe_cfg.8
rename to providers/rxe/man/rxe_cfg.8
diff --git a/librxe/src/rxe-abi.h b/providers/rxe/rxe-abi.h
similarity index 100%
rename from librxe/src/rxe-abi.h
rename to providers/rxe/rxe-abi.h
diff --git a/librxe/src/rxe.c b/providers/rxe/rxe.c
similarity index 100%
rename from librxe/src/rxe.c
rename to providers/rxe/rxe.c
diff --git a/librxe/src/rxe.h b/providers/rxe/rxe.h
similarity index 100%
rename from librxe/src/rxe.h
rename to providers/rxe/rxe.h
diff --git a/librxe/rxe_cfg b/providers/rxe/rxe_cfg
similarity index 100%
rename from librxe/rxe_cfg
rename to providers/rxe/rxe_cfg
diff --git a/librxe/src/rxe_queue.h b/providers/rxe/rxe_queue.h
similarity index 100%
rename from librxe/src/rxe_queue.h
rename to providers/rxe/rxe_queue.h
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
