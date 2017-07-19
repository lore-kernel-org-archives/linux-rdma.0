From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 4.8 GA release is available
Date: Thu, 20 Jul 2017 00:00:08 +0300
Message-ID: <596FC858.6090605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-4.8 is available at:
http://openfabrics.org/downloads/OFED/ofed-4.8/OFED-4.8.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 4.8

Release notes:
http://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-release_notes

OFED-4.8 Main Changes from OFED 3.18-3 GA
1. Added support for RHEL7.3 and SLES12 SP2

2. compat-rdma:
- BACKPORT-ib_srp: synced with MLNX_OFED ib_srp backport
- IB/srp: force reconnect_delay module param to exceed fast_io_fail_tmo
- Final updates to ccl ABI between host and card to match OFED 4.8 and 
kernel 4.9.
- Fix rstream timeouts on 4k_lat test
- Support for Kernel 4.8 in QIB on OFED-4.8
- compat-rdma: Add i40iw to openibd
- Interop related fixes for iWarp drivers i40iw and nes
- configure: Fix typo
- compat: Cleanup auto-generated defines
- iw_cxgb4: Guard against null cm_id in dump_ep/qp
- Xeon Phi updates
- Fixes for i40iw which have been included in kernels > 4.8
- Updated 0003-add-the-ibp-client-and-server-drivers.patch

3. Updated packages:
- compat-rdma-4.8 - based on linux-4.8
- infiniband-diags-2.0.0
- Removed libibmad (deprecated)
- libfabric-1.4.2
- fabtests-1.4.2
- rdma-core v13
- libibscif-1.1.3
- rdma-core-12-1
- dapl-2.1.10
- fabtests-1.4.1rc1
- infiniband-diags-1.6.7
- libfabric-1.4.1rc1
- libibmad-1.3.13
- libibscif-1.1.2
- libvmw_pvrdma-1.0.0
- mstflint-4.5.0-1.17.g8a0c39d
- perftest-3.4-0.9.g98a9a17

4. install.pl
- Disable inband support for mstflint

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
