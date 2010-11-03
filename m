From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/13] IB-mgmt: Port madeye to userspace
Date: Wed, 3 Nov 2010 16:13:47 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B38B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series ports the kernel madeye debug utility to
userspace.  It depends on the kernel MAD snooping functionality
patches recently submitted to this list.  The series
adds the following to the ib-mgmt tree:

* Adds the ability to snoop MADs to libibumad.
* Adds new header files to libibumad that define various MAD
  data structures and definitions.  The headers define a minimal
  number of definitions, basically only what was needed for madeye.
* Starts the process of updating libibmad and opensm to use the
  new definitions.  mad.h and ib_types.h are updated to reference
  values in the new header file, but the names of existing defines
  did not change.
* Adds madeye as a new ib-diag.

The new header files define the MAD headers, but do not define any
of the data fields, such as SA attributes.  Those are left for
further discussion.  The patch series is basically the same as that
submitted for the RFC.  Fixes were added to madeye based on more
extensive testing, and a new patch was added to the series to
identify which fields in libibumad are in network, versus host
order.  I added that separately because it touches existing
structures, as well as new ones that are defined.  Otherwise,
the definition for new structures follow the existing conventions.

Porting madeye to user space is a quick and useful way to verify
that the snooping capabilities work.  However, an alternative goal
of these patches is to allow ibacm and similar applications to
detect and react to SA and CM timeouts.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
