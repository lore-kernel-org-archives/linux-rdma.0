From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libibmad 1.3.13 release
Date: Wed, 8 Mar 2017 23:50:09 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67C61EB7@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of libibmad.

This includes a minimal impact fix for 

http://bugs.openfabrics.org/show_bug.cgi?id=2617

As such OFED should probably pick this release up.

** Important **

This is likely the last release of this library from a separate repo.  I plan to integrate this code into the infiniband-diags repo.  Furthermore this is the last release with the long deprecated symbols.

Tarball is available at:

https://www.openfabrics.org/downloads/management/

md5sum:
29c7723ec08dac02403bb307e03c86cd  libibmad-1.3.13.tar.gz

Changes since v1.3.12:

Hal Rosenstock (1):
  configure.ac: Update AM_INIT_AUTOMAKE to use subdir-objects

Ira Weiny (4):
  libibmad: Makefile.am: Fix INCLUDES warning
  configure.ac: Update configure.in to configure.ac
  libibmad: Fix conflict with new umad.h header
  update README and version 1.3.13

Vladimir Koushnir (1):
  portid.c: Preserve routepath string in str2drpath




Deprecated symbols
--------------------------

ib_gid_t
mad_register_client
mad_register_server
mad_class_agent
mad_send
mad_receive
mad_respond
ib_vendor_call
madrpc_portid
madrpc
madrpc_rmpp
madrpc_init
madrpc_save_mad
smp_query
smp_set
sa_call
ib_path_query
ib_resolve_smlid
ib_resolve_portid_str
ib_resolve_self

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
