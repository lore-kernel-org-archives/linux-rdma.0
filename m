From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6 v2] libibverbs: Add support for XRC
Date: Fri, 19 Aug 2011 02:47:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41BA9@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patches add support for XRC to ibverbs.  Support for XRC
requires additional function calls into the verbs driver library
(e.g. libmlx4): open_xrcd, close_xrcd, create xrc srqs, and open_qp.
Since no mechanism is currently defined to allow for
these calls, we first define a way to add extensions to verbs.

The generic extensions allow for verbs to expose vendor specific
capabilities, but also provide a way for a library to export new calls
needed for features that have been added directly to ibverbs in a
backwards compatible manner.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
