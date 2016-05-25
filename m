From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V7 for-next 0/4] Support SendOnlyFullMember join
Date: Wed, 25 May 2016 22:02:03 +0300
Message-ID: <1464202927-14979-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are four types of multicast join: FullMember, NonMember,
SendOnlyNonMember and SendOnlyFullMember.

This patch-set introduces the ability to send multicast join requests of
type SendOnlyFullMember (until now only the first three types were
supported).
Host that sends such join request, does not require a multicast
subscription and will still send properly, and in addition will not get
other multicast packets from that group.

It adds a new SA query (for classport_info) to check that the sm
supports sending such requests and it modifies multicast processing in
the IB/core module to handle SendOnlyFullMember multicast join requests.

In addition, the patch set modifies IPoIB so that if the sm does support
SendOnlyFullMember join requests, IPoIB will send such a request when
joining a sendonly multicast group.

Changes from V0:
PORTCLASSINFO_REC_FIELD changed to CLASSPORTINFO_REC_FIELD
2 fields in ib_class_port_info instead of one
"sa" changed to SA
"sa" in the headline changed to SA agent
No need to indicates NUM_JOIN_MEMBERSHIP_TYPES = 4
Change the place the ipoib driver calls the new sa_query, does it once after the broadcast is joined.

Changes from V1:
1. add define to sendonly_full_member join state, instead of "8"
2. change commit message to introduce the capmask2
3. number name instead of digit in commit message
4. SA agent instead of SA in commit message header.

Changes from V2:
1. returned back to one field in ib_class_port_info (as in V0).

Changes from V3:
1. Add setter and getter for cap_mask2_resp_time and change accordingly.
2. add relevant reviewd-by section

Changes from V4:
1. add defines for mask/offsets, and sync with the sm code (Thanks to Hal).
2. add check in ipoib for rec is not NULL.
3. Add reviewd-by section.

Changes from V5:
1. set msb in capmask2 in qib_mad.c as needed.

Changes from V6:
1. use define for resp-time-val instead of number.

 
Erez Shitrit (4):
  IB/core: Introduce capabilitymask2 field in ClassPortInfo mad
  IB/SA Agent: Add support for SA agent get ClassPortInfo
  IB/core: Support new type of join-state for multicast
  IB/ipoib: Support SendOnlyFullMember MCG for SendOnly join

 drivers/infiniband/core/multicast.c            |  23 +++-
 drivers/infiniband/core/sa_query.c             | 173 +++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_mad.c            |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  73 +++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  38 ++++--
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   2 +-
 include/rdma/ib_mad.h                          |  60 ++++++++-
 include/rdma/ib_sa.h                           |  12 ++
 9 files changed, 366 insertions(+), 23 deletions(-)

-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
