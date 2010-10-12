From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 0/2] IB/umad: Export mad snooping to userspace
Date: Tue, 12 Oct 2010 12:10:37 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The kernel mad interface allows a client to view all
sent and received MADs.  This has proven to be a useful
debugging technique when paired with the external kernel
module, madeye.  However, madeye was never intended to
be submitted upstream.

A couple of alternatives have been proposed for making
this functionality available in the upstream kernel,
using trace events or exporting the snooping interface
to user space.  This patch series takes the latter approach.

In addition to snooping MADs simply for debugging purposes,
applications can be constructed to examine and act on
MAD traffic.  For example, a daemon could snoop SA queries
and CM messages as part of providing a path record caching
service.  It could cached snooped path records and use CM
timeouts as an indication that cached data may be stale.

Because such services may become crucial to support large
clusters, the desire is to add mad snooping capabilities
to the stack directly, rather than using a debug interface.

These patches compile, but have not been tested.  If this
approach is acceptable, I will modify libibumad to work
with the proposed changes.  I will also create a userspace
version of madeye as a new ib-diag.  Finally, the IB ACM
will eventually be updated to monitor CM response timeouts.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
