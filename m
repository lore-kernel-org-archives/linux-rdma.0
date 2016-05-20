From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC v2 0/2] libibverbs memory barrier fixes
Date: Fri, 20 May 2016 12:43:31 -0700
Message-ID: <20160520200053.6983AE0B9D@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is v2 of the ARM64 mb* support, plus an additional patch to fail
compiles if there is no platform implementation of the memory barriers.
I've included the 2nd patch because I think it is important to not
assume any default barrier implementation.  Getting it wrong can result
in data corruption.

Changes since V1:

Put the RFC tag back on because I want to retest this series.

Implemented the ARM64 memory barrier macros from scratch using the AMD
reference docs.

Added 2nd patch to fail compiles if no mb* macros exist for the platform.

Steve Wise (2):
  libibverbs: add ARM64 memory barrier macros
  Fail compiles if no platform specific memory barriers exist

 include/infiniband/arch.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
