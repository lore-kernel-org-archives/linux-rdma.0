From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 11:45:15 +0100
Message-ID: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

This series introduces IBNBD/IBTRS kernel modules.

IBNBD (InfiniBand network block device) allows for an RDMA transfer of block IO
over InfiniBand network. The driver presents itself as a block device on client
side and transmits the block requests in a zero-copy fashion to the server-side
via InfiniBand. The server part of the driver converts the incoming buffers back
into BIOs and hands them down to the underlying block device. As soon as IO
responses come back from the drive, they are being transmitted back to the
client.

We design and implement this solution based on our need for Cloud Computing,
the key features are:
- High throughput and low latency due to:
1) Only two rdma messages per IO
2) Simplified client side server memory management
3) Eliminated SCSI sublayer
- Simple configuration and handling
1) Server side is completely passive: volumes do not need to be
explicitly exported
2) Only IB port GID and device path needed on client side to map
a block device
3) A device can be remapped automatically i.e. after storage
reboot
- Pinning of IO-related processing to the CPU of the producer

For usage please refer to Documentation/IBNBD.txt in later patch.
My colleague Danil Kpnis presents IBNBD in Vault-2017 about our design/feature/
tradeoff/performance:

http://events.linuxfoundation.org/sites/events/files/slides/IBNBD-Vault-2017.pdf

The patchset is based on Linux 4.11-rc3. I've done functional tests with our
tests framework on AMD64 machines with Mellanox CX-2 and CX-3.

TODOs:
- move some helpers to core
- use new cq api, drain_cq etc
- support poll callback in MQ
- big endian machine support
- better files layout

We've learned a lot from other opensource project, namely SRP/SCST/LIO, etc,
thanks all the contributors. We hope our IBNBD bring more value to 
the opensource world.

A git tree is also avaiable at:
https://github.com/xjtuwjp/linux-2.6/commits/ibnbdv0

As usual, comments and reviews are welcome.

Jack Wang (28):
  ibtrs: add header shared between ibtrs_client and ibtrs_server
  ibtrs: add header for log MICROs shared between ibtrs_client and
    ibtrs_server
  ibtrs_lib: add common functions shared by client and server
  ibtrs_clt: add header file for exported interface
  ibtrs_clt: main functionality of ibtrs_client
  ibtrs_clt: add header file shared only in ibtrs_client
  ibtrs_clt: add files for sysfs interface
  ibtrs_clt: add Makefile and Kconfig
  ibtrs_srv: add header file for exported interface
  ibtrs_srv: add main functionality for ibtrs_server
  ibtrs_srv: add header shared in ibtrs_server
  ibtrs_srv: add sysfs interface
  ibtrs_srv: add Makefile and Kconfig
  ibnbd: add headers shared by ibnbd_client and ibnbd_server
  ibnbd: add shared library functions
  ibnbd_clt: add main functionality of ibnbd_client
  ibnbd_clt: add header shared in ibnbd_client
  ibnbd_clt: add sysfs interface
  ibnbd_clt: add log helpers
  ibnbd_clt: add Makefile and Kconfig
  ibnbd_srv: add header shared in ibnbd_server
  ibnbd_srv: add main functionality
  ibnbd_srv: add abstraction for submit IO to file or block device
  ibnbd_srv: add log helpers
  ibnbd_srv: add sysfs interface
  ibnbd_srv: add Makefile and Kconfig
  ibnbd: add doc for how to use ibnbd and sysfs interface
  MAINTRAINERS: Add maintainer for IBNBD/IBTRS

 Documentation/IBNBD.txt                            |  284 ++
 MAINTAINERS                                        |   14 +
 drivers/block/Kconfig                              |    3 +
 drivers/block/Makefile                             |    2 +
 drivers/block/ibnbd_client/Kconfig                 |   16 +
 drivers/block/ibnbd_client/Makefile                |    5 +
 drivers/block/ibnbd_client/ibnbd_clt.c             | 2007 ++++++++
 drivers/block/ibnbd_client/ibnbd_clt.h             |  231 +
 drivers/block/ibnbd_client/ibnbd_clt_log.h         |   79 +
 drivers/block/ibnbd_client/ibnbd_clt_sysfs.c       |  863 ++++
 drivers/block/ibnbd_client/ibnbd_clt_sysfs.h       |   64 +
 drivers/block/ibnbd_inc/ibnbd-proto.h              |  273 +
 drivers/block/ibnbd_inc/ibnbd.h                    |   55 +
 drivers/block/ibnbd_inc/log.h                      |   68 +
 drivers/block/ibnbd_lib/ibnbd-proto.c              |  244 +
 drivers/block/ibnbd_lib/ibnbd.c                    |  108 +
 drivers/block/ibnbd_server/Kconfig                 |   16 +
 drivers/block/ibnbd_server/Makefile                |    3 +
 drivers/block/ibnbd_server/ibnbd_dev.c             |  436 ++
 drivers/block/ibnbd_server/ibnbd_dev.h             |  149 +
 drivers/block/ibnbd_server/ibnbd_srv.c             | 1074 ++++
 drivers/block/ibnbd_server/ibnbd_srv.h             |  115 +
 drivers/block/ibnbd_server/ibnbd_srv_log.h         |   69 +
 drivers/block/ibnbd_server/ibnbd_srv_sysfs.c       |  317 ++
 drivers/block/ibnbd_server/ibnbd_srv_sysfs.h       |   64 +
 drivers/infiniband/Kconfig                         |    3 +
 drivers/infiniband/ulp/Makefile                    |    2 +
 drivers/infiniband/ulp/ibtrs_client/Kconfig        |    8 +
 drivers/infiniband/ulp/ibtrs_client/Makefile       |    6 +
 drivers/infiniband/ulp/ibtrs_client/ibtrs_clt.c    | 5329 ++++++++++++++++++++
 .../ulp/ibtrs_client/ibtrs_clt_internal.h          |  244 +
 .../infiniband/ulp/ibtrs_client/ibtrs_clt_sysfs.c  |  412 ++
 .../infiniband/ulp/ibtrs_client/ibtrs_clt_sysfs.h  |   62 +
 drivers/infiniband/ulp/ibtrs_lib/common.c          |  104 +
 drivers/infiniband/ulp/ibtrs_lib/heartbeat.c       |  112 +
 drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c     |  248 +
 drivers/infiniband/ulp/ibtrs_lib/ibtrs.c           |  412 ++
 drivers/infiniband/ulp/ibtrs_lib/iu.c              |  113 +
 drivers/infiniband/ulp/ibtrs_server/Kconfig        |    8 +
 drivers/infiniband/ulp/ibtrs_server/Makefile       |    6 +
 drivers/infiniband/ulp/ibtrs_server/ibtrs_srv.c    | 3744 ++++++++++++++
 .../ulp/ibtrs_server/ibtrs_srv_internal.h          |  201 +
 .../infiniband/ulp/ibtrs_server/ibtrs_srv_sysfs.c  |  301 ++
 .../infiniband/ulp/ibtrs_server/ibtrs_srv_sysfs.h  |   59 +
 include/rdma/ibtrs.h                               |  514 ++
 include/rdma/ibtrs_clt.h                           |  316 ++
 include/rdma/ibtrs_log.h                           |   88 +
 include/rdma/ibtrs_srv.h                           |  206 +
 48 files changed, 19057 insertions(+)
 create mode 100644 Documentation/IBNBD.txt
 create mode 100644 drivers/block/ibnbd_client/Kconfig
 create mode 100644 drivers/block/ibnbd_client/Makefile
 create mode 100644 drivers/block/ibnbd_client/ibnbd_clt.c
 create mode 100644 drivers/block/ibnbd_client/ibnbd_clt.h
 create mode 100644 drivers/block/ibnbd_client/ibnbd_clt_log.h
 create mode 100644 drivers/block/ibnbd_client/ibnbd_clt_sysfs.c
 create mode 100644 drivers/block/ibnbd_client/ibnbd_clt_sysfs.h
 create mode 100644 drivers/block/ibnbd_inc/ibnbd-proto.h
 create mode 100644 drivers/block/ibnbd_inc/ibnbd.h
 create mode 100644 drivers/block/ibnbd_inc/log.h
 create mode 100644 drivers/block/ibnbd_lib/ibnbd-proto.c
 create mode 100644 drivers/block/ibnbd_lib/ibnbd.c
 create mode 100644 drivers/block/ibnbd_server/Kconfig
 create mode 100644 drivers/block/ibnbd_server/Makefile
 create mode 100644 drivers/block/ibnbd_server/ibnbd_dev.c
 create mode 100644 drivers/block/ibnbd_server/ibnbd_dev.h
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv.c
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv.h
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv_log.h
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv_sysfs.c
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv_sysfs.h
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/Kconfig
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/Makefile
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/ibtrs_clt.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/ibtrs_clt_internal.h
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/ibtrs_clt_sysfs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_client/ibtrs_clt_sysfs.h
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/common.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/heartbeat.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/ibtrs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/iu.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_server/Kconfig
 create mode 100644 drivers/infiniband/ulp/ibtrs_server/Makefile
 create mode 100644 drivers/infiniband/ulp/ibtrs_server/ibtrs_srv.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_server/ibtrs_srv_internal.h
 create mode 100644 drivers/infiniband/ulp/ibtrs_server/ibtrs_srv_sysfs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_server/ibtrs_srv_sysfs.h
 create mode 100644 include/rdma/ibtrs.h
 create mode 100644 include/rdma/ibtrs_clt.h
 create mode 100644 include/rdma/ibtrs_log.h
 create mode 100644 include/rdma/ibtrs_srv.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
