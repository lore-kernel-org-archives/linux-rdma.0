From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.10-1 release
Date: Thu, 22 Dec 2016 21:02:10 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980E47284@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL (2.1.10) is available at http://downloads.openfabrics.org/dapl/dapl-2.1.10.tar.gz

Vlad, please pull into OFED 4.8

md5sum: 50df18f8011a37da88f4886514b9dd96 dapl-2.1.10.tar.gz

For v2.1 package install RPM packages as follow:
dapl-2.1.10-1
dapl-utils-2.1.10-1
dapl-devel-2.1.10-1
dapl-debuginfo-2.1.10-1

Summary of changes:

Release 2.1.10-1
dtest_suite: add option to pause the test.
dtestcm: add client retry, give server time to queue up all listens
dtest: Add new man pages. (dtestx dtestcm dtestsrq)
cma: fix open_query mode, initialize attributes
ucm: up level CM timer logging, increase drep time at scale
dtest: fix return value check on do_rdma_write_with_msg
dtestx: check device capabilities and do atomic tests only if supported by HW
common: set atomic attributes based on provider/device capabilities
build: dtest_suite.sh was moved to test/scripts
mpxyd: let TX thread sleep if no open devices are referenced
mcm: when mmap req from MIC return with fail stat print WARN.
dtest_suite: remove duplicate dtest_suite.sh
dtest: enable -D option (data check) to work with scif provider
dtest_suite: fix typo in user_string var
mcm: remove logs from post send speed path
mcm proxy: push WR from MIC to host with scif mmap memory instead of scif_send.
dtest: the default size in pingpong test is set to 1 byte regardless to user input. 
dtest: cleanup 4 printfs from the middle of performance test, may reduce performance.

Release commit:  
http://git.openfabrics.org/?p=~ardavis/dapl.git;a=commit;h=b2975b615f58e618a12b9e079568f987b8dc689d

Release Notes:
http://downloads.openfabrics.org/dapl/documentation/uDAPL_release_notes.txt

Regards,

Arlin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
