From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.1-1 release
Date: Wed, 13 Aug 2014 23:55:46 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E6C05B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


New release for uDAPL v2 (2.1.1) is available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 3.12-1 RC1

md5sum: ffdfefd85ddded65286a0d728508fbce dapl-2.1.1.tar.gz

For v2.1 package install RPM packages as follow:

 dapl-2.1.1-1
 dapl-utils-2.1.1-1
 dapl-devel-2.1.1-1
 dapl-debuginfo-2.1.1-1

Summary of v2.1 changes:

Release 2.1.1 (OFED 3.12-1)

common: add provider name to log messages
mpxyd: log warning message if numa_node invalid include debuginfo with build
build: include debuginfo with build
mpxyd: tx thread doesn't sleep during no pending IO state
mpxyd: change MIC cpu_mask to per numa node instead of adapter
mpxyd: set to MXS mode if device numa_node is invalid (-1)
mpxyd: MXS based alltoall benchmark hangs or returns post_send timeout
mpxyd: add IO profile capabilities to help debug alltoall stall cases
mpxyd: retry stalled inline post_send, init m_idx only when signaled

Regards,

Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
