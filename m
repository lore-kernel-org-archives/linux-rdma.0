From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Licensing and cleanup issues
Date: Wed, 28 Sep 2016 18:33:04 +0300
Message-ID: <1475076789-14359-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series comes to solve some potential licensing issue around list.h
and ocrdma_list.h by using the CCAN functionality which has BSD license.

The CCAN required functionality was taken as is with minor touches as of
flattening the directory structure, its original header
with the licensing note was preserved.

In addition, the series drops some local definitions and use shared code instead.
Pull request was sent as well[1]

Jason,
Look at ccan/config.h I just hard coded few required HAVE_XXX which
expects to be available in Linux/distros environment.
In case you think that it should be changed to be set dynamically with cmake please
make the relevant changes as you are more familiar by that time with cmake.

[1] https://github.com/linux-rdma/rdma-core/pull/5

Yishai

Yishai Hadas (5):
  Remove container_of and offset local declarations
  ccan: Add CCAN min and max functionality
  ccan: Add list functionality
  libmlx5: Move to use CCAN list functionality
  libocrdma: Move to use CCAN list functionality

 CMakeLists.txt                    |   1 +
 buildlib/publish_headers.cmake    |  18 +-
 ccan/CMakeLists.txt               |  10 +
 ccan/build_assert.h               |  40 ++
 ccan/check_type.h                 |  64 +++
 ccan/config.h                     |   2 +
 ccan/container_of.h               | 146 +++++++
 ccan/list.h                       | 842 ++++++++++++++++++++++++++++++++++++++
 ccan/minmax.h                     |  65 +++
 ccan/str.h                        | 228 +++++++++++
 ccan/str_debug.h                  |  30 ++
 ibacm/linux/osd.h                 |   8 +-
 libibcm/src/cm.c                  |   5 -
 libibverbs/examples/rc_pingpong.c |   8 +-
 libmlx5/src/buf.c                 |  11 +-
 libmlx5/src/list.h                | 331 ---------------
 libmlx5/src/mlx5.c                |   2 +-
 libmlx5/src/mlx5.h                |  19 +-
 libocrdma/src/ocrdma_list.h       | 104 -----
 libocrdma/src/ocrdma_main.c       |  24 +-
 libocrdma/src/ocrdma_main.h       |  12 +-
 libocrdma/src/ocrdma_verbs.c      |  33 +-
 librdmacm/src/cma.h               |  11 +-
 23 files changed, 1489 insertions(+), 525 deletions(-)
 create mode 100644 ccan/CMakeLists.txt
 create mode 100644 ccan/build_assert.h
 create mode 100644 ccan/check_type.h
 create mode 100644 ccan/config.h
 create mode 100644 ccan/container_of.h
 create mode 100644 ccan/list.h
 create mode 100644 ccan/minmax.h
 create mode 100644 ccan/str.h
 create mode 100644 ccan/str_debug.h
 delete mode 100644 libmlx5/src/list.h
 delete mode 100644 libocrdma/src/ocrdma_list.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
