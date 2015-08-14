From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v9 0/4] Sending kernel pathrecord query to user cache server
Date: Fri, 14 Aug 2015 08:52:05 -0400
Message-ID: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
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
dropped from 47053 jiffies (47.053 seconds) to 10339 jiffies (or 10.339
seconds) on a two-node system, a reduction of 78%.

This patch series is built against Doug's to-be-rebased/for-4.3 branch
after reverting the v8 series and adding Jason's patch:

https://patchwork.kernel.org/patch/6952841/

Some tests with namespace have been performed:
1. An unprivileged user cannot bind to the RDMA_NL_GROUP_LS multicast
   group;
2. An unprivileged user cannot create a new network namespace. However,
   it can create a new user namespace together with a new network
   namespace by using clone() with CLONE_NEWUSER | CLONE_NEWNET flags;
3. In the user and network namespaces created by an unprivileged user,
   the user can be mapped into root and thus be able to bind to the
   RDMA_NL_GROUP_LS multicast group. However, it can neither send 
   requests to the kernel RDMA netlink code nor receive requests from
   it. This is because kernel RDMA netlink code associates itself with
   the init_net network namespace, which in turn associates itself with
   init_user_ns namespace. 

Changes since v8:
-Patch 1:
  - Remove status attribute;
-Patch 4:
  - Add an attribute policy to validate incoming netlink requests or
    responses with nla_parse();
  - Change the check for incoming pathrecord data flags;
  - Add a security check for incoming netlink requests or responses;
  - Add a cast in ibnl_put_msg call to avoid 0-Day building warning.

Changes since v7:
-Patch 1:
  - Replace RDMA_NL_SA with RDMA_NL_LS;
  - Remove the defines for status attribute;
  - Remove RDMA_NL_LS_F_OK;
  - Remove a few structures for simple attribute data;
  - Add the family header for RESOLVE request;
  - Add comments about different attributes.
-Patch 2:
  - Add a helper function to receive netlink responses;
  - Modify ibnl_rcv_msg() to invoke the callback directly for netlink
    response and the SET_TIMEOUT request instead of netlink_dump_start.
-Patch 4:
  - Replace the netlink macros with static inline functions;
  - Simplify the request path with fewer and direct function calls;
  - Fold the netlink request structure into the ib_sa_query structure;
  - Drop the numb_path comparison when determining path_use;
  - Encode the RESOLVE family header when building the request;
  - Determine the anticipated pathrecord data flags by path_use;
  - Use nla_parse() to parse SET_TIMEOUT request message;

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
  IB/core: Add rdma netlink helper functions
  IB/sa: Allocate SA query with kzalloc
  IB/sa: Route SA pathrecord query through netlink

 drivers/infiniband/core/netlink.c  |   55 ++++
 drivers/infiniband/core/sa_query.c |  509 +++++++++++++++++++++++++++++++++++-
 include/rdma/rdma_netlink.h        |    7 +
 include/uapi/rdma/rdma_netlink.h   |   82 ++++++
 4 files changed, 648 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
