From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 0/4] libcxgb4: header file/copyright clean up
Date: Fri, 30 Sep 2016 09:35:17 -0700
Message-ID: <cover.1475253317.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches clean up the header files in libcxgb4 by synching them
with the equivalent upstream versions. The net result of this is proper
dual license copyrights. I also got rid of the libcxgb4/src/queue.h and
replaced it with the ccan list header.

Steve Wise (4):
  libcxgb4: align header files with upstream kernel
  libcxgb4: align t4_regs.h with upstream kernel version.
  libcxgb4: replace t4fw_interface.h with upstream kernel headers
  libcxgb4: use ccan lists

 libcxgb4/src/dev.c            |     9 +-
 libcxgb4/src/libcxgb4.h       |     4 +-
 libcxgb4/src/qp.c             |     4 +-
 libcxgb4/src/queue.h          |   650 -
 libcxgb4/src/t4.h             |    31 +-
 libcxgb4/src/t4_chip_type.h   |    98 +-
 libcxgb4/src/t4_pci_id_tbl.h  |   127 +-
 libcxgb4/src/t4_regs.h        | 64797 ++--------------------------------------
 libcxgb4/src/t4fw_api.h       |  3258 ++
 libcxgb4/src/t4fw_interface.h |  8770 ------
 libcxgb4/src/t4fw_ri_api.h    |   756 +
 11 files changed, 6711 insertions(+), 71793 deletions(-)
 delete mode 100644 libcxgb4/src/queue.h
 create mode 100644 libcxgb4/src/t4fw_api.h
 delete mode 100644 libcxgb4/src/t4fw_interface.h
 create mode 100644 libcxgb4/src/t4fw_ri_api.h

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
