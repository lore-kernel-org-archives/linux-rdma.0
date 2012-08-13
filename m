From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fix V2 0/2] mlx4_core: Fix scaling issues related to memory registration
Date: Mon, 13 Aug 2012 11:15:05 +0300
Message-ID: <1344845707-23157-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here are Yishai's fixes which added few issues that come into play
for systems with large RAM, with these fixes, your commit db5a7a65
"mlx4_core: Scale size of MTT table with system RAM" can really play, 
where without them, things don't work.

These are fixes, should be ok to 3.6 and to -stable anyway.

changes from previous postings -- (I signed this post as V2, the
prev ones where seperate and didn't use consistent numbering
that starts at zero...) -- here're pointers to the posts:

http://marc.info/?l=linux-rdma&m=134434316831352&w=2
http://marc.info/?l=linux-rdma&m=134432700325849&w=2

- enhanced the change-logs
- changed the order of patches such that the 2nd adds on the 1st, 
  and there's no code added in the 1st and remove in the 2nd...

Or.

Yishai Hadas (2):
  net/mlx4_core: Allow large mlx4_buddy objects
  net/mlx4_core: Fix scaling issues related to memory registration

 drivers/net/ethernet/mellanox/mlx4/icm.c     |    9 ++++++---
 drivers/net/ethernet/mellanox/mlx4/icm.h     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/mr.c      |   25 +++++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx4/profile.c |    4 ++--
 5 files changed, 28 insertions(+), 16 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
