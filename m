From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Create a common verbs transport library
Date: Tue, 29 Sep 2015 08:56:49 -0400
Message-ID: <20150929125648.GA3433@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

One of the conditions to move the hfi1 driver from staging into the normal
drivers/infiniband/hw directory is to handle the code duplication in our
verbs layer. This is going to be done by creating a new kmod which we will
call rdmavt, for RDMA verbs transport. This will eventually live in the
existing drivers/infiniband tree in a new sw directory:
drivers/infiniband/sw/vt. This new directory can serve as a home for soft
roce when its ready as well.

The verbs library will start out life in drivers/staging/rdma/vt alongside
hfi1. We (Intel) will push incremental patches to keep the community
apprised of the development and allow for early and more continuous
feedback. Once complete the plan would be to move out of staging along with
hfi1.

The current verbs support in the IB core should not need to be modified,
rdmavt is just another verbs provider. Drivers will not use rdmavt directly.
Rather, rdmavt will use the drivers to abstract away the hardware
differences. Here is a diagram of what this will look like.

   +-------+
   |Ib Core|
   +-------+
       +
       |
+------v--------+
|Verbs Transport|
+-+----------+--+
  |          |
  |          |
+-v--+     +-v--+
|qib |     |hfi1|
+----+     +----+

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
