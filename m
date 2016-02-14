From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 0/2] Fix counters support in mlx4
Date: Sun, 14 Feb 2016 15:51:09 +0200
Message-ID: <1455457871-17354-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

This series fixes an issue introduced in 4.5 after applying Christoph Lameter's
"IB 64 bit counter support" series.  Christoph used a mad in order to query the
vendor driver for extended counters support, however this mad wasn't handled in
mlx4 when link layer is Ethernet.  Thus, counters in RoCE could be broken.

Thanks,
Eran and Matan.

Eran Ben Elisha (2):
  IB/mlx4: Add support for extended counters over RoCE ports
  IB/mlx4: Add support for the port info class for RoCE ports

 drivers/infiniband/hw/mlx4/mad.c | 63 +++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 13 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
