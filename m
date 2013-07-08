From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] iSER initiator updates for 3.11
Date: Mon,  8 Jul 2013 16:19:17 +0300
Message-ID: <1373289560-24681-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Indeed late, but these are some iser initiator updates for 3.11

We have another batch coming which changes the initiator driver such that 
it can use FRWRs (Fast-Reg-Work-Requests) when FMRs aren't available, e.g 
on ConnectX (mlx4) VF or Connect-IB (mlx5) - the other batch should 
be ready by next week.

Or.


Or Gerlitz (1):
  IB/iser: Use proper debug level value for info prints

Shlomo Pongratz (2):
  IB/iser: Restructure allocation/deallocation of connection resources
  IB/iser: Accept session->cmds_max from user space

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   19 +++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   25 ++++--
 drivers/infiniband/ulp/iser/iser_initiator.c |  115 ++++++++++++++++++++---
 drivers/infiniband/ulp/iser/iser_memory.c    |   13 +--
 drivers/infiniband/ulp/iser/iser_verbs.c     |  134 ++++++++++++--------------
 5 files changed, 202 insertions(+), 104 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
