From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: move unsafe global rkey handling to the RDMA core
Date: Mon, 29 Aug 2016 12:02:17 +0200
Message-ID: <1472464943-29450-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This fairly simply series adds support to ib_alloc_pd to create the unsafe
global rkey in the IB core, and then switches over all ULPs to use that
functionality instead of using ib_get_dma_mr directly, and consequently
removes ib_get_dma_mr now that all global registrations are done in the
core code.

The advantage is that abuses of ib_get_dma_mr are more easily prevented,
and use of the global unsafe rkey is more visible and auditable.

I'm also pondering removing the get_dma_mr methods and moving the global
registrations into the ->alloc_pd methods, but I'll need to investigate
how that will work out first.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
