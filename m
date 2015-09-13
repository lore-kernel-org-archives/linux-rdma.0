From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: shrink struct ib_send_wr V4
Date: Sun, 13 Sep 2015 17:13:33 +0200
Message-ID: <1442157215-22341-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series shrinks the WR size by splitting out the different WR
types.

Patch number one is too large for the mailinglist, so if you didn't
get it grab it here:

	http://git.infradead.org/users/hch/rdma.git/commitdiff_plain/c752d80937ff2d71f25ae7fcdd1a151054fb2ceb

or the full git tree at:

	git://git.infradead.org/users/hch/rdma.git wr-cleanup

Now that we have 4.3-rc1 out it might be a good idea to get the rdma tree
for 4.4 started with it.  Both I and others have additional large patches
pending that build ontop of this.

Changes since V3:
  - dropped the old first patch as it has been merged
  - rebase to 4.3-rc1

Changes since V2:
 - fixed patch one to accept SEND - note that this was alredy fixed by
   patch 2
 - added a CC: stable for patch 1
 - added additional review tags

Changes since V1:
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
