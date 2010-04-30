From: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] RDMA/core: add support for iWarp multicast acceleration
	over IB_QPT_RAW_ETY QP type
Date: Fri, 30 Apr 2010 18:53:43 +0200
Message-ID: <20100430165249.1386.73960.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series implements iWarp multicast acceleration over raw eth QP type.

In ibv_attach_mcast and ibv_detach_mcast, new case is added for RDMA_TRANSPORT_IWARP to allow multicast 
on IB_QPT_RAW_ETY QP type. This change is for iWarp only and does not affect IB.

Changes to nes demenstrate how IB_QPT_RAW_ETY QP is used to accelerate multicast traffic.

Miroslaw Walukiewicz
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
