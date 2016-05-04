From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Trivial fixes
Date: Wed,  4 May 2016 08:36:01 +0300
Message-ID: <1462340165-16067-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

I'm sending to you small collection of trivial fixes to core code.

It fixes forgotten skb release call, potential overrun in CMA. SA and
two code simplifications which doesn't introduce any code change
behavior.

Available in the "topic/fix-core" topic branch of this git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:

https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fix-core

Mark Bloch (4):
  IB/iwpm: Fix a potential skb leak
  IB/core: Remove unnecessary check in ibnl_rcv_msg
  IB/core: Fix a potential array overrun in CMA and SA agent
  IB/sa: Use nlmsg_free instead of kfree_skb

 drivers/infiniband/core/cma.c       | 2 +-
 drivers/infiniband/core/iwcm.c      | 2 +-
 drivers/infiniband/core/iwpm_util.c | 1 +
 drivers/infiniband/core/netlink.c   | 3 +--
 drivers/infiniband/core/sa_query.c  | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
