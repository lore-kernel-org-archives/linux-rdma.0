From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] OFED-3.5-rc2 is available
Date: Wed, 3 Oct 2012 20:30:35 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C28B580D5@ORSMSX108.amr.corp.intel.com>
References: <506C5FBE.1080004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506C5FBE.1080004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I seem to be getting this compile error on sles 11 sp 2. 

/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.c:33:1: warning: "pr_fmt" redefined
In file included from /var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/include/linux/printk.h:7,
                 from /usr/src/linux-3.0.13-0.27/include/linux/kernel.h:20,
                 from /usr/src/linux-3.0.13-0.27/include/linux/skbuff.h:17,
                 from /usr/src/linux-3.0.13-0.27/include/linux/if_ether.h:127,
                 from /usr/src/linux-3.0.13-0.27/include/linux/netdevice.h:29,
                 from /var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/include/linux/compat-2.6.29.h:5,
                 from /var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/include/linux/compat-2.6.h:48,
                 from <command-line>:0:
/usr/src/linux-3.0.13-0.27/include/linux/printk.h:152:1: warning: this is the location of the previous definition
/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.c:70:2: warning: "RHEL_MAJOR" is not defined
/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.c:71: error: redefinition of ?struct srp_cred_req?
/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.c:79: error: redefinition of ?struct srp_cred_rsp?
/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.c:90: error: redefinition of ?struct srp_aer_req?
/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.c:103: error: redefinition of ?struct srp_aer_rsp?
make[6]: *** [/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp/ib_srp.o] Error 1
make[5]: *** [/var/tmp/OFED_topdir/BUILD/compat-rdma-3.5/drivers/infiniband/ulp/srp] Error 2
@   


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Vladimir Sokolovsky
Sent: Wednesday, October 03, 2012 8:55 AM
To: OpenFabrics EWG
Cc: linux-rdma
Subject: [ANNOUNCE] OFED-3.5-rc2 is available

Hi,
OFED 3.5-rc2 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-3.5/OFED-3.5-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 3.5

Regards,
Vladimir


OFED-3.5-rc2 Main Changes from OFED 3.5-rc1
-------------------------------------------------------------------------------
compat-rdma: Add SRP backport
compat-rdma: /etc/init.d/openibd: Fix LSB header
compat-rdma: IB/qib: linux-3.6 patches backported
compat-rdma: iw_cxgb4: Fix bug 2369 in OFED bugzilla
compat-rdma: IB/qib: fix compliance regression in 3.5
compat-rdma: RDMA/nes: Added linux-next-pending patches
compat-rdma: RDMA/nes: Updated backports
compat-rdma: NFSRDMA RHEL6.3 backport
compat-rdma: NFSRDMA SLES11SP2 backport
compat-rdma: linux-next-cherry-picks: RDMA/ucma.c: Different fix for ucma context uid=0, causing iWarp RDMA applications to fail in connection establishment

Updated packages:
     infinipath-psm-3.0.1-115.1015_open
     perftest-1.4.0-0.80.gd1763bd
     qperf-0.4.7-0.2.gf3f7001

Supported Platforms and Operating Systems
---------------------------------------------
   o   CPU architectures:
         - x86_64
         - x86
         - ppc64
         - ia64

   o   Linux Operating Systems:
         - RedHat EL6.2          2.6.32-220.el6
         - RedHat EL6.3          2.6.32-279.el6
         - SLES11 SP2            3.0.13-0.27-default
         - kernel.org            3.5    *

       * Minimal QA for these versions.


OFED_release_notes.txt

Note: See the release notes of each component for additional issues.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
