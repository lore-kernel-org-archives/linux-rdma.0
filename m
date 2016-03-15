From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/2] Add support for don't trap steering rule
Date: Tue, 15 Mar 2016 19:03:54 +0200
Message-ID: <1458061436-15911-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series exposes to user application the option to create
a normal flow steering rule that doesn't trap received packets,
allowing them to match lower prioritized rules.

You already took the kernel part for coming merge window of 4.6.

The series includes two patches:
The first patch exposes the new flag.
The second patch is a man page for.

Yishai
------

Marina Varshaver (1):
  Add support for don't trap steering rule

Matan Barak (1):
  Add man page for flow steering verbs

 Makefile.am                |   6 ++-
 include/infiniband/verbs.h |   3 +-
 man/ibv_create_flow.3      | 112 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_create_flow.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
