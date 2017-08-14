From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-next 00/11] Hardware tag matching support
Date: Mon, 14 Aug 2017 16:53:41 +0300
Message-ID: <20170814135352.5324-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series adds to Mellanox ConnectX HCA driver support of
tag matching. It introduces new hardware object eXtended shared Receive
Queue (XRQ), which follows SRQ semantics with addition of extended
receive buffers topologies and offloads.

This series adds tag matching topology and rendezvouz offload.

Main changes between RFC and current version:
 * Followed after RFC posted on the ML and OFVWG discussions
 * Implements agreed verbs interface
 * Rebased on top of latest version
 * Adding feature description under Documentaion/infiniband
 * In struct ib_srq_init_attr moved CQ outside XRC inner struct.
 * Added max size of the information passed after the RNDV header
 * Added hca_sq_owner HW flag for RNDV QPs

Thanks

----------------------------------------------------------------

Doug,

Please note that I merged our shared pull request from the mailing
list before sending this series. Please let me know if something needs
to be redone.

Thanks

----------------------------------------------------------------
The following changes since commit c8252e205138a6649a2274ad658b6fd6cce7b334:

  Merge tag 'mlx5-shared-2017-08-07' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into HEAD (2017-08-13 15:48:40 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-08-14

for you to fetch changes up to 617a0639046f2e1d0cc32782ce60fe25aac3f7e1:

  Documentation: Hardware tag matching (2017-08-13 15:49:08 +0300)

----------------------------------------------------------------
TAG matching support

Message Passing Interface (MPI) is a communication protocol that is
widely used for exchange of messages among processes in high-performance
computing (HPC) systems. Messages sent from a sending process to a
destination process are marked with an identifying label, referred to as
a tag. Destination processes post buffers in local memory that are
similarly marked with tags. When a message is received by the receiver
(i.e., the host computer on which the destination process is running),
the message is stored in a buffer whose tag matches the message tag. The
process of finding a buffer with a matching tag for the received packet
is called tag matching.

There are two protocols that are generally used to send messages over
MPI: The "Eager Protocol" is best suited to small messages that are
simply sent to the destination process and received in an appropriate
matching buffer. The "Rendezvous Protocol" is better suited to large
messages. In Rendezvous, when the sender process has a large message to
send, it first sends a small message to the destination process
announcing its intention to send the large message. This small message
is referred to as an RTS (ready to send) message. The RTS includes the
message tag and buffer address in the sender. The destination process
matches the RTS to a posted receive buffer, or posts such a buffer if
one does not already exist. Once a matching receive buffer has been
posted at the destination process side, the receiver initiates a remote
direct memory access (RDMA) read request to read the data from the
buffer address listed by the sender in the RTS message.

MPI tag matching, when performed in software by a host processor, can
consume substantial host resources, thus detracting from the performance
of the actual software applications that are using MPI for
communications. One possible solution is to offload the entire tag
matching process to a peripheral hardware device, such as a network
interface controller (NIC). In this case, the software application using
MPI will post a set of buffers in a memory of the host processor and
will pass the entire list of tags associated with the buffers to the
NIC. In large-scale networks, however, the NIC may be required to
simultaneously support many communicating processes and contexts
(referred to in MPI parlance as "ranks" and "communicators,"
respectively). NIC access to and matching of the large lists of tags
involved in such a scenario can itself become a bottleneck. The NIC must
also be able to handle "unexpected" traffic, for which buffers and tags
have not yet been posted, which may also degrade performance.

When the NIC receives a message over the network from one of the peer
processes, and the message contains a label in accordance with the
protocol, the NIC compares the label to the labels in the part of the
list that was pushed to the NIC. Upon finding a match to the label, the
NIC writes data conveyed in the message to the buffer in the memory that
is associated with this label and submits a notification to the software
process. The notification serves two purposes: both to indicate to the
software process that the label has been consumed, so that the process
will update the list of the labels posted to the NIC; and to inform the
software process that the data are available in the buffer. In some
cases (such as when the NIC retrieves the data from the remote node by
RDMA), the NIC may submit two notifications, in the form of completion
reports, of which the first informs the software process of the
consumption of the label and the second announces availability of the
data.

----------------------------------------------------------------
Artemy Kovalyov (11):
      net/mlx5: Update HW layout definitions
      IB/core: Add XRQ capabilities
      IB/core: Separate CQ handle in SRQ context
      IB/core: Add new SRQ type IB_SRQT_TM
      IB/uverbs: Add XRQ creation parameter to UAPI
      IB/uverbs: Add new SRQ type IB_SRQT_TM
      IB/uverbs: Expose XRQ capabilities
      IB/mlx5: Fill XRQ capabilities
      net/mlx5: Add XRQ support
      IB/mlx5: Support IB_SRQT_TM
      Documentation: Hardware tag matching

 Documentation/infiniband/tag_matching.txt     |  64 +++++++++++
 drivers/infiniband/core/uverbs_cmd.c          |  43 ++++++--
 drivers/infiniband/core/verbs.c               |  16 +--
 drivers/infiniband/hw/mlx4/srq.c              |   4 +-
 drivers/infiniband/hw/mlx5/main.c             |  20 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   5 +
 drivers/infiniband/hw/mlx5/qp.c               |   9 +-
 drivers/infiniband/hw/mlx5/srq.c              |  29 +++--
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 150 ++++++++++++++++++++++++--
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   9 +-
 include/linux/mlx5/srq.h                      |   5 +
 include/rdma/ib_verbs.h                       |  58 +++++++---
 include/uapi/rdma/ib_user_verbs.h             |  17 ++-
 14 files changed, 371 insertions(+), 59 deletions(-)
 create mode 100644 Documentation/infiniband/tag_matching.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
