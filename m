From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH  0/3] IB/mlx4: Fix extended counters support
Date: Thu, 11 Feb 2016 10:24:41 +0200
Message-ID: <1455179084-4778-1-git-send-email-matanb@mellanox.com>
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
mlx4 when link layer is Ethernet.  Thus, extended counters support was broken.
In addition, this series fixes a bug in IB/core sysfs which was also introduced
in "IB 64 bit counter support" series.

Patch 0001 fixes wrong handling of port info capability mask, which caused
setting of extended counters sysfs even if underlying device doesn't support
it.
Patch 0002-0003 align mlx4 counters sysfs for extended counters scheme in case
link layer is Ethernet.

Thanks,
Eran and Matan.

Eran Ben Elisha (3):
  IB/core: Fix reading capability mask of the port info class
  IB/mlx4: Add support for extended counters over RoCE ports
  IB/mlx4: Add support for the port info class for RoCE ports

 drivers/infiniband/core/sysfs.c  |  5 ++--
 drivers/infiniband/hw/mlx4/mad.c | 63 +++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 16 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
