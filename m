From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 10/15] Remove the auto* based build systems
Date: Mon, 22 Aug 2016 12:13:33 -0600
Message-ID: <1471889618-1605-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The unified cmake version provides the same functionality now.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/Makefile.am                |    27 -
 libcxgb3/autogen.sh                 |     8 -
 libcxgb3/config/.gitignore          |     0
 libcxgb3/configure.in               |    69 -
 libcxgb3/cxgb3.driver               |     1 -
 libcxgb3/src/iwch.map               |     6 -
 libcxgb4/Makefile.am                |    27 -
 libcxgb4/autogen.sh                 |     8 -
 libcxgb4/config/config.guess        |  1439 ----
 libcxgb4/config/config.sub          |  1811 -----
 libcxgb4/config/depcomp             |   530 --
 libcxgb4/config/install-sh          |   323 -
 libcxgb4/configure.in               |    69 -
 libcxgb4/cxgb4.driver               |     1 -
 libcxgb4/src/cxgb4.map              |     6 -
 libhfi1verbs/Makefile.am            |    83 -
 libhfi1verbs/autogen.sh             |    64 -
 libhfi1verbs/configure.in           |   126 -
 libhfi1verbs/hfi1verbs.driver       |     1 -
 libhfi1verbs/makefile               |    93 -
 libhfi1verbs/makesrpm.sh            |    15 -
 libhfi1verbs/src/hfiverbs.map       |     4 -
 libi40iw/Makefile.am                |    26 -
 libi40iw/configure.ac               |    74 -
 libi40iw/i40iw.driver               |     1 -
 libi40iw/src/i40iw.map              |    39 -
 libibcm/Makefile.am                 |    35 -
 libibcm/autogen.sh                  |     9 -
 libibcm/configure.in                |    72 -
 libibumad/Makefile.am               |    75 -
 libibumad/autogen.sh                |    11 -
 libibumad/configure.in              |    72 -
 libibverbs/Makefile.am              |   126 -
 libibverbs/autogen.sh               |     4 -
 libibverbs/config/.gitignore        |     8 -
 libibverbs/configure.ac             |   124 -
 libipathverbs/Makefile.am           |    79 -
 libipathverbs/autogen.sh            |    43 -
 libipathverbs/configure.in          |   120 -
 libipathverbs/ipathverbs.driver     |     1 -
 libipathverbs/src/ipathverbs.map    |     4 -
 libmlx4/Makefile.am                 |    19 -
 libmlx4/autogen.sh                  |     4 -
 libmlx4/config/.gitignore           |     8 -
 libmlx4/configure.ac                |    96 -
 libmlx4/mlx4.driver                 |     1 -
 libmlx4/src/mlx4.map                |     5 -
 libmlx5/Makefile.am                 |    27 -
 libmlx5/autogen.sh                  |     7 -
 libmlx5/config/.gitignore           |     8 -
 libmlx5/configure.ac                |   108 -
 libmlx5/m4/ax_gcc_func_attribute.m4 |   223 -
 libmlx5/mlx5.driver                 |     1 -
 libmlx5/src/mlx5.map                |     5 -
 libmthca/Makefile.am                |    29 -
 libmthca/autogen.sh                 |     8 -
 libmthca/config/.gitignore          |     8 -
 libmthca/configure.in               |    82 -
 libmthca/mthca.driver               |     1 -
 libmthca/src/mthca.map              |     5 -
 libnes/Makefile.am                  |    26 -
 libnes/autogen.sh                   |    12 -
 libnes/config/.gitignore            |     0
 libnes/configure.in                 |    74 -
 libnes/nes.driver                   |     1 -
 libnes/src/nes.map                  |     5 -
 libocrdma/Makefile.am               |    23 -
 libocrdma/autogen.sh                |     8 -
 libocrdma/config/.gitignore         |     8 -
 libocrdma/configure.in              |    70 -
 libocrdma/ocrdma.driver             |     1 -
 libocrdma/src/ocrdma.map            |     5 -
 librdmacm/Makefile.am               |   141 -
 librdmacm/autogen.sh                |     5 -
 librdmacm/configure.ac              |   108 -
 librxe/AUTHORS                      |     0
 librxe/COPYING                      |     0
 librxe/INSTALL                      |     0
 librxe/Makefile.am                  |    36 -
 librxe/Makefile.in                  |   939 ---
 librxe/NEWS                         |     0
 librxe/README                       |     0
 librxe/aclocal.m4                   |  9390 ----------------------
 librxe/config.h.in                  |    89 -
 librxe/config/config.guess          |  1526 ----
 librxe/config/config.sub            |  1658 ----
 librxe/config/depcomp               |   530 --
 librxe/config/install-sh            |   519 --
 librxe/config/ltmain.sh             |  9636 ----------------------
 librxe/config/missing               |   360 -
 librxe/configure                    | 14728 ----------------------------------
 librxe/configure.in                 |    77 -
 librxe/librxe.spec                  |    55 -
 librxe/rxe.driver                   |     1 -
 librxe/src/rxe.map                  |     5 -
 95 files changed, 46315 deletions(-)
 delete mode 100644 libcxgb3/Makefile.am
 delete mode 100755 libcxgb3/autogen.sh
 delete mode 100644 libcxgb3/config/.gitignore
 delete mode 100644 libcxgb3/configure.in
 delete mode 100644 libcxgb3/cxgb3.driver
 delete mode 100644 libcxgb3/src/iwch.map
 delete mode 100644 libcxgb4/Makefile.am
 delete mode 100755 libcxgb4/autogen.sh
 delete mode 100755 libcxgb4/config/config.guess
 delete mode 100755 libcxgb4/config/config.sub
 delete mode 100755 libcxgb4/config/depcomp
 delete mode 100755 libcxgb4/config/install-sh
 delete mode 100644 libcxgb4/configure.in
 delete mode 100644 libcxgb4/cxgb4.driver
 delete mode 100644 libcxgb4/src/cxgb4.map
 delete mode 100644 libhfi1verbs/Makefile.am
 delete mode 100755 libhfi1verbs/autogen.sh
 delete mode 100644 libhfi1verbs/configure.in
 delete mode 100644 libhfi1verbs/hfi1verbs.driver
 delete mode 100644 libhfi1verbs/makefile
 delete mode 100644 libhfi1verbs/makesrpm.sh
 delete mode 100644 libhfi1verbs/src/hfiverbs.map
 delete mode 100644 libi40iw/Makefile.am
 delete mode 100644 libi40iw/configure.ac
 delete mode 100644 libi40iw/i40iw.driver
 delete mode 100644 libi40iw/src/i40iw.map
 delete mode 100644 libibcm/Makefile.am
 delete mode 100755 libibcm/autogen.sh
 delete mode 100644 libibcm/configure.in
 delete mode 100644 libibumad/Makefile.am
 delete mode 100755 libibumad/autogen.sh
 delete mode 100644 libibumad/configure.in
 delete mode 100644 libibverbs/Makefile.am
 delete mode 100755 libibverbs/autogen.sh
 delete mode 100644 libibverbs/config/.gitignore
 delete mode 100644 libibverbs/configure.ac
 delete mode 100644 libipathverbs/Makefile.am
 delete mode 100755 libipathverbs/autogen.sh
 delete mode 100644 libipathverbs/configure.in
 delete mode 100644 libipathverbs/ipathverbs.driver
 delete mode 100644 libipathverbs/src/ipathverbs.map
 delete mode 100644 libmlx4/Makefile.am
 delete mode 100755 libmlx4/autogen.sh
 delete mode 100644 libmlx4/config/.gitignore
 delete mode 100644 libmlx4/configure.ac
 delete mode 100644 libmlx4/mlx4.driver
 delete mode 100644 libmlx4/src/mlx4.map
 delete mode 100644 libmlx5/Makefile.am
 delete mode 100755 libmlx5/autogen.sh
 delete mode 100644 libmlx5/config/.gitignore
 delete mode 100644 libmlx5/configure.ac
 delete mode 100644 libmlx5/m4/ax_gcc_func_attribute.m4
 delete mode 100644 libmlx5/mlx5.driver
 delete mode 100644 libmlx5/src/mlx5.map
 delete mode 100644 libmthca/Makefile.am
 delete mode 100755 libmthca/autogen.sh
 delete mode 100644 libmthca/config/.gitignore
 delete mode 100644 libmthca/configure.in
 delete mode 100644 libmthca/mthca.driver
 delete mode 100644 libmthca/src/mthca.map
 delete mode 100644 libnes/Makefile.am
 delete mode 100755 libnes/autogen.sh
 delete mode 100644 libnes/config/.gitignore
 delete mode 100644 libnes/configure.in
 delete mode 100644 libnes/nes.driver
 delete mode 100644 libnes/src/nes.map
 delete mode 100644 libocrdma/Makefile.am
 delete mode 100644 libocrdma/autogen.sh
 delete mode 100644 libocrdma/config/.gitignore
 delete mode 100644 libocrdma/configure.in
 delete mode 100644 libocrdma/ocrdma.driver
 delete mode 100644 libocrdma/src/ocrdma.map
 delete mode 100644 librdmacm/Makefile.am
 delete mode 100755 librdmacm/autogen.sh
 delete mode 100644 librdmacm/configure.ac
 delete mode 100644 librxe/AUTHORS
 delete mode 100644 librxe/COPYING
 delete mode 100644 librxe/INSTALL
 delete mode 100644 librxe/Makefile.am
 delete mode 100644 librxe/Makefile.in
 delete mode 100644 librxe/NEWS
 delete mode 100644 librxe/README
 delete mode 100644 librxe/aclocal.m4
 delete mode 100644 librxe/config.h.in
 delete mode 100755 librxe/config/config.guess
 delete mode 100755 librxe/config/config.sub
 delete mode 100755 librxe/config/depcomp
 delete mode 100755 librxe/config/install-sh
 delete mode 100755 librxe/config/ltmain.sh
 delete mode 100755 librxe/config/missing
 delete mode 100755 librxe/configure
 delete mode 100644 librxe/configure.in
 delete mode 100644 librxe/librxe.spec
 delete mode 100644 librxe/rxe.driver
 delete mode 100644 librxe/src/rxe.map

diff --git a/libcxgb3/Makefile.am b/libcxgb3/Makefile.am
deleted file mode 100644
index 99f1cae08531..000000000000
diff --git a/libcxgb3/autogen.sh b/libcxgb3/autogen.sh
deleted file mode 100755
index fd47839cae8c..000000000000
diff --git a/libcxgb3/config/.gitignore b/libcxgb3/config/.gitignore
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/libcxgb3/configure.in b/libcxgb3/configure.in
deleted file mode 100644
index db9177230cae..000000000000
diff --git a/libcxgb3/cxgb3.driver b/libcxgb3/cxgb3.driver
deleted file mode 100644
index cfa6186bf714..000000000000
diff --git a/libcxgb3/src/iwch.map b/libcxgb3/src/iwch.map
deleted file mode 100644
index 59a8baead48f..000000000000
diff --git a/libcxgb4/Makefile.am b/libcxgb4/Makefile.am
deleted file mode 100644
index f75d9641ce12..000000000000
diff --git a/libcxgb4/autogen.sh b/libcxgb4/autogen.sh
deleted file mode 100755
index fd47839cae8c..000000000000
diff --git a/libcxgb4/config/config.guess b/libcxgb4/config/config.guess
deleted file mode 100755
index 61754411ea95..000000000000
diff --git a/libcxgb4/config/config.sub b/libcxgb4/config/config.sub
deleted file mode 100755
index 16cd209d75ed..000000000000
diff --git a/libcxgb4/config/depcomp b/libcxgb4/config/depcomp
deleted file mode 100755
index 04701da536f3..000000000000
diff --git a/libcxgb4/config/install-sh b/libcxgb4/config/install-sh
deleted file mode 100755
index 4d4a9519eaf8..000000000000
diff --git a/libcxgb4/configure.in b/libcxgb4/configure.in
deleted file mode 100644
index 336ab1c57daf..000000000000
diff --git a/libcxgb4/cxgb4.driver b/libcxgb4/cxgb4.driver
deleted file mode 100644
index e041cb24c610..000000000000
diff --git a/libcxgb4/src/cxgb4.map b/libcxgb4/src/cxgb4.map
deleted file mode 100644
index 59a8baead48f..000000000000
diff --git a/libhfi1verbs/Makefile.am b/libhfi1verbs/Makefile.am
deleted file mode 100644
index d86ea3dd57e6..000000000000
diff --git a/libhfi1verbs/autogen.sh b/libhfi1verbs/autogen.sh
deleted file mode 100755
index 738b034eb59a..000000000000
diff --git a/libhfi1verbs/configure.in b/libhfi1verbs/configure.in
deleted file mode 100644
index 3f6e6779ce74..000000000000
diff --git a/libhfi1verbs/hfi1verbs.driver b/libhfi1verbs/hfi1verbs.driver
deleted file mode 100644
index 3ceb7ee85afb..000000000000
diff --git a/libhfi1verbs/makefile b/libhfi1verbs/makefile
deleted file mode 100644
index e7661ddc7bad..000000000000
diff --git a/libhfi1verbs/makesrpm.sh b/libhfi1verbs/makesrpm.sh
deleted file mode 100644
index 3fafb418f472..000000000000
diff --git a/libhfi1verbs/src/hfiverbs.map b/libhfi1verbs/src/hfiverbs.map
deleted file mode 100644
index d3517dd0f59b..000000000000
diff --git a/libi40iw/Makefile.am b/libi40iw/Makefile.am
deleted file mode 100644
index 98d6f8ae1226..000000000000
diff --git a/libi40iw/configure.ac b/libi40iw/configure.ac
deleted file mode 100644
index e3849b03561b..000000000000
diff --git a/libi40iw/i40iw.driver b/libi40iw/i40iw.driver
deleted file mode 100644
index 7dab2f03b9e9..000000000000
diff --git a/libi40iw/src/i40iw.map b/libi40iw/src/i40iw.map
deleted file mode 100644
index 112420a1d1c1..000000000000
diff --git a/libibcm/Makefile.am b/libibcm/Makefile.am
deleted file mode 100644
index ff0b1ded12a3..000000000000
diff --git a/libibcm/autogen.sh b/libibcm/autogen.sh
deleted file mode 100755
index f433312161d2..000000000000
diff --git a/libibcm/configure.in b/libibcm/configure.in
deleted file mode 100644
index 145e3a4cebf2..000000000000
diff --git a/libibumad/Makefile.am b/libibumad/Makefile.am
deleted file mode 100644
index 1dddf7bb2ffd..000000000000
diff --git a/libibumad/autogen.sh b/libibumad/autogen.sh
deleted file mode 100755
index 4827884ba1f1..000000000000
diff --git a/libibumad/configure.in b/libibumad/configure.in
deleted file mode 100644
index 0b2794baad40..000000000000
diff --git a/libibverbs/Makefile.am b/libibverbs/Makefile.am
deleted file mode 100644
index 5349314c53a9..000000000000
diff --git a/libibverbs/autogen.sh b/libibverbs/autogen.sh
deleted file mode 100755
index 6c9233e01a60..000000000000
diff --git a/libibverbs/config/.gitignore b/libibverbs/config/.gitignore
deleted file mode 100644
index 4d4c7b1710b0..000000000000
diff --git a/libibverbs/configure.ac b/libibverbs/configure.ac
deleted file mode 100644
index a8046f3c5a72..000000000000
diff --git a/libipathverbs/Makefile.am b/libipathverbs/Makefile.am
deleted file mode 100644
index 4d3e9258d989..000000000000
diff --git a/libipathverbs/autogen.sh b/libipathverbs/autogen.sh
deleted file mode 100755
index 493c586fdef7..000000000000
diff --git a/libipathverbs/configure.in b/libipathverbs/configure.in
deleted file mode 100644
index f2cf2e3f90ee..000000000000
diff --git a/libipathverbs/ipathverbs.driver b/libipathverbs/ipathverbs.driver
deleted file mode 100644
index d2125786170b..000000000000
diff --git a/libipathverbs/src/ipathverbs.map b/libipathverbs/src/ipathverbs.map
deleted file mode 100644
index d3517dd0f59b..000000000000
diff --git a/libmlx4/Makefile.am b/libmlx4/Makefile.am
deleted file mode 100644
index 9bb90e964fe9..000000000000
diff --git a/libmlx4/autogen.sh b/libmlx4/autogen.sh
deleted file mode 100755
index 6c9233e01a60..000000000000
diff --git a/libmlx4/config/.gitignore b/libmlx4/config/.gitignore
deleted file mode 100644
index 4d4c7b1710b0..000000000000
diff --git a/libmlx4/configure.ac b/libmlx4/configure.ac
deleted file mode 100644
index 01bf7cbcf163..000000000000
diff --git a/libmlx4/mlx4.driver b/libmlx4/mlx4.driver
deleted file mode 100644
index 4d29fa818afe..000000000000
diff --git a/libmlx4/src/mlx4.map b/libmlx4/src/mlx4.map
deleted file mode 100644
index ae8ed861f956..000000000000
diff --git a/libmlx5/Makefile.am b/libmlx5/Makefile.am
deleted file mode 100644
index 345d5afbcfee..000000000000
diff --git a/libmlx5/autogen.sh b/libmlx5/autogen.sh
deleted file mode 100755
index b0ad85eb4cb9..000000000000
diff --git a/libmlx5/config/.gitignore b/libmlx5/config/.gitignore
deleted file mode 100644
index 4d4c7b1710b0..000000000000
diff --git a/libmlx5/configure.ac b/libmlx5/configure.ac
deleted file mode 100644
index cd235474245e..000000000000
diff --git a/libmlx5/m4/ax_gcc_func_attribute.m4 b/libmlx5/m4/ax_gcc_func_attribute.m4
deleted file mode 100644
index c788ca9bd435..000000000000
diff --git a/libmlx5/mlx5.driver b/libmlx5/mlx5.driver
deleted file mode 100644
index 5190aa59ab50..000000000000
diff --git a/libmlx5/src/mlx5.map b/libmlx5/src/mlx5.map
deleted file mode 100644
index ae8ed861f956..000000000000
diff --git a/libmthca/Makefile.am b/libmthca/Makefile.am
deleted file mode 100644
index 1dd9a7ba8601..000000000000
diff --git a/libmthca/autogen.sh b/libmthca/autogen.sh
deleted file mode 100755
index fd47839cae8c..000000000000
diff --git a/libmthca/config/.gitignore b/libmthca/config/.gitignore
deleted file mode 100644
index 4d4c7b1710b0..000000000000
diff --git a/libmthca/configure.in b/libmthca/configure.in
deleted file mode 100644
index fb665ed2dd40..000000000000
diff --git a/libmthca/mthca.driver b/libmthca/mthca.driver
deleted file mode 100644
index 5880a477f9c4..000000000000
diff --git a/libmthca/src/mthca.map b/libmthca/src/mthca.map
deleted file mode 100644
index ae8ed861f956..000000000000
diff --git a/libnes/Makefile.am b/libnes/Makefile.am
deleted file mode 100644
index ade8e8b1eee8..000000000000
diff --git a/libnes/autogen.sh b/libnes/autogen.sh
deleted file mode 100755
index 1e486f86b880..000000000000
diff --git a/libnes/config/.gitignore b/libnes/config/.gitignore
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/libnes/configure.in b/libnes/configure.in
deleted file mode 100644
index a25d129cc159..000000000000
diff --git a/libnes/nes.driver b/libnes/nes.driver
deleted file mode 100644
index 1d8d85d51758..000000000000
diff --git a/libnes/src/nes.map b/libnes/src/nes.map
deleted file mode 100644
index ae8ed861f956..000000000000
diff --git a/libocrdma/Makefile.am b/libocrdma/Makefile.am
deleted file mode 100644
index 9b786e2b51a4..000000000000
diff --git a/libocrdma/autogen.sh b/libocrdma/autogen.sh
deleted file mode 100644
index fd47839cae8c..000000000000
diff --git a/libocrdma/config/.gitignore b/libocrdma/config/.gitignore
deleted file mode 100644
index 4d4c7b1710b0..000000000000
diff --git a/libocrdma/configure.in b/libocrdma/configure.in
deleted file mode 100644
index 2fd54b5ecd72..000000000000
diff --git a/libocrdma/ocrdma.driver b/libocrdma/ocrdma.driver
deleted file mode 100644
index dead9f84707e..000000000000
diff --git a/libocrdma/src/ocrdma.map b/libocrdma/src/ocrdma.map
deleted file mode 100644
index ae8ed861f956..000000000000
diff --git a/librdmacm/Makefile.am b/librdmacm/Makefile.am
deleted file mode 100644
index edfb36bb4149..000000000000
diff --git a/librdmacm/autogen.sh b/librdmacm/autogen.sh
deleted file mode 100755
index 24c0a769be34..000000000000
diff --git a/librdmacm/configure.ac b/librdmacm/configure.ac
deleted file mode 100644
index 768e2573f754..000000000000
diff --git a/librxe/AUTHORS b/librxe/AUTHORS
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/librxe/COPYING b/librxe/COPYING
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/librxe/INSTALL b/librxe/INSTALL
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/librxe/Makefile.am b/librxe/Makefile.am
deleted file mode 100644
index 972ae3b390b7..000000000000
diff --git a/librxe/Makefile.in b/librxe/Makefile.in
deleted file mode 100644
index aa536082e9ef..000000000000
diff --git a/librxe/NEWS b/librxe/NEWS
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/librxe/README b/librxe/README
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/librxe/aclocal.m4 b/librxe/aclocal.m4
deleted file mode 100644
index 4ccc6e2225b5..000000000000
diff --git a/librxe/config.h.in b/librxe/config.h.in
deleted file mode 100644
index eda71c5b3524..000000000000
diff --git a/librxe/config/config.guess b/librxe/config/config.guess
deleted file mode 100755
index f32079abda66..000000000000
diff --git a/librxe/config/config.sub b/librxe/config/config.sub
deleted file mode 100755
index 6759825a5b7f..000000000000
diff --git a/librxe/config/depcomp b/librxe/config/depcomp
deleted file mode 100755
index 04701da536f3..000000000000
diff --git a/librxe/config/install-sh b/librxe/config/install-sh
deleted file mode 100755
index a5897de6ea7f..000000000000
diff --git a/librxe/config/ltmain.sh b/librxe/config/ltmain.sh
deleted file mode 100755
index 3061e3c5a2f7..000000000000
diff --git a/librxe/config/missing b/librxe/config/missing
deleted file mode 100755
index 894e786e16c1..000000000000
diff --git a/librxe/configure b/librxe/configure
deleted file mode 100755
index a2af18f879ef..000000000000
diff --git a/librxe/configure.in b/librxe/configure.in
deleted file mode 100644
index 8927cef50468..000000000000
diff --git a/librxe/librxe.spec b/librxe/librxe.spec
deleted file mode 100644
index 7f65163c1079..000000000000
diff --git a/librxe/rxe.driver b/librxe/rxe.driver
deleted file mode 100644
index ed63053225fd..000000000000
diff --git a/librxe/src/rxe.map b/librxe/src/rxe.map
deleted file mode 100644
index 710d82708fd1..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
