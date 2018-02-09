From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 4.8-2-rc1 release is available
Date: Fri, 9 Feb 2018 21:26:20 +0200
Message-ID: <d42fcbf8-7bca-98f0-dece-336c2365e760@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-4.8-2-rc1 is available at:

https://openfabrics.org/downloads/OFED/ofed-4.8-2/OFED-4.8-2-rc1.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 4.8-2

Release notes:
https://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-2-rc1-release_notes

OFED-4.8-2-rc1 Main Changes from OFED-4.8-1
-------------------------------------------------------------------------------
1. compat-rdma
- bnxt_en: Fix Max MTU setting on SLES 12 SP3
- qede: SLE12SP3 Backport fix use core min max MTU check
- cxgb: SLE12SP3 Backport fix: use net core MTU range checking
- Remove vmw_pvrdma tech preview patches
- Fixed mlx4 backport
- qedr cherry pick: lower message verbosity
- Update qib backport for SLES 12.3
- bnxt_en: backport for RH 7.0 and 7.1
- compat-rdma.spec: Added compat-rdma-firmware subpackage
- bnxt_en: Backporting for RHEL 7.4 and SLES12SP3
- qedr: Add backports for RHEL 7.4 and SLES 12 SP3
- configure: Add parameters for RXE and RDMAVT
- ib_iser: Added support for SLES12 SP3
- mlx5: Added support for SLES12 SP3
- mlx4: Added support for SLES12 SP3
- ib_core: Added support for SLES12 SP3
- mlx5: Added RHEL7.4 support
- mlx4: Added RHEL7.4 support
- configure/makefile: Rename CONFIG_INFINIBAND_RXE -> CONFIG_RDMA_RXE to match upstream

2. Updated packages
- rdma-core-v16.2
- fabtests-1.5.3
- libfabric-1.5.3
- perftest-4.1-0.2.g770623f

3. ofed_scripts
- add --with-rdmavt-mod for qib
- Add VMware Paravirtual RDMA Driver as an installable driver
- Remove vmw_pvrdma tech preview install option
- install.pl: Added rdma-core-devel dependency for the perftest build
- Revert "install.pl: Enable bnxt_re on supported OSes only"
- install.pl: Added compat-rdma-firmware package
- install.pl: Enable bnxt_re on supported OSes only
- install.pl: Updated rdma-core dependencies
- install.pl: Remove requirement on the specific cmake version
- install.pl: Added support for SLES12 SP3
- install.pl: Added RHEL7.4 support


ULP and Driver restrictions:
- NVMe-oF (kernel 4.8 only)
- NFS-RDMA (SLES12.2 RH7.3 only).
- i40iw 10GbE iWARP Adapter (kernel 4.8 only)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
