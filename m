From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] mlx4 fixes for 3.10
Date: Sun, 21 Apr 2013 18:09:58 +0300
Message-ID: <1366557001-29408-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here are few mlx4 for 3.10, two that deal with RAW PACKET QPs and
another ones that clears a verbose print to be a debug one.

Or.


Dotan Barak (1):
  IB/mlx4: Disables VLAN stripping for RAW PACKET QPs

Eli Cohen (1):
  IB/mlx4: Set link type for RAW PACKET QPs in the QP context

Jack Morgenstein (1):
  net/mlx4_core: Deprecate warning message for SRQ_LIMIT event to debug level

 drivers/infiniband/hw/mlx4/qp.c         |    6 ++++++
 drivers/net/ethernet/mellanox/mlx4/eq.c |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
