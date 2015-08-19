From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: shrink struct ib_send_wr
Date: Wed, 19 Aug 2015 18:37:31 +0200
Message-ID: <1440002254-795-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series shrinks the WR size by splitting out the different WR
types.

Patch number two is too large for the mailinglist, so if you didn't
get it grab it here:

	http://git.infradead.org/users/hch/rdma.git/commitdiff/30e522ee6c1d7adb614d7308f09fbfd71c6d3e07

or the full git tree at:

	git://git.infradead.org/users/hch/rdma.git wr-cleanup

Changes since the version sent around a couple of times:

 - new patch 1 which rejects invalid opcodes.  Patch 2 was doing
   this implicitly except for UD QPs, but I think we should a)
   do this explicitly and b) ensure this goes into 4.2 and -stable
   as I can see quite a lot of harm from submitting such malformed
   operations
 - patch 2 now covers all drivers including those in staging to
   side step any sort of discussions on the staging tree.
 - patch 2 now explicitly replaces the weird overloading in the mlx5
   driver with an explicit embedding of struct ib_send_wr, similar
   to what we do for all other MRs.
 - new patch to drop another unused send_wr field.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
