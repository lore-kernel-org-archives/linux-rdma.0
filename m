From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.37
Date: Fri, 7 Jun 2013 01:43:40 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972D55144@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rupert/Vlad, please pull this package into OFED 3.5.2

Thanks, Arlin
------------------

Latest Packages (see ChangeLog for recent changes):

md5sum: 2e185e1aac2c09b3d9e529ee1aa1669e dapl-2.0.37.tar.gz 

For v2.0 package install RPM packages as follow: 

dapl-2.0.37-1 
dapl-utils-2.0.37-1 
dapl-devel-2.0.37-1 
dapl-debuginfo-2.0.37-1 

Summary of v2.0 changes: 

Release 2.0.37 fixes (OFED 3.5.2): 

common: add support for ia name during dat_ia_query 
common: dapl_os_atomic_inc/dec() not working as expected on ppc64 machines. 
dapltest: ppc64 endian issue with exchanged mem handle and address 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
