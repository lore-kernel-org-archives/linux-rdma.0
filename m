From: "Arlin Davis" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.23 release
Date: Fri, 2 Oct 2009 17:15:30 -0700
Message-ID: <099FBF52252142AA87A29578C69AAE14@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL v2 (2.0.23) available at:

http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for recent changes):

md5sum: f58d6dd903cee271d71b0eb6fa33984e compat-dapl-1.2.14.tar.gz 
md5sum: dc1f31a4bc28aedcb725264d65db7e51 dapl-2.0.23.tar.gz 

Vlad, please pull into OFED 1.5 using package spec files and installing following order (v2 first):

dapl-2.0.23-1 
dapl-utils-2.0.23-1 
dapl-devel-2.0.23-1 
dapl-debuginfo-2.0.23-1 
compat-dapl-1.2.14-1 
compat-dapl-devel-1.2.14-1 

Summary of changes since last release: 

v2 - cma: cannot reuse the cm_id and qp for new connection, must reallocate a new one. 
v2 - scm, cma: update DAPL cm protocol revision with latest address/port changes 
v2 - ucm: modify IB address format to align better with sockaddr_in6 
v2 - Add definition for getpid similar to that used by the other dtest apps. 
v2 - WinOF provides a common implementation of gettimeofday that should 
v2 - the completion manager was updated to provide an abstraction that 
v2 - dtestcm: remove IB verb definitions 
v2 - dtest, dtestx: remove IB verb definitions 
v2 - scm: tighten up socket options to insure similiar behavior on Windows and Linux. 
v2 - cma: improve serialization of destroy and event processing 
v2 - scm: improve serialization of destroy and state changes 
v2 - common: no cleanup/release code for timer thread 
v2 - scm, cma: dapli_thread doesn't always get teminated on library close. 
v2 - ucm: tighten up locking with CM processing, state changes 
v2 - ucm: For UD type QP's, return CR p_data with CONN_EST event on passive side. 
v2 - ucm: cleanup extra cr/lf 
v2 - ucm: fix issues with UD QP's. 
v2 - winof: Convert windows version of dapl and dat libaries to use private heaps. 
v2 - dtest, dtestx: modifications for UD QP testing with ucm provider. 
v2 - scm, ucm: UD QP support was broken when porting to common openib code base. 
v2 - cma: cleanup warning with unused local variable, ret, in disconnect 
v2 - cma: remove debug message after rdma_disconnect failure 
v2 - scm: socket errno check needs O/S dependent wrapper 
v2 - dapltest: update script files for WinOF 
v2 - cma: conditional check for new rdma_cm definition. 

For more details see the following: 

http://www.openfabrics.org/downloads/dapl
documentation/uDAPL_v20.pdf for v2 API specification 
documentation/transition_to_dat20_120406.pdf for details on porting to 2.0 
documentation/DAT_IB_Extensions.pdf for IB extension details. 
documentation/DAT_IW_Extensions.pdf for iWARP extension details. 
documentation/uDAPL_ofed_testing_bkm.pdf for latest uDAPL OFED BKM, updated 8-22-2008 

uDAT/uDAPL source git tree is located at git://git.openfabrics.org/~ardavis/scm/dapl.git 

Thanks,

-arlin

_______________________________________________

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
