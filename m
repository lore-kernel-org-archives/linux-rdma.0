From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.7 release
Date: Wed, 27 Jul 2016 16:15:09 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E22F49913@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags at:

https://openfabrics.org/downloads/management/infiniband-diags-1.6.7.tar.gz

md5sum:

e100bb49f4227a70e0831152b2e4d61e  infiniband-diags-1.6.7.tar.gz


Dependencies:

        1) libibmad >= 1.3.12
        2) libibumad >= 1.3.7
        3) opensm-libs >= 3.3.10
        4) ib_umad kernel module
        5) glib2


Release notes v1.6.6 => 1.6.7

   1) bug fixes
   2) Add support for systemd


Authors since 1.6.6

Dan Ben Yosef (1):
  saquery.c: Fix changing qos_class flag value to network order twice

Hal Rosenstock (5):
  ibcacheedit.c: Eliminate unused parameter passed to
    update_switchportguids
  ibqueryerrors.c: Removed unused passed parameters to print_port_config
    and query_and_dump
  Remove unused pisize parameter from dump_portinfo in ibdiag_common
  ibportstate.c: Fix unsigned comparison warnings
  ibsendtrap.c: Eliminate unused parameter from send_trap

Ira Weiny (1):
  rdma-ndd: Add systemd support

Vladimir Koushnir (1):
  infiniband-diags: Add Switch-IB2 support to device white lists

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
