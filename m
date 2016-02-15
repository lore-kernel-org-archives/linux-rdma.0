From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: isert: convert to the new CQ API and a few random cleanups
Date: Mon, 15 Feb 2016 21:10:56 +0100
Message-ID: <1455567060-18381-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series uses the new CQ API and cleans up a few random lose arounds
around the R/W path.  I have a few more changes for the RW path in the
works, but I think this is a good enough standalone series for now.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
