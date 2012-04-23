From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.35
Date: Mon, 23 Apr 2012 23:29:25 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481203F3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for v2.0 (2.0.35) available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into current OFED 3.2 RC. 

Thanks, Arlin

----------------

Latest Packages (see ChangeLog for recent changes):

 md5sum: ff01d9fbae488e849472d00d6fb14a43 dapl-2.0.35.tar.gz 

For 2.0 support, including development, install RPM packages as follow: 
  dapl-2.0.35-1 
  dapl-utils-2.0.35-1 
  dapl-devel-2.0.35-1 
  dapl-debuginfo-2.0.35-1 
 
Release 2.0.35 fixes (OFED 3.2 RC): 
 
* config/build: remove post/postun hacking used to modify dat.conf 
* config: clean up help option displays with ext-type options 
* windows: Provide auto-detect between RoCE and Infiniband for Windows. 
* ucm: update UD cm provider to support new CM stat and error counters 
* scm: update socket cm provider to support new CM stat and error counters 
* commom: add cm, link, and diag event counters in IB extended builds 
* scm: use ioctl SIOCIFCONF to get complete list of configured netdev interfaces 
* ucm: UD send failures at scale, ucm_send ERR: get_smsg(hd=149,tl=150) 
* scm: fix retry count on connection pending timeout 
* ucm: cleanup debug message, ntohl on p_size is incorrect 
* cma, scm, ucm: allow EP (QP) creation without EVD (CQ) 
* common: add DAPL_DBG_TYPE_CM_STATS (0x40000) to debug log options 
* common: dapls_ep_flush_cq will segfault when no CQ is attached to EP 
* common: ep_create should allow max_request_iov attribute setting of zero 
* common: add check for NULL handle on ext calls, SRQ free, and helper functions 
* common: add missing sub-types to dat_strerror() 
* common: extended CR event processing missing rejects on errors 
* ucm: incorrectly sends user reject during CR callback errors 
* common: change dbg level on CR callback if not listening on SP 
* scm: incorrectly sends user reject during CR callback errors 
* dat: add check for NULL handle on IA calls 
* cma,scm,ucm: extra reference on EP, with RSP, causes dat_ep_free() to hang 
* common: RSP service points incorrectly freed during CR callback 
* common: clean up dat_rsp_create log message 
* common: cleanup debug message on EVD overflows 
* scm: return correct event error code when remote host refuses requests 
* dapltest: server CR EVD is too small for multi-client configurations. 
* Common: CR EVD overflow causes segfault. 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
