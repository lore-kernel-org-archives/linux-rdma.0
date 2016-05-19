From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 0/7] Completion timestamping
Date: Thu, 19 May 2016 14:51:35 +0300
Message-ID: <1463658702-9975-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series from Matan adds completion timestamp for libibverbs.
The kernel part was already accepted.

The series was retested successfully with mlx5 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git
branch: ts_v2.

Thanks,
Yishai

In order to do so, we add an extensible poll cq mechanism.
Former attempts of extending poll CQ were made. An attempt to solve this
problem tried to split the WC into mandatory and optional fields.
The user declared which optional fields each CQ should report and the
WC was constructed in a dynamic way representing all requested fields.
We got some comments regarding this complex approach and API. Furthermore,
it resulted in degraded performance in some flows.

The current approach is based on Jason's proposal. Instead of using a WC
struct, we report completion fields by request. A new ibv_cq_ex is added.
This new extended CQ contains accessor functions to the completion fields.
Each vendor assigns these function pointers in order to provide the
completion data efficiently. In order to create a suitable CQ and maintain
backward and forward compatibility, the user declares which completion
attributes he needs while creating the CQ. A successful creation of the CQ
guarantees that all requested attributes can be queried using the accessor
function pointers.

This approach prevents copying the WC fields in cost of indirect function calls.
However, as most applications don't use most completion fields anyway, the new
approach fully makes sense.

Benchmarks we ran in our test lab found that this new approach generally
equals to current API but *not* worse than. As the new API enables
extending the polled fields we can overall say that it's a better API than
the legacy one.

The user creates a CQ using ibv_create_cq_ex, stating which completion
attributes could be queried later on from this CQ.
In order to decrease per-completion polling overhead, as of updating indices in
the hardware, we split the polling into batches.

A batch is started when calling ibv_start_poll_ex. If a completion is
successfully fetched, the user could query its attributes using accessor
functions ibv_wc_read_xxx.  In order to fetch the next completion in the batch,
the user uses ibv_next_poll_ex.  The same ibv_wc_read_xxx functions are used in
order to query these completions as well. In order to end a batch, the user
uses ibv_end_poll_ex.  Of course, starting a new batch incurs some overhead.

Each batch could poll zero or more completions.
Each completion polling starts with either ibv_start_poll_ex/ibv_next_poll_ex
and ends with ibv_next_poll_ex/ibv_end_poll_ex.
Completion attributes could only be queried between these calls.
These attributes represents the values of the completion already fetched by
the last ibv_start_poll_ex/ibv_next_poll_ex.

The batching API is thread-safe (assuming the CQ wasn't created with
SINGLE_THREADED attribute) and represents a series of completions the user
would like to poll one after another.  The vendor user space driver should
guarantee this.

Completion timestamp is added on top of these extended ibv_create_cq_ex verb by
using wc_flags field of init_cq_attr. The user could query the CQ's completion
timestamp using ibv_wc_read_completion_ts. The timestamp mask (number of
supported bits) and the HCA's frequency are given in ibv_query_device_ex verb.

We also give the user an ability to read the HCA's current clock.
This is done via ibv_query_rt_values_ex. This verb could be extended
in the future for other interesting information.

Changes from V1:
- Moved to indirect function calls in order to poll a CQ.

Changes from V0:
- Split the series to small logical patches.
- Align naming in some places to match other verbs.
- Fix and improve the man pages.
- Add an example code as part of rc_pingpong.

Matan Barak (6):
  Add support for extended creating CQ verb
  Add member functions to poll an extended CQ
  Add timestamp_mask and hca_core_clock to ibv_query_device_ex
  Add completion timestamp to poll_cq
  Create a single threaded CQ
  Add a verb that queries real time values from the HCA

Yishai Hadas (1):
  Add timestamp support in rc_pingpong

 Makefile.am                   |   3 +-
 examples/devinfo.c            |  10 ++
 examples/rc_pingpong.c        | 278 ++++++++++++++++++++++++++++++++----------
 include/infiniband/driver.h   |   9 ++
 include/infiniband/kern-abi.h |  26 ++++
 include/infiniband/verbs.h    | 248 +++++++++++++++++++++++++++++++++++++
 man/ibv_create_cq_ex.3        | 152 +++++++++++++++++++++++
 man/ibv_query_device_ex.3     |   6 +-
 man/ibv_query_rt_values_ex.3  |  50 ++++++++
 src/cmd.c                     |  69 +++++++++++
 src/device.c                  |  44 +++++++
 src/ibverbs.h                 |   5 +
 src/libibverbs.map            |   1 +
 13 files changed, 835 insertions(+), 66 deletions(-)
 create mode 100644 man/ibv_create_cq_ex.3
 create mode 100644 man/ibv_query_rt_values_ex.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
