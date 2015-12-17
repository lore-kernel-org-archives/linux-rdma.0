From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] IB 64 bit counter support V2
Date: Thu, 17 Dec 2015 13:52:55 -0600
Message-ID: <20151217195255.334854705@linux.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

V1->V2 Add detection of the capability for 64 bit counter support and lots
  of improvements as a result of suggestions by Hal Rosenstock.

Currently we only use 32 bits for the packet and byte counters. There have been
extended countes available for some time but we have no support for those
yet upstream. We keep having issues with 32 bit counters wrapping. Especially
the byte counter can wrap frequently (as in multiple times per minute)

This patch adds 4 new counters and updates 4 32 bit counters to use the
64 bit sizes so that they no longer wrap.

Should the device not support 64 bit counters then only the original 32
bit counters will be visible.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
