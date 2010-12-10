From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] uDAPL v2.0 - dapl-2.0.31-1 release
Date: Fri, 10 Dec 2010 15:54:22 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011EBD71E7@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL v2.0 (2.0.31) available at http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for details):

	md5sum: 76f18eedf0758ca81aaa3923a65808a5 dapl-2.0.29.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.31-1 
dapl-utils-2.0.31-1 
dapl-devel-2.0.31-1 
dapl-debuginfo-2.0.31-1 
compat-dapl-1.2.19-1 
compat-dapl-devel-1.2.19-1 

Summary of changes: 

Arlin Davis (22):
      ucm: add missing map file for UCM provider
      cma: fix debug build
      ucm: allow configuration of CM burst (signal) threshold on posting
      common: modify debug in dat_evd_dequeue to reduce noise, only output on non-empty
      common: restructure EVD processing to handle EP destruction phase
      common: add high resolution time stamps and thread id to sdtout debug logs
      scm, ucm: MPI spawn test on oversubcribed server taking excessive time to complete
      common: print out errors on free build and not just debug builds
      debug build: only timestamp if sending to stdout to avoid performance hit
      ucm: configure the recv channel FD to non-blocking
      cma: disconnect can block for excessive times waiting for rdma_cm DREP timeout
      ucm: add debugging to include process id for better scale up debug aids
      ucm: hold lock when sending cm_msgs to sync timer start with packet send
      ucm: decrease timeout retry count for disconnect requests
      ucm: release UD cm objects after AH is exchanged to avoid duplicate request drops
      common: increase default IB inline send threshold to 400
      libdat: memory leak in static registration during parsing
      libdat: static provider entries created for local SR database not freed
      cma: definition for dapl_sp_remove_ep() is missing in cm.c
      scm, ucm: set RAI_NOROUTE flag with rdma_getaddrinfo() call to avoid blocking.
      common: clean up build warning for unused variable event_ptr
      Release 2.0.31

sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org (5):
      ibal: delay QP transition during disconnect phase
      ibal: sync QP destruction and device close
      common: allow DAPL out of band connection models to use ibacm to obtain path record data.
      windows: debug version of windows does not build.
      common: dat_evd_dequeue (poll_cq) fails  with invalid parameter after EP (qp) free

Pradeep Satyanarayana (2):
      cma: rdma_destroy_id called twice during device open bind error
      common cq: a mixup of errno and the -1 return from poll in dapls_wait_comp_channel

Stan Smith (2):
      ucm: remove unnecessary debug warning in async callback
      windows: Missing librdmacm include path for build


Vlad, please pull this into OFED 1.5.3.

Thanks,

Arlin 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
