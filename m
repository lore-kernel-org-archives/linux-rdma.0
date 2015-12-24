From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: start moving user space visible constants to uapi headers
Date: Thu, 24 Dec 2015 15:39:21 +0100
Message-ID: <1450967967-12479-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently very little of the uverbs user interface is actually exposed in
uapi headers, and it's a constant struggle to figure out what's kernel
internal and what is actually exposed in public.  This series starts
sorting this out by creating the infrastructure for a uapi header shared
between uverbs and the core IB stack, and starts moving all WR and WC
constants as well as the device capabilitity flags there.

A lot more work will have to follow, and I hope others will help out as
well.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
