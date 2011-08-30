From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.33
Date: Tue, 30 Aug 2011 19:46:56 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E50C32@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


New release for v2.0 (2.0.33) available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 1.5.4 RC1:

--------------

Latest Package (see ChangeLog for recent changes):

md5sum: 1dbffd27c790cc822383b309f0a01312 dapl-2.0.33.tar.gz 

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.33-1 
dapl-utils-2.0.33-1 
dapl-devel-2.0.33-1 
dapl-debuginfo-2.0.33-1 
compat-dapl-1.2.19-1 
compat-dapl-devel-1.2.19-1 

New features for 2.0.33
 IB transport extensions for MPI collectives and Mellanox FCA provider added as optional build. 
 Requires Mellanox mverbs, FCA library, and ConnectX-2 adapters 

Build example for FCA installed in default /opt/mellanox/fca directory: 
   ./configure --enable-coll-type=fca LDFLAGS=-L/opt/mellanox/fca/lib CPPFLAGS=-I/opt/mellanox/fca/include/ 

Summary of v2.0 changes: 

Release 2.0.33 fixes (OFED 1.5.4 RC1): 

scm,ucm: fix compatibility issues and set minimum protocol support 
build: link librdmacm dependency to ib_acm usage for ucm and scm providers 
build: add selective enable/disable-xxx build switch for each provider 
build: add extended header files to EXTRA_DIST and fix missing backslash 
build: set IB extended coll-type to none by default 
common: change errno mapping of EINVAL to DAT_INVALID_PARAMETER 
build: add IB collective and FCA provider to dapl build package as an option 
common: add new dapls_evd_post_event_ext call for extended events 
ucm: add support for IB collective providers 
scm: add support for IB collective providers 
cma: add support for IB collective providers 
common: add supported collective types in named attributes for query 
common: add collective call mappings via standard dapli_post_ext() 
common: new debug bitmask definition for extension logging 
common: new IB collective provider for Mellanox Fabric Collective Agent 
dat: add definitions for MPI offloaded collectives in IB transport extensions 
common: cleanup debug messages when building with ibacm feature 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
