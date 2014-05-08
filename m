From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 V2 0/2] Add support for UD QPs under RoCE IP addressing
Date: Thu,  8 May 2014 09:52:38 +0300
Message-ID: <1399531960-30738-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yishai,

This is just a rebased-port of the series which adds support for Ethernet L2 address 
resolution for UD QPs, whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set 
from user space without going through uverbs and the kernel IB core.

Matan and Or.

changes from V1:
 - rebased against libmlx4  1.0.6

changes from V0:
 - better checking for invalid port numbers
 - create_ah_ex in libmlx4 conforms to the verbs extensions mechanism

Matan Barak (2):
  Add RoCE IP based addressing support for UD QPs
  Add ibv_query_port_ex support

 src/mlx4.c  |    8 +++-
 src/mlx4.h  |   11 ++++
 src/verbs.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 159 insertions(+), 13 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
