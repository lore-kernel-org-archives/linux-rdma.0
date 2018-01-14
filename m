From: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Sun, 14 Jan 2018 17:35:50 -0500
Message-ID: <20180114223603.19961-1-bmt@zurich.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set contributes a new version of the SoftiWarp
driver, as originally introduced Oct 6th, 2017.

Thank you all for the commments on my last submissiom. It
was vey helpful and encouraging. I hereby re-send a SoftiWarp
patch after taking all comments into account, I hope. Without
introducing SoftiWarp (siw) again, let me fast forward
to the changes made to the last submission:


1. Removed all kernel module parameters, as requested.
   I am not completely happy yet with what came out of
   that, since parameters like the name of interfaces
   siw shall attach to, or if we want to use TCP_NODELAY
   for low ping-pong delay, or disable it for higher
   message rates for multiple outstanding operations,
   were quite handy. I understand I have to find a better
   solution for that. Ideally, we would be able to
   distinguish between global siw driver control (like
   interfaces it attaches to), and per-QP parameters
   (somehow similar to socket options) which allow for
   example to tune delay, setting CRC on/off, or control
   GSO usage.

   For now, the former module parameters became global
   const values, as defined in siw_main.c. So, I gave
   up on flexibility for now, but hope to re-gain it
   with a proper interface.

2. Changed all debug printouts to device debug printouts,
   or removed them.

3. Implemented sending and handling of TERMINATE 
   messages. Determining the information to be carried
   in those messages, as scattered over several RFC's,
   was unexpectedly complex.

   It turned out, that some iwarp hardware only
   rudimentarily implements that iwarp termination
   protocol, lacking sending back useful information
   in case of application failure.

   I anyway think, it is rather helpful to understand why
   a certain RDMA operation failed at peer side, since it
   carries that information back to the initiator.

4. Used Sparse to fix the various style and consistency
   issues of the last version.

5. Removed siw private implementation of DMA mapping ops
   in favour of using in-kernel available dma_virt_ops.

6. Fixed local SQ processing starvation due to high
   inbound rate of READ.requests to same QP.
   
7. Introduced some level of NUMA awareness at transmit
   side. The code tries to serve SQ processing with a
   core from the same NUMA node as the current Ethernet
   adapter.


The current code comes with the following known
limitations:

1. To get rid of module parameters, siw now attaches
   to all interfaces of type ETHER (or additionally
   LOOPBACK, if enabled).

   Please take it as an ad-hoc solution. I understand
   it will likely not be acceptable, but I wanted to
   come out with a reasonable and working update of siw.
   So far, I did not came across any good solution
   for dynamic interface management for siw. I would
   highly appreciate suggestions, and look forward
   for discussion.

2. Performance needs some additional investigation.
   The dynamics of the interaction with kernel TCP
   still needs some better understanding, especially
   regarding clever setting of message flags, socket
   parameters, etc. On a 100Gb/s link, one QP can get
   around 60Gb/s for large messages, and 6.5us WRITE
   delay for small messages, but there is still
   fluctuation, and therefor probably some headroom.

3. I kept the siw_tx_hdt() function, which
   tries to push to TCP all pieces of an iWarp message
   as one message vector. This makes that function
   probably rather complex, but performance seem
   to benefit from that approach.

4. zero copy transmission is currently switched off
   (bool zcopy_tx is false in siw_main.c). Switching
   it on lowers CPU load at sending side, but introduces
   a high rate of mid-frame fragmentation at TCP
   layer (RDMAP frame gets broken into two
   wire transmissions), which hurts receiver 
   performance. It will get re-enabled if those effects
   are better understood, and controlled.


As always, I am very thankful for reviewing the code,
much appreciating the time and effort it takes. I am
very open for discussion and suggestions.

Thanks very much,
Bernard.

Bernard Metzler (13):
  iWARP wire packet format definition
  Main SoftiWarp include file
  Attach/detach SoftiWarp to/from network and RDMA subsystem
  SoftiWarp object management
  SoftiWarp application interface
  SoftiWarp connection management
  SoftiWarp application buffer management
  SoftiWarp Queue Pair methods
  SoftiWarp transmit path
  SoftiWarp receive path
  SoftiWarp Completion Queue methods
  SoftiWarp debugging code
  Add SoftiWarp to kernel build environment

 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/sw/Makefile        |    1 +
 drivers/infiniband/sw/siw/Kconfig     |   18 +
 drivers/infiniband/sw/siw/Makefile    |   15 +
 drivers/infiniband/sw/siw/iwarp.h     |  415 +++++++
 drivers/infiniband/sw/siw/siw.h       |  823 +++++++++++++
 drivers/infiniband/sw/siw/siw_ae.c    |  120 ++
 drivers/infiniband/sw/siw/siw_cm.c    | 2184 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_cm.h    |  156 +++
 drivers/infiniband/sw/siw/siw_cq.c    |  150 +++
 drivers/infiniband/sw/siw/siw_debug.c |  463 +++++++
 drivers/infiniband/sw/siw/siw_debug.h |   87 ++
 drivers/infiniband/sw/siw/siw_main.c  |  816 ++++++++++++
 drivers/infiniband/sw/siw/siw_mem.c   |  243 ++++
 drivers/infiniband/sw/siw/siw_obj.c   |  338 +++++
 drivers/infiniband/sw/siw/siw_obj.h   |  200 +++
 drivers/infiniband/sw/siw/siw_qp.c    | 1445 ++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_qp_rx.c | 1531 +++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_qp_tx.c | 1346 ++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_verbs.c | 1876 ++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_verbs.h |  119 ++
 include/uapi/rdma/siw_user.h          |  216 ++++
 22 files changed, 12563 insertions(+)
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
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
