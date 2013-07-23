From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.38
Date: Tue, 23 Jul 2013 23:30:55 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972D7D98E@ORSMSX104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rupert, please pull new dapl-2.0.38 released package into OFED 3.5.2

Thanks, Arlin
------------------

Latest Packages (see ChangeLog for recent changes):

md5sum: 21b933fb24ed86d5c5413d9a269f913d dapl-2.0.38.tar.gz 

For v2.0 package install RPM packages as follow: 

dapl-2.0.38-1 
dapl-utils-2.0.38-1 
dapl-devel-2.0.38-1 
dapl-debuginfo-2.0.38-1 

Summary of v2.0 changes: 

Release 2.0.38 fixes (OFED 3.5.2) 

dapltest: add -n parameter to override default server port number (45278) 
ucm,scm: UD mode creates many CR objects per EP that needs cleaned up 
cma: add DAPL_CM_TOS environment variable to enable passing a TOS to the RDMA CM 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
