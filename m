From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.3 release
Date: Sat, 25 Jan 2014 03:58:38 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04ADAA62@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)'" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags.

Tarball available in:

http://www.openfabrics.org/downloads/management/
       
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
6e9c8c5517c690923163cca89710bf2b  infiniband-diags-1.6.3.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
        infiniband-diags: Check node-name-map strings when querying by name

Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        libibnetdisc/ibnetdisc.c: improve log information to stdout
        libibnetdisc/ibnetdisc.c: fix insert of invalid lid 0xFFFF into lid_port hash_table
        ibtracert.c: Add 'force' flag to man page
        infiniband-diags/vendstat: Fix GeneralInfo SW version
        ibportstate: on/off option is missing in help
        iblinkinfo: Remove "-R" option from man page
        ibaddr: Add missing -t option to manpage

Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
        ibdiag_sa.c: Output attribute ID in hex rather than decimal

Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
        infiniband-diags: fail configure if glib2 is not found

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
        Fix errors triggered by autoregen.sh
        get_lid_from_name(): Remove an unused variable

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
