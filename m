From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] librdmacm-1.0.14 release
Date: Fri, 10 Dec 2010 12:41:00 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C8C2DC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

librdmacm is a library that allows a user to establish connections over any RDMA transport (currently Infinband and iWarp).

The new stable release, 1.0.14, is available from:

	http://www.openfabrics.org/downloads/rdmacm/librdmacm-1.0.14.tar.gz

with sha1sum

	c6e4c426ad2086e8335e35254d4b6f444e6d5cd9  librdmacm-1.0.14.tar.gz

The git shortlog since 1.0.13 is:

Jason Gunthorpe (1):
      librdmacm: Fix autotools to include the necessary M4 files

Jonathan Rosser (2):
      librdmacm: fix make install
      librdmacm: fix compiler warning of void * arithmetic

Sean Hefty (8):
      librdmacm: do not pass uninitialized ai_hints into getaddrinfo
      librdmacm: expand support for hints to rdma_getaddrinfo
      librdmacm: only allocate qp in rdma_create_ep if qp_attr provided
      librdmacm: do not modify qp_init_attr in rdma_get_request
      librdmacm/rping: Make sure CQ event thread exits before destroying the CQ
      librdmacm: support non-default ACM port number
      librdmacm: Support RAI_NUMERICHOST and no delay options
      v1.0.14

Steve Wise (1):
      RPING: Remove printf for FLUSH completion.
--

Vlad, please pull this into OFED 1.5.3.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
