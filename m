From: Steve Wise <larrystevenwise@gmail.com>
Subject: [PATCH v3 iproute2-next 0/4] Dynamic rdma link creation
Date: Wed,  3 Apr 2019 12:10:28 -0500
Message-ID: <cover.1554304142.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: Steve Wise <larrystevenwise@gmail.com>, leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series adds rdmatool support for creating/deleting rdma links.
This will be used, mainly, by soft rdma drivers to allow adding/deleting
rdma links over netdev interfaces.  It provides the user side for
the following kernel changes merged in linux-5.1.

Changes since v2:

- move checks for required parameters in the parameter handlers
- move final 'link add' processing to link_add_netdev()
- added reviewed-by tags

Changes since v1:

- move error receive checking from rd_sendrecv_msg() to rd_recv_msg().
- Add rd->suppress_errors to allow control over whether errors when
  reading a response should be ignored.  Namely: resource queries can
  get errors like "none found" when querying for resources, and this
  error should not be displayed.  So on a rd object basis, error
  suppression can be controlled.
- Rebased on rdma/for-next UABI (no need to sync rdma_netlink.h now)
- use chains of struct rd_cmd and rd_exec_cmd vs open coding the parsing
  for the 'link add' command.
- minor nit resolution
- added .mailmap file.  If this is not desired for iproute2, then please
  drop the patch.

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
  Add .mailmap file
  rdma: add helper rd_sendrecv_msg()
  rdma: add 'link add/delete' commands
  rdma: man page update for link add/delete

 .mailmap             |  8 +++++
 man/man8/rdma-link.8 | 47 ++++++++++++++++++++++++++
 rdma/dev.c           |  2 +-
 rdma/link.c          | 78 ++++++++++++++++++++++++++++++++++++++++++++
 rdma/rdma.h          |  4 +++
 rdma/res.h           |  1 +
 rdma/utils.c         | 18 ++++++++++
 7 files changed, 157 insertions(+), 1 deletion(-)
 create mode 100644 .mailmap

-- 
2.20.1
