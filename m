From: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] drivers/infiniband: fix too big NAPI weights
Date: Wed, 21 Aug 2013 18:50:20 +0200
Message-ID: <1377103822-1752-1-git-send-email-mschmidt@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some drivers request too big NAPI weights and would trigger the error
message in netif_napi_add() added in commit 82dc3c63. Let's fix them.

Michal Schmidt (2):
  IB/nes: lower NAPI weight
  IB/ipoib: lower NAPI weight

 drivers/infiniband/hw/nes/nes_nic.c       | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
