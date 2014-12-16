From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] libibumad 1.3.10 release
Date: Tue, 16 Dec 2014 15:35:41 -0500
Message-ID: <5490979D.4020808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 1.3.10 release of libibumad.

Tarball is available in:
http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
3a4046ddaaf43bbb82f124808232a294  libibumad-1.3.10.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Alex Netes (1):
      libibumad: Fix memory leak in resolve_ca_port

Dan Ben Yosef (1):
      umad.c: Buffer not null terminated

Hal Rosenstock (14):
      libibumad: Minor fixups for previous umad_str patch
      libibumad: Fix issues causing const warnings for strings
      libibumad: Add recent/missing SM/SA attributes
      libibumad: Rename attributes UMAD_SM_ATTR_XXX rather than UMAD_SMP_ATTR_XXX
      libibumad: update shared library version
      libibumad: package version update for 1.3.9 release
      umad_sm.h: Add Mellanox extended port info SM attribute ID to enum
      umad_[sm sa].h: Add PortInfoExtended SM and PortInfoExtendedRecord SA attributes
      umad_sa.h: Add some new (at IBA 1.3) SA CapabilityMask2 bit definitions
      umad_cm.h: Add new SAP and SPR CM attributes
      umad_str.c: Add strings for newly added attributes
      Added/updated some Mellanox copyrights
      libibumad.ver: Update shared library version
      configure.in: package version update for 1.3.10 release

Ilya Nelkenbaum (1):
      libibumad/umad.c: In resolve_ca_port, skip ethernet link layer ports

Ira Weiny (11):
      libibumad: fix umad_register man page
      libibumad: update umad_[send|recv] man pages to document how rmpp is handled
      libibumad: change UMAD_METHOD_RESP to UMAD_METHOD_RESP_MASK
      libibumad: add UMAD_SA_STATUS_PRI_SUGGESTED to SA status.
      libibumad: add string functions for various enums
      libibumad: document the setting of errno for umad_send and umad_recv
      libibumad: add SA CAP MASK[2] definitions
      libibumad: add ClassPortInfo struct
      umad_types.h: fix status type in umad_hdr
      Add support for new registration ioctl
      Add make check with umad register tests

Line Holen (1):
      umad_sm.h Add SM trap definitions

Nick Mills (1):
      configure.in: Remove unused --disable-libcheck configure option

Sean Hefty (10):
      libibumad: Provide MAD definitions with libibumad
      libibumad: Add SA MAD definitions to umad
      libibumad: Add basic SM definitions to umad
      libibumad: Add CM definitions to umad
      libibumad: Add new umad header files to release
      libibumad: Define ntohll/htonll
      libibumad: Define data type to indicate values are in big-endian
      libibumad/sa: Add SA specific status values
      libibumad: Define well known QKEY
      Fix export of umad_sa_mad_status_str

sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org (1):
      Add UMAD_RMPP_FLAG_ACTIVE into umad_types.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
