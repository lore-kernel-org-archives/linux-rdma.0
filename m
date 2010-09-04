From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] management tarballs release
Date: Sat, 4 Sep 2010 14:26:40 +0300
Message-ID: <20100904112640.GJ12172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of the management (OpenSM and infiniband
diagnostics) tarballs available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:

8341b50b95bfd511621a23ad900a46c5  libibumad-1.3.6.tar.gz
a1d04520f9d77713a021e4d6af099383  libibmad-1.3.6.tar.gz
3880d2f467b6f2d5fada941c7f8baeb7  opensm-3.3.7.tar.gz
2e6c404427dda6512c3bb40c1a67d4f4  infiniband-diags-1.5.7.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Sasha


Al Chu (5):
      make libibnetdisc default behavior to overwrite a cache
      support libibnetdisc caching no-overwrite flag
      add ibcacheedit tool
      support diffing nodedesc on remoteports in ibnetdiscover
      support diffing lids and nodedesc on remoteports in ibnetdiscover

Arputham Benjamin (1):
      libibumad: Increase the limit of UMAD_MAX_DEVICES

Arthur Kepner (1):
      opensm: toggle sweeping V3

Doron Shoham (1):
      ibnetdiscover: add '-f' flag to show full information (ports' speed and width).

Eli Dorfman (Voltaire) (6):
      return no path when path does not exist
      fix MFT record dump
      opensm: Fix wrong messages in MC delete flow
      opensm: Modify OSM_LOG_SYS messages
      opensm/osm_lid_mgr.c: Allow switch lids to be non LMC aligned
      opensm: Fix sl2vl configuration

Hal Rosenstock (16):
      opensm/osm_sa_path_record.c: Add error code to newly added log message
      opensm/osm_sa_multipath_record.c: livelock in mpr_rcv_get_path_parms
      infiniband-diags/libibnetdisc/ibnetdisc.c: Fix compile warns on 32 bit archs
      infiniband-diags/libibnetdisc/chassis.c: In group_nodes, pass on all nodes
      infiniband-diags/libibnetdisc/chassis.c: In group_nodes, set fabric->chassis
      infiniband-diags/ibnetdiscover.c: Cosmetic changes
      opensm: Better handling of non responsive SMAs
      infiniband-diags/perfquery.8: Add some missing counters to description
      opensm/osm_trap_rcv.c: No need for heavy sweep when just NodeDescription changes
      opensm/osm_mcast_mgr.c: Only route MLIDs with more than 1 member
      opensm/osm_qos.c: Eliminate unneeded endport SL to VL setup
      opensm/osm_req.c: In osm_send_trap144, eliminate redundant clear of m_key in smp
      opensm/osm_helper.c: Add some missing message names to disp_msg_str
      opensm/include/osm_helper.h: Eliminate some duplicate declarations
      opensm/osm_pkey_mgr.c: Eliminate unneeded parameter from pkey_mgr_get_physp_max_blocks API
      infiniband-diags/ibnetdiscover: Fix handling of CA ports in recv_port_info

Hefty, Sean (2):
      ib/mgmt: fix build under windows stack
      libibnetdisc: fix cast in unmarshall16

Ira Weiny (3):
      libibnetdisc: move ibmad_port out of smp_engine
      opensm/osm_perfmgr.c: Remove unnecessary lock reference from Performance Manager object
      ibqueryerrors.c: Optimize by querying AllPortSelect first

Jim Schutt (1):
      opensm/qos.c: Revert port ranges for calls to sl2vl_update_table().

Sasha Khapyorsky (9):
      infiniband-diags/vendstat: code simplifications
      infiniband-diags/vendstat: add config space access options
      infiniband-diags/vendstat: allow multiple config space records
      iba/ib_types.h: remove assertion in ib_get_attr_offset()
      infiniband-diags/ibstat: convert to PRIx64 macros GUID printing
      complib/cl_timer: remove not needed timeval initializations
      opensm_release_notes-3.3: update
      management: update shared library versions
      management: packages versions update

Smith, Stan (3):
      opensm/complib use portable macro syntax
      osmtest - use helper function
      ib_types.h add debug assert

Stan C. Smith (3):
      opensm - address windows env issues
      opensm/libvendor Reduce stack consumption
      opensm - cleanup

Yevgeny Kliteynik (7):
      opensm: fixing compilation issues in some header files
      opensm/osmtest.c: fix bug in getting attr offset
      opensm/main.c: force stdout to be line-buffered
      opensm/osm_sa_path_record.c: adding wrapper for pr_rcv_get_path_parms()
      opensm/osmeventplugin: added new events to monitor SM
      complib/cl_timer.c: fixing cl_timer calculation
      opensm/osm_opensm.c: no report when SM is exiting

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
