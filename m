From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] uDAPL v2 - dapl-2.0.24 release
Date: Fri, 30 Oct 2009 16:53:48 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835F10B5D0@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
New release for uDAPL 2.0 available on the OFA download page and in my git tree.

md5sum: a8472363f40e7bddbf40217c45165bcc dapl-2.0.24.tar.gz 

Summary of changes since last release: 

v2 - winof: Utilize WinOF version of inet_ntop() for Windows OSes which do not support inet_ntop(). 
v2 - winof: ucm windows build issue with new CQ completion channel 
v2 - winof: add ucm provider to windows build 
v2 - winof: add missing build files for ibal, scm 
v2 - scm: connection peer resets under heavy load, incorrect event on error 
v2 - ucm: increase default reply and rtu timeout values. 
v2 - ucm: change some debug message levels and add check for valid UD REPLY during retries. 
v2 - ucm: increase timers during subsequent retries 
v2 - ucm, scm: address handles need destroyed when freeing Endpoints with UD QP's. 
v2 - openib_common: ignore pd free errors, clear pd_handle and return. 
v2 - ucm: using UD type QP's, ucm reports wrong reject event when user rejects AH resolution request. 
v2 - ucm, scm, cma: Fix CNO support on DTO type EVD's 
v2 - ucm: fix lock init bug in ucm_cm_find 
v2 - ucm: fix build problem with latest windows ucm changes 
v2 - ucm: HCA should not be closed until all resources have been released. 
v2 - ucm: build warning when compiling on 32-bit systems. 
v2 - ucm: trying to deregister the same memory region twice 
v2 - dat: reduce debug message level when parsing for location of dat.conf 
v2 - ucm: update ucm provider for windows environment 
v2 - ucm: add timer/retry CM logic to the ucm provider 

Vlad, please pull new package into latest OFED 1.5 build and install the following:
 
dapl-2.0.24-1 
dapl-utils-2.0.24-1 
dapl-devel-2.0.24-1 
dapl-debuginfo-2.0.24-1 
compat-dapl-1.2.14-1 
compat-dapl-devel-1.2.14-1 

See http://www.openfabrics.org/downloads/dapl/ more details.

-arlin



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
