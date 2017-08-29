From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Allow systemd to also setup the RDMA_LS socket for ibacm
Date: Tue, 29 Aug 2017 09:58:41 -0600
Message-ID: <1504022325-31039-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This expands the socket activation for ibacm to include the kernel facing
listening netlink socket. This helps avoid racing during bootup by
allowing the kernel to block resolution until ibacm is started during
earlier boot.

Also a small clean up of F_SETFL

https://github.com/linux-rdma/rdma-core/pull/198

Jason Gunthorpe (4):
  Add set_fd_nonblock to util
  srp_daemon: Use pipe2 instead of pip&fcntl
  Use set_fd_nonblock in instead of open coding F_SETFL
  ibacm: Allow systemd to also setup the RDMA_LS socket for ibacm

 ibacm/ibacm.socket      |  4 +++
 ibacm/src/acm.c         | 81 ++++++++++++++++++++++++++++++++++++-------------
 librdmacm/rsocket.c     |  7 +++--
 srp_daemon/srp_daemon.c | 19 +-----------
 util/CMakeLists.txt     |  5 ++-
 util/dummy.c            |  0
 util/util.c             | 22 ++++++++++++++
 util/util.h             |  4 +++
 8 files changed, 97 insertions(+), 45 deletions(-)
 delete mode 100644 util/dummy.c
 create mode 100644 util/util.c

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
