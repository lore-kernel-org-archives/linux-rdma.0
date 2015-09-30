From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.7-1 release
Date: Wed, 30 Sep 2015 03:48:51 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980A6CBBF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL (2.1.7) is available at http://downloads.openfabrics.org/dapl/

Vlad, please pull into OFED 3.18-1 RC2

     md5sum: c25f1c3f99fd7cf9de7c69f664cda492 dapl-2.1.7.tar.gz 

For v2.1 package install RPM packages as follow:

     dapl-2.1.7-1
     dapl-utils-2.1.7-1  
     dapl-devel-2.1.7-1
     dapl-debuginfo-2.1.7-1

Release notes: http://downloads.openfabrics.org/dapl/documentation/uDAPL_release_notes.txt

Summary of changes:

Release 2.1.7
dtest: add -a -i options, all data sizes, incremental size
dapl: Fix segfault while freeing qp
mpxyd: add P2P inline support for data size <= 96 bytes
dtest: change rdma_write_ping_pong so client is always last receiver
ucm: add DAPL_NETWORK_PROCESS_NUM option for total ranks
ucm: fca create group incorrectly using IB addr instead of socket address.
ucm: fca_comm_destroy called with NULL
dtest: add -W option for rdma write pingpong, similar to ib_write_lat
docs: update release notes for collective build
mpxyd: reduce log level for rcv message flush
dapltest: dapltest with no argument not working in ppc64 arch

Release commit:  http://git.openfabrics.org/?p=~ardavis/dapl.git;a=commit;h=0494ec10176e07804c26b28484535252e47c3f99

Regards, Arlin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
