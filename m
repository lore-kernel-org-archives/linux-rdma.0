From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH V1 libibverbs 0/5] Add cross-channel support
Date: Sat, 16 Jan 2016 17:53:39 +0200
Message-ID: <1452959624-29454-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The following set of patches adds cross-channel (CC) support
in the libibverbs.

The cross-channel feature allows to execute WQEs that involve
cross-channel synchronization of IO operations=E2=80=99 on different QP=
s.

Complex applications usually require synchronizations for IO
operations from multiple sources before continuing their
execution.

In order to implement this, the host software usually needs
to handle completions from each one of the receive queues
(arriving in arbitrary order), process the data after last
message arrival and only then post work request on the send
queue to send the combined data to its destination.

Execution of such operation generates multiple interrupts at
an unpredictable time with an overhead of interrupts handling
and context switches.

This patchset adds synchronization primitives which gives
ability to perform conditional operations and a following
submission will introduce arithmetic calculation offload.

Synchronization abilities combined with arithmetic calculations
will allow us to program complex scenarios with a single function
call, hereby significantly reducing overhead associated with IO
processing.

Patch #1 adds CQ ignore overrun flag.
Patch #2 implements QP flags to configure master/slave properties
         of queue.
Patch #3 expands work request structure to have cross-channel
         specific primitives.
Patch #4 exports cross-channel device capability flag.
Patch #5 provides an example of cross-channel synchronizations.

These patches were added on top of "Completion timestamping" [1]
and "Expose QP block self multicast loopback creation flag" [2]
series.

[1] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg28895.ht=
ml
[2] http://comments.gmane.org/gmane.linux.drivers.rdma/30158

Changes from v0:
  * Enrich cover message and commit messages.
  * Add ibv_cc_pingpong example.
  * Add manual to all newly created flags.

Leon Romanovsky (5):
  Add CQ ignore overrun flag
  Add cross-channel QP flags
  Add cross-channel work requests primitives
  Export cross-channel capability flag
  Add an example of cross-channel synchronization

 Makefile.am                |   6 +-
 examples/.gitignore        |   1 +
 examples/cc_pingpong.c     | 991 +++++++++++++++++++++++++++++++++++++=
++++++++
 include/infiniband/verbs.h |  23 +-
 man/ibv_cc_pingpong.1      |  66 +++
 man/ibv_create_cq_ex.3     |  18 +-
 man/ibv_create_qp_ex.3     |  18 +-
 man/ibv_post_send.3        |  25 +-
 src/cmd.c                  |   5 +-
 9 files changed, 1141 insertions(+), 12 deletions(-)
 create mode 100644 examples/cc_pingpong.c
 create mode 100644 man/ibv_cc_pingpong.1

--=20
1.7.12.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
