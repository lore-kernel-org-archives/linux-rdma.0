From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] ibsim 0.6 release
Date: Thu, 30 Jan 2014 16:52:46 -0500
Message-ID: <52EAC9AE.8070601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 0.6 release of ibsim.

Tarball is available in:
http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
d08e196d980e7c88066b3e5e25bf5432  ibsim-0.6.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Al Chu (4):
      Fix PerformanceSet parsing corner case
      Output error on bad input to PerformanceSet
      ibsim: Do not return allportselect for non-switches
      ibsim: Remove parse corner case with full ibnetdiscover output

Albert Chu (1):
      ibsim: Fix typo in help

Alex Netes (1):
      ibsim: fix double slash in include the path

David McMillen (1):
      umad2sim: Segmentation fault fix

Doron Shoham (1):
      ibsim: support xmitwait counters

Hal Rosenstock (14):
      ibsim/sim_mad.c: Add sim support for PerfMgt ClassPortInfo
      ibsim: Eliminate unused modified variable
      ibsim: Change lid print format to unsigned
      ibsim/sim.h: Better portinfo alignment in Port struct
      ibsim: Handle sim_init_net errors better
      ibsim/sim_net.c: Eliminate IsLEDInfoSupported PortInfo CapabilityMask bit
      ibsim/sim_mad.c: Eliminate a couple of unneeded blank lines
      ibsim/sim_mad.c: Better error handling in send_trap
      ibsim: Some cosmetic changes
      ibsim/sim_cmd.c: Cosmetic change to error message
      ibsim/sim_cmd.c: Fix help for error command
      ibsim/sim_cmd.c: Allow error command on attributes for switch port 0
      sim_client.c: Set issm flag on connect when SIM_SET_ISSM set
      ibsim/ibsim.c: Bump version to 0.6

Huang, Parry W (2):
      ibsim/ibsim.c: Fixed bug regarding undefined commands
      ibsim/sim_cmd.c: Fixed help output for dump command

Huang, Perry (3):
      ibsim/sim.h: Add support for optional performance attributes.
      ibsim/sim_mad.c: Add read/reset functions for optional performance attributes.
      ibsim/sim_cmd: Add command to set perf. counters.

Ira Weiny (1):
      tests/subnet_discover: And I found the other reason (Re: Found one reason libibnetdisc is slower than subnet_discover)

Jon Stanley (1):
      ibsim/sim_cmd: Fix compile errors

Nicolas Morey Chaisemartin (1):
      Socket name can be forced by exporting IBSIM_SOCKNAME before starting ibsim and/or preloading umad2sim so multiple simulator can run on the same system at the same time

Nicolas Morey-Chaisemartin (1):
      ibsim: Fixed custom release in SPEC file

Sasha Khapyorsky (23):
      tests/mcast_storm: code consolidation
      tests/mcast_storm: add mcmember parameters
      ibsim: remove libibcommon dependencies
      ibsim/sim_cmd.c: fix printf format
      ibsim: fix port initial state
      ibsim: fix LocalPortNum in PortInfo response
      tests/mcast_storm.c: fix gid file parser
      ibsim: fix C99 non complaint types
      mcast_storm.c: migrate to newer libibmad API
      tests/mcast_storm.c: fix numeric GID parser
      tests/mcast_storm.c: fix uninitialized variable use
      tests/mcast_storm.c: fix mcmember parameters initialization
      tests/mcast_storm: fix MGID command line parser
      tests/mcast_storm.c: support comments in gid file
      tests/mcast_storm.c: report error response status
      tests/subnet_discover: discover test utility
      tests/query_many: simple utility to send many SMP queries
      tests/subnet_discover: limit possible number of hops
      tests/subnet_discover: add --help option
      tests/subnet_discover: --maxsmps (-n) option
      tests/subnet_discover.c: print useful information
      tests/subnet_discover: report unresponded transactions
      tests/subnet_discover: verbose node discovery printout

hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org (4):
      ibsim/sim_net.c: In new_node, fix nodetype in nodeinfo for router nodes
      ibsim/sim_client.c: In sim_client_init, return -1 on error
      ibsim: Eliminate unneeded argument in sim_client_init
      ibsim/sim_client.c: Eliminate unneeded qp param from sim_init

sebastien dugue (1):
      ibsim - Fix umad2sim build with glibc >= 2.10


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
