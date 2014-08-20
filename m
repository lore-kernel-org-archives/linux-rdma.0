From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 V4 0/2] Add RoCE IP based addressing support for UD QPs
Date: Wed, 20 Aug 2014 09:52:07 +0300
Message-ID: <1408517529-20631-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yishai,

This is just a rebased-port of the series which adds support for Ethernet L2 address
resolution for UD QPs, whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set
from user space without going through uverbs and the kernel IB core.

Matan and Or.

changes from V3:
 - Adapt the code for the latest changes in the related libibverbs series:
     Instead of using an extended create_ah_ex function, the standard (legacy)
     create_ah provider function uses a libibverbs utility function to
     handle the L2 resolution.
 - Removed the extended query port support and use an internal function for caching.

changes from V2:
 - Adapt the code for the latest changes in the related libibverbs series

changes from V1:
 - rebased against libmlx4  1.0.6

changes from V0:
 - better checking for invalid port numbers
 - create_ah_ex in libmlx4 conforms to the verbs extensions mechanism

Matan Barak (2):
  Add ibv_query_port caching support
  Add RoCE IP based addressing support for UD QPs

 src/mlx4.c  |    2 +
 src/mlx4.h  |    7 ++++++
 src/verbs.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 69 insertions(+), 6 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
