From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.12-1 rc2 release is available
Date: Tue, 16 Sep 2014 15:52:20 +0300
Message-ID: <54183284.4080607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.12-1-rc2 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.12-1/OFED-3.12-1-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.12-1

Release notes: 
https://openfabrics.org/downloads/OFED/release_notes/OFED_3.12-1_rc2_release_notes 



OFED-3.12-1-rc2 Main Changes from OFED 3.12-1-rc1
-------------------------------------------------------------------------------
Updated packages:
     - dapl-2.1.2
     - mstflint-3.7.0-1.18.gcdb9f80
     - compat-rdma:
         xeon-phi: updates to ofed-mic script
         xeon-phi: correct configure file for correct -with-ibp-debug flag
         xeon-phi: remove bogus comment in compat-rdma.spec
         xeon-phi: updates to ibp_server
         xeon-phi: updated technology preview for ibscif
         RDMA/ocrdma: Add a fix for mmaping kernel mem to user
         cxgb4: GRO busted in sles/rhel backports.
         cxgb4: Fix vlan support in sles and rhel backport.
         add missing docs directory

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
