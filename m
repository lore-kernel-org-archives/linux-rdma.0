From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18-rc3 release is available
Date: Mon, 22 Jun 2015 19:22:22 +0300
Message-ID: <5588363E.20808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.18-rc3 is available at:

https://www.openfabrics.org/downloads/OFED/ofed-3.18/OFED-3.18-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18

Release notes: https://www.openfabrics.org/downloads/OFED/release_notes/OFED_3.18-rc3_release_notes

OFED-3.18-rc3 Main Changes from OFED-3.18-rc2
-------------------------------------------------------------------------------
1. Updated packages:
  - dapl-2.1.5
  - libfabric-1.0.0
  - librdmacm-1.0.21
  - mstflint-4.0.1-1.42.g0d3b372


2. compat-rdma changes
  - RDMA/ocrdma: insert Dual/BSD license.
  - IB/ipoib: Change To max_cm_mtu when changing mode to connected
  - RDMA/ocrdma : ocrdma upstream sync up patch.
  - NFS/RDMA: fix for RHEL7.1
  - be2net: Fixing the build failure for SLES11 SP4
  - Fix XEON PHI compilation
  - compat-rdma/linux-next-pending: Adding changes to enable the use of the tos field for iwarp providers
  - gen-compat-config.sh: Added XPS related staff
  - openibd: Check if iwpmd is running before unloading modules
  - compat-rdma.spec: Updated content of compat-rdma-devel RPM
  - compat-rdma: add backport to fix ofed-bz2539
  - compat-rdma: add backport to fix ofed-bz2539
  - Fixed openibd stop on OSes using systemd
  - compat-rdma.spec: Fixed openibd header
  - mlx4/5: Added bug fixes
  - IB/core: Added fixes from upstream
  - ibdev2netdev: Added dev_port support
  - mlx4/backport: Fixed dev_id
  - iw_cxgb4: use wildcard mapping for getting remote addr info
  - cxgb4: update firmware to 1.3.32
  - compat-rdma.spec: Added systemd support for all relevant OSes

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
