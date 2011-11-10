From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4 version 1.2.0 released
Date: Thu, 10 Nov 2011 11:09:38 -0600
Message-ID: <4EBC0552.1010104@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

Version 1.2.0 of libcxgb4 is now available for download at:

http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.2.0.tar.gz

with md5sum:

9e26aee8ec9975336e27439791bf9615 libcxgb4-1.2.0.tar.gz

This release includes many important bug fixes and features for the T4 device.

Steve.

---

git shortlog:

Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (1):
       Spin release 1.2.0.

Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> (17):
       libcxgb4: DB Overflow Avoidance.
       libcxgb4: put queue idx values in status page for debug.
       libcxgb4: DB Drop Recovery for RDMA and LLD queues.
       libcxgb4: cq debug changes
       libcxgb4: don't write host idx values when wq is in error.
       libcxgb4: Add debug code to dump state on a stall condition.
       libcxgb4: Remove auto generated ltmain.sh file.
       libcxgb4: Correctly flush unsignaled WRs followed by a signaled WR.
       libcxgb4: Don't flush unsignaled WRs if the QP closed normally
       libcxgb4: return -ENOSYS in c4iw_resize_cq().
       libcxgb4: Bug Fix#4410 - Fix 3 segfaults
       libcxgb4: fixed compilation warnings
       libcxgb4: Checks iw_cxgb4 ABI version to know door bell drop recovery supp
       libcxgb4: Support for flushing a CQ bound to multiple QPs
       libcxgb4: Reset cidx_flush if a active queue starts getting hw cqes
       libcxgb4: Fix multi-flush logic path....again
       libcxgb4: Reset flush_cidx before incrementing cidx.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
