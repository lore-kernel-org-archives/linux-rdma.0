From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs 0/3] Add cross-channel support
Date: Sun, 20 Dec 2015 13:22:41 +0200
Message-ID: <1450610564-17279-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patchset adds supplementary part of cross-channel support [1]
to libibverbs.

These patches were added on top of "Completion timestamping" [2]
and "Expose QP block self multicast loopback creation flag" [3]
series.

[1] http://thread.gmane.org/gmane.linux.drivers.rdma/31715
[2] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg28895.html
[3] http://comments.gmane.org/gmane.linux.drivers.rdma/30158

Leon Romanovsky (3):
  libibverbs: Add CQ ignore overrun creation flag
  libibverbs: Add cross-channel QP initialization flags
  libibverbs: Export cross-channel capability flag

 include/infiniband/verbs.h | 11 ++++++++---
 man/ibv_create_cq_ex.3     | 10 ++++++++--
 src/cmd.c                  |  5 ++++-
 3 files changed, 20 insertions(+), 6 deletions(-)

-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
