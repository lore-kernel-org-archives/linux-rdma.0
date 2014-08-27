From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.12-1 rc1 release is available
Date: Wed, 27 Aug 2014 14:31:23 +0300
Message-ID: <53FDC18B.6050809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.12-1-rc1 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.12-1/OFED-3.12-1-rc1.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/  for OFED 3.12-1

Release notes: https://openfabrics.org/downloads/OFED/release_notes/OFED_3.12-1_rc1_release_notes


OFED-3.12-1-rc1 Main Changes from OFED 3.12 GA
-------------------------------------------------------------------------------
1. Add support for the OSes
    - RedHat EL7.0
    - SLES 12 RC2
2. Updated packages:
    - dapl-2.1.1
    - ibacm-1.0.9
    - libcxgb4-1.3.5
    - libibverbs-1.1.8
    - libmlx4-1.0.6
    - libocrdma-1.0.3
    - librdmacm-1.0.19.1
    - mstflint-3.7.0-1.17
    - opensm-3.3.18
    - perftest-2.3-0.12
3. Bug fixes

Known issues
------------
- infinipath-psm installation fails on RHEL7.0 and SLES12

Regards,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
