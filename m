From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/10] Add fcoe, fcoib drivers for mlx4 device
Date: Mon, 16 Aug 2010 15:16:08 -0700
Message-ID: <4C69B8A8.1050204@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Thanks for your feedbacks for previous patch set. I reworked, rearranged 
order of the patches as suggested.
Please ignore the previous patch set. Here is the new one.

The following series implements fcoe and fcoib offload driver for mlx4 
device

mlx4_fc: implement fcoe/fcoib, hook to scsi mid-layer to offload scsi 
operations, and use openfc's libfc to do ELS/BLS
mlx4_fcoib: driver implement fcoib initialization protocol to discover 
IB-FC gateways/bridges
mlx4: add/enable mlx4_core, mlx4_ib, mlx4_en to support fcoe/fcoib

 drivers/infiniband/hw/mlx4/cq.c       |    4 +-
 drivers/infiniband/hw/mlx4/main.c     |   10 +-
 drivers/net/mlx4/cq.c                 |   27 +-
 drivers/net/mlx4/en_cq.c              |    2 +-
 drivers/net/mlx4/en_main.c            |    9 +
 drivers/net/mlx4/fw.c                 |   13 +
 drivers/net/mlx4/intf.c               |   19 +
 drivers/net/mlx4/main.c               |    4 +-
 drivers/net/mlx4/mlx4.h               |    1 +
 drivers/net/mlx4/mr.c                 |  140 ++-
 drivers/scsi/Kconfig                  |   22 +
 drivers/scsi/Makefile                 |    2 +
 drivers/scsi/mlx4_fc/Makefile         |    8 +
 drivers/scsi/mlx4_fc/fcoib.h          |  343 ++++++
 drivers/scsi/mlx4_fc/fcoib_api.h      |   61 +
 drivers/scsi/mlx4_fc/fcoib_discover.c | 1925 
+++++++++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/fcoib_main.c     | 1211 ++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc.c            | 2003 
+++++++++++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc.h            |  666 +++++++++++
 drivers/scsi/mlx4_fc/mfc_exch.c       | 1496 ++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc_rfci.c       | 1001 ++++++++++++++++
 drivers/scsi/mlx4_fc/mfc_sysfs.c      |  244 ++++
 include/linux/mlx4/device.h           |   23 +-
 include/linux/mlx4/driver.h           |    9 +
 include/rdma/ib_verbs.h               |   10 +-
 25 files changed, 9222 insertions(+), 31 deletions(-)

thanks
-vu
