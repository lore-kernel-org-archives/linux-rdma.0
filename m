From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 0/5] generic adaptive IRQ moderation library for I/O devices
Date: Tue,  6 Feb 2018 00:03:11 +0200
Message-ID: <20180205220316.30236-1-sagi@grimberg.me>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Idan Burstein <idanb@mellanox.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-rdma@vger.kernel.org

Adaptive IRQ moderation (also called adaptive IRQ coalescing) has been widely used
in the networking stack for over 20 years and has become a standard default
setting.

Adaptive moderation is a feature supported by the device to delay an interrupt
for a either a period of time, or number of completions (packets for networking
devices) in order to optimize the effective throughput by mitigating the cost of
handling interrupts which can be expensive in modern rates in networking and/or
storage devices.

The basic concept of adaptive moderation is to provide time and packet based control
of when the device generates an interrupt in an adaptive fashion, attempting to
identify the current workload based on online gathered statistics instead of a
predefined configuration. When done correctly, adaptive moderation can win the
best of both throughput

This rfc patchset introduces a generic library that provides the mechanics for
online statistics monitoring and decision making for the consumer which simply
need to program the actual device while still keeping room for device specific
tuning.

In the networking stack, each device driver implements adaptive IRQ moderation
on its own. The approach here is a bit different, it tries to take the common denominator,
which is per-queue statistics gathering and workload change identification
(basically decides if the moderation scheme needs to change).

The library is targeted to multi-queue devices, but should work on single queue
devices as well, however I'm not sure that these devices will need something
like interrupt moderation.

The model used in the proposed implementation requires the consumer (a.k.a the
device driver) to initialize an irq adaptive moderator context (a.k.a irq_am) per
its desired context which will most likely be a completion queue.

The moderator is initialized with a set of am (adaptive moderation) levels,
which are essentially the abstraction of the device specific moderation parameters.
Usually the different levels will map to different pairs of
(time <usecs>, completion-count) which are left specific to the consumer.

The moderator assumes that the am levels are sorted in an increasing order when the
lowest level corresponds to the optimum latency tuning (short time and low
completion-count) and gradually increasing towards the throughput optimum tuning
(longer time and higher completion-count). So there is a trend and tuning direction
tracked by the moderator. When the moderator collects sufficient statistics (also
controlled by the consumer defining nr_events), it compares the current stats with the
previous stats and if a significant changed was observed in the load, the moderator
attempts to increment/decrement its current level (called a step) and schedules a program
dispatch work.

The main reason why this implementation is different then the common networking devices
implementation (and kept separate) is that in my mind at least, network devices are different
animals than other I/O devices in the sense that:
(a) network devices rely heavily on byte count of raw ethernet frames for adaptive moderation
    while in storage or I/O, the byte count is often a result of a submission/completion transaction
    and sometimes even known only to the application on top of the infrastructure (like in the
    rdma case).
(b) Performance characteristics and expectations in representative workloads.
(c) network devices collect all sort of stats for different functionalities (where adaptive moderation
    is only one use-case) and I'm not sure at all that a subset of stats could easily migrate to a different
    context.

Having said that, if sufficient reasoning comes along, I could be convinced otherwise if unification
of the implementations between networking and I/O is desired.

Additionally, I hooked two consumers into this framework:
1. irq-poll - interrupt polling library (used by various rdma consumers and can be extended to others)
2. rdma cq - generic rdma cq polling abstraction library

With this, both RDMA initiator mode consumers and RDMA target mode consumers
are able to utilize the framework (nvme, iser, srp, nfs). Moreover, I currently do
not see any reason why other HBAs (or devices in general) that support interrupt
moderation wouldn't be able to hook into this framework as well.

Note that the code is in *RFC* level, attempting to convey the concept.
If the direction is acceptable, the setup can be easily modified and
cleanups can be performed.

Initial benchmarking shows promising results with 50% improvement in throughput
when testing high load of small I/O. The experiment taken used nvme-rdma host vs. nvmet-rdma
target exposing a null_blk device. The workload ran multithreaded fio run with high queue-depth
and block size of 512B read I/O (4K block size would exceed 100 Gbe wire speed).

The results without adaptive moderation reaches ~8M IOPs bottlenecking the host and target cpu.
With adaptive moderation enabled, IOPs quickly converge to ~12M IOPs (at the expense of slightly
higher latencies obviously) and debugfs stats show that the moderation level reached the
throughput optimum level. There is currently a known issue I've observed in some conditions
converging back to latency optimum (after reaching throughput optimum am levels) and I'll work
to fix the tuning algorithm. Thanks to Idan Burstein for running some benchmarks on his
performance setup.

I've also tested this locally with my single core VMs and saw similar improvement of ~50%
in throughput in a similar workload (355 KIOPs vs. 235 KIOPs). More testing will help
a lot to confirm and improve the implementation.

QD=1 Latency tests showed a marginal regression of up to 2% in latency (lightly tested though).
The reason at this point is that the moderator still bounces in the low latency am levels
constantly (would like to improve that).

Another observed issue is the presence of user context polling (IOCB_HIPRI) which does not update
the irq_am stats (mainly because its not interrupt driven). This can cause the moderator to do
the wrong thing as its based on partial view of the load (optimize for latency instead of getting
out of the poller's way). However, recent discussions raised the possibility that polling requests
will be executed on a different set of queues with interrupts disabled altogether, which would make
this a non-issue.

None the less, I would like to get some initial feedback on the approach. Also, I'm not an expert
in tuning the algorithm. The basic approach was inspired by the mlx5 driver implementation which
seemed the closest to fit the abstraction level that I was aiming for. So I'd also love to get some
ideas on how to tune the algorithm better for various workloads (hence the RFC).

Lastly, I have also attempted to hook this into nvme (pcie), but that wasn't successful mainly
because the coalescing set_feature is global to the controller and not per-queue.
I'll be looking to bringing per-queue coalescing to the NVMe TWG (in case the community is
interested in supporting this).

Feedback would be highly appreciated, as well as a test drive with the code in case anyone
is interested :)

Sagi Grimberg (5):
  irq-am: Introduce helper library for adaptive moderation
    implementation
  irq-am: add some debugfs exposure on tuning state
  irq_poll: wire up irq_am and allow to initialize it
  IB/cq: add adaptive moderation support
  IB/cq: wire up adaptive moderation to workqueue based completion
    queues

 drivers/infiniband/core/cq.c |  73 ++++++++++-
 include/linux/irq-am.h       | 118 ++++++++++++++++++
 include/linux/irq_poll.h     |   9 ++
 include/rdma/ib_verbs.h      |   9 +-
 lib/Kconfig                  |   6 +
 lib/Makefile                 |   1 +
 lib/irq-am.c                 | 291 +++++++++++++++++++++++++++++++++++++++++++
 lib/irq_poll.c               |  30 ++++-
 8 files changed, 529 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/irq-am.h
 create mode 100644 lib/irq-am.c

-- 
2.14.1
