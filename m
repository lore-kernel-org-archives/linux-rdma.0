From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.36
Date: Thu, 5 Jul 2012 19:20:46 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481A98F6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New uDAPL release (2.0.36) available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull v2.0 into OFED 3.x and remove the v1.2 compat-dapl package for OFED 3.x, it is no longer supported going forward.

Thanks, Arlin
--------------

Latest Packages (see ChangeLog for recent changes):

	md5sum: 8313a302685089502b44934183199dd5 dapl-2.0.36.tar.gz 

For support, including development, install RPM packages as follow: 

dapl-2.0.36-1 
dapl-utils-2.0.36-1 
dapl-devel-2.0.36-1 
dapl-debuginfo-2.0.36-1 

Summary of changes: 

 Release 2.0.36 fixes (OFED 3.x): 

 scm: increase ACK timeout to 20 for a default value to match other pr 
 common: allow qp modify in init state 
 common: check for valid states during ep posting 
 dat.conf: keep list of providers in order for backward compatibility 
 ucm: record and silently drop a duplicate reject CM message 
 windows: new version of getlocalipaddr not portable 
 dapltest: DFLT_QLEN is defined in multiple tests 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
