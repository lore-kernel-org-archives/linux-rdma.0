From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: merge struct ib_device_attr into struct ib_device
Date: Mon, 21 Sep 2015 13:59:46 -0700
Message-ID: <1442869187-5556-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch gets rid of struct ib_device_attr and cleans up drivers nicely.

It goes on top of my send_wr cleanups and the memory registration udpates
from Sagi.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
