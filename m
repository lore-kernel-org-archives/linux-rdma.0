From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.5-1 release
Date: Tue, 26 May 2015 18:25:30 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D772B6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL (2.1.5) is available at http://downloads.openfabrics.org/dapl/dapl-2.1.5.tar.gz

Vlad, please pull into OFED 3.18 RC3

md5sum: 8a7735bfe24dd7c446aec38db3577728 dapl-2.1.5.tar.gz

For v2.1 package install RPM packages as follow:

dapl-2.1.5-1
dapl-utils-2.1.5-1
dapl-devel-2.1.5-1
dapl-debuginfo-2.1.5-1

Summary of changes:

Release 2.1.5
update release notes, readme files
dat.conf: update comments regarding versions
dtest: add logging of provider private data size with -v
scm: remove use of msg.resv field for process id logging
cma: report correct CM req private data size on query
mpxyd: memset ib_wr structure before post_send on WC and WR requests
mcm: add HST side provider support for device without inline data capability
ucm: CM changes for UD extended port space and indexer
ucm: add device support for new port space hash table
ucm: allocate/free AH hash table for UD endpoint types
ucm: check for AH caching when destroying via UD extension
ucm: optimizations for large scale UD communication management
mpxyd: use wr opcode instead of wc opcode to support logging on error cases
mcm: HST->MXS mode, using RDMA_WRITE_WITH_IMM, fails with dtest -w
dapl: aarch64 support for linux
dapltest: add scripts to dist, set default device to IPoIB
mpxyd: add wc_flags to proxy work completions

Release commit:  http://git.openfabrics.org/?p=~ardavis/dapl.git;a=commit;h=facfb793374e4030ebf2ed539d77270a3e90d26e

Regards,

Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
