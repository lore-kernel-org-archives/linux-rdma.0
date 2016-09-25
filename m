From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Add directory to place common code and move trivial functions into it
Date: Sun, 25 Sep 2016 09:50:02 +0300
Message-ID: <1474786207-2149-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is patch series which adds directory to place common code.

Highlights of this this series:
1. The min/max functions were moved into it.
2. OCRDMA list implementation was chosen as common code.
3. Libmlx5 was converted to use that list.h.
4. Remove container_of and offset local declarations.

View the commits on github:

https://github.com/linux-rdma/rdma-core/pull/4

Leon Romanovsky (5):
  cmake: Update build instructions in CmakeList
  utils: Create utils directory to put all common code and move min/max
    into it
  utils: Remove container_of and offset local declarations
  libocrdma: Move ocrdma's list implementation into common directory
  libmlx5: Convert libmlx5 to use common list implementation

 CMakeLists.txt                    |   7 +
 ibacm/linux/osd.h                 |   8 +-
 libibverbs/examples/rc_pingpong.c |   8 +-
 libmlx5/src/buf.c                 |  13 +-
 libmlx5/src/list.h                | 331 --------------------------------------
 libmlx5/src/mlx5.h                |  20 +--
 libocrdma/src/ocrdma_list.h       | 104 ------------
 libocrdma/src/ocrdma_main.c       |   8 +-
 libocrdma/src/ocrdma_main.h       |  12 +-
 libocrdma/src/ocrdma_verbs.c      |  16 +-
 librdmacm/src/cma.h               |  11 +-
 utils/list.h                      | 111 +++++++++++++
 utils/math.h                      |  44 +++++
 13 files changed, 196 insertions(+), 497 deletions(-)
 delete mode 100644 libmlx5/src/list.h
 delete mode 100644 libocrdma/src/ocrdma_list.h
 create mode 100644 utils/list.h
 create mode 100644 utils/math.h

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
