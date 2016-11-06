From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Flow steering enhancements
Date: Sun,  6 Nov 2016 16:42:44 +0200
Message-ID: <1478443369-8208-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Maor aligns libibverbs flow steering functionality
with the lastly accepted code in kernel 4.9.
As of that, a user space application can enjoy and activate the new
functionality.

It includes,
- Introducing IPV4 extended spec with some new fields as of protocol/tos/ttl.
- Introducing IPV6 extended flow spec.
- Introducing sniffer flow steering rule type.

The series was tested successfully with both CX3 and CX4.

Specifically,
Patch #1: Pre-patch for the series, fixes ibv_create_flow API to be aligned
          with its man page upon an error case.
Patch #2: Enables extended fields for IPV4 flow specification.
Patch #3: Introduces an IPv6 extended flow specification.
Patch #4: Introduces sniffer flow steering rule type.
patch #5  Man page update to describe the new functionality.
  
Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/34

Yishai

Maor Gottlieb (5):
  ibverbs: Align ibv_create_flow with man page
  ibverbs: Introduce IBV_FLOW_SPEC_IPV4_EXT flow specification
  ibverbs: Introduce IPv6 flow specification
  ibverbs: Introduce sniffer flow steering rule type
  ibverbs: Update ibv_create_flow man page

 libibverbs/cmd.c                 | 90 ++++++++++++++++++++++++++++++++++++++--
 libibverbs/kern-abi.h            | 38 ++++++++++++++++-
 libibverbs/man/ibv_create_flow.3 | 41 +++++++++++++++++-
 libibverbs/verbs.h               | 42 ++++++++++++++++++-
 4 files changed, 204 insertions(+), 7 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
