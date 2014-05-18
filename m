From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 V3 0/2] Add support for UD QPs under RoCE IP addressing
Date: Sun, 18 May 2014 12:39:10 +0300
Message-ID: <1400405952-14388-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Yishai,

This is just a rebased-port of the series which adds support for Ethernet L2 address 
resolution for UD QPs, whose L2 address-handles, unlike RC/UC/XRC/etc QPs are set 
from user space without going through uverbs and the kernel IB core.

Matan and Or.

changes from V2:
 - Adapt the code for the latest changes in the related libibverbs series

changes from V1:
 - rebased against libmlx4  1.0.6

changes from V0:
 - better checking for invalid port numbers
 - create_ah_ex in libmlx4 conforms to the verbs extensions mechanism

Matan Barak (2):
  Add RoCE IP based addressing support for UD QPs
  Add ibv_query_port_ex support

 src/mlx4.c  |    4 ++
 src/mlx4.h  |   11 +++++
 src/verbs.c |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 144 insertions(+), 12 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
