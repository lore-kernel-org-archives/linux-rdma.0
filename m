From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v1 iproute2-next 0/4] Dynamic rdma link creation
Date: Thu, 21 Feb 2019 10:22:42 -0800
Message-ID: <cover.1550773362.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series adds rdmatool support for creating/deleting rdma links.
This will be used, mainly, by soft rdma drivers to allow adding/deleting
rdma links over netdev interfaces.  It provides the user side for
the following kernel changes merged in linux-rdma/for-next:

https://www.spinics.net/lists/linux-rdma/msg75609.html

I believe this series is ready to go.  Please review!

Changes since RFC:

- add rd_sendrecv_msg() and make use of it in dev_set as well
  as the new link commands.
- fixed problems with the man pages
- changed the command line to use "netdev" as the keyword
  for the network device, do avoid confused with the ib_device
  name.
- got rid of the "type" parameter for link delete.  Also pass
  down the device index instead of the name, using the common
  rd services for validating the device name and fetching the
  index.

Thanks,

Steve.

Steve Wise (4):
  rdma: add helper rd_sendrecv_msg()
  Sync up rdma_netlink.h
  rdma: add 'link add/delete' commands
  rdma: man page update for link add/delete

 man/man8/rdma-link.8                  | 47 ++++++++++++++++++++++
 rdma/dev.c                            |  2 +-
 rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
 rdma/link.c                           | 67 +++++++++++++++++++++++++++++++
 rdma/rdma.h                           |  2 +
 rdma/utils.c                          | 23 ++++++++++-
 6 files changed, 197 insertions(+), 18 deletions(-)

-- 
1.8.3.1
