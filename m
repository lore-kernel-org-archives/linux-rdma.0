From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/5] Completion timestamping
Date: Tue, 27 Oct 2015 18:51:35 +0200
Message-ID: <1445964700-13235-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series adds completion timestamp for libibverbs.
In order to do so, we add an extensible poll cq. The problem with
extending the WC is that you could run out of the current cache
line when adding new features and degrade performance. This is solved
by introducing a custom WC.

The user creates a CQ using ibv_create_cq_ex, stating which WC fields
should be returned by this CQ. When the user calls ibv_poll_cq_ex,
this custom WC is returned. The fields orders and sizes are declared
in advanced (we avoid alignment rules by putting the fields starting
from the 64bit fields --> 8bit fields). Each WC has a wc_flags field
representing which fields are valid in this WC.
The vendor drivers could optimize those calls extensively.

Completion timestamp is added on top of these extended ibv_create_cq_ex
verb and ibv_poll_cq_ex verb. The user should call ibv_create_cq_ex
stating that this CQ should support reporting completion timestamp.
ibv_poll_cq_ex reports this raw completion timestamp value in every
packet.

In the future, a verb like the following could be added in order to
transform this time into system time:
ibv_get_timestamp(struct ibv_context *context, uint64_t raw_time,
		  struct timespec *ts, int flags);

The timestamp mask (number of supported bits) and the HCA's frequency
are given in ibv_query_device_ex verb.

We also give the user an ability to read the HCA's current clock.
This is done via ibv_query_values_ex. This verb could be extended
in the future for other interesting information.

Thanks,
Matan

Matan Barak (5):
  Add ibv_poll_cq_ex verb
  Add timestamp_mask and hca_core_clock to ibv_query_device_ex
  Add support for extended ibv_create_cq
  Add completion timestmap support for ibv_poll_cq_ex
  Add ibv_query_values_ex

 Makefile.am                   |   6 +-
 examples/devinfo.c            |  10 ++
 include/infiniband/compiler.h |  89 ++++++++++++
 include/infiniband/driver.h   |   9 ++
 include/infiniband/kern-abi.h |  26 +++-
 include/infiniband/verbs.h    | 318 ++++++++++++++++++++++++++++++++++++++++++
 man/ibv_create_cq_ex.3        |  71 ++++++++++
 man/ibv_poll_cq_ex.3          | 173 +++++++++++++++++++++++
 man/ibv_query_device_ex.3     |   6 +-
 src/cmd.c                     |  63 +++++++++
 src/device.c                  |  44 ++++++
 src/ibverbs.h                 |  12 ++
 src/libibverbs.map            |   1 +
 13 files changed, 822 insertions(+), 6 deletions(-)
 create mode 100644 include/infiniband/compiler.h
 create mode 100644 man/ibv_create_cq_ex.3
 create mode 100644 man/ibv_poll_cq_ex.3

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
