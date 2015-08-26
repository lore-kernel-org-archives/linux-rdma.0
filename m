From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: shrink struct ib_send_wr V3
Date: Wed, 26 Aug 2015 11:00:36 +0200
Message-ID: <1440579639-10684-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series shrinks the WR size by splitting out the different WR
types.

Patch number two is too large for the mailinglist, so if you didn't
get it grab it here:

	http://git.infradead.org/users/hch/rdma.git/commitdiff/2b63f958de7bd630aba85caf65986831d4372869

or the full git tree at:

	git://git.infradead.org/users/hch/rdma.git wr-cleanup

Changes since V2:

 - fixed patch one to accept SEND - note that this was alredy fixed by
   patch 2
 - added a CC: stable for patch 1
 - added additional review tags

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
