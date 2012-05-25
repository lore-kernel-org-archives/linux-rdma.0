From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 0/2] report correct resources limitations
Date: Fri, 25 May 2012 05:57:12 +0300
Message-ID: <1337914634-13906-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm sending these patches as a response to Sean's query, basically
I was planning to do so little bit later with more patches, but
here they are.

Or.

Sagi Grimberg (2):
  Limit qp resources accepted for ibv_create_qp()
  Report correct resource limits to a new user context

 src/mlx4.c  |   13 +++++++++++++
 src/mlx4.h  |   19 ++++++++++++++++++-
 src/qp.c    |    6 ++++--
 src/verbs.c |   18 +++++++++++++-----
 4 files changed, 48 insertions(+), 8 deletions(-)

Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
