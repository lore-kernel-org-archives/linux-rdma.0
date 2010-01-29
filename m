From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
Date: Fri, 29 Jan 2010 14:54:36 -0800
Message-ID: <adar5p8ldxv.fsf@roland-alpha.cisco.com>
References: <20100129214039.17745.38679.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100129214039.17745.38679.stgit-tBlMHHroXgg@public.gmane.org> (Alex Chiang's message
	of "Fri, 29 Jan 2010 14:44:57 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Justin Chen discovered that Linux "only" supports 32 IB cards in
 > a single system when testing a larger system with 40 cards and
 > discovered that OFED only reported 32 HCAs.
 > 
 > This patchset doubles the number of HCAs allowed per system in a
 > backwards-compatible manner.

Looks like a really great start, some nice cleanups as well the added
functionality.  I've been meaning to use pahole for a while...

Have you considered drivers/infiniband/core/user_mad.c and ucm.c?  I
think user_mad.c is somewhat more important, as that is what allows an
adapter to be used for running the SM.  So I think we're still left with
some potential issues around lots of adapters in one system.  (I think
use of ucm by real apps is minimal to nonexistent, but someday we should
deal with that too)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
