From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Add support for multicast in RoCEv2
Date: Mon, 12 Jun 2017 11:14:01 +0300
Message-ID: <20170612081404.17553-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Noa enables multicast traffic over RoCE v2.

To allow this, several changes were required.

First of all, there is a need to validate MLID when link layer is
Infiniband. This check is mandatory according to Infiniband spec
but the MLID should be ignored for RoCE according to RoCEv2 Annex
(Annex 17, A17.5.6).

Second, there is need to cange the mapping of IPv4 multicast
addresses to MGIDs to be according to RoCEv2 Annex (A17.4.1.1 L3
Addresses): GID = ::ffff:<IPv4 Address>

And third, multicast addresses need to be mapped to multicast MAC
instead of searching for it in the GID table.

Thanks

Noa Osherovich (3):
  IB/core: Fix the validations of a multicast LID in attach or detach
    operations
  IB/core: Set RoCEv2 MGID according to spec
  IB/core: Add support for RoCEv2 multicast

 drivers/infiniband/core/cma.c   | 13 +++++----
 drivers/infiniband/core/verbs.c | 62 +++++++++++++++++++++++++++++++++++++----
 include/rdma/ib_addr.h          |  8 +++++-
 3 files changed, 70 insertions(+), 13 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
