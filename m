From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC libibverbs 0/2] Use MR with contiguous pages
Date: Tue,  8 Dec 2015 17:17:03 +0200
Message-ID: <1449587825-26444-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This RFC introduces an ability to user space application to work
with contiguous pages when ibv_reg_mr is used.

This ability achieved by asking the provider as part of ibv_reg_mr
to allocate from the kernel such a memory in a transparent way to
the application.

The idea is to pass NULL as part of ibv_reg_mr and turn on an access
flag bit asking for that.

Patches:
#1 - Add the above support as part of ibv_reg_mr.
#2 - Example usage as part of ibv_rc_pingpong.
 
Yishai Hadas (2):
  Add contiguous pages support
  Example code to use contig pages

 examples/rc_pingpong.c     | 47 +++++++++++++++++++++++++++++++++++-----------
 include/infiniband/verbs.h |  2 ++
 src/verbs.c                | 29 ++++++++++++++++++++++------
 3 files changed, 61 insertions(+), 17 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
