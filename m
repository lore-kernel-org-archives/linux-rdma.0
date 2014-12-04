From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.12-1 rc4 release is available
Date: Thu, 04 Dec 2014 17:36:25 +0200
Message-ID: <54807F79.7080304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi,
OFED-3.12-1-rc4 is available at:

https://www.openfabrics.org/downloads/OFED/ofed-3.12-1/OFED-3.12-1-rc4.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.12-1

Release notes: https://openfabrics.org/downloads/OFED/release_notes/OFED_3.12-1_rc4_release_notes

Main Changes from OFED 3.12-1-rc3
     - compat-rdma
         IB/qib: streamline qib xeon-phi patches
         qib add RHEL7 support
         RDMA/nes: Fix for register mr with zero length
     - ofed-scripts
         install.pl: Build intel-mic-psm as needed
         uninstall.sh: Replaced by perl script
         install.pl: Remove kernel version check for qib/ipathverbs
     - libocrdma-1.0.4

PS: resending this email in text format due to link/html issues.

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
