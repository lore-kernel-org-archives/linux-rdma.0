From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 0/2] Add support for UD QPs under RoCE IP addressing
Date: Sun,  2 Feb 2014 17:54:59 +0200
Message-ID: <1391356501-4270-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland and Yishai

This series adds support for Ethernet L2 address resolution for UD QPs, whose 
L2 address-handles, unlike RC/UC/XRC/etc QPs are set from user space without
going through uverbs and the kernel IB core.

Matan and Or.

Matan Barak (2):
  Add RoCE IP based addressing support for UD QPs
  Add ibv_query_port_ex support

 src/mlx4.c  |    7 +++
 src/mlx4.h  |   11 +++++
 src/verbs.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 149 insertions(+), 9 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
