From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.30 and compat-dapl-1.2.19 release
Date: Mon, 9 Aug 2010 15:22:11 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C98301100FFEAB@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
New release for uDAPL v1.2 (1.2.19) and v2.0 (2.0.30) available at:

http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for details):
md5sum: ef98486354feb7ea930f3cd698a310fd compat-dapl-1.2.19.tar.gz 
md5sum: 8177f4721f286a3d9e00b60eda74d6dc dapl-2.0.30.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.30-1 
dapl-utils-2.0.30-1 
dapl-devel-2.0.30-1 
dapl-debuginfo-2.0.30-1 
compat-dapl-1.2.19-1 
compat-dapl-devel-1.2.19-1 

Summary of v2.0 and v1.2 changes: 

Release 2.0.30 fixes: 

common: increase default logging to include warnings 
common: add more debug levels for cm logging 
common: cleanup CR linkings after DTO error on EP 
ucm: cleanup CM debug warning messages 
scm, ucm: improperly handles pkey check/query in host order 
windows: linux compatability header file _errno.h is moving out of verbs.h. 
windows: update SOURCES files to link winverbs.lib, which is 

Release 1.2.19 fixes: 

common, cma: disconnect and cleanup CR linkings after DTO error on EP 

-----

Vlad, please pull both into OFED 1.5.2 RC4:


Thanks,

-arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
