From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.6-1 release
Date: Thu, 13 Aug 2015 18:22:05 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980A5059A@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL (2.1.6) is available at http://downloads.openfabrics.org/dapl/

Vlad, please pull into OFED 3.18-1 

	md5sum: dce3ef7c943807d35bcb26dae72b1d88 dapl-2.1.6.tar.gz

For v2.1 package install RPM packages as follow:

	dapl-2.1.6-1
	dapl-utils-2.1.6-1
	dapl-devel-2.1.6-1
	dapl-debuginfo-2.1.6-1

Release notes: http://downloads.openfabrics.org/dapl/documentation/uDAPL_release_notes.txt

Summary:

Release 2.1.6
ucm: add cluster size environments to adjust CM timers
mpxyd: proxy_in data transfers can improperly start before RTU received
mcm: forward open/query for MFO devices in query only mode
mpxyd: byte swap incorrect on WRC wr_len
dtest: remove ERR message from flush QP function
dapltest: Quit command with "-n port" number will core dump
config: update dat.conf for MFO qib devices, 2 adapters/ports
mpxyd: add MFO support on proxy side
mcm: add MFO proxy commands, device, and CM support
mcm: add MFO support to openib_common code base
mcm: add full offload (MFO) mode to provider to support qib on MIC
dtest: pre-allocated buffer too small for RMR, DTO ops timeout
mpxyd: fix buffer initialization when no-inline support is active
mpxyd: reduce log level on qp_flush to CM level
mcm: intra-node proxy missing LID setup on rejects
mcm: add intra-node support via ibscif device and mcm provider
mcm: provide MIC address info with proxy device open
mcm: add device info to non-debug log
common: add DAPL_DTO_TYPE_EXTENSION_IMM for rdma_write_imm DTO type checking
mpxyd: fix up some of the PI logging
dtest: modify rdma_write_with_msg to support uni-direction streaming
mcm,mpxyd: fix dreq processing to defer QP flush when proxy WRs still pending
mpxyd: update byte_len and comp_cnt for PO to remote HST communications
mcm: bug fixes for non-inline devices
mcm: return CM_rej with CM_req_in errors
mpxyd,mcm: RDMA write with immed data not signaled on request side
mcm: add WC opcode and wc_flags in debug log message
mpxyd: set options bug fix for mcm_ib_inline

Release commit:  http://git.openfabrics.org/?p=~ardavis/dapl.git;a=commit;h=91febc42f0070b2b9eaa81c0c113c6ff7ab8ea60

Regards, Arlin
