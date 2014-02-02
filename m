From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/3] Add support for UD QPs under RoCE IP addressing
Date: Sun,  2 Feb 2014 17:54:39 +0200
Message-ID: <1391356482-4228-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series adds support for Ethernet L2 address resolution for UD QPs, whose 
L2 address-handles, unlike RC/UC/XRC/etc QPs are set from user space without
going through uverbs and the kernel IB core.

Matan and Or.

Matan Barak (3):
  Add ibv_port_cap_flags
  Use neighbour lookup for RoCE UD QPs Eth L2 resolution
  Add ibv_query_port_ex support

 Makefile.am                |    3 +
 configure.ac               |   11 +
 include/infiniband/verbs.h |  155 ++++++++-
 src/device.c               |    2 +
 src/neigh.c                |  866 ++++++++++++++++++++++++++++++++++++++++++++
 src/neigh.h                |   42 +++
 src/verbs.c                |  161 ++++++++-
 7 files changed, 1236 insertions(+), 4 deletions(-)
 create mode 100644 src/neigh.c
 create mode 100644 src/neigh.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
