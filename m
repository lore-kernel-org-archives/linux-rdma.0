From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.3-1 release
Date: Tue, 16 Dec 2014 22:52:21 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D03059@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for DAPL (2.1.3) is available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 3.18 daily builds.

Latest Packages (see ChangeLog for recent changes, see README.mcm for MIC support):

   md5sum: 04537bdd405b89c562d73bfdd6027c2b dapl-2.1.3.tar.gz

For package install RPM packages as follow:

   dapl-2.1.3-1
   dapl-utils-2.1.3-1
   dapl-devel-2.1.3-1
   dapl-debuginfo-2.1.3-1

Full list of changes since last release:

Amir Hanania (2):
  common: add srq support for openib verbs providers
  dtest: add dtestsrq for SRQ example and provider testing

Arlin Davis (21):
  add provider and proxy support for GUID across platform
  mpxyd: log warning if running in COMPAT mode
  mpxyd/mcm: add provider specific attribute DAT_IB_PROXY_VERSION
  extension: add IB UD extensions to reduce provider CM and AH memory footprint
  openib: add new TIMEWAIT state for CM
  openib: add IB UD cm_free/ah_free extension support in UCM provider
  dtestx: update IB extension example test with new v2.0.9 features
  mcm: provide CPU family/model attribute on both host and mic sides
  openib: add port_num to provider named attributes
  mpxyd: set global seg_sz to 128KB for proxy data service
  mcm: add segmentation to HST->MXS mode for improved performance
  mcm: HST->MXS mode incorrectly signals multiple fragments per WR
  mpxyd: DTO completion ERR: status 12, op RDMA_WRITE running MPI alltoall test
  mpxyd: increase max open files for service
  ucm: RTU not retransmitted in TIMEWAIT state
  dtestx: allow scale up to 1000 EP's
  common: dapl_ep_free must serialize CM object destroy
  ucm: add time wait override capability for CM services
  dapl: add rdma_write_imm and write only option to dtest
  dapl: mpxyd service changes to support multi-thread single-core

Regards,

Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
