From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 4.8-1 GA release is available
Date: Fri, 1 Dec 2017 03:02:16 +0200
Message-ID: <fee4318e-265a-68c8-50b5-35bebf242251@dev.mellanox.co.il>
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
OFED-4.8-1 is available at:

http://openfabrics.org/downloads/OFED/ofed-4.8-1/OFED-4.8-1.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 4.8-1


Release notes:

http://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-1-release_notes

OFED-4.8-1 Main Changes from OFED-4.8
-------------------------------------------------------------------------------
1. compat-rdma
- openibd: rpcrdma added to the list of modules to unload
- bnxt_en/bnxt_re: Support ulp_shutdown hook
- bnxt_re: BZ 2655 Fix nfs client hang with a call trace on stress traffic
- bnxt_re: BZ 2654 Fix traffic failure after changing ip address
- bnxt_re: BZ 2656 fix a crash in qp error event processing
- bnxt_en: BZ 2649 Enabling DCB parameter for bnxt_en
- Fixes for i40iw which have been included in kernels 4.12 and 4.13
- qedr: fix BZ 2642 - parse VLAN ID and priority correctly
- bnxt_en: Bug 2645 - Set default completion ring for async events
- bnxt_re: bz 2646 - 
0012-bnxt_re-Make-room-for-mapping-beyond-32-entries.patch
- ib_srp: Fixed backport - issue 2635
- bnxt_en: Misc bug fixes
- bnxt_re: Fix bnxt_en installation in the latest daily builds
- bnxt_re: Adding bug fix patches
- bnxt_re: Backports for SLES12SP0/SP1/SP2 and RH7.0/7.1
- NFS/RDMA backport patch for SLES12SP2
- NFS/RDMA backport patch to revert source files to 4.6 kernel in order 
to facilitate dependency on distro SUNRPC. Include fix to use correct 
ib_map_mr_sg signature from OFED4.8.
- makefile: Added CONFIG_BNXT parameter to override kernel's default
- compat-rdma.spec: Fixed QED firmware installation
- configure: Fix typos introduced by 
b8520c5751cc6c40bb2f5ba8533a34dc260f86f2
- configure: Fix typo
- Merge branch 'master' of https://github.com/selvintxavier/compat-rdma
- Fixed SRP support on RHEL7.2 by using blk_iopoll API in ib_core
- bnxt_re: Add bnxt_re backports
- bnxt_re: Enable bnxt_re building
- Removed previously applied patch 
0057-qed-Fix-error-in-the-dcbx-app-meta-data.patch
- Add qedr

2. Updated packages
- rdma-core stable-v15
- libfabric-1.5.2
- fabtests-1.5.2
- mstflint-4.8.0

3. ofed_scripts
- Added support for rdma-core new packaging format
- install.pl: Added support for using source RPM per Distro
- install.pl: Enable nfsrdma on RHEL7.3 and SLES12 SP2
- Fix syntax error after libbnxt_re-rdmav2
- Add bnxt_re support
- Add qedr


Regards,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
