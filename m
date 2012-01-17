From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] OpenSM tarball release
Date: Tue, 17 Jan 2012 17:08:02 +0200
Message-ID: <20120117150802.GA11763@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of OpenSM.
Tarball available in:

http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
6e667badb126a5e21ea2ab90cd950226  opensm-3.3.13.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert Chu (8):
      Fix typo in qos-ulps parsing comment
      Support source-port-guid QoS policy configuration with ULP 'any'
      Support source-target-port-guid QoS policy configuration with ULP 'any'
      Fix memleak and segfault
      Do not load configs from the default config file and specified config
	file
      Remove duplicate initialization of scatter_ports
      Free memory from osm_subn_opt_t when osm_subn_t destroyed
      Move no_fallback_routing_engine from osm_subn_opt_t to osm_opensm_t.

Alex Netes (10):
      Fix use of logical && with constant operand; switch to bitwise &
      Fix use of GNU old-style field designator extension
      Fix suggest parentheses around operand warning
      Removed unused parameter "ib_mad_addr" from umad_reciever()
      Fixed multicast groups reconfiguration during heawy sweep
      Fix IPoIB broadcast group creation on non-default Pkey
      opensm: fixed segfault in osm_destroy
      opensm: update shared library versions
      opensm_release_notes-3.3: update
      opensm: packages versions update

Hal Rosenstock (12):
      opensm/osm_torus.c: Use "OpenSM standard" error codes
      opensm/libvendor/osm_vendor_ibumad.c: Fix DR path printing on send
	timeouts
      opensm/osm_sa_mad_ctrl.c: Enhance send error log message
      opensm/osm_perfmgr.c: Enhance send error log message
      opensm/osm_switch.h: Fix commentary typo
      opensm/osmeventplugin/src/osmeventplugin.c: Output LIDs in decimal
      opensm/osm_sa_class_port_info.c: Conditionalize setting of
	OSM_CAP2_IS_MCAST_TOP_SUPPORTED
      opensm/complib/cl_atomic.h: Commentary changes
      opensm/osm_subnet.c: Trivial optimization to code flow in
	subn_verify_sl2vl
      opensm/man/torus-2QoS.conf.5.in: Update portgroup_max_ports section
      opensm: Change osm_routing_engine struct to not use C++ reserved word
      opensm/osm_prtn.c: Fix typo in log message

Hefty, Sean (1):
      opensm: Remove duplicate definition of IB_MAD_STATUS_CLASS_MASK

Ira Weiny (1):
      opensm: Add the precreation of multicast groups
-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
