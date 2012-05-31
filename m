From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [ANNOUNCE] libibmad 1.3.9 release
Date: Thu, 31 May 2012 16:59:45 -0700
Message-ID: <20120531165945.fecda3c7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of libibmad.

Tarball available at:[*]
http://sofa.openfabrics.org/downloads/management/libibmad-1.3.9.tar.gz

5bff1406b95d6165ae31acc9f01482e0  libibmad-1.3.9.tar.gz

Dependencies:

	1) libibumad >= 1.3.7
	2) opensm-libs >= 3.3.10
	3) ib_umad kernel module

Release notes for 1.3.8 to 1.3.9 are:

   1) bug fixes
   2) Add support for Congestion Control MAD's
   3) Add SA NodeRecord
   4) Add MKey support to ibmad_port object
   5) Update counter offsets for PortExtendedSpeedsCounters
   6) Additional print functions
        classportinfo dump function
	additional debugging

   These changes increment the soname to 8 but the library is backwards
   compatible to soname 5.


Git log
=======

Author: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

    libibmad/dump.c: clean up boundary conditions in dump routines
    libibmad: Add MKey support to SMP requests via smp_mkey_get/set()

Author: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

    libibmad/fields.c: Update counter offsets for PortExtendedSpeedsCounters
    libibmad: Add support for SA NodeRecord
    libibmad/rpc.c: On receive, add debug info for dumping incoming MAD address

Author: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

    libibmad: fix misspelling
    libibmad: Add support for congestion control config mads.
    Support classportinfo dump function
    Add support for congestion control mads


[*] I am not sure why the tarball does not appear on www.openfabrics.org/downloads or downloads.openfabrics.org.

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
