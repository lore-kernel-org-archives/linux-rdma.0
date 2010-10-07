From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: SRP submaintainership
Date: Thu, 07 Oct 2010 09:54:24 -0700
Message-ID: <adatyky3pvj.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dave Dillow has been involved with both kernel development and SRP for
a long time, and I trust Dave's technical judgement and good taste
about the SRP code.  Dave has graciously agreed to serve as a
submaintainer for the SRP initiator, which should mean that SRP
patches will get more focus and also free me to spend more time on
other maintenance/patch review.

Thanks Dave!

 - Roland

===

MAINTAINERS: Hand off SCSI RDMA Protocol (SRP) initiator to Dave Dillow

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f46d8e6..1c72a42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5041,6 +5041,16 @@ W:	http://www.kernel.dk
 S:	Maintained
 F:	drivers/scsi/sr*
 
+SCSI RDMA PROTOCOL (SRP) INITIATOR
+M:	David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+W:	http://www.openfabrics.org
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git
+F:	drivers/infiniband/ulp/srp/
+F:	include/scsi/srp.h
+
 SCSI SG DRIVER
 M:	Doug Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
 L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
