From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] IB 64 bit counter support
Date: Fri, 11 Dec 2015 12:25:32 -0600
Message-ID: <20151211182532.332343651@linux.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently we only use 32 bits for the packet and byte counters. There have been
extended countes available for some time but we have no support for those
yet upstream. We keep having issues with 32 bit counters wrapping. Especially
the byte counter can wrap frequently (as in multiple times per minute)

This patch adds 4 new counters and updates 4 32 bit counters to use the
64 bit sizes so that they no longer wrap.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
