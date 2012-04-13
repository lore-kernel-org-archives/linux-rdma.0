From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] ibacm release 1.0.6
Date: Fri, 13 Apr 2012 18:47:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373451AD691@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibacm release 1.0.6 is now available from:

https://www.openfabrics.org/downloads/rdmacm/ibacm-1.0.6.tar.gz

The git shortlog from 1.0.5 is:

Dotan Barak (1):
      After allocation of dynamic memory blocks, check the allocation

Hal Rosenstock (4):
      ib_acme: Fix typo
      ib_acme: Use IPv4 rather than IPv6 when connecting to ACM server
      ib_acme: Better error handling in resolve_gid
      ibacm: Display LID using unsigned decimal

Sean Hefty (4):
      ibacm: Allow user to specify LIDs and/or GIDs when using PR lookups
      ibacm: Set default route resolution to SA
      ibacm: Fixes to ACM package to support distros
      v1.0.6
      Fix refcnt for multicast destination
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
