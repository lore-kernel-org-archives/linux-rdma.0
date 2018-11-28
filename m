From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH RFC iproute2-next 0/2] Dynamic rdma link creation
Date: Wed, 28 Nov 2018 08:25:10 -0800
Message-ID: <cover.1543422310.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leon@kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org

This series adds rdmatool support for creating/deleting rdma links.
This will be used, mainly, by soft rdma drivers to allow adding/deleting
rdma links over netdev interfaces.

I've tagged this as "RFC" to start reviewing it, and because it is
dependent on kernel changes which are still under review [1].

Please comment!

Thanks,

Steve.

[1] https://www.spinics.net/lists/linux-rdma/msg71469.html

Steve Wise (2):
  rdma: add 'link add/delete' commands
  rdma: man page update for link add/delete

 man/man8/rdma-link.8 |  51 +++++++++++++++++++++++++
 rdma/link.c          | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/rdma.h          |   1 +
 rdma/utils.c         |   2 +-
 4 files changed, 159 insertions(+), 1 deletion(-)

-- 
1.8.3.1
