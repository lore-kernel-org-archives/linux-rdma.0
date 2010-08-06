From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 00/10] Add fcoe, fcoib drivers for mlx4 device
Date: Fri, 06 Aug 2010 15:49:20 -0700
Message-ID: <4C5C9170.20706@mellanox.com>
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

The following series implements fcoe and fcoib offload driver for mlx4 
device

mlx4_fc: implement fcoe/fcoib, hook to scsi mid-layer to offload scsi 
operations, and use openfc's libfc to do ELS/BLS
mlx4_fcoib: driver implement fcoib initialization protocol to discover 
IB-FC gateways/bridges

Yevgeny Petrilin:
    Pre-reserve MTPs for FC
    Attach cq to the least cqs attached completion vector
    Enable T11 bit support in fw
   Add API to query the steer capabilities of mlx4 device
 
Oren Duer:
   Add APIs to mlx4_en/mlx4_ib driver to query interfaces for given 
internal device
   Add MPT reserve/release_range APIs

Vu Pham:
    Enable vlan support in qp path
    Enable mlx4_fc/mlx4_fcoib driver in scsi Kconfig/Makefile
    Add mlx4_fc/mlx4_fcoib drivers 

 drivers/infiniband/hw/mlx4/cq.c       |    4 +-
 drivers/infiniband/hw/mlx4/main.c     |   10 +-
 drivers/net/mlx4/cq.c                 |   27 +-
 drivers/net/mlx4/en_cq.c              |    2 +-
 drivers/net/mlx4/en_main.c            |   14 +
 drivers/net/mlx4/fw.c                 |   13 +
 drivers/net/mlx4/intf.c               |   50 +
 drivers/net/mlx4/main.c               |   10 +-
 drivers/net/mlx4/mlx4.h               |    2 +
 drivers/net/mlx4/mr.c                 |   29 +-
 drivers/scsi/Kconfig                  |   14 +
 drivers/scsi/Makefile                 |    2 +
 drivers/scsi/mlx4_fc/Makefile         |    8 +
 drivers/scsi/mlx4_fc/fcoib.h          |  561 +++++++++
 drivers/scsi/mlx4_fc/fcoib_api.h      |  102 ++
 drivers/scsi/mlx4_fc/fcoib_discover.c | 2003 
+++++++++++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/fcoib_main.c     | 1340 ++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc.c            | 1992 
++++++++++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc.h            |  662 +++++++++++
 drivers/scsi/mlx4_fc/mfc_exch.c       | 1502 ++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc_rfci.c       |  990 ++++++++++++++++
 drivers/scsi/mlx4_fc/mfc_sysfs.c      |  243 ++++
 include/linux/mlx4/device.h           |   20 +-
 include/linux/mlx4/driver.h           |   17 +
 include/linux/mlx4/qp.h               |    2 +-
 include/rdma/ib_verbs.h               |   10 +-
 26 files changed, 9606 insertions(+), 23 deletions(-)
