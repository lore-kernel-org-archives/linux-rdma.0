From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 00/10] non selective polling block interface
Date: Thu,  9 Mar 2017 15:16:32 +0200
Message-ID: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Today, our only polling interface is selective in the sense that
it polls for a specific tag (cookie). blk_mq_poll will not complete
until the specific tag has completed (given that the block driver
implements it obviously).

target mode drivers like our nvme and scsi target, can benefit
from opportunistically polling the block device when we submit
a bio to it, but it doesn't make sense to use a selective
polling interface (like nvmet does at the moment) for it
because we don't care about specific I/O for the time being.

Instead, allow to poll for batch of completions and return if
we don't have any completions or we exhausted our budget (batch).

This set also adds poll_batch support for nvme-pci and nvme-rdma,
and converts nvmet and scsi target to use it. Note that I couldn't
come up with a hero value for the batch size, so I left it at
magic 4 for now, perhaps someone can have a better idea for this.

In addition, I'd like to see if we can hook this with frontend
context (nvmet-rdma, srpt or isert) to avoid scheduling for interrupt
if we have pending block IO that we can poll for.

I would also like to somehow allow aio-dio user-space reap to also have
access to this in the future, but I have yet to come up with something
good for it.

I experimented with this code on nvmet-rdma with a strong initiator
bombarding small 512B IOs (4k block size saturates my network) against
a 4 cpu-core nvmet-rdma target system.

Without this patchset I got:
590K/590K read/write IOPs

With this patchset applied I got:
680K/680K read/write IOPs

The canonical read latency (QD=1) did not have a noticeable
change (29-30 usec).

Hopefully if this is appealing, people can experiment with this
and report back their results.

Sagi Grimberg (10):
  nvme-pci: Split __nvme_process_cq to poll and handle
  nvme-pci: Add budget to __nvme_process_cq
  nvme-pci: open-code polling logic in nvme_poll
  block: Add a non-selective polling interface
  nvme-pci: Support blk_poll_batch
  IB/cq: Don't force IB_POLL_DIRECT poll context for
    ib_process_cq_direct
  nvme-rdma: Don't rearm the CQ when polling directly
  nvme-rdma: Support blk_poll_batch
  nvmet: Use non-selective polling
  target: Use non-selective polling

 block/blk-mq.c                      |  14 ++++
 drivers/infiniband/core/cq.c        |   2 -
 drivers/nvme/host/pci.c             | 146 +++++++++++++++++++++++-------------
 drivers/nvme/host/rdma.c            |   9 ++-
 drivers/nvme/target/io-cmd.c        |   8 +-
 drivers/target/target_core_iblock.c |   1 +
 include/linux/blk-mq.h              |   2 +
 include/linux/blkdev.h              |   1 +
 8 files changed, 125 insertions(+), 58 deletions(-)

-- 
2.7.4
