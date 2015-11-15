From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: garbage collect old memory registration code
Date: Sun, 15 Nov 2015 19:05:53 +0100
Message-ID: <1447610762-3781-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series removes huge chunks of code related to old memory
registration methods that we don't use anymore.

This expects my "IB: merge struct ib_device_attr into struct ib_device"
patch to be already applied.

Also available as a git tree:

	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-mr-cleanups
	git://git.infradead.org/users/hch/rdma.git rdma-mr-cleanups

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
