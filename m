From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] librdmacm 1.0.18 release
Date: Wed, 5 Feb 2014 17:55:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D18EB2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 1.0.18 release of the librdmacm available.  It may be downloaded from:

http://www.openfabrics.org/downloads/rdmacm/

md5sum
786b76ce5f1da97d2b0fd8d787a7add0  librdmacm-1.0.18.tar.gz

The following changes were made between 1.0.17 and 1.0.18.

Bart Van Assche (6):
      Add "foreign" option to AM_INIT_AUTOMAKE
      Makefile.am: Fix an automake warning
      [1/4] acm: Remove the unused variable 'pri_path'
      [2/4] cma: Remove the unused variable 'id_priv'
      [3/4] rsocket: Remove the unused variable 'ret'
      [4/4] Declare 'server_port' as an unsigned variable

Guy Shapiro (1):
      librdmacm: Some fixes to man pages

Hal Rosenstock (4):
      [librdmacm] man/rdma_create_id.3: Add RDMA_PS_IB port space description
      [librdmacm] rstream.c: Indicate when specified address family is unknown
      [librdmacm] man/rstream.1: Update man page to be consistent with rstream -
      [librdmacm] Makefile.am: Add missing riostream man page to man_MANS

Jeff Squyres (1):
      autogen.sh: Use autoreconf in autogen.sh

Or Gerlitz (1):
      librdmacm: Add directives on binding to IPv6 any address to man pages

Sean Hefty (22):
      rsocket: Merge usage of wr_id between stream and datagram svcs
      rsocket: Add support for iWarp
      lib: Rename configure.in to configure.ac
      cmatose: Allow user to specify address format
      acm: Define needed ACM protocol messages
      init: Remove USE_IB_ACM configuration option
      rsockets: Support native IB addressing on connected rsockets
      examples: Add support for native IB addressing to samples
      rsockets: Add ability to set the IB route directly
      rsocket: Return 0 on success for SOL_RDMA options
      rstream: Use rsocket option to set route directly
      cmtime: Add example program that times rdma cm calls
      cmtime: Add ability to time rdma_bind_addr calls
      cmtime: Allow user to specify timeout values
      cmtime: Add retry support for address and route resolution
      rsocket: Update rsocket man page
      rsockets: Handle race between rshutdown and rpoll
      Retrieve SGID after calling rdma_bind_addr
      rping: Fix server reporting error on exit
      librdmacm: Check 'init' under mutex
      udaddy: Remove support for port space IB
      librdmacm 1.0.18

Susan K. Coulter (1):
      rsocket: Add keepalive logic

Yan Droneaud (1):
      examples: Add cmtime to .gitignore

Yann Droneaud (5):
      configure: Apply updates proposed by autoupdate
      configure: Use automake's option "subdir-objects"
      Add .gitignore rules
      Open files with "close on exec" flag
      Remove executable mode bit on text files
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
