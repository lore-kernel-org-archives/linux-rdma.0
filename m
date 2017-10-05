From: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH 0/1] Request for Comments on SoftiWarp
Date: Thu,  5 Oct 2017 09:26:58 -0400
Message-ID: <20171005132659.25930-1-bmt@zurich.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set introduces the SoftiWarp driver.

Originally introduced to linux-rdma in 2011, SoftiWarp (siw) is
around as a project for a while. It aims at implementing the iWARP protocol
suite (IETF-RFC 5044/5041/5040/6581) on top of kernel TCP sockets.
It integrates with the linux-rdma  (or "OpenFabrics") framework. When our
initial attempt to contribute siw to Linux somehow sanded up, we
continued to use and further develop it as an open source project,
currently hosted at https://github.com/zrlio/softiwarp.

We found siw being useful, if applications are using
an RDMA API for communication (in particular, the ibverbs API), and
there is no local RDMA hardware support. This might be relevant for RDMA
application development and testing, as well as setups where
RDMA client applications at hosts without hardware RDMA support
want to communicate with servers which want to offload communication
to dedicated RDMA hardware. With the advent of NVME storage technology,
and NVME over Fabrics as a remote storage access method, use cases
may expand within that area (we recently added the driver support
needed to run siw at both NVMeF initiator and target side).
Last but not least, since supporting different (asynchronous, one sided)
communication patterns, we found pure siw client-server deployments can
outperform sockets based communication setups.

With all that, siw complements Soft-RoCE, also a pure software implementation
of an RDMA provider, but running the RoCE/RoCEv2 protocol. In contradiction
to Soft-RoCE, SoftiWarp per definition implements only the RC (reliable
connected) RDMA service, as defined by iWARP.

SoftiWarp comprises a kernel module and a user space library, both
plugging into the linux-rdma kernel environment, or libibverbs and librdmacm
respectively. It supports both kernel and user level RDMA applications.
For efficiency, user level communication endpoint resources such as
send/receive and completion queues are shared (memory mapped) between
siw kernel component and siw user library. We tested siw interoperability
with hardware iWARP products, such as Chelsio's T3/T4/T5/T6 adapters.

We approach the list with this RFC, since we are seeking for advice on
how to make siw ready for Linux acceptance. So, we are prepared -
and hoping for - constructive criticism on what we are presenting here.

The current code has limitations we are aware of. In particular, we are
currently working on:

1) IPv6 addressing support.

2) Revised debug code. The currently used siw specific debug macros seem to
   be obsolete and should probably get substituted by state of the art driver
   debug code.

3) NUMA awareness. We expect better performance results if siw
   would do a better job here.

4) Module parametrization. All settable driver parameters are currently set
   via module parameters. It might be a good idea to have those within /sys.

5) Transmit path implementation. We experimented with different approaches
   to implement a low latency transmit path. The current design of having
   one per CPU core transmit thread might be not the best idea. Advice
   is appreciated!

For the patch set we provide, we added siw as another software driver to
drivers/infiniband/sw.



To experiment with the current siw code, we suggest cloning our out-of-tree
development repo at https://github.com/zrlio/softiwarp.
Here, the branch 'dev-siw.mem_ext' contains the most recent code
development status, which is currently in sync with the patch.
Testing siw requires the installation of both user library and kernel
module, located within userlib/ and kernel/ respectively. That siw
version expects a running kernel of version >= 4.12.

>From Friday night on, I will be on vacation for two weeks with only
limited access to email. I will try to stay connected, and hope for a lively
discussion. I will of course address all comments latest when I am back on
October 24th, but I wanted to get the code out now - to get more eyes
on it.

Thank you,
Bernard.


Bernard Metzler (1):
  Adding SoftiWarp to the RDMA subsystem

 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/sw/Makefile        |    1 +
 drivers/infiniband/sw/siw/Kconfig     |   18 +
 drivers/infiniband/sw/siw/Makefile    |   15 +
 drivers/infiniband/sw/siw/iwarp.h     |  381 ++++++
 drivers/infiniband/sw/siw/siw.h       |  785 ++++++++++++
 drivers/infiniband/sw/siw/siw_ae.c    |  113 ++
 drivers/infiniband/sw/siw/siw_cm.c    | 2270 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_cm.h    |  154 +++
 drivers/infiniband/sw/siw/siw_cq.c    |  164 +++
 drivers/infiniband/sw/siw/siw_debug.c |  442 +++++++
 drivers/infiniband/sw/siw/siw_debug.h |  178 +++
 drivers/infiniband/sw/siw/siw_main.c  |  754 +++++++++++
 drivers/infiniband/sw/siw/siw_mem.c   |  403 ++++++
 drivers/infiniband/sw/siw/siw_obj.c   |  428 +++++++
 drivers/infiniband/sw/siw/siw_obj.h   |  113 ++
 drivers/infiniband/sw/siw/siw_qp.c    | 1172 +++++++++++++++++
 drivers/infiniband/sw/siw/siw_qp_rx.c | 1381 ++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_qp_tx.c | 1342 +++++++++++++++++++
 drivers/infiniband/sw/siw/siw_verbs.c | 1933 ++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_verbs.h |  119 ++
 include/uapi/rdma/siw_user.h          |  220 ++++
 22 files changed, 12387 insertions(+)
 create mode 100644 drivers/infiniband/sw/siw/Kconfig
 create mode 100644 drivers/infiniband/sw/siw/Makefile
 create mode 100644 drivers/infiniband/sw/siw/iwarp.h
 create mode 100644 drivers/infiniband/sw/siw/siw.h
 create mode 100644 drivers/infiniband/sw/siw/siw_ae.c
 create mode 100644 drivers/infiniband/sw/siw/siw_cm.c
 create mode 100644 drivers/infiniband/sw/siw/siw_cm.h
 create mode 100644 drivers/infiniband/sw/siw/siw_cq.c
 create mode 100644 drivers/infiniband/sw/siw/siw_debug.c
 create mode 100644 drivers/infiniband/sw/siw/siw_debug.h
 create mode 100644 drivers/infiniband/sw/siw/siw_main.c
 create mode 100644 drivers/infiniband/sw/siw/siw_mem.c
 create mode 100644 drivers/infiniband/sw/siw/siw_obj.c
 create mode 100644 drivers/infiniband/sw/siw/siw_obj.h
 create mode 100644 drivers/infiniband/sw/siw/siw_qp.c
 create mode 100644 drivers/infiniband/sw/siw/siw_qp_rx.c
 create mode 100644 drivers/infiniband/sw/siw/siw_qp_tx.c
 create mode 100644 drivers/infiniband/sw/siw/siw_verbs.c
 create mode 100644 drivers/infiniband/sw/siw/siw_verbs.h
 create mode 100644 include/uapi/rdma/siw_user.h

-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
