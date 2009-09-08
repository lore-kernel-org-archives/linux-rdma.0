From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PLEASE READ] Transition from general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org to linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Date: Mon, 07 Sep 2009 21:56:41 -0700
Message-ID: <adaocpmm3ue.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

As you may have noticed, the linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org list is up and
running.  A number of sites have started archiving it -- in no
particular order, the sites I know of are:

    http://www.spinics.net/lists/linux-rdma/
    http://marc.info/?l=linux-rdma
    http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/
    http://dir.gmane.org/gmane.linux.drivers.rdma

If you know of any archives I've missed, please let me know.

Another nice tool we have with the new list is

    http://patchwork.kernel.org/project/linux-rdma/list/

which will make me have to work a little harder to lose patches.  Also,
if you are someone who handles a driver or some other part of the tree,
you can register and I will be able to delegate patches to you.

I would suggest that everyone who is currently following
general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org to subscribe to the new list (send the
line "subscribe linux-rdma" in the body of a message to
majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org).  Also, everyone sending email to the old
list to also please start to copy the new vger list as well (especially
for patches, so that the patchwork tool catches them).

As a date to finalize the transition, I propose the end of the month --
that is, on October 1 we shut down the old general@ list and expect
everything to be cut over by then.  I'll send a number of reminders
before then, but please do speak up if this schedule is too tight -- I
don't think keeping the old list running for longer is a big hardship
for anyone.

Finally, I'll plan to merge the following for 2.6.32:


MAINTAINERS: InfiniBand/RDMA mailing list transition to vger

InfiniBand/RDMA development discussion is moving from
general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org to linux-rdma-u79uwXL29TaiAVqoAR/hOA@public.gmane.org

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dca9d8..989ff11 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -439,7 +439,7 @@ F:	drivers/hwmon/ams/
 AMSO1100 RNIC DRIVER
 M:	Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
-L:	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
@@ -1494,7 +1494,7 @@ F:	drivers/net/cxgb3/
 
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
 M:	Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
-L:	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.openfabrics.org
 S:	Supported
 F:	drivers/infiniband/hw/cxgb3/
@@ -1868,7 +1868,7 @@ F:	fs/efs/
 EHCA (IBM GX bus InfiniBand adapter) DRIVER
 M:	Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
 M:	Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
-L:	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
 F:	drivers/infiniband/hw/ehca/
 
@@ -2552,7 +2552,7 @@ INFINIBAND SUBSYSTEM
 M:	Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
 M:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 M:	Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
-L:	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org (moderated for non-subscribers)
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.openib.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
@@ -2729,7 +2729,7 @@ F:	drivers/net/ipg.c
 
 IPATH DRIVER
 M:	Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
-L:	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 T:	git git://git.qlogic.com/ipath-linux-2.6
 S:	Supported
 F:	drivers/infiniband/hw/ipath/
@@ -3485,7 +3485,7 @@ F:	drivers/scsi/NCR_D700.*
 NETEFFECT IWARP RNIC DRIVER (IW_NES)
 M:	Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 M:	Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
-L:	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.neteffect.com
 S:	Supported
 F:	drivers/infiniband/hw/nes/
-- 
1.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
