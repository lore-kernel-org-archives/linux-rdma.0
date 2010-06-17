From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.29 release
Date: Thu, 17 Jun 2010 13:46:46 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103CC8784@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
New release for uDAPL v2.0 (2.0.29) available at:

http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for details):

md5sum: 76f18eedf0758ca81aaa3923a65808a5 dapl-2.0.29.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.29-1 
dapl-utils-2.0.29-1 
dapl-devel-2.0.29-1 
dapl-debuginfo-2.0.29-1 
compat-dapl-1.2.17-1 
compat-dapl-devel-1.2.17-1 

Summary of changes: 

Release 2.0.29 fixes (OFED 1.5.2): 

scm, ucm: add pkey and sl override for QP's, DAPL_IB_SL, DAPL_IB_KEY.
cma: remove dependency on rdma_cma_abi.h 
configure: need a false conditional for verbs attr.link_layer member check 
ucm: incorrectly freeing port on passive side after reject 
ucm: modify debug CM output for consistency, all ports, qpn in hex 

Vlad, please pull into OFED 1.5.2 RC2 (should be final uDAPL package for OFED 1.5.2):

Thanks,

-arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
