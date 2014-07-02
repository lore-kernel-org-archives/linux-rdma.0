From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/8] librdmacm: Add support for XRC QPs
Date: Tue,  1 Jul 2014 23:11:11 -0700
Message-ID: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Update the XRC support in the librdmacm to match the upstream
libibverbs XRC support, plus verbs extensions.

This patch aligns the librdmacm with the latest libibverbs
version, and removes compatibility with earlier version
of libibverbs that do not support verbs extensions.

Sean Hefty (8):
  librdmacm: Remove NULL checks after calling alloca
  librdmacm: Use SRQ in rdma_create_qp
  build: Add build support for XRC
  rdmacm: Add functionality to allocate an XRCD
  rdmacm: Add support for allocating XRC SRQs
  rdmacm: Add support for XRC QPs
  rdmacm: Update addrinfo with XRC support
  example/rdma_xclient/server: Update XRC support in sample programs

 configure.ac              |    8 +-
 examples/rdma_xclient.c   |  195 ++++++-------------------------
 examples/rdma_xserver.c   |  285 ++++++++-------------------------------------
 include/rdma/rdma_cma.h   |    4 +-
 include/rdma/rdma_verbs.h |    3 +-
 src/addrinfo.c            |   14 +--
 src/cma.c                 |  166 ++++++++++++++++++++-------
 src/cma.h                 |   42 +-------
 src/librdmacm.map         |    2 +
 9 files changed, 223 insertions(+), 496 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
