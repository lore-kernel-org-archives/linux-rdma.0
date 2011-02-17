From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] management tarballs release
Date: Thu, 17 Feb 2011 05:46:13 +0200
Message-ID: <20110217034613.GA14113@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of the management (OpenSM and infiniband
diagnostics) tarballs available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

c0b24a1053ae8b0b3caf5950b3ede6dc  infiniband-diags-1.5.8.tar.gz
c2755aa360d3f29d04865ba4e2454a98  libibmad-1.3.7.tar.gz
c7575b7620615d7dfa1c7fdbbd310ec7  libibumad-1.3.7.tar.gz
df051f5f0192d369b0b904147cb045a8  opensm-3.3.8.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

OpenSM:
=======

Alex Netes (1):
      opensm: fixed getline pointer allocation free in osm_console_io

Eli Dorfman (Voltaire) (1):
      Wrong handling of MC create and delete traps

Hal Rosenstock (6):
      opensm/osm_state_mgr.c: Don't signal DISCOVER to SM state machine when already DISCOVERING
      opensm: Fix some typos
      osmtest/osmt_service.c: In osmt_run_service_records_flow, add missing status
      opensm/osm_ucast_ftree: When roots are not connected, update hop count but not lft
      opensm/osm_trap_rcv.c: No need to check for sweep for trap 145
      opensm: Add support for SwitchInfo:MulticastFDBTop

Ira Weiny (1):
      Add node/port/qos information to some error messages

Jason Gunthorpe (1):
      Fix autotools to include the necessary M4 files

Sasha Khapyorsky (3):
      opensm/sa: simplify osm_mcmr_rcv_find_or_create_new_mgrp() function call
      opensm/osm_node_info_rcv.c: move p_physp declaration under code block
      opensm/osm_db_files.c: malloc() return value run-time check

Stan C. Smith (2):
      replace (long*)(long) casting with transportable data type (uintptr_t)
      replace (long*)(long) casting with transportable data type (uintptr_t)

Yevgeny Kliteynik (28):
      opensm/osm_qos_policy.c: change a log message
      opensm/osm_prtn.c: removing TopSpin hack
      libvendor/osm_vendor_ibumad_sa.c: remove useless "if" statement
      libvendor/osm_vendor_mlx_sa.c: remove useless "if" statement
      opensm/osm_mtree.c: removing useless 'if' statement
      opensm/osm_sminfo_rcv.c: removing unused variable
      opensm/osm_pkey.c: removing unused function
      opensm/osm_sa_pkey_record.c: removing unused variable
      opensm/osm_sa_vlarb_record.c: removed unused variable
      opensm/osm_node_info_rcv.c: remove useless code line
      osmtest/osmtest.c: handle timeouts in PR stress test
      opensm/osm_helper.c: fix potential overrun of the array
      opensm/osm_helper.c: cosmetics - move define closer to the relevant code
      opensm/osm_mesh.c: fixing a bug in compare_switches()
      opensm/osm_subnet.c: fixing small bug in error path
      opensm/osm_db_files.c: fix small memory leak
      osmtest/osmt_slvl_vl_arb.c: handling fopen() failure
      opensm/osm_helper.c: use ARR_SIZE macro instead of hardcoded values
      osm_vl15intf.c: fixing use-after-free coredump
      opensm/osm_trap_rcv.c: fix possible core dump
      opensm/osm_ucast_ftree.c: fix small memory leak in error path
      opensm/osm_ucast_ftree.c: fixing another memory leak at error path
      opensm/osm_ucast_lash.c: small bug in calculating allocated size
      opensm/osm_pkey_mgr.c: fixing small memory leak
      opensm/osm_ucast_file.c: closing file descriptor in error path
      opensm/osm_qos_parser_y.y: fixing bunch of memory leaks on invalid values
      opensm/osm_console.c: fix memory and file descriptor leaks
      opensm/st.c: fix potential core dumps

libibumad:
==========

Jason Gunthorpe (1):
      Fix autotools to include the necessary M4 files

Mike Heinz (1):
      FW: [PATCH] umad_send.3 (man page)

Yevgeny Kliteynik (1):
      umad.{c,h}: moving stdlib.h include from C to H file

libibmad:
=========

Ira Weiny (1):
      libibmad/fields.c: Change all PortCounter names to match the Specification

Jason Gunthorpe (1):
      Fix autotools to include the necessary M4 files

infiniband-diags:
=================

Albert Chu (4):
      add --diff support to iblinkinfo
      support --diffcheck in iblinkinfo
      Add lid and node description diff options for --diffcheck in iblinkinfo
      support --filterdownports in iblinkinfo

Alex Netes (3):
      Makefile: ChangeLog and version generation script path fix
      infiniband-diags: update shared library versions
      infiniband-diags: package versions update

Eli Dorfman (Voltaire) (2):
      infiniband-diags: Do not exit when unexpected node found
      inifiband-diags: Support Voltaire switch ISR4200

Hal Rosenstock (3):
      infiniband-diags/ibtracert: Eliminate direct route (-D) option
      infiniband-diags/saquery.c: In dump_one_mcmember_record, fix flow label endian
      infiniband-diags/iblinkinfo.c: Limit some queries to switches

Ira Weiny (4):
      libibmad/fields.c: Change all PortCounter names to match the Specification
      infiniband-diags: Verify timeout value specified to diagnostics
      Further timeout paramater verification (Was: [PATCH] infiniband-diags: Verify timeout value specified to diagnostics)
      ibnetdisc.c: Fix partial scan of the fabric.

Jason Gunthorpe (2):
      Fix autotools to include the necessary M4 files
      The shell scripts use bashism, so use bash directly.

Yevgeny Kliteynik (1):
      ibstat.c: fix core dump if wrong port phys state is reported

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
