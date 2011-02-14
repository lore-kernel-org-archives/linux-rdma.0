From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.32
Date: Sun, 13 Feb 2011 20:37:29 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98301272F41FC@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for v2.0 (2.0.32) available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 1.5.3 RC4:

--------------

Latest Package (see ChangeLog for recent changes):

md5sum: 0a56cb34462762f0073d732cfe2fb06e dapl-2.0.32.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.32-1 
dapl-utils-2.0.32-1 
dapl-devel-2.0.32-1 
dapl-debuginfo-2.0.32-1 
compat-dapl-1.2.19-1 
compat-dapl-devel-1.2.19-1 

Summary of changes: 

Release 2.0.32 fixes (OFED 1.5.3 GA): 
cma: reduce output log level in disconnect from WARN to CM_WARN 
ucm: delay freeing of active side UD cm object in case RTU is dropped 
ucm: cm object needs to be on work queue before req sent on wire 
ucm, scm: remove use of usec_sleep delays and use events for disc and destroy 
common: reduce default max inline data size because of performance anomaly 
common: dapls_evd_dto_wait() dbg message should print status and not errno 
ucm, scm: exchange max_qp_rd_atom and limit outstanding requests 
scm: retry socket connect on ECONNREFUSED under heavy load 
common: qp modify RTR using wrong ep attribute parameter for dest_rd_atomic




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
