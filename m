From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v7 0/4] Sending kernel pathrecord query to user cache server
Date: Tue, 30 Jun 2015 09:45:51 -0400
Message-ID: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A SA cache is undeniably critical for fabric scalability and performance.
In user space, the ibacm application provides a good example of pathrecord
cache for address and route resolution. With the recent implementation of
the provider architecture, ibacm offers more extensibility as a SA cache.
In kernel, ipoib implements its own small cache for pathrecords, which is
however not available for general use. Furthermore, the implementation of
a SA cache in user space offers better flexibility, larger capacity, and
more robustness for the system.

In this patch series, a mechanism is implemented to allow ib_sa to
send pathrecord query to a user application (eg ibacm) through netlink.
Potentially, this mechanism could be easily extended to other SA queries.

With a customized test implemented in rdma_cm module (not included in this
series), it was shown that the time to retrieve 1 million pathrecords
dropped from 46660 jiffies (46.66 seconds) to 16119 jiffies (or 16.119
seconds) on a two-node system, a reduction of more than 60%.

Changes since v6:
- Patch 4:
  - Replace __u8/16/64 with u8/16/64;
  - Remove the pathrecord flags testing when checking a netlink response;
  - Remove a few error prints;

Changes since v5:
- Patch 1:
  - Replace reversible and numb_path attributes with path_use attribute.
  - Define Mandatory attribute flag.
  - Define attribute data types in cpu byte order.
- Patch 4:
  - Change the calculation of total attribute len;
  - Modify the setting of attributes.

Changes since v4:
- Patch 1: rename LS_NLA_TYPE_NUM_PATH as LS_NLA_TYPE_NUMB_PATH.
- Patch 4: remove the renaming of LS_NLA_TYPE_NUM_PATH as
           LS_NLA_TYPE_NUMB_PATH.

Changes since v3:
- Patch 1: add basic RESOLVE attribute types.
- Patch 4: change the encoding of the RESOLVE request message based on
  the new attribute types and the input comp_mask. Change the response
  handling by iterating all attributes.

Changes since v2:
- Redesigne the communication protocol between the kernel and user space
  application. Instead of the MAD packet format, the new protocol uses
  netlink message header and attributes to exchange request and
  response between the kernel and user space.The design was described
  here:
  http://www.spinics.net/lists/linux-rdma/msg25621.html

Changes since v1:
- Move kzalloc changes into a separate patch (Patch 3).
- Remove redundant include line (Patch 4).
- Rename struct rdma_nl_resp_msg as structure ib_nl_resp_msg (Patch 4).

Kaike Wan (4):
  IB/netlink: Add defines for local service requests through netlink
  IB/core: Check the presence of netlink multicast group listeners
  IB/sa: Allocate SA query with kzalloc
  IB/sa: Route SA pathrecord query through netlink

 drivers/infiniband/core/netlink.c  |    8 +
 drivers/infiniband/core/sa_query.c |  533 +++++++++++++++++++++++++++++++++++-
 include/rdma/rdma_netlink.h        |    7 +
 include/uapi/rdma/rdma_netlink.h   |   87 ++++++
 4 files changed, 630 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
