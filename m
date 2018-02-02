From: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block Device (IBNBD)
Date: Fri,  2 Feb 2018 15:08:40 +0100
Message-ID: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series introduces IBNBD/IBTRS modules.

IBTRS (InfiniBand Transport) is a reliable high speed transport library
which allows for establishing connection between client and server
machines via RDMA. It is optimized to transfer (read/write) IO blocks
in the sense that it follows the BIO semantics of providing the
possibility to either write data from a scatter-gather list to the
remote side or to request ("read") data transfer from the remote side
into a given set of buffers.

IBTRS is multipath capable and provides I/O fail-over and load-balancing
functionality.

IBNBD (InfiniBand Network Block Device) is a pair of kernel modules
(client and server) that allow for remote access of a block device on
the server over IBTRS protocol. After being mapped, the remote block
devices can be accessed on the client side as local block devices.
Internally IBNBD uses IBTRS as an RDMA transport library.

Why?

   - IBNBD/IBTRS is developed in order to map thin provisioned volumes,
     thus internal protocol is simple and consists of several request
	 types only without awareness of underlaying hardware devices.
   - IBTRS was developed as an independent RDMA transport library, which
     supports fail-over and load-balancing policies using multipath, thus
	 it can be used for any other IO needs rather than only for block
	 device.
   - IBNBD/IBTRS is faster than NVME over RDMA.  Old comparison results:
     https://www.spinics.net/lists/linux-rdma/msg48799.html
     (I retested on latest 4.14 kernel - there is no any significant
	  difference, thus I post the old link).

Key features of IBTRS transport library and IBNBD block device:

o High throughput and low latency due to:
   - Only two RDMA messages per IO.
   - IMM InfiniBand messages on responses to reduce round trip latency.
   - Simplified memory management: memory allocation happens once on
     server side when IBTRS session is established.

o IO fail-over and load-balancing by using multipath.

o Simple configuration of IBNBD:
   - Server side is completely passive: volumes do not need to be
     explicitly exported.
   - Only IB port GID and device path needed on client side to map
     a block device.
   - A device is remapped automatically i.e. after storage reboot.

This series is a second try, first variant was published [1] and
presented on Vault in 2017 [2].

Since the first version the following was changed:

   - Load-balancing and IO fail-over using multipath features were added.
   - Major parts of the code were rewritten, simplified and overall code
     size was reduced by a quarter.

Commits for kernel can be found here:
   https://github.com/profitbricks/ibnbd/commits/linux-4.15-rc8

The out-of-tree modules are here:
   https://github.com/profitbricks/ibnbd/

[1] https://lwn.net/Articles/718181/
[2] http://events.linuxfoundation.org/sites/events/files/slides/IBNBD-Vault-2017.pdf

Roman Pen (24):
  ibtrs: public interface header to establish RDMA connections
  ibtrs: private headers with IBTRS protocol structs and helpers
  ibtrs: core: lib functions shared between client and server modules
  ibtrs: client: private header with client structs and functions
  ibtrs: client: main functionality
  ibtrs: client: statistics functions
  ibtrs: client: sysfs interface functions
  ibtrs: server: private header with server structs and functions
  ibtrs: server: main functionality
  ibtrs: server: statistics functions
  ibtrs: server: sysfs interface functions
  ibtrs: include client and server modules into kernel compilation
  ibtrs: a bit of documentation
  ibnbd: private headers with IBNBD protocol structs and helpers
  ibnbd: client: private header with client structs and functions
  ibnbd: client: main functionality
  ibnbd: client: sysfs interface functions
  ibnbd: server: private header with server structs and functions
  ibnbd: server: main functionality
  ibnbd: server: functionality for IO submission to file or block dev
  ibnbd: server: sysfs interface functions
  ibnbd: include client and server modules into kernel compilation
  ibnbd: a bit of documentation
  MAINTAINERS: Add maintainer for IBNBD/IBTRS modules

 MAINTAINERS                                    |   14 +
 drivers/block/Kconfig                          |    2 +
 drivers/block/Makefile                         |    1 +
 drivers/block/ibnbd/Kconfig                    |   22 +
 drivers/block/ibnbd/Makefile                   |   13 +
 drivers/block/ibnbd/README                     |  272 ++
 drivers/block/ibnbd/ibnbd-clt-sysfs.c          |  723 +++++
 drivers/block/ibnbd/ibnbd-clt.c                | 1959 +++++++++++++
 drivers/block/ibnbd/ibnbd-clt.h                |  193 ++
 drivers/block/ibnbd/ibnbd-log.h                |   71 +
 drivers/block/ibnbd/ibnbd-proto.h              |  360 +++
 drivers/block/ibnbd/ibnbd-srv-dev.c            |  410 +++
 drivers/block/ibnbd/ibnbd-srv-dev.h            |  149 +
 drivers/block/ibnbd/ibnbd-srv-sysfs.c          |  264 ++
 drivers/block/ibnbd/ibnbd-srv.c                |  901 ++++++
 drivers/block/ibnbd/ibnbd-srv.h                |  100 +
 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/ulp/Makefile                |    1 +
 drivers/infiniband/ulp/ibtrs/Kconfig           |   20 +
 drivers/infiniband/ulp/ibtrs/Makefile          |   15 +
 drivers/infiniband/ulp/ibtrs/README            |  238 ++
 drivers/infiniband/ulp/ibtrs/ibtrs-clt-stats.c |  455 +++
 drivers/infiniband/ulp/ibtrs/ibtrs-clt-sysfs.c |  519 ++++
 drivers/infiniband/ulp/ibtrs/ibtrs-clt.c       | 3496 ++++++++++++++++++++++++
 drivers/infiniband/ulp/ibtrs/ibtrs-clt.h       |  338 +++
 drivers/infiniband/ulp/ibtrs/ibtrs-log.h       |   94 +
 drivers/infiniband/ulp/ibtrs/ibtrs-pri.h       |  494 ++++
 drivers/infiniband/ulp/ibtrs/ibtrs-srv-stats.c |  110 +
 drivers/infiniband/ulp/ibtrs/ibtrs-srv-sysfs.c |  278 ++
 drivers/infiniband/ulp/ibtrs/ibtrs-srv.c       | 1811 ++++++++++++
 drivers/infiniband/ulp/ibtrs/ibtrs-srv.h       |  169 ++
 drivers/infiniband/ulp/ibtrs/ibtrs.c           |  582 ++++
 drivers/infiniband/ulp/ibtrs/ibtrs.h           |  331 +++
 33 files changed, 14406 insertions(+)
 create mode 100644 drivers/block/ibnbd/Kconfig
 create mode 100644 drivers/block/ibnbd/Makefile
 create mode 100644 drivers/block/ibnbd/README
 create mode 100644 drivers/block/ibnbd/ibnbd-clt-sysfs.c
 create mode 100644 drivers/block/ibnbd/ibnbd-clt.c
 create mode 100644 drivers/block/ibnbd/ibnbd-clt.h
 create mode 100644 drivers/block/ibnbd/ibnbd-log.h
 create mode 100644 drivers/block/ibnbd/ibnbd-proto.h
 create mode 100644 drivers/block/ibnbd/ibnbd-srv-dev.c
 create mode 100644 drivers/block/ibnbd/ibnbd-srv-dev.h
 create mode 100644 drivers/block/ibnbd/ibnbd-srv-sysfs.c
 create mode 100644 drivers/block/ibnbd/ibnbd-srv.c
 create mode 100644 drivers/block/ibnbd/ibnbd-srv.h
 create mode 100644 drivers/infiniband/ulp/ibtrs/Kconfig
 create mode 100644 drivers/infiniband/ulp/ibtrs/Makefile
 create mode 100644 drivers/infiniband/ulp/ibtrs/README
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-clt-stats.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-clt-sysfs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-clt.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-clt.h
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-log.h
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-pri.h
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-srv-stats.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-srv-sysfs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-srv.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs-srv.h
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs/ibtrs.h

Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
-- 
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
