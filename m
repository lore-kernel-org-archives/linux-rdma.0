From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.34
Date: Thu, 3 Nov 2011 00:59:18 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E93275@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for v2.0 (2.0.34) available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 1.5.4 RC3 

Thanks,

Arlin

--------------

Latest Package (see ChangeLog for recent changes):

md5sum: d8114711c07fa9f4b7e52ab2803a9e8d dapl-2.0.34.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.34-1 
dapl-utils-2.0.34-1 
dapl-devel-2.0.34-1 
dapl-debuginfo-2.0.34-1 
compat-dapl-1.2.19-1 
compat-dapl-devel-1.2.19-1 

Summary of changes: 

Release 2.0.34 fixes (OFED 1.5.4 GA): 

scm: change debug message level for listen/bind errors 
common: increase default IB ack timer from 16 to 20 
common: remote ia address null pointer creates seg fault 
common: posting events on full queue returns wrong error code 
common: dat_ep_modify seg faults with null ep_param ptr 
common: dat_evd_free seg faults with resized software EVD 
common: remove assert for incorrect events during cm_request 
dat: dat_cno_query with NULL cno_handle causes segmentation fault 
scm: dat_psp_create returns wrong error code on bind/listen failure 
scm: socket connect request count is reset improperly on retry 
scm: when hostname has loopback addr assigned, default to eth0 instead of failing 
scm: add port number to error log during hca_open failures 
common: query calls return incorrect IA handle to consumer 
common: srq create asserts with !dapl_llist_is_empty(head) failed




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
