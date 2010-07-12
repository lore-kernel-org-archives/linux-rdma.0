From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] compat-dapl-1.2.18 release
Date: Mon, 12 Jul 2010 12:59:12 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C98301044928C3@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
New release for uDAPL compat-dapl (v1.2) available at:

http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for details):

md5sum: 9cf1d6b21f648d797fce25beeb9322eb compat-dapl-1.2.18.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.29-1 
dapl-utils-2.0.29-1 
dapl-devel-2.0.29-1 
dapl-debuginfo-2.0.29-1 
compat-dapl-1.2.18-1 
compat-dapl-devel-1.2.18-1 

Summary of changes: 

common, cma: race conditions with DTO error, disconnect and dapl_reset_ep 
common: add new dapl_os_sleep_usec() function 
configure: need a false conditional for verbs attr.link_layer member check 

Vlad, please pull into OFED 1.5.2 RC3 (final v1.2 package for 1.5.2):

Thanks,

-arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
