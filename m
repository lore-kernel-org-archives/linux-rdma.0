From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] ***libibmad users please read*** -- infiniband-diags
 v2.0.0 released
Date: Thu, 1 Jun 2017 18:27:55 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67CC83B4@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

*** libibmad users should note that libibmad is no longer a separate repo/package ***

There have just been too many changes to libibmad which are directly related to infiniband-diags changes.  Keeping a separate repo/package did not seem reasonable any longer.

Infiniband-diags v2.0.0 now includes/provides libibmad

The package has also been moved to the Linux-rdma github.  V2.0.0 release is here:

https://github.com/linux-rdma/infiniband-diags/releases


Dependencies:

	1) libibumad >= 1.3.7
	2) opensm-libs >= 3.3.10
	3) ib_umad kernel module
	4) glib2


Release notes 1.6.7 => 2.0.0

   1) combine libibmad
   2) Removed rdma-ndd
   	2a) Removed need for systemd
   	2b) Removed need for udev


Authors since 1.6.7

*Preserved full history from libibmad*

Ana Guerrero López (4):
  Update AM_INIT_AUTOMAKE to use subdir-objects
  Replace INCLUDES with AM_CPPFLAGS
  Update the shebang to point to /bin/bash
  A few typo fixes in the manpages

Dag Moxnes (1):
  ibportstate: Fixed switch peer port probing when using DR routing

Eitan Zahavi (1):
  ibsendtrap.c: Add support for security traps

Hal Rosenstock (13):
  ibportstate.c: When not switch, port can be router port
  ibaddr.c: Fix LID printfs to be unsigned rather than signed
  libibnetdisc/internal.h: Remove duplicated declaration of
    add_to_portlid_hash
  ibtracert.c: Enable m_key option
  Add Bull device ID support to device white lists
  infiniband-diags: Add Connect-X5 device ID to device white
  scripts: Add mkey support into ibhosts, ibswitches, and ibrouters
  ibdiag_common.c: Disambiguate link speed when QDR and could be FDR10
  saquery.c: Remove use of to be deprecated ib_gid_t
  ibdiag_common.c: Fix endian conversion in resolve_self for umad_port
    GID prefix and GUID
  ibdiag_common.c: Fix cosmetic formatting issue
  ibstat.c: Add include for __be64 type
  perfquery.c: Output PerfMgt ClassPortInfo CapabilityMask2

Ira Weiny (15):
  doc/man/*.in: update pre-built *.in files
  scripts: Add m_key to man pages
  infiniband-diags: Use modern glibc htobe64/be64toh macros
  infiniband-diags: Fix type passed to umad_get_ca_portguids
  infiniband-diags/perfquery: Use universal zero init for perf_count
  infiniband-diags: Update README files to reflect new merged repo
  infiniband-diags: Bump version to 2.0.0
  infiniband-diags: Update COPYING files to reflect the new repo
  infiniband-diags: Remove redundant AUTHORS file
  infiniband-diags: Move libibmad auto-configuration to main dir
  infiniband-diags: Merge makefiles and build against internal libibmad
  infiniband-diags: Combine libibmad spec into infiniband-diags
  infiniband-diags: Remove outdated scripts for ChangeLog
  infiniband-diags: set noreplace on config files
  infiniband-diags: Remove rdma-ndd


Oded Nissan (2):
  ibstat.c: If port is 1x SDR, rate is 2.5 rather than 2 Gbps
  perfquery.c: Add support for additional counters in
    PortCountersExtended

Vincent Ficet (1):
  infiniband-diags: Add Bull device ID support to device white lists
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
