From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.2 release
Date: Sun, 18 Aug 2013 07:44:30 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E02234402@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags.
Tarball available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
0df49878f90c52ab7a997ca55e57ef51  infiniband-diags-1.6.2.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Author: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
        ibnetdiscover: Add missing -f option to manpage
        ibnetdiscover: Output vlcap in full output format
        infiniband-diags/src/perfquery.c: Fix all_ports corner case
        infiniband-diags: Allow user to specify multiple ports
        infiniband-diags: Support node-name-map in ibroute

Author: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
        ibsysstat.c: fix resource leak
        ibtracert.c: Uninitialized variable
        ibtracert.c: fix resource leak
        saquery.c: resource leak

Author: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        infiniband-diags/ibportstate.c: Add ON and OFF options.
        infiniband-diags/ibqueryerrors.c: obtain destination sl before perf query
        infiniband-diags/ibroute.c: fix pull extra block for LFT
        infiniband-diags/src/saquery.c: New option to saquery InformInfoRecord (IIR)

Author: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
        Remove bashisms from infiniband-diags

Author: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
        infiniband-diags/ibportstate.c: Fix PortInfo sets with extended speeds
        infiniband-diags/ibsysstat.c: Fix non default OUI operation
        infiniband-diags/saquery: Add support for ServiceID in PathRecord querying
        infiniband-diags: Eliminate unneeded clean_nodedesc calls
        infiniband-diags: saquery: Dump SwitchInfoRecord based on IsSetMulticastFDBTopSupported SA capability
        libibnetdisc/Makefile.am: Add missing makefile dependency
        perfquery.c: Fix dumping of PortSamplesControl
        saquery: Add SMInfoRecord support
        saquery: Add SwitchInfoRecord support

Author: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        infiniband-diags/saquery.c: Display NodeRecord LID in decimal

Author: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
        infiniband-diags/dump_fts: fix block calculation for LFT's
        infiniband-diags: Fix gen_ver.sh for use with new Autoconf file
        infiniband-diags: add .gitignore
        infiniband-diags: add skip-sl to default ibqueryerrors.8.in
        infiniband-diags: convert IBERROR to IBEXIT
        infiniband-diags: fix rst2man when using upstream docutils
        infiniband-diags: remove doc/man/ibclearcounters.8.in
        infiniband-diags: umad_init needs to be called before sa_get_handle
        infiniband-diags: update emails
        infiniband-diags: update emails in default pages
        infiniband-diags: updates for new autoconf tools

Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
        infiniband-diags: Fix SA error reporting for common MAD errors
        infiniband-diags: Fix ibsysstat man page
        infiniband-diags: add change to pregenerated saquery.8.in
        infiniband-diags: add comment for path_portid
        infiniband-diags: add default <man>.in files
        infiniband-diags: add dump_fts tool
        infiniband-diags: add make check target for shell scripts
        infiniband-diags: check_lft_balanc: support either DR or Lid based dump lfts output
        infiniband-diags: combine common alias option processing
        infiniband-diags: deprecate dump_[m|l]fts.sh scripts
        infiniband-diags: fix bug with loop ports where SMP queries are needed
        infiniband-diags: fix rpm requires for glib2
        infiniband-diags: fix saquery rst/man page
        infiniband-diags: ibroute fix resolve failure message
        infiniband-diags: ibroute: add MAD status to query failure message
        infiniband-diags: ibstat fix strncpy coverity check and -l bug
        infiniband-diags: libibnetdisc add find node by lid
        infiniband-diags: move sa query code into it's own common file
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
