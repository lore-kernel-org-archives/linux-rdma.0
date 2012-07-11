From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND for-next 0/6] batch of fixes for 3.6
Date: Wed, 11 Jul 2012 18:39:26 +0300
Message-ID: <1342021172-20372-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

Here's a batch of small fixes from Dotan for 3.6

Please ignore the prev posting, it had wrong sign-off address for me.

Or.

Dotan Barak (6):
  IB/mthca: Events received for non-existent QPs should generate a warning
  IB/mthca: Fill in the attribute sq_sig_type value in query QP
  IB/mlx4: Fill the masked_atomic_cap attribute in query device
  net/mlx4_core: Remove double function declarations
  IB/cm: Destroy idr as part of the module init error flow
  net/mlx4_core: Free ICM table in case of error

 drivers/infiniband/core/cm.c             |   16 ++++++++++------
 drivers/infiniband/hw/mlx4/main.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c   |    4 +++-
 drivers/net/ethernet/mellanox/mlx4/icm.c |    2 ++
 drivers/net/ethernet/mellanox/mlx4/icm.h |    6 ------
 5 files changed, 16 insertions(+), 14 deletions(-)


Cc: dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
