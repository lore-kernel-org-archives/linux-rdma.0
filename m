From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.5 release
Date: Wed, 11 Feb 2015 00:04:49 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC23C1F@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags at:

https://www.openfabrics.org/downloads/management/

md5sum:
2a587bda5fc8287643c83363e4b6ec21  infiniband-diags-1.6.5.tar.gz

Dependencies:

        1) libibmad >= 1.3.12
        2) libibumad >= 1.3.7
        3) opensm-libs >= 3.3.10
        4) ib_umad kernel module
        5) glib2

Release notes v1.6.4 => 1.6.5

   1) bug fixes
   2) updates for new hardware device IDs
   3) rdma-ndd daemon

Authors since 1.6.4

Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
        ibtracert.c: Remove checking the port 0 state for base switch port 0
        Add new configure flag to enable/disable the rdma-ndd build
        New MAD SM:PortInfoExtended and changing PM:PortExtendedSpeedsCounters
        Fix missing source dir in configure.ac

Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
        Align infiniband-diags MLNX device IDs with OpenSM
        vendstat.c: Add additional vendor IDs to ext_fw_info_device
        ibnetdisc.c: Add additional supported device IDs to is_mlnx_ext_port_info_supported
        ibdiag_common.c: Add more supported device IDs in is_mlnx_ext_port_info_supported
        ibccconfig.c: Account for enhanced switch port 0 in SwitchPortCongestionSetting handling
        ibccquery.c: Account for enhanced switch port 0 in SwitchPortCongestionSetting handling
        saquery.c: Return proper status from query_sa_cpi on bad result status
        saquery.c: Fix handling of cpi and ClassPortInfo options
        ibping.c: Fix support of OUIs other than IB_OPENIB_OUI
        ibportstate.c: Cosmetic changes to MLNX Extended PortInfo
        saquery.c: In query_sa_cpi, make error message consistent
        saquery.c: In print_node_record, change LID print format

Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
        infiniband-diags: update for udev changes.
        infiniband-diags/test-code: remove unused variables
        infiniband-diags: add rdma-ndd daemon
        infiniband-diags: update smpquery man page
        infiniband-diags: If rst2man is available fix missing source dir in configure

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
