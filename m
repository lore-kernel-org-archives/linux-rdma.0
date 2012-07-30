From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.1 release
Date: Mon, 30 Jul 2012 13:35:24 -0700
Message-ID: <20120730133524.a811473c0245dafa1614de2b@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags.

The tarball is available at:
http://downloads.openfabrics.org/management/infiniband-diags-1.6.1.tar.gz

d250e63f849b017f7149046c003cc8f6  infiniband-diags-1.6.1.tar.gz

Dependencies:

        1) libibmad >= 1.3.9
        2) libibumad >= 1.3.7
        3) opensm-libs >= 3.3.10
        4) ib_umad kernel module


Release notes v1.6.0 => 1.6.1

   1) bug fixes and code clean up


16:32:07 > git log --pretty=short 1.6.0..HEAD | git shortlog
Albert Chu (1):
      infiniband-diags: Fix command line parsing bug in ibccconfig, ibccquery, saquery, and smpquery.

Daniel Klein (1):
      Subject: [PATCHv2] infiniband-diags/vendstat: updated devices supporting extended fw info

Hal Rosenstock (10):
      infiniband-diags/ibnetdiscover: fix no port 0 info segmentation fault
      ibnetdiscover: fix not showing FDR10 speeds
      ibnetdiscover: fix not showing FDR10 speeds
      mcm_rereg_test.c: Fix a couple of output messages
      ibnetdiscover: fix not showing FDR10 speeds
      mcm_rereg_test.c: Fix a couple of output messages
      iblinkinfo: fix no port 0 info segmentation fault
      infiniband-diags: Support MLNX ExtendedPortInfo for ConnectIB device
      infiniband-diags/perfquery.c: Fix compile warning
      infiniband-diags/vendstat.c: Commentary change

Ira Weiny (4):
      infiniband-diags: saquery avoid a potential seg fault in libibmad
      infiniband-diags: update README and configure.in for 1.6.1 release



-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
